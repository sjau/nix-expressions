{ lib, fetchFromGitHub, python3, callPackage, unpaper, ghostscript, tesseract, qpdf, glibcLocales, fetchurl, img2pdf, setuptools_scm }:

with python3.pkgs;

let

  pdfminer_six = callPackage /home/hyper/Desktop/git-repos/nix-expressions/ocrmypdf/pdfminer_six.nix {};
  setuptools_scm_git_archive = callPackage /home/hyper/Desktop/git-repos/nix-expressions/ocrmypdf/setuptools_scm_git_archive.nix {};
  ruffus = callPackage /home/hyper/Desktop/git-repos/nix-expressions/ocrmypdf/ruffus.nix {};
  pytest-helpers-namespace = callPackage (builtins.fetchurl "https://raw.githubusercontent.com/sjau/nix-expressions/master/pytest_helpers_namespace.nix") {};

in

buildPythonApplication rec {
  version = "7.3.1";
  name = "OCRmyPDF-${version}";

  src = fetchFromGitHub {
    owner = "jbarlow83";
    repo = "OCRmyPDF";
    rev = "v${version}";
    sha256 = "0gi1bf3dz0shgc4jf55n54ma026f0ayiggx42y7d8knxlpjzzy89";
  };

  postPatch = ''
    substituteInPlace requirements/main.txt \
      --replace "chardet == 3.0.4" "chardet" \
      --replace "cffi == 1,11,5" "cffi" \
      --replace "img2pdf == 0.3.1" "img2pdf" \
      --replace "pdfminer.six == 20181108" "pdfminer.six" \
      --replace "pikepdf == 0.3.7" "pikepdf" \
      --replace "Pillow >= 5.0.0, !=5.1.0 ; sys_platform == \"darwin\"" "Pillow" \
      --replace "pycparser == 2.1.9" "pycparser" \
      --replace "python-xmp-toolkit == 2.0.1" "python-xmp-toolkit" \
      --replace "ruffus == 2.8.0" "ruffus"
    substituteInPlace requirements/dev.txt \
      --replace "check-manifest == 0.35" "check-manifest" \
      --replace "twine >= 1.8.1" "twine" \
      --replace "coverage == 4.5" "coverage" \
      --replace "GitPython == 2.1.3" "gitPython"
    substituteInPlace requirements/test.txt \
      --replace "pytest >= 3.9.3" "pytest" \
      --replace "PyPDF2 >= 1.26.9" "PyPDF2" \
      --replace "#PyMuPDF >= 1.13.4" "PyMuPDF"
    substituteInPlace src/ocrmypdf/lib/compile_leptonica.py \
      --replace "©" "(c)"
    export SETUPTOOLS_SCM_PRETEND_VERSION="${version}"
    export LANG=en_US.UTF-8
    export LC_ALL=en_US.UTF-8
  '';

  buildInputs = [ pytest pytest_xdist pytestcov setuptools_scm pytest-helpers-namespace pytestrunner glibcLocales ];

  doCheck = false;
  
  propagatedBuildInputs = [
    chardet
    cffi
    img2pdf
    pdfminer_six
    setuptools_scm_git_archive

    ruffus
    pillow
    reportlab
    pypdf2
    img2pdf
    unpaper
    ghostscript
    tesseract
    qpdf
  ];

  meta = {
    homepage = https://github.com/jbarlow83/OCRmyPDF;
    description = "Adds an OCR text layer to scanned PDF files, allowing them to be searched or copy-pasted.";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ hyper_ch ];
  };
}
