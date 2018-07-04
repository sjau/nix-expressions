{ stdenv, fetchurl, fetchpatch, pkgconfig, libtool, autoconf, automake, cppunit, ncurses, libsigcxx, curl, zlib, openssl, xmlrpc_c, callPackage, python27 }:


# Build Script:     https://github.com/pyroscope/rtorrent-ps/blob/master/build.sh
# Main Repo:        https://github.com/pyroscope/rtorrent-ps
# Docs:             https://rtorrent-ps.readthedocs.io/en/latest/install.html#build-from-source
# Arch Build:       https://aur.archlinux.org/cgit/aur.git/tree/PKGBUILD?h=rtorrent-ps
# The python packages are needed for the PyroScope installation
# For finishing the user inntallation do the PyroScope installation and then follow further the installation guide

# CUSTOM VIEW IGNORE FILTER PATCH
# This applies a patch to make an easy filter torrents to only appear in view1 (main) or view2 (name).
# Add the follwing to your rtorrent.rc or rtorrent.d/views.rc file (be sure to apply it before the sorting)
#
#    # VIEW IGNORE PATCH
#    view_filter = main,not=$d.get_ignore_commands=
#    view_filter = name,d.get_ignore_commands=
#
# Once applied, on a given torrent, you can change the ignore settings with shift + i --> after view update they will be put in either view1 or view2
#
# I use this to make simple decisions to decied what should be shared/kept forever (view2)
# and what I should delete after some time (view1)

let

#    libtorrent-ps = callPackage /etc/nixos/libtorrent-ps.nix {};
    libtorrent-ps = callPackage (builtins.fetchurl "https://raw.githubusercontent.com/sjau/nix-expressions/master/libtorrent-ps.nix") {};

    packageOverrides = pkgs: rec {
        xmlrpc_c = pkgs.stdenv.lib.overrideDerivation pkgs.xmlrpc_c (oldAttrs : {
            configureFlags = oldAttrs.configureFlags ++ [ "USE_CXXFLAGS=true" ];
        });
    };

in

stdenv.mkDerivation rec {

    name = "rtorrent-${rt_version}";
    rt_version = "0.9.6";

    src = fetchurl {
        name = "rtorrent-ps-${rt_version}";
        url = "https://bintray.com/artifact/download/pyroscope/rtorrent-ps/rtorrent-${rt_version}.tar.gz";
        sha256 = "03jvzw9pi2mhcm913h8qg0qw9gwjqc6lhwynb1yz1y163x7w4s8y";
    };

    commandPyroscope = fetchurl {
        name = "command_pyroscope.cc";
        url = "https://raw.githubusercontent.com/pyroscope/rtorrent-ps/master/patches/command_pyroscope.cc";
#        sha256 = "12n41ga57m1ybc7vza3ax21bm1cnzlsxm7dcpp6ay5aqd5ymg3r4";
        sha256 = "1dalwl0sqyyf6vk1bd2sid4q3s5if2dq79kqdm5kd7wvh1zckivz";
    };

    uiccPyroscope = fetchurl {
        name = "ui_pyroscope.cc";
        url = "https://raw.githubusercontent.com/pyroscope/rtorrent-ps/master/patches/ui_pyroscope.cc";
        sha256 = "0r76ydspv5ywfd74qpw3ffjnx8j0skjbbb7mfgz6j36p188abb6s";
    };

    uihPyroscope = fetchurl {
        name = "ui_pyroscope.h";
        url = "https://raw.githubusercontent.com/pyroscope/rtorrent-ps/master/patches/ui_pyroscope.h";
        sha256 = "0x43ihsjhvpb2spnhm2zlhzv6pbkkqr8610aig2g0dhj4gn18w3n";
    };

    unpackCmd = ''
        tar xvzf "$src"
    '';

    postUnpack = ''
        cp -v "$commandPyroscope" "$sourceRoot/src/command_pyroscope.cc"
        cp -v "$uiccPyroscope"    "$sourceRoot/src/ui_pyroscope.cc"
        cp -v "$uihPyroscope"     "$sourceRoot/src/ui_pyroscope.h"
        export USE_CXXFLAGS=true
        export CXXFLAGS+=" -fno-strict-aliasing -Wno-terminate"
        export CXXFLAGS+=" -I${libsigcxx}/include/sigc++-2.0/"
        export CXXFLAGS+=" -I${libsigcxx}/lib/sigc++-2.0/include/"
    '';

    nativeBuildInputs = [ pkgconfig ];
    buildInputs = [ libtool autoconf automake cppunit libtorrent-ps ncurses curl zlib openssl xmlrpc_c libsigcxx ];
    propagatedBuildInputs = [ (python27.withPackages (pythonPackages: with pythonPackages; [
            virtualenv
            pip
            setuptools
        ]))
    ];

    patchFlags = [ "-uNp1" ];
    patches = [
        (fetchpatch {   url    = "https://raw.githubusercontent.com/pyroscope/rtorrent-ps/master/patches/ps-event-view_all.patch";
                        sha256 = "1b6l11g6dlgym2gplaix1lk8q6rhv93j80f0qiirxk6p2hgqizq1"; })
        (fetchpatch {   url    = "https://raw.githubusercontent.com/pyroscope/rtorrent-ps/master/patches/ps-fix-double-slash-319_all.patch";
                        sha256 = "131bs1yikwc3mq19kkr4k8bz72sny1p6rym1xhgqgsn2caw15x6v"; })
        (fetchpatch {   url    = "https://raw.githubusercontent.com/pyroscope/rtorrent-ps/master/patches/ps-fix-sort-started-stopped-views_all.patch";
                        sha256 = "081alibwg2va9bsnxfm5h9dji494jngxd4mjhrxp1hj2kg090xgh"; })
        (fetchpatch {   url    = "https://raw.githubusercontent.com/pyroscope/rtorrent-ps/master/patches/ps-fix-throttle-args_all.patch";
                        sha256 = "03mxn7x4fp9ymcifr7gdyp9c416hbk7zkn26g5rf950v41w7bscm"; })
        (fetchpatch {   url    = "https://raw.githubusercontent.com/pyroscope/rtorrent-ps/master/patches/ps-handle-sighup-578_all.patch";
                        sha256 = "1q49r6aisl00nfs3qs49z4vnwccmih2hswf85aplnmhfyl2y4ic1"; })
        (fetchpatch {   url    = "https://raw.githubusercontent.com/pyroscope/rtorrent-ps/master/patches/ps-info-pane-xb-sizes_all.patch";
                        sha256 = "0glahfvqrqrx9skvb3x2icp07gv9vm9vzryylf0as3pvs1w9i9cw"; })
        (fetchpatch {   url    = "https://raw.githubusercontent.com/pyroscope/rtorrent-ps/master/patches/ps-issue-515_all.patch";
                        sha256 = "05p4j4nzjjj06d7hhy2l5jpxrcigankvp7x2v97fb810khvk10ph"; })
        (fetchpatch {   url    = "https://raw.githubusercontent.com/pyroscope/rtorrent-ps/master/patches/ps-item-stats-human-sizes_all.patch";
                        sha256 = "06i4mldasqm9hvins0v8sxlbs63mcvsidq8kmhkyzd34ya3czak5"; })
        (fetchpatch {   url    = "https://raw.githubusercontent.com/pyroscope/rtorrent-ps/master/patches/ps-ssl_verify_host_all.patch";
                        sha256 = "1zfkajwdr8pc3kwqbys5jkqbbdn72i4p4yxl0599x1slqakv2fiy"; })
        (fetchpatch {   url    = "https://raw.githubusercontent.com/pyroscope/rtorrent-ps/master/patches/ps-throttle-steps_all.patch";
                        sha256 = "0j9gq5axgy0bbl7pxshpyqgm0rrwflawvpq9pn358mc479qf5cmz"; })
        (fetchpatch {   url    = "https://raw.githubusercontent.com/pyroscope/rtorrent-ps/master/patches/ps-ui_pyroscope_all.patch";
                        sha256 = "05waghxvxyk0ajxk1zi2his9m7i8wppf0d818bqbwr7l17njmhbm"; })
        (fetchpatch {   url    = "https://raw.githubusercontent.com/pyroscope/rtorrent-ps/master/patches/ps-view-filter-by_all.patch";
                        sha256 = "0dxwlbi0vba0qajzwv6i5d80l8gz97zxgw2aky4nldf19ks4b5aq"; })
        (fetchpatch {   url    = "https://raw.githubusercontent.com/pyroscope/rtorrent-ps/master/patches/rt-base-cppunit-pkgconfig.patch";
                        sha256 = "1909mlb7bmhmp7kk3akgrc0d07y7l2xymw3jz5p7ldr4zv2078l7"; })
        (fetchpatch {   url    = "https://raw.githubusercontent.com/pyroscope/rtorrent-ps/master/patches/pyroscope.patch";
                        sha256 = "0gsgx4r4p8qjnyv0c61dgzx3xw6hh0z929pdn52jnv4pnfv4bqwd"; })
        (fetchpatch  {  url    = "https://raw.githubusercontent.com/pyroscope/rtorrent-ps/master/patches/ui_pyroscope.patch";
                        sha256 = "13jxl3chqfmw4a8xl3l51x13ssp109s8ivmiq46b8w4v16n84vzg"; })
        (fetchpatch {   url    = "https://raw.githubusercontent.com/sjau/nix-expressions/master/customPatches/rtorrent_view_ignore.patch";
                        sha256 = "13a3ac7dl60i1bigsn229yg3mn1iip481lky5bk6i0ki75mhc19c"; })
    ];

    preConfigure = "./autogen.sh";

    configureFlags = [ "--with-xmlrpc-c" "--with-posix-fallocate" ];

    postInstall = ''
        mkdir -p $out/share/man/man1 $out/share/doc/rtorrent
        # mv doc/old/rtorrent.1 $out/share/man/man1/rtorrent.1
        mv doc/rtorrent.rc $out/share/doc/rtorrent/rtorrent.rc
    '';

    meta = with stdenv.lib; {
        inherit (src.meta) homepage;
        description = "An ncurses client for libtorrent, ideal for use with screen, tmux, or dtach";

        platforms = platforms.unix;
        maintainers = with maintainers; [ hyper_ch ];
    };
}
