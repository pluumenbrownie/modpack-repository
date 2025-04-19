#! /bin/bash

# Write the metadata file book.toml
echo '[book]' >book.toml
echo 'title = "Pluumenbrownies Modpack Repository"' >>book.toml
cat book.toml

# Write the SUMMARY.md file and automatically find the
echo '[Overview](overview.md)' >src/SUMMARY.md
find . -type d -exec test -e '{}'/pack.toml \; \
    -exec sh -c 'echo "- [$(toml get $1/pack.toml name)]($1.md)" >>src/SUMMARY.md' sh {} \; \
    -exec sh -c 'echo $1 >src/$1.md' sh {} \; \
    -exec sh -c 'echo $1' sh {} \; \
    -exec sh -c 'cat $1.md' sh {} \;
cat src/SUMMARY.md

# Create overview page in overview.md
echo 'Something overviewing' >src/overview.md
