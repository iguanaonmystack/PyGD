import subprocess
from setuptools import setup, find_packages, Extension
from Cython.Build import cythonize
from Cython.Compiler import Options

Options.annotate = True

#dependency_includes = subprocess.run(
#    ['pkg-config', '--cflags', 'cheese'],
#    stdout=subprocess.PIPE
#).stdout.decode().strip().replace('-I', '').split(' ')

ext_modules = cythonize([Extension(
    '*',
    ['pygd/*.pyx'],
    #include_dirs=dependency_includes,
    libraries=['gd'],
)])

setup(
    name='PyCheese',
    version='0.1',
    description='Python bindings for libcheese',
    packages=find_packages(),
    ext_modules=ext_modules,
)
