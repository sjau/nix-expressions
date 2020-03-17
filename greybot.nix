{stdenv, fetchurl, perl, perl528Packages.POE, perl528Packages.DBI, perl528Packages.strictures, perl528Packages.TestWarnings }:

stdenv.mkDerivation {
  name = "greybot";
  version = "20180731";

  src = fetchurl {
    url = "http://wooledge.org/~greg/greybot/greybot.pl-20180731";
    sha256 = "1rb0pwnfihwvp8mw15xrrrrnz21khh36fba5zsqvhlglck6qy0rg";
  };

  unpackPhase = ":";

  installPhase = ''
    echo "------------------------------------"
    ls -al
    echo "------------------------------------"
    mkdir -p $out/bin
    cp -n greybot* $out/bin/
  '';

  meta = with stdenv.lib; {
    homepage    = http://wooledge.org/~greybot/;
    description = "Easy to use IRC factoid bot";
    license     = licenses.wtfpl;
    maintainers = with maintainers; [ "sjau" ];
  };

}
