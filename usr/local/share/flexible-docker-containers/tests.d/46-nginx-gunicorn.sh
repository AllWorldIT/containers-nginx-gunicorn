#!/bin/bash
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


fdc_test_start nginx-gunicorn "Check Nginx is responding to static file requests using IPv4..."
if ! curl --verbose --ipv4 "http://localhost/static/file.css" --output test.static.out; then
	fdc_test_fail nginx-gunicorn "Failed to get static file from Nginx using IPv4"
	false
fi

echo "/* TEST STATIC SUCCESS */" > test.static.out.correct
if ! diff test.static.out.correct test.static.out; then
	fdc_test_fail nginx-gunicorn "Contents of static file does not match what it should be using IPv4"
	false
fi

fdc_test_pass nginx-gunicorn "Nginx is responding to static files using IPv4"


# Return if we don't have IPv6 support
if [ -z "$(ip -6 route show default)" ]; then
	fdc_test_alert nginx-gunicorn "Not running IPv6 tests due to no IPv6 default route"
	return
fi


fdc_test_start nginx-gunicorn "Check Nginx is responding to static file requests using IPv6..."
if ! curl --verbose --ipv6 "http://localhost/static/file.css" --output test.static.out; then
	fdc_test_fail nginx-gunicorn "Failed to get static file from Nginx using IPv6"
	false
fi

echo "/* TEST STATIC SUCCESS */" > test.static.out.correct
if ! diff test.static.out.correct test.static.out; then
	fdc_test_fail nginx-gunicorn "Contents of static file does not match what it should be using IPv6"
	false
fi

fdc_test_pass nginx-gunicorn "Nginx is responding to static files using IPv6"
