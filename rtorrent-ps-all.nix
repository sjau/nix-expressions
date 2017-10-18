{
  packageOverrides = pkgs: with pkgs; rec {
    rtorrent-ps = pkgs.stdenv.lib.overrideDerivation pkgs.rtorrent (oldAttrs: {
      patches = with pkgs; [
        (fetchpatch {
          url    = "https://raw.githubusercontent.com/pyroscope/rtorrent-ps/master/patches/pyroscope.patch";
          sha256 = "0ji6j9a7x001s9hx24qdvasax1qr04qaqdwcs8c374j1j38r7xm8";
        })
      ];
    });
  };
}
