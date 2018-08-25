from setuptools import setup, find_packages, Extension
from Cython.Build import cythonize
from Cython.Compiler import Options

Options.annotate = True

ext_modules = cythonize(Extension('*', ['pygd/*.pyx'], libraries=['gd']))

setup(
    name='PyGD',
    version='0.1',
    description='Python bindings for libgd (libgd.github.io)',
    packages=find_packages(),
    ext_modules=ext_modules,
)
