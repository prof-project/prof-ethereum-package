#!/bin/bash
cd "$(dirname "$0")"

export DOCKER_HOST="$(docker context inspect --format '{{ .Endpoints.docker.Host }}')"
cd ..
kurtosis run --cli-log-level error --enclave prof-test . --args-file test/network_params.yaml
