{ stdenv, lib, fetchzip, jdk, bash, makeWrapper }:

stdenv.mkDerivation rec {
    name = "batchsigner-${lt_version}";
    lt_version = "1.6.3";

    src = fetchzip {
        url = "https://www.e-service.admin.ch/wiki/download/attachments/35979898/suis-batchsigner-${lt_version}-bin.zip";
#        url = "https://sjau.ch/suis-batchsigner-${lt_version}.zip";
        sha256 = "1f2rsdkn3axrfwvrlskrilbda4ssi3vh6pgfk5xvaakajsi4mrav";
        extraPostFetch = "chmod -R 755 $out";
    };

    unpackCmd = ''
        unzip "$src"
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
    '';

    meta = with stdenv.lib; {
        homepage = "https://www.openegov.admin.ch/egov/de/home/produkte/signieren/batchsigner.html";
        description = "A Java tool to digitally sign documents in a non-interactive way.";

        platforms = platforms.linux;
        maintainers = with maintainers; [ hyper_ch ];
    };
}

