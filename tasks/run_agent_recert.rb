#!/opt/puppetlabs/puppet/bin/ruby
# frozen_string_literal: true

require 'puppet'
require 'open3'
require 'json'

require_relative '../../ruby_task_helper/files/task_helper'

# documentation comment
class RunAgentRecert < TaskHelper
  def task(name: nil, **kwargs)
    cmd = 'puppet access show'

    if(kwargs[:date])
      cmd = 'puppet task run ca_extend::check_agent_expiry -n $(puppet config print certname)'
    else
      cmd = "puppet task run ca_extend::check_agent_expiry date=#{kwargs[:date]}  -n $(puppet config print certname)"
    end

    stdout, stderr, status = Open3.capture3(cmd)
    raise Puppet::Error, _("stderr: '#{stderr}'") if status != 0
    stdout.strip.to_json
    
    # agent_cert_results = JSON.parse(stdout.strip.to_json)

    # expiring_certs = agent_cert_results['expiring']

    
    # failed_agents = []      # Agents that failed to update
    # successful_agents = []  # Agents that successfully updated

    # # Update all expiring certs
    # expiring_certs.each { | cert |
    #   match = cert.match(%r{([^\/]+).pem})

    #   recert_cmd = "HOME=/root && export HOME && puppet infrastructure run regenerate_agent_certificate agent=#{match[1]}"
    #   stdout, stderr, status = Open3.capture3(recert_cmd)
  
    #   if status != 0
    #     failed_agents <<  kwargs[:agent]
    #   else
    #     successful_agents <<  kwargs[:agent]
    #   end
    # }

    # {
    #   'failed' => failed_agents,
    #   'successul' => successful_agents
    # }.to_json
  end
end

RunAgentRecert.run if __FILE__ == $PROGRAM_NAME
