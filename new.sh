#!/bin/bash 
file="$(date +'%Y%m%d')-$1"
touch content/posts/${file}.md
code content/posts/${file}.md