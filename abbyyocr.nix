{ stdenv, lib, fetchurl }:

stdenv.mkDerivation rec {
    name = "abbyyocr-";
    lt_version = "11.1.14.707470";

    src = fetchurl {
        url = "http://ocr4linux.com/_media/abbyyocr.${lt_version}.tar.gz";
        sha256 = "0000000000000000000000000000000000000000000000000000";
    };

    unpackCmd = ''
        tar xzf "$src"
        # The install script is contained in the unpacked .run file; so extract it
        while IFS= read -r line; do
            [[ $line = *[![:ascii:]]* ]] && break;
            printf '%s\n' "$line" >> "install.sh";
        done < "abbyyocr.run"
        chmod 0755 "install.sh"
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
            --replace "# export JAVA_HOME=/usr/lib/jvm/java-6-sun" "export JAVA_HOME=${jdk}      # export JAVA_HOME=/usr/lib/jvm/java-6-sun" \
            --replace "# export SIGNER_HOME=/opt/suis-batchsigner" "export SIGNER_HOME=$out    # export SIGNER_HOME=/opt/suis-batchsigner" \
            --replace "# export SIGNER_HOME=/opt/suis-batchsigner" "export SIGNER_HOME=$out    # export SIGNER_HOME=/opt/suis-batchsigner" \
            --replace 'lib/suis-batchsigner-1.6.3.jar:`cat bin/classpath_unix`' "$out/lib/*"
        # Set batchsigner log to /tmp/suis-batchsigner.log - needs to be writeable
        substituteInPlace \
            $out/conf/log4j.properties \
            --replace "log4j.appender.ROL.File=log/suis-batchsigner.log" "log4j.appender.ROL.File=/tmp/suis-batchsigner.log"
    '';

    meta = with stdenv.lib; {
        homepage = "http://ocr4linux.com";
        description = "ABBYY FineReader Engine 11 CLI for Linux is a powerful, ready-to-use command line based application for system administrators, developers and advanced computer users who want to use optical character recognition (OCR, text recognition) and PDF conversion technologies on the Linux platform.";

        platforms = platforms.linux;
        maintainers = with maintainers; [ hyper_ch ];
    };
}

