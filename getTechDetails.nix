{ stdenv, writeScriptBin, nix-info }:

writeScriptBin "getTechDetails" ''
    #!${stdenv.shell}

    # Small script to get the required technical details
    # when filing a bug report against NixOS

    nixosInfo=$(${nix-info}/bin/nix-info -m)

    printf '%s\n\n'          "''${nixosInfo}"
''
