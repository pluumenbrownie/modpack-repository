#! /bin/bash
# shellcheck disable=SC2016

find . -maxdepth 1 -type d -exec test -e '{}'/pack.toml \; \
    -exec test {} != "./css" \; \
    -exec test {} != "./FontAwesome" \; \
    -exec test {} != "./fonts" \; \
    -exec bash -c 'cp -r "$1" ./book' bash {} \; \
    -exec bash -c 'echo "Copied $1"' bash {} \;

cp -r "./download" book
echo "Copied ./download"
