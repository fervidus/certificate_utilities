#!/opt/puppetlabs/puppet/bin/ruby
# frozen_string_literal: true

require 'openssl'
require 'date'

# Obtain cert
cert = OpenSSL::X509::Certificate.new(File.read('/etc/puppetlabs/puppet/ssl/ca/ca_crt.pem'))

puts cert.not_after
