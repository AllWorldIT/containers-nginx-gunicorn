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


if [ "$GUNICORN_WORKER_CLASS" = "uvicorn.workers.UvicornWorker" ]; then
    cat <<EOF > /app/app.py
from fastapi import FastAPI
from fastapi.responses import HTMLResponse

app = FastAPI()

@app.get('/')
def root():
    return HTMLResponse(content='TEST SUCCESS\n', status_code=200)
EOF
    cat <<EOF > /app/requirements.txt
fastapi
EOF

python -m venv /app/.venv
(
    # shellcheck disable=SC1091
    . /app/.venv/bin/activate

    pip install 'uvicorn[standard]' 'gunicorn' 'setproctitle' 'gevent'
    pip install -r /app/requirements.txt
)

else
    cat <<EOF > /app/app.py
from flask import Flask
app = Flask(__name__)

@app.route('/')
def root():
    return 'TEST SUCCESS\n'
EOF
    cat <<EOF > /app/requirements.txt
flask
EOF

python -m venv /app/.venv
(
    # shellcheck disable=SC1091
    . /app/.venv/bin/activate

    pip install 'gunicorn' 'setproctitle' 'gevent'
    pip install -r /app/requirements.txt
)

fi


mkdir /app/static
echo '/* TEST STATIC SUCCESS */' > /app/static/file.css
