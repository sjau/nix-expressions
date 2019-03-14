{ stdenv, lib, callPackage, buildPythonPackage, fetchPypi, isPyPy, python3, pip }:

let

  pybind11 = callPackage /home/hyper/Desktop/git-repos/nix-expressions/ocrmypdf/pybind11.nix {};

in

buildPythonPackage rec {
  pname = "pikepdf";
  version = "0.3.7";
  name = "${pname}-${version}";

  src = fetchPypi {
    inherit pname version;
    sha256 = "141jbmjpny70aab4f4xlvrq96l4wx8j835lklxnnnrah6h796347";
  };

  propagatedBuildInputs = [ pybind11 ];

  buildInputs = [ pip ];

  meta = with stdenv.lib; {
    homepage = https://github.com/pikepdf/pikepdf;
    description = "A Python library for reading and writing PDF, powered by qpdf ";
    license = lib.licenses.mpl20;
    maintainers = with lib.maintainers; [ hyper_ch ];
  };
}
