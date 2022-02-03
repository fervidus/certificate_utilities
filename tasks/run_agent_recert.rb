#!/opt/puppetlabs/puppet/bin/ruby
# frozen_string_literal: true

require 'uri'
require 'net/http'
require 'json'
require 'open3'

require_relative '../../ruby_task_helper/files/task_helper'

# documentation comment
class RunAgentRecert < TaskHelper
  def task(name: nil, **kwargs)
    cmd = "HOME=/root && export HOME && puppet infrastructure run regenerate_agent_certificate agent=#{kwargs['agent']}"
    stdout, stderr, status = Open3.capture3(cmd)

    raise Puppet::Error, _("stderr: '#{stderr}'") if status != 0
    { status: stdout.strip }
  end
end

RunAgentRecert.run if __FILE__ == $PROGRAM_NAME
