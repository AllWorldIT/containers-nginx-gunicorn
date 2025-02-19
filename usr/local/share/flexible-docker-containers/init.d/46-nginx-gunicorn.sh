#!/bin/bash
# Copyright (c) 2022-2025, AllWorldIT.
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


fdc_notice "Creating Nginx Gunicorn directories"

# Check our run directory exists
if [ ! -d /run/gunicorn ]; then
	fdc_info "Creating Nginx Gunicorn runtime directory"
	mkdir /run/gunicorn
	chown gunicorn:nginx /run/gunicorn
	chmod 0750 /run/gunicorn
fi

# Check our temporary directory exists
if [ ! -d /var/tmp/gunicorn ]; then
	fdc_info "Creating Nginx Gunicorn temporary directory"
	mkdir /var/tmp/gunicorn
	chown gunicorn:gunicorn /var/tmp/gunicorn
	chown 0750 /var/tmp/gunicorn
fi


fdc_notice "Initializing Nginx Gunicorn settings"

# Setup number of workers and threads
GUNICORN_WORKERS="${GUNICORN_WORKERS:-2}"
GUNICORN_WORKER_THREADS="${GUNICORN_WORKER_THREADS:-2}"

# Application module and callable
GUNICORN_MODULE="${GUNICORN_MODULE:-app}"
GUNICORN_CALLABLE="${GUNICORN_CALLABLE:-app}"

# Other defaults
GUNICORN_LOGLEVEL="${GUNICORN_LOGLEVEL:-info}"


# Write out environment and fix perms of the config file
set | grep -E '^GUNICORN_(ACCESS_LOGFILE|MODULE|CALLABLE|LOGLEVEL|WORKER(S|_THREADS|_CLASS))=' > /etc/gunicorn/gunicorn.conf
chown root:gunicorn /etc/gunicorn/gunicorn.conf
chmod 0640 /etc/gunicorn/gunicorn.conf

# Decide what we're doing about the app environment
if [ ! -e /etc/gunicorn/gunicorn.env ]; then
	if set | grep -q -E '^GUNICORN_ENV_'; then
		fdc_notice "Writing out custom Gunicorn environment variables"
		set | grep -E '^GUNICORN_ENV_' | sed -e 's/^GUNICORN_ENV_//' > /etc/gunicorn/gunicorn.env
	fi
fi
if [ -e /etc/gunicorn/gunicorn.env ]; then
	chown root:gunicorn /etc/gunicorn/gunicorn.env
	chmod 0640 /etc/gunicorn/gunicorn.env
fi
