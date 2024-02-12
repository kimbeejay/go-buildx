# Docker CE client with BuildKit and Golang support

### Run
```bash
docker run --rm \
  --name buildx \
  -v /var/run/docker.sock:/var/run/docker.sock \
  -d \
  ghcr.io/kimbeejay/go-buildx:1.21
```
