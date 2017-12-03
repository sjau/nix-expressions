{ stdenv, writeScriptBin, nix-info }:

writeScriptBin "freeCache" ''
    #!${stdenv.shell}

    # Small script to free cache

    printf '%s\n' "3" > "/proc/sys/vm/drop_caches"
''
