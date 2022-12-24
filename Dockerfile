FROM --platform=linux/amd64 rust:1.61.0 as builder
WORKDIR /usr/src/myapp
COPY . .
RUN rustup target add x86_64-unknown-linux-musl armv7-unknown-linux-musleabi
RUN cargo build --target armv7-unknown-linux-musleabi --release
RUN cargo build --target x86_64-unknown-linux-musl --release

FROM --platform=linux/amd64 alpine:3.16.0
COPY --from=builder /usr/src/myapp/target/x86_64-unknown-linux-musl/release/myapp /usr/local/bin
CMD ["/usr/local/bin/myapp"]


FROM --platform=linux/amd64 alpine:3.16.0
COPY --from=builder /usr/src/myapp/target/armv7-unknown-linux-musleabi/release/myapp /usr/local/bin
CMD ["/usr/local/bin/myapp"]
