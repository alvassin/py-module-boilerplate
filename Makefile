#!/usr/bin/make

CI_PROJECT_NAME ?= $(shell python3 setup.py --name)

VERSION = $(shell python3 setup.py --version | tr '+' '-')
PROJECT_PATH := $(shell echo $(CI_PROJECT_NAME) | tr '-' '_')


all:
	@echo "make devenv			- Configure the development environment"
	@echo "make build			- Build package"
	@echo "make test			- Run tests"
	@echo "make upload			- Upload this project to the registry"
	@echo "make clean			- Remove files which are created by distutils"
	@exit 0

devenv:
	rm -rf env
	virtualenv -p python3.7 env
	env/bin/pip install -Ue '.[develop]'

clean:
	rm -fr *.egg-info .tox dist build $(PROJECT_PATH)/version.py
	find . -iname '*.pyc' -delete

version:
	env/bin/python bump.py $(PROJECT_PATH)/version.py

build: clean version
	env/bin/python setup.py sdist bdist_wheel

test: clean version
	env/bin/tox -r

upload: clean build
	twine upload --skip-existing \
		dist/*.gz dist/*.whl || \
		(echo "Do you have pypi repository configured?"; exit 1)


