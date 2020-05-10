{stdenv, fetchFromGitHub, zfs }:

stdenv.mkDerivation {
  name = "easysnap";
  version = "2020-05-10";

  src = fetchFromGitHub {
    owner = "sjau";
    repo = "easysnap";
    rev = "d17927804cd7a35a9ca7094734d022a15c9f5415";
    sha256 = "14dnk7cdnqs7v6vvfrqx88bk9jshc5iyka1a800k73s6vvscxw7r";
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
