"""
    @package: hhslib
    @script: fetch.py
    @purpose: HTTP request functions library
    @created: Mon 27, 2020
    @author: <B>H</B>ugo <B>S</B>aporetti <B>J</B>unior
    @mailto: yorevs@hotmail.com
    @site: https://github.com/yorevs/homesetup
    @license: Please refer to <https://opensource.org/licenses/MIT>
"""
import json
import subprocess

from colors import cprint, Colors


def __convert_headers(headers):
    flat_headers = {}
    for d in headers:
        flat_headers.update(d)
    str_headers = ""
    for key, value in flat_headers.iteritems():
        temp = "{}={}".format(key, value)
        str_headers += temp if not str_headers else "," + temp

    return '"{}"'.format(str_headers)


def __convert_body(body):
    if type(body) is str:
        return body
    elif type(body) is dict:
        return json.dumps(body)
    else:
        return json.dumps(body.__dict__)


def fetch(url, method='GET', headers=None, body=None, silent=True):
    cmd_args = ['fetch.bash', method, '--silent']
    if headers is not None:
        cmd_args.append('--headers')
        cmd_args.append(__convert_headers(headers))
    if body is not None:
        cmd_args.append('--body')
        cmd_args.append(__convert_body(body))
    cmd_args.append(url)

    try:
        if not silent:
            cprint(Colors.GREEN, 'Fetching: method={} headers={} body={} url={} ...'
                   .format(method, headers if headers else '[]', body if body else '{}', url))
        response = subprocess.check_output(cmd_args, stderr=subprocess.STDOUT)
        return json.dumps(response).strip()
    except subprocess.CalledProcessError as err:
        print("Failed to fetch: method={} headers={} body={} url={} \t => {}"
              .format(method, headers if headers else '[]', body if body else '', url, err.message))
        return None


def get(url, headers=None, silent=False):
    return fetch(url, 'GET', headers, None, silent)


def delete(url, headers=None, silent=False):
    return fetch(url, 'DELETE', headers, None, silent)


def post(url, body, headers=None, silent=False):
    return fetch(url, 'POST', headers, body, silent)


def put(url, body, headers=None, silent=False):
    return fetch(url, 'PUT', headers, body, silent)


def patch(url, body, headers=None, silent=False):
    return fetch(url, 'PATCH', headers, body, silent)

