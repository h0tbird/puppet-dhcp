#------------------------------------------------------------------------------
# Define: dhcp::subnet
#
#   This define is part of the dhcp module.
#
#   Marc Villacorta <marc.villacorta@gmail.com>
#   2012-01-18
#
#   Tested platforms:
#       - CentOS 6
#
# Parameters:
#
#   
#
# Actions:
#
#   Creates a subnet declaration.
#
# Sample Usage:
#
#   dhcp::subnet { '192.168.1.0':
#       netmask             => '255.255.255.0',
#       domain_name         => 'popapp.lan',
#       domain_name_servers => '8.8.8.8, 8.8.4.4',
#       routers             => '192.168.1.1',
#       subnet_mask         => '255.255.255.0',
#       ntp_servers         => '192.168.1.1',
#       default_lease_time  => '21600',
#       max_lease_time      => '43200',
#       range_dynamic_bootp => '192.168.1.200 192.168.1.250',
#   }
#
#------------------------------------------------------------------------------
define dhcp::subnet (

    $netmask,
    $ensure              = present,
    $domain_name         = undef,
    $domain_name_servers = undef,
    $routers             = undef,
    $subnet_mask         = undef,
    $ntp_servers         = undef,
    $default_lease_time  = undef,
    $max_lease_time      = undef,
    $range_dynamic_bootp = undef

) {

    # Validate parameters:
    validate_re($ensure, '^present$|^absent$')

    # Include delegated class:
    include dhcp

    # Collect variables:
    $templates = getvar("${module_name}::params::templates")
    $configs   = getvar("${module_name}::params::configs")

    # Create the file fragment:
    concat::fragment { $name:
        ensure  => $ensure,
        order   => '10',
        target  => $configs[0],
        content => template("${templates}/dhcpd.conf_subnet.erb"),
    }
}
