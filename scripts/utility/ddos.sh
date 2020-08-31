#!/usr/bin/env bash

for concurrency in 100 500 1000 2000 5000 10000 15000 20000 30000; do
   h2load -D10 -c "$concurrency" "$1"
   sleep 5s
done
