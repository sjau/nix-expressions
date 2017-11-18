{ stdenv, writeScriptBin, nix-info }:

writeScriptBin "getTechDetails" ''
    #!${stdenv.shell}

    # Small script to get the required technical details
    # when filing a bug report against NixOS

#    nixosVer=$(nixos-version)
#    nixosEnv=$(nix-env --version)
#    nixosPkgs=$(nix-instantiate --eval '<nixpkgs>' -A lib.nixpkgsVersion)
#    nixosSand=$(grep build-use-sandbox /etc/nix/nix.conf)
    nixInfo=$(nix-info -m)

#    printf '%s\n\n`%s`\n\n' '* System: (NixOS: `nixos-version`, Ubuntu/Fedora: `lsb_release -a`, ...)'            "''${nixosVer}"
#    printf '%s\n\n`%s`\n\n' '* Nix version: (run `nix-env --version`)'                                            "''${nixosEnv}"
#    printf '%s\n\n`%s`\n\n' '* Nixpkgs version: (run `nix-instantiate --eval "<nixpkgs>" -A lib.nixpkgsVersion`)' "''${nixosPkgs}"
#    printf '%s\n\n`%s`\n'   '* Sandboxing enabled: (run `grep build-use-sandbox /etc/nix/nix.conf`)'              "''${nixosSand}"
    printf '%s\n\n'          "''${nixInfo}"
''
