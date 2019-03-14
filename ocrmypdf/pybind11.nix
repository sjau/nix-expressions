{ stdenv, fetchFromGitHub, cmake, python }:

stdenv.mkDerivation rec {
  name = "pybind-${version}";
  version = "2.2.4";
  src = fetchFromGitHub {
    owner = "pybind";
    repo = "pybind11";
    rev = "v${version}";
    sha256 = "0pa79ymcasv8br5ifbx7878id5py2jpjac3i20cqxr6gs9l6ivlv";
  };

  nativeBuildInputs = [ cmake ];

  # disable tests as some tests (test_embed/test_interpreter) are failing at the moment
  cmakeFlags = [
     "-DPYTHON_EXECUTABLE=${python.interpreter}"
     "-DPYBIND11_TEST=0"
  ];
  doCheck = false;

  meta = {
    homepage = https://github.com/pybind/pybind11;
    description = "Seamless operability between C++11 and Python";
    longDescription = ''
      Pybind11 is a lightweight header-only library that exposes
      C++ types in Python and vice versa, mainly to create Python
      bindings of existing C++ code.
    '';
    platforms = with stdenv.lib.platforms; unix;
    license = stdenv.lib.licenses.bsd3;
    maintainers = with stdenv.lib.maintainers; [ yuriaisaka ];
  };

}
