# Alpine image to build
FROM alpine:latest AS builder

# Install Go for building
RUN apk add --no-cache go git

# Set working directory to /app
WORKDIR /app

# Install dependencies
COPY go.mod go.sum ./
RUN go mod download

# Build the application
COPY . .
RUN go build -o noah-mqtt cmd/noah-mqtt/main.go

# Home Assistant Add-on base image
ARG BUILD_FROM=ghcr.io/home-assistant/base:latest
FROM $BUILD_FROM

# Copy built binary
COPY --from=builder /app/noah-mqtt /usr/bin/noah-mqtt

# Set permissions
RUN chmod +x /usr/bin/noah-mqtt

# Start application
CMD ["/usr/bin/noah-mqtt"]
