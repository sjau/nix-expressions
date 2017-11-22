{ stdenv, lib, fetchurl }:

let

    abbyyocrunpack = callPackage (builtins.fetchurl "https://raw.githubusercontent.com/sjau/nix-expressions/master/abbyyocrunpack.nix") {};

in

stdenv.mkDerivation rec {
    name = "abbyyocr-";
    lt_version = "11.1.14.707470";

    src = fetchurl {
        url = "http://ocr4linux.com/_media/abbyyocr.${lt_version}.tar.gz";
        sha256 = "1zhsxxxbm0hhvf380zv0lw6sk5sysv9xf4wmm3647qfawn1bkra3";
    };

    unpackCmd = ''
        abbyyocrunpack "$src"
    '';

    buildPhase = ":";       # nothing to build
    installPhase = ''
        mkdir -p $out/{bin,conf,doc,examples,log,opt}
        cp -R conf doc examples lib log $out/
        cp -a bin/batchsigner.sh $out/bin/batchsigner.sh
        chmod 0755 $out/bin/batchsigner.sh
        # fix the /bin/bash and export JAVA_HOME in script
        substituteInPlace \
            $out/bin/batchsigner.sh \
            --replace "#!/bin/sh" "#!/usr/bin/env bash" \
    '';

    meta = with stdenv.lib; {
        homepage = "http://ocr4linux.com";
        description = "ABBYY FineReader Engine 11 CLI for Linux is a powerful, ready-to-use command line based application for system administrators, developers and advanced computer users who want to use optical character recognition (OCR, text recognition) and PDF conversion technologies on the Linux platform.";

        platforms = platforms.linux;
        maintainers = with maintainers; [ hyper_ch ];
    };
}

