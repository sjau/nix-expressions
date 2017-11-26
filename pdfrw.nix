{ stdenv, lib, buildPythonPackage, fetchFromGitHub, fetchPypi, isPyPy, python3, pytest, zlib }:

with python3.pkgs;

buildPythonPackage rec {
  pname = "pdfrw";
  version = "0.4";
  name = "${pname}-${version}";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1x1yp63lg3jxpg9igw8lh5rc51q353ifsa1bailb4qb51r54kh0d";
  };

  static_pdfs = fetchFromGitHub {
    name = "static_pdfs";
    owner = "pmaupin";
    repo = "static_pdfs";
    rev = "d646009a0e3e71daf13a52ab1029e2230920ebf4";
    sha256 = "03wff6f73gd4z4wy1yx8b10bqr5gzs2drnzpkjbr767m5b6i62az";
  };

  postPatch = ''
    # expected.txt needed, otherwise it'l complain
    touch expected.txt
    substituteInPlace tests/update_expected.py \
      --replace "print src" "print (src)" \
      --replace 'print "OK"' 'print ("OK")' \
      --replace "print count, goodcount" "print (count, goodcount)"
    substituteInPlace tests/test_examples.py \
      --replace "import expected" "from . import expected"
    substituteInPlace tests/test_roundtrip.py \
      --replace "import expected" "from . import expected"
  '';

  checkInputs = [ unittest2 ];
  
  checkPhase = ''
    # Copy over the test pdfs and stuff to the building directory
    cp -r $static_pdfs/* "./tests/static_pdfs"
    PYTHONPATH="$PYTHONPATH:tests" py.test tests
  '';

  buildInputs = [ pytest ];

  propagatedBuildInputs = [
    reportlab
    pycrypto
    zlib
  ];

  meta = with stdenv.lib; {
    homepage = https://github.com/pmaupin/pdfrw;
    description = "Python library and utility that reads and writes PDF files.";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ hyper_ch ];
  };
}
