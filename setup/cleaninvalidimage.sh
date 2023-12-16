#!/bin/bash
#
# Author: lvx
# Date: 2023-12-16
# Description: Cleaning up images with tag=none.

image_ids=$(docker images -f "dangling=true" -q)
num=$(docker images -f "dangling=true" -q | wc -l)

if [ $num -ne 0 ]; then
  echo -e "\nThe number of invalid images cleared is:$num"
  docker rmi -f $image_ids 
fi