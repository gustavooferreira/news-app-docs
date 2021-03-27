# Setup Guide

To spin up all the components locally, I've provided a `docker-compose` file.

The `docker-compose` file is located in this repository to avoid creating yet another repo.

First, you will have to generate the docker images for all 3 services mentioned in the [readme](README.md) and [design document](SYSTEM_DESIGN.md).

To build the images, all you need to do is clone each service repo, and while inside each repo's folder, run:

```bash
make build-docker
```

**NOTE:** If you try to build these docker images on a Mac with a M1 processor you might face issues. On line 20 of the `Dockerfiles` I'm pinning the architecture to x86-64. If you face issues, please remove `GOARCH=amd64` from the `go build` command.

Once you have the 3 images in your local docker images cache, you can start the environment.

To start the development environment please run the following command:

```bash
make start-docker-env
```

Once the environment is started, you will need to wait around 30 to 40 seconds for the MySQL database to be fully ready. Both the feeds and articles management services won't be operational until the database is ready.

Only start exploring the environment once you get a 200 response on both service's healthcheck endpoints:

```bash
curl -i http://localhost:9000/api/v1/healthcheck
curl -i http://localhost:9001/api/v1/healthcheck
```

To stop the development environment please run the following command:

```bash
make stop-docker-env
```

---

## Environment details

Both API ports are exposed on the host as follows:

- Feeds Management API port: 9000
- Articles Management API port: 9001

You can immediately start firing requests to those APIs according to the instructions in the [usage guide](USAGE.md).

For more details about the APIs, please find their respective specifications in the [openapi directory](openapi).

# Notes

The `news_feeds` database comes preloaded with the following entries.

Table `feeds`:

| url                                               | provider | category | enabled |
| ------------------------------------------------- | :------: | :------: | :-----: |
| http://feeds.bbci.co.uk/news/uk/rss.xml           |    1     |    1     |  true   |
| http://feeds.bbci.co.uk/news/technology/rss.xml   |    1     |    2     |  true   |
| http://feeds.skynews.com/feeds/rss/uk.xml         |    2     |    1     |  true   |
| http://feeds.skynews.com/feeds/rss/technology.xml |    2     |    2     |  true   |

Table `providers`:

| id  | name     |
| :-: | -------- |
|  1  | BBC News |
|  2  | Sky News |

Table `categories`:

| id  | name       |
| :-: | ---------- |
|  1  | UK         |
|  2  | Technology |
