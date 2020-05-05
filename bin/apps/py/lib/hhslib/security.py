"""
    @package: hhslib
    @script: security.py
    @purpose: Common security library
    @created: Mon 04, 2020
    @author: <B>H</B>ugo <B>S</B>aporetti <B>J</B>unior
    @mailto: yorevs@hotmail.com
    @site: https://github.com/yorevs/homesetup
    @license: Please refer to <https://opensource.org/licenses/MIT>
"""
import base64


# @purpose: Encode file into base64
import subprocess


def encode(filepath, outfile):
    with open(filepath, 'r') as in_file:
        with open(outfile, 'w') as out_file:
            out_file.write(str(base64.b64encode(in_file.read())))


# @purpose: Decode file from base64
def decode(filepath, outfile):
    with open(filepath, 'r') as in_file:
        with open(outfile, 'w') as out_file:
            out_file.write(str(base64.b64decode(in_file.read())))


# @purpose: Encrypt file using gpg
def encrypt(filepath, outfile, passphrase):
    cmd_args = [
        'gpg', '--quiet', '--yes', '--batch', '--symmetric',
        '--passphrase={}'.format(passphrase),
        '--output', outfile, filepath
    ]
    subprocess.check_output(cmd_args, stderr=subprocess.STDOUT)


# @purpose: Decode and then, decrypt the vault file
def decrypt(filepath, outfile, passphrase):
    cmd_args = [
        'gpg', '--quiet', '--yes', '--batch', '--digest-algo', 'SHA512',
        '--passphrase={}'.format(passphrase),
        '--output', outfile, filepath
    ]
    subprocess.check_output(cmd_args, stderr=subprocess.STDOUT)
