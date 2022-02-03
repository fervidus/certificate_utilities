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
    files = Dir['/etc/puppetlabs/puppet/ssl/certs/*.*.pem']

    cert = OpenSSL::X509::Certificate.new(File.read(files[0]))

    puts cert.not_after
  end
end

GetCertificate.run if __FILE__ == $PROGRAM_NAME
