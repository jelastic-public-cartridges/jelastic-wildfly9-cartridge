#!/bin/bash

# Simple deploy and undeploy scenarios for Wildfly9

WGET=$(which wget);

function _deploy(){
     [ "x${context}" == "xroot" ] && context="ROOT";
     [ -f "${WEBROOT}/${context}.war" ] && rm -f ${WEBROOT}/${context}.war;
     [ -f "${WEBROOT}/${context}.ear" ] && rm -f ${WEBROOT}/${context}.ear;
     [ -f "${WEBROOT}/${context}.war.undeployed" ] && mv ${WEBROOT}/${context}.war.undeployed ${WEBROOT}/${context}.war.deployed
     [ -f "${WEBROOT}/${context}.ear.undeployed" ] && mv ${WEBROOT}/${context}.ear.undeployed ${WEBROOT}/${context}.ear.deployed
     local download_dir=$(mktemp -d)
     $WGET --no-check-certificate --content-disposition -P "$download_dir" "$package_url";
     local app_filename=$(ls -1 "$download_dir")
     cd "$download_dir";
     set +f;
     [[ "$app_filename" =~ (.*.ear) ]] && mv -f "${app_filename}" "${context}.ear" || mv -f "${app_filename}" "${context}.war"
     chown jelastic:jelastic ${context}.*;
     mv ${context}.* ${WEBROOT};
     cd /; rm -rf "$download_dir";
     set -f;
}

function _undeploy(){
     [ "x${context}" == "xroot" ] && context="ROOT";
     rm -rf "${WEBROOT}/${context}.war" "${WEBROOT}/${context}.war.*" 1>/dev/null;
     rm -rf "${WEBROOT}/${context}.ear" "${WEBROOT}/${context}.ear.*" 1>/dev/null;
}
