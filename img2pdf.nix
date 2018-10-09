{ stdenv, lib, buildPythonPackage, fetchPypi, isPyPy, python3, callPackage }:

with python3.pkgs;

let

    pdfrw = callPackage (builtins.fetchurl "https://raw.githubusercontent.com/sjau/nix-expressions/master/pdfrw.nix") {};

in

buildPythonPackage rec {
  pname = "img2pdf";
  version = "0.3.0";
  name = "${pname}-${version}";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1z11xh63acphmryj0x9ss7fsldknkq0x3kmg64m1fwzymc2vp0cd";
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
