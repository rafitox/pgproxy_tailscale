# syntax=docker/dockerfile:1.4

########################################
# 1) Builder: fetch Tailscale & compile pgproxy
########################################
FROM --platform=$BUILDPLATFORM cgr.dev/chainguard/go:latest-dev AS builder

# Install git in dev image so we can clone
RUN apk add --no-cache git

# Clone the exact Tailscale tag you want
ARG TAILSCALE_TAG=v1.82.5
RUN git clone --branch ${TAILSCALE_TAG} \
      https://github.com/tailscale/tailscale.git /src/tailscale

WORKDIR /src/tailscale/cmd/pgproxy

# Build a fully static binary (CGO disabled) using the repo’s go.mod/go.sum
RUN CGO_ENABLED=0 go build -o /pgproxy ./

########################################
# 2) Runtime: minimal Chainguard Go image
########################################
FROM cgr.dev/chainguard/go:latest

# Copy the static pgproxy binary
COPY --from=builder /pgproxy /usr/local/bin/pgproxy

# Expose default Postgres port
EXPOSE 5432

ENTRYPOINT ["/usr/local/bin/pgproxy"]

