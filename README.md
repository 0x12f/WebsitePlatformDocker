## Template to get started with the platform

[Installation instructions](https://github.com/getwebspace/platform/wiki/Installation-(Docker)) from Docker template [getwebspace/platform-template](https://github.com/getwebspace/platform-template)

#### Running a container from the command line
```shell script
docker run --detach \
  --name getwebspace-platform \
  --publish 80:80 \
  --restart always \ 
  --volume $PWD/resource:/var/container/public/resource:ro \
  --volume $PWD/plugin:/var/container/public/plugin:ro \
  --volume $PWD/theme:/var/container/theme:ro \
  --volume $PWD/var:/var/container/var:rw \
  --volume $PWD/var/upload:/var/container/public/uploads:rw \
  getwebspace/platform:latest
```

#### Running a container with docker-compose.yml
The example takes into account the use of Traefik, you can configure otherwise.
```yaml
version: "3"

networks:
    web:
        external: true

services:
    platform:
        image:  getwebspace/platform:latest
        environment:
            - DEBUG=1
          # - SALT=Please-Change-Me
          # - SIMPLE_PHONE_CHECK=1
          # - DATABASE=mysql://user:secret@localhost/mydb
        volumes:
            - ./resource:/var/container/public/resource:ro
            - ./plugin:/var/container/plugin:rw
            - ./theme:/var/container/theme:ro
            - ./var:/var/container/var:rw
            - ./var/upload:/var/container/public/uploads:rw
        labels:
            - "traefik.enable=true"
            - "traefik.http.routers.example.entrypoints=http,https"
            - "traefik.http.routers.example.tls=true"
            - "traefik.http.routers.example.tls.certresolver=letsEncrypt"
            - "traefik.http.routers.example.rule=Host(`example.com`)"
            - "traefik.http.services.example-service.loadbalancer.server.port=80"
        networks:
            - web
```

#### Folder chmod's
```shell script
chmod -R 0777 resource
chmod -R 0777 plugin
chmod -R 0777 theme
chmod -R 0777 var
```

##### Database chmod (if use sqlite)
```shell script
chmod 0777 var/database.sqlite
```

#### Database schema initialization and update
#### Adding a user with administrator rights
After starting the container, go to `https://[your-domain]/cup/system`
