FROM golang:latest as build
WORKDIR /go/src/github.com/pomerium/pomerium
ENV CGO_ENABLED=0
ENV GO111MODULE=on
# docker build --build-arg ARCH=arm --build-arg ARM=7 .
# frustratingly not supported by dockerhub automated builds though
ARG ARCH=amd64
ARG ARM=7
ENV GOARCH=${ARCH}
ENV GOARM=${ARM}
# cache depedency downloads
COPY go.mod go.sum ./
RUN go mod download
COPY . .
# build 
RUN make

FROM gcr.io/distroless/static
WORKDIR /pomerium
COPY --from=build /go/src/github.com/pomerium/pomerium/bin/* /bin/
CMD ["/bin/pomerium"]
