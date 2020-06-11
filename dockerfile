### BUILDER
FROM rust:1.44.0-buster as build

# Create new empty project
RUN USER=root cargo new --bin dom5status
WORKDIR /dom5status

# Copy manifests
COPY ./Cargo.lock ./Cargo.lock
COPY ./Cargo.toml ./Cargo.toml

# this build step will cache your dependencies
RUN cargo build --release
RUN rm src/*.rs

# Copy source tree
COPY ./src ./src

RUN rm ./target/release/deps/dom5status*
RUN cargo build --release

### RUNNER
FROM debian:buster-slim

### Openssl + CA Certs
RUN apt-get update && apt-get -y install ca-certificates libssl-dev && rm -rf /var/lib/apt/lists/*

# Copy build artifact 
COPY --from=build /dom5status/target/release/dom5status .

# Start
CMD ["./dom5status"]