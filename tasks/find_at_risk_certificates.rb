#!/opt/puppetlabs/puppet/bin/ruby
# frozen_string_literal: true

require 'uri'
require 'net/http'
require 'json'
require 'datetime'

require_relative '../../ruby_task_helper/files/task_helper'

# documentation comment
class GetCertificate < TaskHelper
  def task(name: nil, **kwargs)
    certname = `/opt/puppetlabs/puppet/bin/puppet config print certname`

    # Remove problematic whitespace
    certname.strip!

    cert_file = File.new("/etc/puppetlabs/puppet/ssl/certs/#{certname}.pem")

    cert = OpenSSL::X509::Certificate.new(cert_file)

    expire = DateTime.parse(cert.not_after.to_s)

    days_from_expiration = expire - kwargs[:max_days_to_expiration]

    now = DateTime.now

    # if ninety_days_from_expiration < now
    #   `puppet resource service puppet ensure=stopped`
    #   `rm -rf /etc/puppetlabs/puppet/ssl`
    #   `puppet resource service puppet ensure=running`
    # end

    puts certname if days_from_expiration < now
  end
end

GetCertificate.run if __FILE__ == $PROGRAM_NAME
