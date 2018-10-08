{ stdenv, fetchFromGitHub, pkgconfig, python, python3 }:

stdenv.mkDerivation rec {

    name = "ungoogle-chromium-${version}";
    version = "2018-09-24";

    src = fetchFromGitHub {
        owner = "Eloston";
        repo = "ungoogled-chromium";
        rev = "b80a0ec5dc7cad643f4c2c82bf2727a205621eac";
        sha256 = "1rp1n6sqgj8jpsv0ajy1v8gc58sdb34jgykgjijgzn11g1y9dhv3";
    };

    postUnpack = ''
    '';

    nativeBuildInputs = [ pkgconfig ];
    buildInputs = [  ];
    propagatedBuildInputs = [
        python
        python3
    ];

    install = ''
        echo ""
        echo ""
        echo "------------------------------"
        pwd
        ls
        mkdir -p build/src
        ./get_package.py linux_simple build/src/ungoogled_packaging
        echo "------------------------------"
        echo ""
        echo ""
    '';

    postInstall = ''
    '';

    meta = with stdenv.lib; {
        inherit (src.meta) homepage;
        description = "ungoogled-chromium is Google Chromium, sans integration with Google. It also features some changes to enhance privacy, control, and transparency.";

        platforms = platforms.unix;
        maintainers = with maintainers; [ hyper_ch ];
    };
}
