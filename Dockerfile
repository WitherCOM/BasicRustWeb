################
##### Builder
FROM rust:buster as builder

WORKDIR /app
COPY . .
RUN --security=insecure mkdir -p /root/.cargo && chmod 777 /root/.cargo && mount -t tmpfs none /root/.cargo && cargo build --release

################
##### Runtime
FROM  alpine:3.16.0 AS runtime 
COPY --from=builder /app/target/release/web-app /usr/local/bin
CMD ["/usr/local/bin/web-app"]

