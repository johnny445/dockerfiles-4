#!/bin/sh
set -xe

# install DB and assets
if [ -L "$0" ] ; then
    DIR="$(dirname "$(readlink -f "$0")")" ;
else
    DIR="$(dirname "$0")" ;
fi ;

# Install composer and npm dependencies
sh "$DIR/../install.sh";

# Default Docker public address
if [ -z "$PUBLIC_ADDRESS" ]; then
    export PUBLIC_ADDRESS=http://drupal_docker.docker/
fi

set -ex

# Run HEM
export HEM_RUN_ENV="${HEM_RUN_ENV:-local}"
as_build "hem --non-interactive --skip-host-checks assets download"

# Install assets
export DATABASE_NAME=drupaldb
export DATABASE_USER=drupal
export DATABASE_PASSWORD=drupal
export DATABASE_ROOT_PASSWORD=drupal
export DATABASE_HOST=database

sh "$DIR/install_database.sh"
sh "$DIR/install_assets.sh"
