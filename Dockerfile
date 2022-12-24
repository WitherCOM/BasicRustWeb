################
##### Builder
FROM --platform=linux/amd64 rust:buster as builder
WORKDIR /app
COPY . .
RUN apt update && apt upgrade -y
RUN apt install -y binutils-arm-linux-gnueabihf

RUN rustup target add armv7-unknown-linux-musleabihf x86_64-unknown-linux-musl
RUN rustup toolchain install stable-armv7-unknown-linux-gnueabihf

RUN cargo build --release --target x86_64-unknown-linux-musl
ENV CARGO_TARGET_ARMV7_UNKNOWN_LINUX_MUSLEABIHF_LINKER=arm-linux-gnueabihf-ld
RUN cargo build --release --target armv7-unknown-linux-musleabihf

RUN mkdir target/amd64 && cp target/x86_64-unknown-linux-musl/release/web-app target/amd64 && \
    mkdir target/arm && cp target/armv7-unknown-linux-musleabihf/release/web-app target/arm

################
##### Runtime
FROM  alpine:3.16.0 AS runtime 
ARG TARGETARCH
COPY --from=builder /app/target/${TARGETARCH}/web-app /usr/local/bin
CMD ["/usr/local/bin/web-app"]

