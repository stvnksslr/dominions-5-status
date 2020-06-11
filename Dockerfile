FROM rust:1.35-stretch as build
ADD . app
WORKDIR /app
RUN cargo build --release 


FROM rust:1.35-slim-stretch
WORKDIR /app
COPY --from=build app/taropget/release/dom5status .
ENV SSL_CERT_FILE=/etc/ssl/cert.pem
ENV SSL_CERT_DIR=/etc/ssl/certs
CMD ["./target/release/dom5status"]