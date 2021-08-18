FROM golang:latest AS builder

RUN go get -d -v github.com/google/go-jsonnet/cmd/jsonnet-lint@latest
RUN go install -v github.com/google/go-jsonnet/cmd/jsonnet-lint@latest

FROM opensuse/leap:latest AS runner

COPY --from=builder /go/bin/jsonnet-lint /usr/local/bin/jsonnet-lint
COPY entrypoint.bash /entrypoint.bash

ENTRYPOINT ["bash", "/entrypoint.bash"]
