#!/usr/bin/env bash
set -euo pipefail
BASEDIR=$(pwd)

for file in $(find app/ -type f -name makefile); do
	dir=$(dirname ${file})
	cd ${BASEDIR}/${dir}
	source ./config.env
	make build
	kind --name local load docker-image go-live/${APP_IMAGE}:${APP_VERSION}
done