[![pipeline status](https://gitlab.conarx.tech/containers/nginx-gunicorn/badges/main/pipeline.svg)](https://gitlab.conarx.tech/containers/nginx-gunicorn/-/commits/main)

# Container Information

[Container Source](https://gitlab.conarx.tech/containers/nginx-gunicorn) - [GitHub Mirror](https://github.com/AllWorldIT/containers-nginx-gunicorn)

This is the Conarx Containers Nginx Gunicorn image, it provides the Nginx webserver bundled with Gunicorn for serving of Python-based web
applications.

Support is included for downloading and installing requirements listed in `requirements.txt` and optionally persisting these across
container restarts.

Static files are by default served by Nginx directly if placed in the `static/` folder of an application.



# Mirrors

|  Provider  |  Repository                                    |
|------------|------------------------------------------------|
| DockerHub  | allworldit/nginx-gunicorn                      |
| Conarx     | registry.conarx.tech/containers/nginx-gunicorn |



# Conarx Containers

All our Docker images are part of our Conarx Containers product line. Images are generally based on Alpine Linux and track the
Alpine Linux major and minor version in the format of `vXX.YY`.

Images built from source track both the Alpine Linux major and minor versions in addition to the main software component being
built in the format of `vXX.YY-AA.BB`, where `AA.BB` is the main software component version.

Our images are built using our Flexible Docker Containers framework which includes the below features...

- Flexible container initialization and startup
- Integrated unit testing
- Advanced multi-service health checks
- Native IPv6 support for all containers
- Debugging options



# Community Support

Please use the project [Issue Tracker](https://gitlab.conarx.tech/containers/nginx-gunicorn/-/issues).



# Commercial Support

Commercial support for all our Docker images is available from [Conarx](https://conarx.tech).

We also provide consulting services to create and maintain Docker images to meet your exact needs.



# Environment Variables

Additional environment variables are available from...
* [Conarx Containers Nginx image](https://gitlab.conarx.tech/containers/nginx)
* [Conarx Containers Postfix image](https://gitlab.conarx.tech/containers/postfix)
* [Conarx Containers Alpine image](https://gitlab.conarx.tech/containers/alpine)


## GUNICORN_WORKERS

Number of Gunicorn workers to spawn, defaults to `2`.


## GUNICORN_WORKER_CLASS

Worker class to use with Gunicorn. eg. `uvicorn.workers.UvicornWorker`. Defaults to "".


## GUNICORN_WORKER_THREADS

Number of Gunicorn workers to spawn, defaults to `2`.


## GUNICORN_MODULE

Application module to use, defaults to `app`.


## GUNICORN_CALLABLE

Application callable, defaults to `app`.


## GUNICORN_LOGLEVEL

Gunicorn log level, defaults to `info`.


## GUNICORN_ACCESS_LOGFILE

Gunicorn access logfile, defaults to not being set. Can be set to `-` to log to Docker.


## GUNICORN_ENV_*

Environment to export to Gunicorn, where `GUNICORN_ENV_` will be stripped from each item.



# Volumes


## /app

Application directory.



# Exposed Ports

Postfix port 25 is exposed by the [Conarx Containers Postfix image](https://gitlab.conarx.tech/containers/postfix) layer.

Nginx port 80 is exposed by the [Conarx Containers Nginx image](https://gitlab.conarx.tech/containers/nginx) layer.



# Files & Directories

Configuration for Nginx can also be overridden, see the source for this containers Nginx configuration and
[Conarx Containers Nginx image](https://gitlab.conarx.tech/containers/nginx) for more details.


## /etc/gunicorn/gunicorn.env

Environment to export to Gunicorn. This is created from `GUNICORN_ENV_*` where `GUNICORN_ENV_` is stripped off if it does not exist
an there are environment variables with that name.


## /app/gunicorn.conf.py

Gunicorn Python-based configuration file. See Gunicorn documentation for more details.


## /app/requirements.txt

For `uvicorn` workers, the `requirements.txt` needs to contain `uvicorn[standard]`.

If `/app/requirements.txt` exists, pip will be used to install the relevant dependencies.

The virtual environment along with dependencies can be persisted using a volume for `/app/.venv`.


## /app/static/

This directory will be served directly from Nginx bypassing Gunicorn by default.


## /app/.venv/

Virtual environment for the application which must be created beforehand. The requirement `uvicorn[standard]` must be included.

This can be created with the following for Uvicorn workers...

```sh
docker run -it --rm \
    -v /path/to/venv:/app/.venv \
    -v /path/to/app/requirements.txt:/app/requirements.txt \
    allworldit/nginx-gunicorn \
    /bin/sh -c "python -m venv /app/.venv; . /app/.venv/bin/activate; pip install 'uvicorn[standard]' 'gunicorn' 'setproctitle'; pip install --requirement /app/requirements.txt"
```

or using the following without Uvicorn workers...

```sh
docker run -it --rm \
    -v /path/to/venv:/app/.venv \
    -v /path/to/app/requirements.txt:/app/requirements.txt \
    allworldit/nginx-gunicorn \
    /bin/sh -c "python -m venv /app/.venv; . /app/.venv/bin/activate; pip install 'gunicorn' 'setproctitle' 'gevent'; pip install --requirement /app/requirements.txt"
```


## /run/gunicorn

Run directory.


## /var/tmp/gunicorn

Temporary directory.



# Health Checks

Health checks are done by the underlying
[Conarx Containers Nginx image](https://gitlab.iitsp.com/allworldit/docker/nginx/README.md).
