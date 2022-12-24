FROM --platform=linux/amd64 rust:latest as builder

RUN apt update && apt upgrade -y 
RUN apt install -y g++-arm-linux-gnueabihf libc6-dev-armhf-cross
 
RUN rustup target add armv7-unknown-linux-gnueabihf 
RUN rustup toolchain install stable-armv7-unknown-linux-gnueabihf 
 
WORKDIR /app 
COPY . . 
ENV CARGO_TARGET_ARMV7_UNKNOWN_LINUX_GNUEABIHF_LINKER=arm-linux-gnueabihf-gcc CC_armv7_unknown_Linux_gnueabihf=arm-linux-gnueabihf-gcc CXX_armv7_unknown_linux_gnueabihf=arm-linux-gnueabihf-g++
RUN cargo build --target armv7-unknown-linux-gnueabihf --release --verbose
RUN cargo build --target --release


FROM --platform=linux/arm/v7 alpine:3.16.0
COPY --from=builder /app/target/armv7-unknown-linux-gnueabihf/release/FirstWebApp /usr/local/bin
CMD ["/usr/local/bin/FirstWebApp"]

FROM --platform=linux/amd64 alpine:3.16.0
COPY --from=builder /app/target/release/FirstWebApp /usr/local/bin
CMD ["/usr/local/bin/FirstWebApp"]
