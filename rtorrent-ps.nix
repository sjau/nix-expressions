{ lib
, stdenv
, callPackage
, fetchFromGitHub
, fetchpatch
, fetchurl
, autoreconfHook
, autoconf-archive
, cppunit
, curl
, libsigcxx
, libtool
, ncurses
, openssl
, pkg-config
, xmlrpc_c
, zlib
}:

# Build Script:     https://github.com/chros73/rtorrent-ps-ch/blob/master/build.sh
# Main Repo:        https://github.com/chros73/rtorrent-ps-ch/
# Docs:             https://github.com/chros73/rtorrent-ps-ch/blob/master/README.rst
# Compiling Guide:  https://github.com/chros73/rtorrent-ps-ch/blob/master/docs/DebianInstallFromSourceTheEasyWay.rst
# The python packages are needed for PyroScope's pyrocore installation
# For finishing the user inntallation do the PyroScope installation and then follow further the installation guide

# CUSTOM VIEW IGNORE FILTER PATCH
# This applies a patch to make an easy filter torrents to only appear in view1 (main) or view2 (name).
# Add the follwing to your rtorrent.rc or rtorrent.d/views.rc file (be sure to apply it before the sorting)
#
#    VIEW IGNORE PATCH
#    view.filter = main,not=$d.ignore_commands=
#    view.filter = name,d.ignore_commands=
#
# Once applied, on a given torrent, you can change the ignore settings with shift + i --> after the view update
# (usually a few seconds) they will be put in either view1 or view2
#
# I use this to make simple decisions to decied what should be shared/kept forever (view2)
# and what I should delete after some time (view1)


let
    libtorrent-ps = callPackage (builtins.fetchurl "https://raw.githubusercontent.com/sjau/nix-expressions/master/libtorrent-ps.nix") {};
in

stdenv.mkDerivation rec {
    pname = "rtorrent-ps-ch";
    version = "0.9.8";

    src = fetchFromGitHub {
        owner = "rakshasa";
        repo = "rtorrent";
        rev = "6154d1698756e0c4842b1c13a0e56db93f1aa947";
        hash = "sha256-4gx35bjzjUFdT2E9VGf/so7EQhaLQniUYgKQmVdwikE=";
    };

    commandPyroscope = fetchurl {
        name = "command_pyroscope.cc";
        url = "https://raw.githubusercontent.com/sjau/nix-expressions/master/rtorrent/0.9.8_command_pyroscope.cc";
        sha256 = "sha256-SgYj07iRbQYv85ln0FjkZXhf6qaPCtm9vcuV8RDSAN0=";
    };
    uiccPyroscope = fetchurl {
        name = "ui_pyroscope.cc";
        url = "https://raw.githubusercontent.com/sjau/nix-expressions/master/rtorrent/0.9.8_ui_pyroscope.cc";
        sha256 = "sha256-iO2rZ5AHCH8VT5UlVA91oqYZ/TkU4yssWEh8C4lGwA8=";
    };
    uihPyroscope = fetchurl {
        name = "ui_pyroscope.h";
        url = "https://raw.githubusercontent.com/sjau/nix-expressions/master/rtorrent/0.9.8_ui_pyroscope.h";
        sha256 = "sha256-zHXww9GhkQVogIU8lAJAfkJ+7ByxiQd5q/5vrUnuplc=";
    };




    postUnpack = ''
        cp -v "$commandPyroscope" "$sourceRoot/src/command_pyroscope.cc"
        cp -v "$uiccPyroscope"    "$sourceRoot/src/ui_pyroscope.cc"
        cp -v "$uihPyroscope"     "$sourceRoot/src/ui_pyroscope.h"
        $( cd "$sourceRoot/" ; sed -i -e 's:\(AC_DEFINE(HAVE_CONFIG_H.*\):\1  AC_DEFINE(RT_HEX_VERSION, 0x000908, for CPP if checks):' configure.ac )
    '';

    patchFlags = [ "-uNp1" ];
    patches = [
        (fetchpatch {   url    = "https://raw.githubusercontent.com/sjau/nix-expressions/master/rtorrent/0.9.8_ps-import.return_all.patch";
                        sha256 = "sha256-nIQztZ1ck+k4I67OoRJSldh36C5dlCWk3FqJOQRF2Hs="; })
        (fetchpatch {   url    = "https://raw.githubusercontent.com/sjau/nix-expressions/master/rtorrent/0.9.8_ps-include-timestamps_all.patch";
                        sha256 = "sha256-NFvNaX2w4djkaeymGGuKFaJBteB7toXrw/yT5jXjvIE="; })
        (fetchpatch {   url    = "https://raw.githubusercontent.com/sjau/nix-expressions/master/rtorrent/0.9.8_ps-info-pane-is-default_all.patch";
                        sha256 = "sha256-8SV7a6JdpZ99l9w0AI2+2z3wr7KgHMS8AaJWBTnDJlY="; })
        (fetchpatch {   url    = "https://raw.githubusercontent.com/sjau/nix-expressions/master/rtorrent/0.9.8_ps-issue-515_all.patch";
                        sha256 = "sha256-Aly9dPvfsUfOrrJk4tWR0xZM9IyfoKtlJ7olziUl284="; })
        (fetchpatch {   url    = "https://raw.githubusercontent.com/sjau/nix-expressions/master/rtorrent/0.9.8_ps-item-stats-human-sizes_all.patch";
                        sha256 = "sha256-ZarPhvJktO8nrBPhFvVmdRi9aNdoA23jhqlirRqtJBo="; })
        (fetchpatch {   url    = "https://raw.githubusercontent.com/sjau/nix-expressions/master/rtorrent/0.9.8_ps-log_messages_all.patch";
                        sha256 = "sha256-u3hhnJs/tiP1ftBAlF8mtgPoIHr4qN4fzVs72XX3eKk="; })
        (fetchpatch {   url    = "https://raw.githubusercontent.com/sjau/nix-expressions/master/rtorrent/0.9.8_ps-object_std-map-serialization_all.patch";
                        sha256 = "sha256-EnfwA1v//qmney1KuZIUmaSRTIjyGawkPXs6cRVODXk="; })
        (fetchpatch {   url    = "https://raw.githubusercontent.com/sjau/nix-expressions/master/rtorrent/0.9.8_ps-silent-catch_all.patch";
                        sha256 = "sha256-Y4FczoyBjCGVouRWd7KTym8hi1X/c5kNb4kKzJiRu9w="; })
        (fetchpatch {   url    = "https://raw.githubusercontent.com/sjau/nix-expressions/master/rtorrent/0.9.8_ps-ui_pyroscope_all.patch";
                        sha256 = "sha256-dcEq7Qn0ZL7wQgE14O7lKJ6adIQi/jC7VGD6vjt8ihc="; })
        (fetchpatch {   url    = "https://raw.githubusercontent.com/sjau/nix-expressions/master/rtorrent/0.9.8_backport_rt_all_02-display_throttle_speed.patch";
                        sha256 = "sha256-2zEs8UTZsyPADwZ6ZTmYVA0jOWkFEWHCr1/sWxW8ynE="; })
        (fetchpatch {   url    = "https://raw.githubusercontent.com/sjau/nix-expressions/master/rtorrent/0.9.8_backport_rt_all_04-partially_done_and_choke_group_fix.patch";
                        sha256 = "sha256-QpMxiaxb0nGeu9t/Fb8Vpg/OtG2UUGjCEswEgEbAV3E="; })
        (fetchpatch {   url    = "https://raw.githubusercontent.com/sjau/nix-expressions/master/rtorrent/0.9.8_backport_rt_all_05-honor_system_file_allocate_fix.patch";
                        sha256 = "sha256-CCf7KqYXQ8A4MbIYkSVAXMexJEiDGiKdjBCCqO5lQ00="; })
        (fetchpatch {   url    = "https://raw.githubusercontent.com/sjau/nix-expressions/master/rtorrent/0.9.8_backport_rt_all_08-info_pane_xb_sizes.patch";
                        sha256 = "sha256-0o8vGL9O/tMTAmiUXaBgs4Ntf0ljOSBsSA8AHO7ufkw="; })
        (fetchpatch {   url    = "https://raw.githubusercontent.com/sjau/nix-expressions/master/rtorrent/0.9.8_backport_rt_all_09-inotify_mod.patch";
                        sha256 = "sha256-dI13vUlkWwBhsIeF+kW9DO4vFGotIrFvxR6nJCrq1gE="; })
        (fetchpatch {   url    = "https://raw.githubusercontent.com/sjau/nix-expressions/master/rtorrent/0.9.8_backport_rt_all_80-ps-dl-ui-find.patch";
                        sha256 = "sha256-UDvvBik+IlKfvmvEnRznrXUDjfLhpux30hD59POHI5I="; })
        (fetchpatch {   url    = "https://raw.githubusercontent.com/sjau/nix-expressions/master/rtorrent/0.9.8_pyroscope_all.patch";
                        sha256 = "sha256-jeNFtrOXbCtFse0mkT6A0PA++n8tGAa2txKjSzLpTz8="; })
        (fetchpatch {   url    = "https://raw.githubusercontent.com/sjau/nix-expressions/master/rtorrent/0.9.8_ui_pyroscope_all.patch";
                        sha256 = "sha256-NAIwfNpDTzSI9p6uIA7diDjjCS5IzHmZiJJwEnbB+WE="; })

        (fetchpatch {   url    = "https://raw.githubusercontent.com/sjau/nix-expressions/master/rtorrent/0.9.8_rtorrent_view_ignore.patch";
                        sha256 = "sha256-L9qxMKaokca6yszZZDhtvF38gaAQaWJfDbtrJvgxQB4="; })
    ];

    passthru = {
        inherit libtorrent-ps;
    };

    nativeBuildInputs = [
        autoconf-archive
        autoreconfHook
        pkg-config
    ];

    buildInputs = [
        cppunit
        curl
        libsigcxx
        libtool
        libtorrent-ps
        ncurses
        openssl
        xmlrpc_c
        zlib
    ];

    configureFlags = [
        "--with-xmlrpc-c"
        "--with-posix-fallocate"
    ];

    enableParallelBuilding = true;

    postInstall = ''
        mkdir -p $out/share/man/man1 $out/share/doc/rtorrent
        mv doc/old/rtorrent.1 $out/share/man/man1/rtorrent.1
        mv doc/rtorrent.rc $out/share/doc/rtorrent/rtorrent.rc
    '';

    meta = with lib; {
        homepage = "https://rakshasa.github.io/rtorrent/";
        description = "An ncurses client for libtorrent, ideal for use with screen, tmux, or dtach";
        license = licenses.gpl2Plus;
        maintainers = with maintainers; [ ebzzry codyopel ];
        platforms = platforms.unix;
    };
}
