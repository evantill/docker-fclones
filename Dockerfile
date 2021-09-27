ARG RUST_VERSION=1.55
FROM rust:${RUST_VERSION} as build

#static link thanks to https://dev.to/deciduously/use-multi-stage-docker-builds-for-statically-linked-rust-binaries-3jgd
RUN rustup target add x86_64-unknown-linux-musl
ARG FCLONES_VERSION=0.16.0
RUN cargo install --target x86_64-unknown-linux-musl --version ${FCLONES_VERSION} fclones

FROM scratch
COPY --from=build /usr/local/cargo/bin/fclones /
USER 1000

ENTRYPOINT [ "/fclones" ]
CMD ["-help"]