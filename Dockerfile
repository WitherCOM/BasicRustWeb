FROM rust:1.61.0 as builder
WORKDIR /usr/src/myapp
COPY . .
RUN cargo build  --release

FROM alpine:3.16.0
COPY --from=builder /usr/src/myapp/release/myapp /usr/local/bin
CMD ["/usr/local/bin/myapp"]

