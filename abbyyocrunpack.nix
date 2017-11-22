{ stdenv, writeScriptBin, nix-info }:

writeScriptBin "abbyyocrunpack" ''
    #!${stdenv.shell}

    filesizes=$( grep "filesizes" "$1" | head -1)
    filesizes="${filesizes##*=}"
    filesizes="${filesizes:1:-1}"

    while read -r h n off other; do
        offset="$off"
    done <<< $(grep 'offset=`head' "$1" | head -1)
    offset=$((offset+1))

    tail +$offset "$1" | head -c $filesizes | tar xz
''
