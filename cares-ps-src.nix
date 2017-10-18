{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "c-ares-${version}";
  version = "1.13.0";

  src = fetchurl {
    name = "c-ares-ps-${version}";
    url = "http://c-ares.haxx.se/download/${name}.tar.gz";
    sha256 = "19qxhv9aiw903fr808y77r6l9js0fq9m3gcaqckan9jan7qhixq3";
  };

  meta = with stdenv.lib; {
    description = "A C library for asynchronous DNS requests";
    homepage = https://c-ares.haxx.se;
    license = licenses.mit;
    platforms = platforms.all;
  };
}
