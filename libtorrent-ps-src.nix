# NOTE: this is rakshava's version of libtorrent, used mainly by rtorrent
# This is NOT libtorrent-rasterbar, used by Deluge, qbitttorent, and others
{ stdenv, fetchurl, pkgconfig
, libtool, autoconf, automake, cppunit
, openssl, libsigcxx, zlib }:

stdenv.mkDerivation rec {
  name = "libtorrent-${version}";
  version = "0.13.6";

  src = fetchurl {
    name = "libtorrent-ps-${version}";
    url = "https://bintray.com/artifact/download/pyroscope/rtorrent-ps/libtorrent-${version}.tar.gz";
    sha256 = "0makq1zpfqnrj6xx1xc7wi4mh115ri9p4yz2rbvjhj0il4y8l4ah";
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ libtool autoconf automake cppunit openssl libsigcxx zlib ];

  preConfigure = "./autogen.sh";

  meta = with stdenv.lib; {
    homepage = "http://rtorrent.net/downloads/";
    description = "A BitTorrent library written in C++ for *nix, with focus on high performance and good code";

    platforms = platforms.linux;
    maintainers = with maintainers; [ ebzzry codyopel ];
  };
}
