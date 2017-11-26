{ stdenv, lib, buildPythonPackage, fetchPypi, isPyPy, python3, callPackage, fetchurl }:

with python3.pkgs;

let

    pdfrw = callPackage (builtins.fetchurl "https://raw.githubusercontent.com/sjau/nix-expressions/master/pdfrw.nix") {};

in

buildPythonPackage rec {
  pname = "img2pdf";
  version = "0.2.4";
  name = "${pname}-${version}";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1bn9zzsmg4k41wmx1ldmj8a4yfj807p8r0a757lm9yrv7bx702ql";
  };

  propagatedBuildInputs = [
    pillow
    pdfrw
  ];

  meta = with stdenv.lib; {
    homepage = https://gitlab.mister-muffin.de/josch/img2pdf;
    description = "Losslessly convert raster images to PDF. ";
    license = lib.licenses.lgpl;
    maintainers = with lib.maintainers; [ hyper_ch ];
  };
}
