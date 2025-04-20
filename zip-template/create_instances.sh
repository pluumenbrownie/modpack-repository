#! /bin/bash
# shellcheck disable=SC2016

export LOCAL_URL='http://localhost:8080'

export TEMPLATES=zip-template

export DOWNLOAD=download
mkdir $DOWNLOAD

export CURRENT=$DOWNLOAD/current_instance
mkdir $CURRENT

mkdir $CURRENT/.minecraft
cp $TEMPLATES/packwiz-installer-bootstrap.jar $CURRENT/.minecraft

remove_dotslash() {
    echo "$1" | sed s/\\.\\///g
}
export -f remove_dotslash

set_mmc_pack() {
    # First, try to get the version of each loader.
    # Then, get right mmc and replace loader version.
    VERSION=$(toml get -r "$1" versions.forge) &&
        sed "s/loader-version/$VERSION/g" $TEMPLATES/mmc-pack-forge.json >$CURRENT/mmc-pack.json
    VERSION=$(toml get -r "$1" versions.neoforge) &&
        sed "s/loader-version/$VERSION/g" $TEMPLATES/mmc-pack-neoforge.json >$CURRENT/mmc-pack.json
    VERSION=$(toml get -r "$1" versions.quilt) &&
        sed "s/loader-version/$VERSION/g" $TEMPLATES/mmc-pack-quilt.json >$CURRENT/mmc-pack.json
    VERSION=$(toml get -r "$1" versions.fabric) &&
        sed "s/loader-version/$VERSION/g" $TEMPLATES/mmc-pack-fabric.json >$CURRENT/mmc-pack.json

    sed -i "s/mc-version/$(toml get -r "$1" versions.minecraft)/g" $CURRENT/mmc-pack.json
}
export -f set_mmc_pack

set_instance_cfg() {
    sed "s/pack-name/$(toml get -r "$2" name)/g" $TEMPLATES/instance.cfg |
        sed "s|url-placeholder|$3|g" |
        sed "s/pack-location/$(remove_dotslash "$1")/g" >$CURRENT/instance.cfg
}
export -f set_instance_cfg

create_zip() {
    cd download/current_instance/ &&
        zip -r "../$1.zip" ./* &&
        zip -r "../$1.zip" .minecraft/* &&
        cd ../..
}
export -f create_zip

find . -type d -exec test -e '{}'/pack.toml \; \
    -exec bash -c 'set_mmc_pack $1' bash {}/pack.toml \; \
    -exec bash -c 'set_instance_cfg $1 $2 $3' bash {} {}/pack.toml "$REPO_URL" \; \
    -exec bash -c 'create_zip $1' bash {} \; \
    -exec bash -c 'set_instance_cfg $1 $2 $3' bash {} {}/pack.toml $LOCAL_URL \; \
    -exec bash -c 'create_zip $1' bash {}-local \; \
    -exec bash -c 'echo "$1 processed succesfully."' bash {} \;

# rm -r $CURRENT
