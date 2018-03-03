{ lib
, fetchPypi
, buildPythonPackage
, mock
, pytest_xdist
, isPy3k
, pysqlite
}:

buildPythonPackage rec {
  pname = "SQLAlchemy";
  name = "${pname}-${version}";
  version = "1.1.17";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0g012zpzpn5hl5b6mx938c9j2zrwx46qxkkijdpnkb8ikhvyqmbb";
  };

  checkInputs = [
    mock
#     Disable pytest_xdist tests for now, because our version seems to be too new.
#     pytest_xdist
  ] ++ lib.optional (!isPy3k) pysqlite;

  doCheck = false;
  checkPhase = ''
    py.test
  '';

  meta = with lib; {
    homepage = http://www.sqlalchemy.org/;
    description = "A Python SQL toolkit and Object Relational Mapper";
    license = licenses.mit;
  };
}
