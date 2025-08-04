# [opencode](https://github.com/sst/opencode) docker images

[![version](https://ghcr-badge.egpl.dev/spotdemo4/opencode/latest_tag?color=%2344cc11&ignore=latest&label=version&trim=)](https://github.com/spotdemo4/opencode-docker/pkgs/container/opencode)
[![size](https://ghcr-badge.egpl.dev/spotdemo4/opencode/size?color=%2344cc11&tag=latest&label=image+size&trim=)](https://github.com/spotdemo4/opencode-docker/pkgs/container/opencode)

```yaml
# docker-compose.yaml
services:
  opencode:
    image: ghcr.io/spotdemo4/opencode:latest
    container_name: opencode
    ports:
      - '4096:4096'
    volumes:
      - ~/.local/share/opencode/auth.json:/root/.local/share/opencode/auth.json
    restart: unless-stopped
```