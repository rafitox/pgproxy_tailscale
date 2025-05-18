# pgproxy_tailscale
This repository provides a secure and minimal Docker image for Tailscale's pgproxy, built using Chainguard’s hardened, distroless Golang base image with a multi-stage build process.

Tailscale's pgproxy.go was designed internally and recently open-sourced, enabling secure, identity-aware access to PostgreSQL instances over Tailscale mTLS. This implementation focuses on reducing the attack surface by using a minimal container image and following container hardening best practices.
