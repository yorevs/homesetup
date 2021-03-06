import setuptools

with open("README.md", "r") as fh:
    long_description = fh.read()

setuptools.setup(
    name='hhslib',
    version='0.9.7',
    description='HomeSetup python library',
    author='Hugo Saporetti Junior',
    author_email='yorevs@hotmail.com',
    packages=setuptools.find_packages(),
    url='https://github.com/yorevs/homesetup'
)
