{ stdenv, lib, buildPythonPackage, fetchPypi, isPyPy, python3, setuptools_scm }:

buildPythonPackage rec {
  pname = "setuptools_scm_git_archive";
  version = "1.0";
  name = "${pname}-${version}";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1nii1sz5jq75ilf18bjnr11l9rz1lvdmyk66bxl7q90qan85yhjj";
  };

  preBuild = ''
    echo "------------------------------------------------"
    mkdir -p build/bdist.linux-x86_64/wheel/
    ls -al build/bdist.linux-x86_64/wheel
    ls -al
    sleep 5
    echo "------------------------------------------------"
  '';

  propagatedBuildInputs = [ setuptools_scm ];

  buildInputs = [ ];

  meta = with stdenv.lib; {
    homepage = https://github.com/Changaco/setuptools_scm_git_archive;
    description = "setuptools_scm plugin for git archives";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ hyper_ch ];
  };
}
