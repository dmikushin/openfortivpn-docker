# Docker container for OpenForti VPN

This Docker container creates OpenForti VPN session and exposes it to the host system as a SOCKS5 proxy at port 8081.

## Building

```
docker build -t openfortivpn-docker -f docker/Dockerfile .
```

## Usage

```
docker-compose up -d
```

