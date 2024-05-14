#!/bin/sh

cd $(dirname $0)

screen -ls $(basename $(pwd)) && exit 0

screen -a -dmS $(basename $(pwd)) ./up.sh
