{stdenv, fetchurl }:
stdenv.mkDerivation {
    name = "getTechDetails-master";

    src = fetchurl {
        url = "https://raw.githubusercontent.com/sjau/bash-stuff/master/getTechDetails";
        sha256 = "0p0jjspgv3wlab9c3lz8g46hhyjf7gg0k41w32pxqs2xqcyhfwva";
    };

    installPhase = ''
        mkdir -p $out/bin
        cp -n * $out/bin
    '';
}
