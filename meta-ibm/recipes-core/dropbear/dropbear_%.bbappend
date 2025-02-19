
FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"
SRC_URI += "file://dropbear.default"

do_configure:append() {
    if [ -e ${WORKDIR}/dropbear@.service ] ; then
        if ! grep -q "DROPBEAR_EXTRA_ARGS DROPBEAR_PERMISSION_ARGS -I 3600" ${WORKDIR}/dropbear@.service 2>/dev/null ; then
            sed -i.bak 's/DROPBEAR_EXTRA_ARGS"*\([^"]*\)"*/DROPBEAR_EXTRA_ARGS $DROPBEAR_PERMISSION_ARGS -I 3600/' ${WORKDIR}/dropbear@.service
            if [ $? -ne 0 ]; then
                echo "sed replacement failed"
                exit 1
            fi
        fi
    else
        echo '${WORKDIR}/dropbear@.service not found'
        exit 1
    fi
}
