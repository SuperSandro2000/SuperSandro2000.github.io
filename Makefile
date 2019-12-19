.DEFAULT_GOAL := all
MAKEFLAGS=--warn-undefined-variables
SHELL := /bin/bash

SUDO ?= $(shell if ! groups | grep -q docker; then echo 'sudo --preserve-env=DOCKER_BUILDKIT'; fi)

.PHONY: primer
primer:
	wget https://unpkg.com/primer/build/build.css -O _sass/_build.scss

_posts/2019-12-18-useful-links.md: _posts/_2019-12-18-useful-links.md _useful-links/README.md
	cat _posts/_2019-12-18-useful-links.md >$@
	tail _useful-links/README.md -n +5 >>$@

.PHONY: build
build: _posts/2019-12-18-useful-links.md
	$(SUDO) docker build . --pull

.PHONY: dev
dev: _posts/2019-12-18-useful-links.md
	$(SUDO) docker build . --pull -f dev.Dockerfile -t personal-website-dev
	$(SUDO) docker run --rm -p 4000:4000 personal-website-dev

.PHONY: all
all: build
