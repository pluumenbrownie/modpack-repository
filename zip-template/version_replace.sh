awk '
{
    gsub(/"mc-version"/, "\"1.20.4\"");
    gsub(/"loader-version"/, "\"0.19.2\"");
    print;
}' input.json > output.json
