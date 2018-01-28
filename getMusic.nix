{ stdenv, writeScriptBin, nix-info }:

writeScriptBin "getMusic" ''
    #!${stdenv.shell}

    # Small script to download
    cd "/home/hyper/Syncthing/Music" && youtube-dl -x "$1"
''
