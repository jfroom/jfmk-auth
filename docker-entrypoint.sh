#!/bin/bash

set -e
bundle check || bundle install
exec "$@"
