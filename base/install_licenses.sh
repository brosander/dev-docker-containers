#!/bin/bash

if [ -e "/license-installer/install_license.sh" ]; then
  gosu pentaho /license-installer/install_license.sh install -q /pentaho-licenses/*.lic
else
  echo "No license installer found."
fi
