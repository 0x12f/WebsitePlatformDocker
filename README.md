## Docker platform template

#### Run with command line
```shell script
docker run --detach \
  --name 0x12f-platform \
  --restart always \
  --volume $PWD/resource:/var/container/public/resource:ro \
  --volume $PWD/theme:/var/container/theme:ro \
  --volume $PWD/var:/var/container/var:rw \
  --volume $PWD/var/upload:/var/container/public/uploads:rw \
  --security-opt="traefik.enable=true" \
  --security-opt="traefik.port=80" \
  --security-opt="traefik.backend=example.site.0x12f.com" \
  --security-opt="traefik.frontend.rule=Host:example.site.0x12f.com" \
  --security-opt="traefik.frontend.redirect.entryPoint=https" \
  --security-opt="traefik.docker.network=web" \
  0x12f/platform:latest
```

#### Run with docker-compose.yml
```yaml
version: "3"

networks:
    web:
        external: true

services:
    platform:
        image:  0x12f/platform:latest
        volumes:
            - $PWD/resource:/var/container/public/resource:ro
            - $PWD/theme:/var/container/theme:ro
            - $PWD/var:/var/container/var:rw
            - $PWD/var/upload:/var/container/public/uploads:rw
        labels:
            - traefik.enable=true
            - traefik.port=80
            - traefik.backend=example.site.0x12f.com
            - traefik.frontend.rule=Host:example.site.0x12f.com
          # - traefik.frontend.redirect.entryPoint=https
            - traefik.docker.network=web
        networks:
            - web
```
