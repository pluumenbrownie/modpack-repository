#! /bin/bash

echo -e '[book]\ntitle = "Pluumenbrownies Modpack Repository"' >book.toml
echo -e '[Overview](overview.md)' >src/SUMMARY.md

find . -type d -exec test -e '{}'/pack.toml \; \
    -exec sh -c 'echo -e "- [$(toml get $1/pack.toml name)]($1.md)" >>src/SUMMARY.md' sh {} \; \
    -exec sh -c 'echo -e $1 >src/$1.md' sh {} \; \
    -exec sh -c 'echo $1' sh {} \;

echo -e 'Something overviewing' >src/overview.md
