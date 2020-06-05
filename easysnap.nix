{ stdenv, fetchFromGitHub, zfs }:

stdenv.mkDerivation {
  name = "easysnap";
  version = "2020-05-17";

  src = fetchFromGitHub {
    owner = "sjau";
    repo = "easysnap";
    rev = "aa84cc24463b9907da457309d7a07924aad67a00";
    sha256 = "1rd4lrlk86ghxmjc037qndc7fxcp2v8rfvx7zn25n3lllmkchyy5";
  };

  installPhase = ''
    mkdir -p $out/bin
    cp -n easysnap* $out/bin/

    for i in $out/bin/*; do
      substituteInPlace $i \
        --replace zfs ${zfs}/bin/zfs
    done
  '';

  meta = with stdenv.lib; {
    homepage    = https://github.com/sjau/easysnap;
    description = "Customizable ZFS Snapshotting tool with zfs send/recv pulling";
    license     = licenses.gpl3;
    maintainers = with maintainers; [ "sjau" ];
  };

}
