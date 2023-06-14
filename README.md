![Docker builder](https://github.com/getwebspace/platform/workflows/Docker%20builder/badge.svg)
![License](https://img.shields.io/github/license/getwebspace/platform)
![](https://visitor-badge.glitch.me/badge?page_id=getwebspace.platform.template)

## Template to get started with the platform

[Website](https://getwebspace.org/) |
[Documentation](https://github.com/getwebspace/platform/wiki) |
[Official Repository](https://github.com/getwebspace/platform) |
[Doker template](https://github.com/getwebspace/platform-template) |
[Demo shop](https://demo.getwebspace.org)

#### Running a container with docker-compose.yml

```yaml
version: "3"

services:
    platform:
        image: ghcr.io/getwebspace/platform:latest
        environment:
            - DEBUG=1
          # - SIMPLE_PHONE_CHECK=1
          # - DATABASE=mysql://user:secret@localhost/mydb
        volumes:
            - ./resource:/var/container/public/resource:ro
            - ./plugin:/var/container/plugin:rw
            - ./theme:/var/container/theme:ro
            - ./var:/var/container/var:rw
            - ./var/upload:/var/container/public/uploads:rw
        ports:
            - 9000:80
```

#### Folder chmod's
```shell script
chmod -R 0755 resource
chmod -R 0777 plugin
chmod -R 0777 theme
chmod -R 0777 var
chmod -R 0776 var/upload
```

#### Database schema initialization and update
#### Adding a user with administrator rights
After starting the container, go to `https://[your-domain]/cup/system`


## License
Licensed under the MIT license. See [License File](LICENSE.md) for more information.
