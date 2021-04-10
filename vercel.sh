#!/bin/bash

amazon-linux-extras install golang1.11 
go install github.com/barelyhuman/statico
export PATH=$PATH:$HOME/go/bin/
statico
