#!/bin/sh

services=(
cu
gitlab
github
bitbucket
ericbismenet
)

for i in "${services[@]}"
do
  ssh-keygen -b 2048 -t rsa -f $HOME/.ssh/$i -q -P ""
done


