#!/usr/bin/env sh

docker build --no-cache -t n3phtys/liferay-ci:7.3ga6 --build-arg CORETTO_ARCH=x64 .
