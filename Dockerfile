################
##### Builder
FROM --platform=linux/amd64 rust:buster as builder
WORKDIR /app
COPY . .
RUN apt update && apt upgrade -y
RUN apt install -y g++-arm-linux-gnueabihf libc6-dev-armhf-cross

RUN rustup target add armv7-unknown-linux-musleabi x86_64-unknown-linux-musl
RUN rustup toolchain install stable-armv7-unknown-linux-musleabi

RUN cargo build --release --target x86_64-unknown-linux-musl
RUN cargo build --release --target armv7-unknown-linux-musleabi

RUN mkdir target/amd64 && cp target/x86_64-unknown-linux-musl/web-app target/amd64 && \
    mkdir target/arm && target/armv7-unknown-linux-musleabi/web-app target/arm_v7

################
##### Runtime
FROM  alpine:3.16.0 AS runtime 
COPY --from=builder /app/target/${BUILDARCH}/release/web-app /usr/local/bin
CMD ["/usr/local/bin/web-app"]

