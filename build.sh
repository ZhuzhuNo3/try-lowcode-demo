#!/usr/bin/env bash

img=lowcode-demo
tag=zz

docker build --squash -t "$img:$tag" .

# save
# docker save "$img:$tag" | gzip > "$img".tar.gz
