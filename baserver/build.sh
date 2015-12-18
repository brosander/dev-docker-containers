#!/bin/bash

cd "$(dirname "$0")"
docker build -t bryanrosander/pentaho-baserver .
