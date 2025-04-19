#! /bin/bash

REPO_URL="https://pluumenbrownie.github.io/modpack-repository"
export REPO_URL

TEMPLATES=zip-template
export TEMPLATES

DOWNLOAD=download
export DOWNLOAD
mkdir $DOWNLOAD

CURRENT=$DOWNLOAD/current_instance
export CURRENT
mkdir $CURRENT

mkdir $CURRENT/.minecraft
cp $TEMPLATES/packwiz-installer-bootstrap.jar $CURRENT/.minecraft

remove_dotslash() {
    echo "$1" | sed s/\\.\\///g
}
export -f remove_dotslash

set_mmc_pack() {
    toml get "$1" versions.forge >/dev/null && cp $TEMPLATES/mmc-pack-forge.json $CURRENT/mmc-pack.json
    toml get "$1" versions.neoforge >/dev/null && cp $TEMPLATES/mmc-pack-neoforge.json $CURRENT/mmc-pack.json
    toml get "$1" versions.quilt >/dev/null && cp $TEMPLATES/mmc-pack-quilt.json $CURRENT/mmc-pack.json
    toml get "$1" versions.fabric >/dev/null && cp $TEMPLATES/mmc-pack-fabric.json $CURRENT/mmc-pack.json
    echo -n ''
}
export -f set_mmc_pack

set_instance_cfg() {
    sed "s/pack-name/$(toml get -r "$2" name)/g" $TEMPLATES/instance.cfg |
        sed "s|url-placeholder|$REPO_URL|g" |
        sed "s/pack-location/$(remove_dotslash "$1")/g" >$CURRENT/instance.cfg
    echo -n ''
}
export -f set_instance_cfg

create_zip() {
    cd download/current_instance/ &&
        zip -r "../$1.zip" * &&
        zip -r "../$1.zip" .minecraft/* &&
        cd ../..
}
export -f create_zip

find . -type d -exec test -e '{}'/pack.toml \; \
    -exec sh -c 'echo $(toml get -r $1 name)' sh {}/pack.toml \; \
    -exec sh -c 'set_mmc_pack $1' sh {}/pack.toml \; \
    -exec sh -c 'set_instance_cfg $1 $2' sh {} {}/pack.toml $REPO_URL \; \
    -exec sh -c 'create_zip $1' sh {} \;
