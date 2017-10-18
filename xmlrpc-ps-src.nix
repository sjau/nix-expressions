{ stdenv, fetchurl, curl, libxml2 }:

stdenv.mkDerivation rec {
  name = "xmlrpc-c-1.33.17";
  version = "2917";

  src = fetchurl {
    name = "xmlrpc-c-r${version}";
    url = "https://bintray.com/artifact/download/pyroscope/rtorrent-ps/xmlrpc-c-advanced-$version-src.tgz";
    sha256 = "0makq1zpfqnrj6xx1xc7wi4mh115ri9p4yz2rbvjhj0il4y8l4ah";
  };

  buildInputs = [ curl libxml2 ];

  configureFlags = [
    "--enable-libxml2-backend"
  ];

  # Build and install the "xmlrpc" tool (like the Debian package)
  postInstall = ''
    (cd tools/xmlrpc && make && make install)
  '';

  hardeningDisable = [ "format" ];

  meta = with stdenv.lib; {
    description = "A lightweight RPC library based on XML and HTTP";
    homepage = http://xmlrpc-c.sourceforge.net/;
    # <xmlrpc-c>/doc/COPYING also lists "Expat license",
    # "ABYSS Web Server License" and "Python 1.5.2 License"
    license = licenses.bsd3;
    platforms = platforms.linux;
    maintainers = [ maintainers.bjornfor ];
  };
}
