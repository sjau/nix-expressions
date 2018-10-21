{ lib, python3, callPackage }:


with python3.pkgs;

buildPythonApplication rec {
  pname = "bottle-websocket";
  version = "0.2.9";

  src = fetchPypi {
    inherit pname version;
    sha256 = "12vkxigkx5pxh5dkvn2hip86rpnyjnm186nis3c2wnf7q06zg1wq";
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
  ];

  propagatedBuildInputes = [
    gevent-websocket
  ];

  meta = with lib; {
    homepage    = https://github.com/zeekay/bottle-websocket;
    description = "This project adds websocket capabilities to bottle, leveraging gevent-websocket and gevent.";
    license     = licenses.mit;
    maintainers = with maintainers; [ ];
  };
}
