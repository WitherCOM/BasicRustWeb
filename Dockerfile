################
##### Builder
FROM rust:buster as builder

WORKDIR /app
COPY . .
RUN cargo build --release
################
##### Runtime
FROM  alpine:3.16.0 AS runtime 
COPY --from=builder /app/target/release/web-app /usr/local/bin
CMD ["/usr/local/bin/web-app"]

