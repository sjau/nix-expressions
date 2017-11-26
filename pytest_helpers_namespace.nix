{ stdenv, lib, buildPythonPackage, fetchPypi, isPyPy, python3, pytest }:

with python3.pkgs;

buildPythonPackage rec {
  pname = "pytest-helpers-namespace";
  version = "2017.11.11";
  name = "${pname}-${version}";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0ihajp4k8vhc4njq7qsh1b22sy09sdwx5ad53x42lr7xfl76m1jy";
  };

  buildInputs = [ pytest ];

  meta = with stdenv.lib; {
    homepage = https://github.com/saltstack/pytest-helpers-namespace;
    description = "This plugin provides a helpers namespace in pytest.";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ hyper_ch ];
  };
}
