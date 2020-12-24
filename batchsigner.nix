{ stdenv, lib, dos2unix, fetchurl, jdk, bash, makeWrapper }:

stdenv.mkDerivation rec {
    name = "batchsigner-${lt_version}";
    lt_version = "1.8.0";

    src = fetchurl {
        url = "https://www.sjau.ch/batchsigner/suis-${name}-bin_linux-x86-64.tar.gz";
        sha256 = "1c1hlnmwh205pfdf2ifym2xag0a975f5cimnyamjgs6kwhbczq9b";
    };

    unpackCmd = ''
        tar xz "$src"
    '';

    buildPhase = ":";       # nothing to build
    nativeBuildInputs = [
        dos2unix
    ];
    installPhase = ''
        mkdir -p $out/{bin,conf,doc,examples,log,opt}
        cp -R conf doc examples lib log $out/
        cp -a bin/batchsigner.sh $out/bin/batchsigner.sh
        dos2unix $out/bin/batchsigner.sh
        chmod 0755 $out/bin/batchsigner.sh
        # fix the /bin/bash and export JAVA_HOME in script
        substituteInPlace \
            $out/bin/batchsigner.sh \
            --replace "#!/bin/sh" "#!/usr/bin/env bash" \
            --replace "# export SIGNER_HOME=/opt/suis-batchsigner" "export SIGNER_HOME=$out    # export SIGNER_HOME=/opt/suis-batchsigner" \
            --replace 'JAVA_HOME=$SIGNER_HOME/jre' "export JAVA_HOME=${jdk}      # export JAVA_HOME=/usr/lib/jvm/java-8-sun" \
            --replace 'lib/suis-batchsigner-1.8.0.jar:`cat bin/classpath_unix`' "$out/lib/*"
        # Set batchsigner log to /tmp/suis-batchsigner.log - needs to be writeable
        substituteInPlace \
            $out/conf/log4j.properties \
            --replace "log4j.appender.ROL.File=log/suis-batchsigner.log" "log4j.appender.ROL.File=/tmp/suis-batchsigner.log"
    '';

    meta = with stdenv.lib; {
        homepage = "https://www.openegov.admin.ch/egov/de/home/produkte/signieren/batchsigner.html";
        description = "A Java tool to digitally sign documents in a non-interactive way.";

        platforms = platforms.linux;
        maintainers = with maintainers; [ hyper_ch ];
    };
}
