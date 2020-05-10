{stdenv, fetchFromGitHub, zfs }:

stdenv.mkDerivation {
  name = "easysnap";
  version = "2020-05-10";

  src = fetchFromGitHub {
    owner = "sjau";
    repo = "easysnap";
    rev = "4195bedb11545290129b81d31565a20d03b97478";
    sha256 = "1g9pv05z60d4kg6d4db5f6dq7dvj9gwlvpm278rwjgvhqxps8930";
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
