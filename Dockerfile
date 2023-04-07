# Copyright (c) 2022-2023, AllWorldIT.
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to
# deal in the Software without restriction, including without limitation the
# rights to use, copy, modify, merge, publish, distribute, sublicense, and/or
# sell copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
# FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS
# IN THE SOFTWARE.


FROM registry.conarx.tech/containers/nginx/edge


ARG VERSION_INFO=
LABEL org.opencontainers.image.authors   "Nigel Kukard <nkukard@conarx.tech>"
LABEL org.opencontainers.image.version   "edge"
LABEL org.opencontainers.image.base.name "registry.conarx.tech/containers/nginx/edge"


RUN set -eux; \
	true "Gunicorn"; \
	apk add --no-cache \
		py3-gunicorn \
		py3-setproctitle \
		# NK: check if Alpine Linux has Uvicorn on update
		py3-gevent; \
	true "Gunicorn user"; \
	addgroup -S gunicorn 2>/dev/null; \
	adduser -S -D -H -h /app -s /sbin/nologin -G gunicorn -g gunicorn gunicorn 2>/dev/null; \
	true "Web app"; \
	mkdir -p /app; \
	addgroup gunicorn www-data 2>/dev/null; \
	true "Gunicorn directories"; \
	mkdir -p /etc/gunicorn; \
	true "Cleanup"; \
	rm -f /var/cache/apk/*


# We'll be using our own tests
RUN set -eux; \
	rm -f usr/local/share/flexible-docker-containers/pre-init-tests.d/44-nginx.sh


# Nginx - override the default vhost to include UWSGI support
COPY etc/nginx/http.d/50_vhost_default.conf.template /etc/nginx/http.d
COPY etc/nginx/http.d/55_vhost_default-ssl-certbot.conf.template /etc/nginx/http.d


# Gunicorn
COPY etc/supervisor/conf.d/gunicorn.conf /etc/supervisor/conf.d/gunicorn.conf
COPY usr/local/sbin/start-gunicorn /usr/local/sbin
COPY usr/local/share/flexible-docker-containers/init.d/46-nginx-gunicorn.sh /usr/local/share/flexible-docker-containers/init.d
COPY usr/local/share/flexible-docker-containers/pre-init-tests.d/46-nginx-gunicorn.sh /usr/local/share/flexible-docker-containers/pre-init-tests.d
COPY usr/local/share/flexible-docker-containers/tests.d/46-nginx-gunicorn.sh /usr/local/share/flexible-docker-containers/tests.d
RUN set -eux; \
	true "Flexible Docker Containers"; \
	if [ -n "$VERSION_INFO" ]; then echo "$VERSION_INFO" >> /.VERSION_INFO; fi; \
	true "Permissions"; \
	chown gunicorn:gunicorn \
		/etc/gunicorn; \
	chown root:root \
		/app \
		/etc/nginx/http.d/50_vhost_default.conf.template \
		/etc/nginx/http.d/55_vhost_default-ssl-certbot.conf.template \
		/usr/local/sbin/start-gunicorn; \
	chmod 0644 \
		/etc/nginx/http.d/50_vhost_default.conf.template \
		/etc/nginx/http.d/55_vhost_default-ssl-certbot.conf.template; \
	chmod 0755 \
		/app \
		/etc/gunicorn \
		/usr/local/sbin/start-gunicorn; \
	fdc set-perms
