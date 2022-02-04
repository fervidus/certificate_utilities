#!/opt/puppetlabs/puppet/bin/ruby
# frozen_string_literal: true

require 'puppet'
require 'open3'

require_relative '../../ruby_task_helper/files/task_helper'

# documentation comment
class RunAgentRecert < TaskHelper
  def task(name: nil, **kwargs)
    output = {}

    token_cmd = 'puppet access show'

    stdout, stderr, status = Open3.capture3(token_cmd)
    raise Puppet::Error, _("stderr: '#{stderr}'") if status != 0
    output['token'] = stdout.strip

    if(kwargs[:date])
      cmd = "puppet task run ca_extend::check_agent_expiry -n puppet.azcender.com"
    else
      cmd = "puppet task run ca_extend::check_agent_expiry date=#{kwargs[:date]} -n puppet.azcender.com"
    end

    stdout, stderr, status = Open3.capture3(cmd)
    # raise Puppet::Error, _("stderr: '#{stderr}'") if status != 0

    output['response'] = { stdout: stdout.strip, stderr: stderr.strip }

    output.to_json

    # cmd = "HOME=/root && export HOME && puppet infrastructure run regenerate_agent_certificate agent=#{kwargs[:agent]}"
    # stdout, stderr, status = Open3.capture3(cmd)

    # raise Puppet::Error, _("stderr: '#{stderr}'") if status != 0
    # stdout.strip.to_json
  end
end

RunAgentRecert.run if __FILE__ == $PROGRAM_NAME
