#!/usr/bin/env sh

time docker buildx build --push --platform linux/arm64/v8,linux/amd64 --tag n3phtys/liferay-ci:buildx-latest .
