#!/bin/bash

source ../lib/utils.sh

if [$# -ne 1]; then 
	echo "Use:"
	echo "      install-kernel.sh <version>"
	exit
fi

install-kernel $1