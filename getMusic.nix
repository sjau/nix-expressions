{ stdenv, writeScriptBin, yt-dlp, ffmpeg }:

writeScriptBin "getMusic" ''
    #!${stdenv.shell}

    # Small script to download
    cd "/home/hyper/Syncthing/Music/New" && ${yt-dlp}/bin/yt-dlp -t mp3 "$1"
''
