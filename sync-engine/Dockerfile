#Build
FROM Rust:1.70-slim as builder

WORKDIR /app
COPY . .

#Install dependencies
RUN echo "deb http://security.debian.org/debian-security bullseye-security main" >> /etc/apt/sources.list && \
    apt-get update && \
    apt-get install -y \
    libssl-dev \
    pkg-config \
    ca-certificates \
    && rm -rf /var/lib/apt/lists/*

#Compile in release mode
RUN cargo build --release

#Final image
FROM debian:bullseye-slim

WORKDIR /app

#Copy the binary from the builder image
COPY --from=builder /app/target/release/sync-engine .
COPY infra/sync-config.toml ./config.toml

#Port to expose
EXPOSE 8080

#Init command
CMD ["./sync-engine", "--config", "config.toml"]


