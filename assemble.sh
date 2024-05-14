#!/bin/sh

set -e

cd $(dirname $0)

./packages.sh
./save.sh
