{stdenv, fetchurl }:
stdenv.mkDerivation {
    name = "getTechDetails-master";

    src = fetchurl {
        url = "https://raw.githubusercontent.com/sjau/bash-stuff/master/getTechDetails";
        sha256 = "1z26qjhbiyz33rm7mp8ycgl5ka0v3v5lv5i5v0b5mx35arvx2zzy";
    };

    installPhase = ''
        mkdir -p $out/bin
        cp -n * $out/bin
    '';
}
