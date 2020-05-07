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
import subprocess


# @purpose: Encode file into base64
def encode(file_path, outfile):
    with open(file_path, 'r') as in_file:
        with open(outfile, 'w') as out_file:
            out_file.write(str(base64.b64encode(in_file.read())))


# @purpose: Decode file from base64
def decode(file_path, outfile):
    with open(file_path, 'r') as in_file:
        with open(outfile, 'w') as out_file:
            out_file.write(str(base64.b64decode(in_file.read())))


# @purpose: Encrypt file using gpg
def encrypt(file_path, outfile, pass_phrase):
    cmd_args = [
        'gpg', '--quiet', '--yes', '--batch', '--symmetric',
        '--passphrase={}'.format(pass_phrase),
        '--output', outfile, file_path
    ]
    subprocess.check_output(cmd_args, stderr=subprocess.STDOUT)


# @purpose: Decode and then, decrypt the vault file
def decrypt(filepath, outfile, pass_phrase, digest_algo='SHA512'):
    cmd_args = [
        'gpg', '--quiet', '--yes', '--batch', '--digest-algo', digest_algo,
        '--passphrase={}'.format(pass_phrase),
        '--output', outfile, filepath
    ]
    subprocess.check_output(cmd_args, stderr=subprocess.STDOUT)
