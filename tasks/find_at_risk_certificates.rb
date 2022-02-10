#!/opt/puppetlabs/puppet/bin/ruby
# frozen_string_literal: true

require 'uri'
require 'net/http'
require 'json'
require 'date'
require 'open3'

require_relative '../../ruby_task_helper/files/task_helper'

# documentation comment
class GetCertificate < TaskHelper
  def task(name: nil, **kwargs)
    files = Dir['/etc/puppetlabs/puppet/ssl/certs/*.*.pem']

    cert = OpenSSL::X509::Certificate.new(File.read(files[0]))

    expire = DateTime.parse(cert.not_after.to_s)

    days_from_expiration = expire - kwargs[:max_days_to_expiration]

    now = DateTime.now
    
    puts File.basename(files[0], '.pem') if days_from_expiration < now
  end
end

GetCertificate.run if __FILE__ == $PROGRAM_NAME
