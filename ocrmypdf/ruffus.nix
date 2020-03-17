{ stdenv, lib, buildPythonPackage, fetchPypi, isPyPy, python3 }:

buildPythonPackage rec {
  pname = "ruffus";
  version = "2.8.0";
  name = "${pname}-${version}";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1sdm9fhsm5jsgly1pz8kcksxl54ga0bjjc9axmi17lg2ipl7d7k0";
  };

  propagatedBuildInputs = [ ];

  buildInputs = [ ];

  meta = with stdenv.lib; {
    homepage = http://www.ruffus.org.uk/;
    description = "A Computation Pipeline library for python.";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ hyper_ch ];
  };
}
