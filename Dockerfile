FROM rust:1.61.0-slim as builder
WORKDIR /usr/src/myapp
COPY . .
RUN rustup target add x86_64-unknown-linux-musl
RUN cargo build --target x86_64-unknown-linux-musl --release

FROM alpine:3.16.0 AS runtime 
COPY --from=builder /usr/src/myapp/target/x86_64-unknown-linux-musl/release/myapp /usr/local/bin
CMD ["/usr/local/bin/myapp"]

