FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"

inherit obmc-phosphor-systemd

SRC_URI += "file://psu.json"

EXTRA_OEMESON:append:ibm-ac-server = " -Ducd90160-yaml=${STAGING_DIR_HOST}${datadir}/power-sequencer/ucd90160.yaml"
EXTRA_OEMESON:append:p10bmc = " -Dibm-vpd=true"

DEPENDS:append:ibm-ac-server = " power-sequencer"
DEPENDS:append:p10bmc = " power-sequencer"

PACKAGECONFIG:append:ibm-ac-server = " monitor"
PACKAGECONFIG:append:swift = " monitor"
PACKAGECONFIG:append:p10bmc = " monitor-ng"

do_install:append(){
    install -D ${WORKDIR}/psu.json ${D}${datadir}/phosphor-power/psu.json
}
FILES:${PN} += "${datadir}/phosphor-power/psu.json"

PSU_MONITOR_ENV_FMT = "obmc/power-supply-monitor/power-supply-monitor-{0}.conf"
SYSTEMD_ENVIRONMENT_FILE:${PN}-monitor:append:ibm-ac-server = " ${@compose_list(d, 'PSU_MONITOR_ENV_FMT', 'OBMC_POWER_SUPPLY_INSTANCES')}"

RDEPENDS:${PN}:append:p10bmc = " ibm-ups"
RDEPENDS:${PN}-regulators:append:p10bmc = " python3-core"
RDEPENDS:${PN}-regulators:append:witherspoon-tacoma = " python3-core"
SYSTEMD_SERVICE:${PN}-regulators:append:p10bmc = " reset_voltage_regulators.service"
FILES:${PN}-regulators:append:p10bmc = " ${bindir}/reset_voltage_regulators"
SYSTEMD_SERVICE:${PN}-regulators:append:witherspoon-tacoma = " reset_voltage_regulators.service"
FILES:${PN}-regulators:append:witherspoon-tacoma = " ${bindir}/reset_voltage_regulators"
