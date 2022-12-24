################
##### Builder
FROM --platform=linux/amd64 rust:stable as builder

RUN apt update && apt upgrade -y
RUN apt install -y g++-arm-linux-gnueabihf libc6-dev-armhf-cross

WORKDIR /app
COPY . .

RUN rustup target add x86_64-unknown-linux-musl armv7-unknown-linux-gnueabihf
RUN rustup toolchain install stable-armv7-unknown-linux-gnueabihf

ENV CARGO_TARGET_ARMV7_UNKNOWN_LINUX_GNUEABIHF_LINKER=arm-linux-gnueabihf-gcc \
    CC_armv7_unknown_linux_gnueabihf=arm-linux-gnueabihf-gcc \
    CXX_armv7_unknown_linux_gnueabihf=arm-linux-gnueabihf-g++

RUN cargo build --target armv7-unknown-linux-gnueabihf --release
RUN cargo build --target x86_64-unknown-linux-musl --release

################
##### Runtime
FROM --platform=linux/amd64 alpine:3.16.0 AS runtime 
COPY --from=builder /app/target/x86_64-unknown-linux-musl/release/web-app /usr/local/bin
CMD ["/usr/local/bin/web-app"]

FROM --platform=linux/amd64 alpine:3.16.0 AS runtime 
COPY --from=builder /app/target/armv7-unknown-linux-gnueabihf/release/web-app /usr/local/bin
CMD ["/usr/local/bin/web-app"]
