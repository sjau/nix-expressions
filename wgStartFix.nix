{ stdenv, writeScriptBin }:

writeScriptBin "wgStartFix" ''
    #!${stdenv.shell}

    # Small script to check if wireguard interfaces are up
    # Usage: wgStartFix "wg0 wg1 wg2 wg_home wg_office"
    # You could add a system cron job like
    #     "*/5 * * * * root wgStartFix 'wg0 wg1 wg2 wg_home wg_office'"

    IFS=', ' read -r -a interfaces <<< "$1"

    for i in ''${interfaces[@]}; do
        if ! systemctl is-active --quiet wireguard-$i; then
            systemctl restart wireguard-$i
        fi
    done
''
