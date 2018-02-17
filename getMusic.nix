{ stdenv, writeScriptBin, youtube-dl }:

writeScriptBin "getMusic" ''
    #!${stdenv.shell}

    # Small script to download
    cd "/home/hyper/Syncthing/Music" && ${youtube-dl}/bin/youtube-dl -x "$1"
''
