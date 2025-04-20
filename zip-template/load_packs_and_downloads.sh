#! /bin/bash
# shellcheck disable=SC2016

find . -maxdepth 1 -type d -exec test -e '{}'/pack.toml \; \
    -exec test {} != "./css" \; \
    -exec test {} != "./FontAwesome" \; \
    -exec test {} != "./fonts" \; \
    -exec sh -c 'cp -r "$1" ./book' sh {} \; \
    -exec sh -c 'echo "Copied $1"' sh {} \;

cp -r "./download" book
echo "Copied ./download"
