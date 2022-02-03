#!/opt/puppetlabs/puppet/bin/ruby
# frozen_string_literal: true

require 'uri'
require 'net/http'
require 'json'
require 'openssl'

require_relative '../../ruby_task_helper/files/task_helper'

# documentation comment
class GetCertificate < TaskHelper
  def task(name: nil, **_kwargs)
    files = Dir['/etc/puppetlabs/puppet/ssl/certs/*.wellsfargo.net.pem']

    cert = OpenSSL::X509::Certificate.new(File.read(files[0]))

    expire = DateTime.parse(cert.not_after.to_s)

    ninety_days_from_expiration = expire - 90

    now = DateTime.now

    if ninety_days_from_expiration < now
      `puppet resource service puppet ensure=stopped`
      `rm -rf /etc/puppetlabs/puppet/ssl`
      `puppet resource service puppet ensure=running`
    end

    puts cert.not_after
  end
end

GetCertificate.run if __FILE__ == $PROGRAM_NAME
