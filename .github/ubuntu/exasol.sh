#!/bin/bash

set -e

# Download dependencies.
if [ -z "$SKIP_DEPENDS" ]; then
    sudo apt-get update -qq
    sudo env DEBIAN_FRONTEND=noninteractive apt-get install -qq curl unixodbc-dev odbcinst unixodbc default-jre
    cat t/odbc/odbcinst.ini | sudo tee -a /etc/odbcinst.ini
fi

# Prepare the configuration.
mkdir -p /opt/exasol

# Download and unpack Exasol ODBC Driver & EXAplus.
# https://www.exasol.com/portal/display/DOWNLOAD/
curl -sSLO https://x-up.s3.amazonaws.com/7.x/7.1.17/EXASOL_ODBC-7.1.17.tar.gz
curl -sSLO https://x-up.s3.amazonaws.com/7.x/7.1.17/EXAplus-7.1.17.tar.gz
sudo tar -xzf EXASOL_ODBC-7.1.17.tar.gz -C /opt/exasol --strip-components 1
sudo tar -xzf EXAplus-7.1.17.tar.gz     -C /opt/exasol --strip-components 1

# Add to the path.
if [[ ! -z "$GITHUB_PATH" ]]; then
    echo "/opt/exasol" >> $GITHUB_PATH
fi
