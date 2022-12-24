FROM rust:latest as builder

WORKDIR /app 
COPY . . 
RUN cargo build --release


FROM alpine:3.16.0
COPY --from=builder /app/target/release/FirstWebApp /usr/local/bin
CMD ["/usr/local/bin/FirstWebApp"]

