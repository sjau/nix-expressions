{ lib, python3, glibcLocales, callPackage }:


with python3.pkgs;

buildPythonApplication rec {
  pname = "deda";
  version = "1.0b3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0kx96mhm32qv7wpa423ximcm7f39shx75m37s39m445km57cccy8";
  };

  postPatch = ''
    # Remove opencv-python from requirements
    sed -i -e 's/opencv-python//g' setup.py
    sed -i -e 's/argparse//g' setup.py
    # Fix README.md unicode error
    export LC_ALL=en_US.utf-8
  '';

  doCheck = true;

  buildInputs = [
    glibcLocales
  ];

  propagatedBuildInputs = [
    numpy opencv3 ConfigArgParse argparse scipy pillow
  ];

  meta = with lib; {
    homepage    = https://github.com/dfd-tud/deda;
    description = "DEDA - printer tracking Dots Extraction, Decoding and Anonymisation toolkit";
    license     = licenses.gpl3Plus;
    maintainers = with maintainers; [ ];
  };
}
