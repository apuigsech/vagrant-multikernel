#!/usr/bin/env bash

BASE_PATH=$(pwd)

set -e
set -o pipefail
set -x

sudo apt-get update > /dev/null
sudo apt-get upgrade -y > /dev/null

source conf/setup.conf
source lib/utils.sh