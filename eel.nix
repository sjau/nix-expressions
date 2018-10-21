{ lib, python3, callPackage }:


with python3.pkgs;

buildPythonApplication rec {
  pname = "Eel";
  version = "0.9.10";

  src = fetchPypi {
    inherit pname version;
    sha256 = "02lyvranm1aaw40fqyipx8mv26v3zhd7b7m6slsw1r7z2wnjrqva";
  };

 # postPatch = ''
 #   # Remove opencv-python from requirements
 #   sed -i -e 's/opencv-python//g' setup.py
 #   sed -i -e 's/argparse//g' setup.py
 #   # Fix README.md unicode error
 #   export LC_ALL=en_US.utf-8
 # '';

  doCheck = true;

  buildInputs = [
    bottle bottleneck
  ];

  propagatedBuildInputs = [
    bottleneck bottle
  ];

  meta = with lib; {
    homepage    = https://github.com/ChrisKnott/Eel;
    description = "Python library for making simple Electron-like offline HTML/JS GUI apps.";
    license     = licenses.mit;
    maintainers = with maintainers; [ ];
  };
}
