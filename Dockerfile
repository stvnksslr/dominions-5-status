### BUILDER
FROM rust:1.35-stretch as build

# create a new empty shell project
RUN USER=root cargo new --bin dom5status
WORKDIR /dom5status

# copy over your manifests
COPY ./Cargo.lock ./Cargo.lock
COPY ./Cargo.toml ./Cargo.toml

# this build step will cache your dependencies
RUN cargo build --release
RUN rm src/*.rs

# copy your source tree
COPY ./src ./src

# build for release
RUN rm ./target/release/deps/dom5status*
RUN cargo build --release

### RUNNER
FROM debian:stretch-slim

RUN apt-get update && apt-get install openssl -y 
# copy the build artifact from the build stage
COPY --from=build /dom5status/target/release/dom5status .

ENV SSL_CERT_FILE=/etc/ssl/cert.pem
ENV SSL_CERT_DIR=/etc/ssl/certs

# set the startup command to run your binary
CMD ["./dom5status"]