#!/opt/puppetlabs/puppet/bin/ruby
# frozen_string_literal: true

require 'openssl'
require 'date'

# Obtain certs
files = Dir['/etc/puppetlabs/puppet/ssl/ca/signed/*.pem']

files.each do |file|
  cert = OpenSSL::X509::Certificate.new(File.read(files[0]))

  expire = DateTime.parse(cert.not_after.to_s)

  ninety_days_from_expiration = expire - 90

  now = DateTime.now

  puts "#{File.basename(file, '.pem')}\t\texpires #{cert.not_after}" if ninety_days_from_expiration < now
end
