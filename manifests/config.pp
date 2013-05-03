#------------------------------------------------------------------------------
# Class: dhcp::config
#
#   This class is part of the dhcp module.
#   You should not be calling this class.
#   The delegated class is Class['dhcp'].
#
#   Marc Villacorta <marc.villacorta@gmail.com>
#   2012-01-18
#
#------------------------------------------------------------------------------
class dhcp::config {

    # Collect variables:
    $templates = getvar("${module_name}::params::templates")
    $configs   = getvar("${module_name}::params::configs")
    $globals   = getvar("${module_name}::globals")
    $subnets   = getvar("${module_name}::subnets")

    # Define the target file:
    concat { $configs[0]: ensure => present }

    # Config file header:
    concat::fragment { 'dhcp_header':
        ensure  => present,
        target  => $configs[0],
        content => template("${templates}/dhcpd.conf_header.erb"),
        order   => '00',
    }

    # Subnet declarations:
    if $subnets {
        create_resources(dhcp::subnet, $subnets)
    }
}
