FROM docker.io/library/golang:1.20-alpine as base

FROM base as go-build

WORKDIR /install

# Copy in sources
COPY goofys .
COPY patches patches

# Apply source patches
RUN apk add --update patch
RUN sh -c "patch -p1 < patches/0001-Remove-duplicate-FusePanicLogger.BatchForget.patch"

# Download Go dependencies
RUN go mod download
RUN go mod verify

# Build final binary
RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 sh -c "go build -o /install/goofys -ldflags '-X main.Version=docker'"

FROM base

LABEL org.opencontainers.image.source "https://github.com/nanderson94/docker-goofys"

RUN apk add fuse

WORKDIR /app
COPY --from=go-build /install/goofys .


CMD ["/app/goofys"]
