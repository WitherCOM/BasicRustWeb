################
##### Builder
FROM rust:1.61.0-slim as builder

WORKDIR /app
COPY . .

RUN rustup target add x86_64-unknown-linux-musl
RUN cargo build --target x86_64-unknown-linux-musl --release

################
##### Runtime
FROM alpine:3.16.0 AS runtime 

# Copy application binary from builder image
COPY --from=builder /app/target/x86_64-unknown-linux-musl/release/web-app /usr/local/bin

# Run the application
CMD ["/usr/local/bin/web-app"]
