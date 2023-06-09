# Docker container for OpenForti VPN

This Docker container creates OpenForti VPN session and exposes it to the host system as a SOCKS5 proxy at port 8081 and SSH proxy at port 63010.

## Building

```
docker build -t openfortivpn-docker .
```

## Deployment

1. Provide a `config` file based on `config.example`.
2. Add a public key into `authorized_keys`, if you plan to proxy SSH connections to a VPN

```
docker-compose up -d
```

## Usage

1. Use `localhost:8080` as a SOCKS5 proxy in your browser, e.g. Firefox
2. Use `ProxyJump` command to proxy the SSH connection to a VPN:

```
Host vpn
    Hostname localhost
    User user
    IdentityFile ~/.ssh/keys/id_ed25519.vpn
    Port 63010
    ForwardAgent yes
Host machine_in_vpn
    Hostname 1.2.3.4
    User john
    Port 22
    ForwardAgent yes
    ProxyJump vpn
```

Then run `ssh machine_in_vpn` to connect to some computer in the VPN.

