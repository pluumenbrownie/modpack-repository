rm mmc-pack.json
rm mmc-pack.json
rm mmc-pack.json
for FILE in $(find . -type f -name 'pack.toml')
do 
    echo $FILE
    mkfifo mmc-pack.json
    awk '
    {
        gsub(/"mc-version"/, "\"$(toml get $FILE versions.minecraft)\"");
        gsub(/"loader-version"/, "\"$(toml get $FILE versions.neoforge)\"");
        print;
    }' zip-template/mmc-pack-neoforge.json > mmc-pack.json & 
    cat mmc-pack.json
    # cat mmc-pack.json
    rm mmc-pack.json
done