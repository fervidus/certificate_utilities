#!/opt/puppetlabs/puppet/bin/ruby
# frozen_string_literal: true

require 'openssl'
require 'date'

# Obtain cert
cert = OpenSSL::X509::Certificate.new(File.read('/etc/puppetlabs/puppet/ssl/ca/ca_crt.pem'))

# puts cert.not_after

expire = DateTime.parse(cert.not_after.to_s)

ninety_days_from_expiration = expire - 90

now = DateTime.now

puts ninety_days_from_expiration < now

# if ninety_days_from_expiration < now
#   `puppet resource service puppet ensure=stopped`
#   `rm -rf /etc/puppetlabs/puppet/ssl`
#   `puppet resource service puppet ensure=running`
# end
