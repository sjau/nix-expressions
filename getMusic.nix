{ stdenv, writeScriptBin, yt-dlp, ffmpeg }:

writeScriptBin "getMusic" ''
    #!${stdenv.shell}

    # Small script to download
    cd "/home/hyper/Syncthing/Music" && ${yt-dlp}/bin/yt-dlp -x "$1"
''
