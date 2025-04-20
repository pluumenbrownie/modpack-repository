#! /bin/bash
# shellcheck disable=SC2016

help export

remove_dotslash() {
    echo "$1" | sed s/\\.\\///g
}
export -f remove_dotslash

detect_modloader() {
    LOADER="failed"
    toml get -r "$1" versions.forge >/dev/null && LOADER="forge"
    toml get -r "$1" versions.neoforge >/dev/null && LOADER="neoforge"
    toml get -r "$1" versions.quilt >/dev/null && LOADER="quilt"
    toml get -r "$1" versions.fabric >/dev/null && LOADER="fabric"
    echo "$LOADER"
}
export -f detect_modloader

print_modloader() {
    echo "$(detect_modloader $1/pack.toml) ($(toml get -r $1/pack.toml versions.$(detect_modloader $1/pack.toml)))"
}
export -f print_modloader

# Write the metadata file book.toml
echo '[book]' >book.toml
echo 'title = "Pluumenbrownies Modpack Repository"' >>book.toml
cat book.toml

mkdir src
# Write the SUMMARY.md file and automatically find the modpacks
echo '[Overview](overview.md)' >src/SUMMARY.md
find . -type d -exec test -e '{}'/pack.toml \; \
    -exec sh -c 'echo "- [$(toml get $1/pack.toml name)]($1.md)" >>src/SUMMARY.md' sh {} \; \
    -exec sh -c 'echo "# $(toml get -r $1/pack.toml name)" >src/$1.md' sh {} \; \
    -exec sh -c 'echo "| Info |      |" >>src/$1.md' sh {} \; \
    -exec sh -c 'echo "|------|------|" >>src/$1.md' sh {} \; \
    -exec sh -c 'echo "| **Minecraft version:** | $(toml get -r $1/pack.toml versions.minecraft) |" >>src/$1.md' sh {} \; \
    -exec sh -c 'echo "| **Modloader (version):** | $(print_modloader $1) |" >>src/$1.md' sh {} \; \
    -exec sh -c 'echo "| **Download:** | [Download $(toml get -r $1/pack.toml name)](./download/$(remove_dotslash $1).zip) |" >>src/$1.md' sh {} \; \
    -exec sh -c 'echo "## How to install" >>src/$1.md' sh {} \; \
    -exec sh -c 'echo "1. Download the .zip archive above." >>src/$1.md' sh {} \; \
    -exec sh -c 'echo "2. Import this archive as an instance in your launcher." >>src/$1.md' sh {} \; \
    -exec sh -c 'echo "3. Start the instance." >>src/$1.md' sh {} \; \
    -exec sh -c 'echo $1' sh {} \; \
    -exec sh -c 'cat src/$1.md' sh {} \;

# Create overview page in overview.md
echo 'Something overviewing' >src/overview.md
