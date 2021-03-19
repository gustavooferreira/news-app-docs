# Setup Guide

To spin up all the components locally, I've provided a `docker-compose` file.

The `docker-compose` file is located in this repository to avoid creating yet another repo.

First, you will have to generate the docker images for all 3 services mentioned in the [readme](README.md) and [design document](SYSTEM_DESIGN.md). Instructions provided in the corresponding repo of each service.

Once you have the 3 images in your local docker images cache, you can start the environment.

To start the development environment please run the following command:

```bash
make start-docker-env
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

You can immediately start firing requests to those APIs according to the instruction in [usage guide](USAGE.md).

For more details about the APIs, please find their respective specifications in the `openapi` directory.
