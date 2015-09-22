#!/bin/sh

echo "Hello world" | tee -a /tmp/hello
rm /tmp/hello
