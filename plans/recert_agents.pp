plan certificate_utilities::recert_agents (
  Optional[Pattern[/\d\d\d\d-\d\d-\d\d/]] $date = undef,
) {
  # Obtain cas and grab the first one for query
  $ca_results = puppetdb_query('resources[certname] { type = "Class" and title = "Puppet_enterprise::Profile::Certificate_authority" }')

  $ca = $ca_results[0]['certname']

  $ca_target = get_target($ca)

  if($date) {
    $expiring_agents_results = run_task('ca_extend::check_agent_expiry', $ca_target, 'date' => $date)
  }
  else {
    $expiring_agents_results = run_task('ca_extend::check_agent_expiry', $ca_target)
  }

  $expiring_agents = $expiring_agents_results.first['expiring']

  out::message($expiring_agents)

  # $failed_agents = []

  # Go through each agent one at a time
  # $expiring_agents.each | String $agent_file | {
  #   if $agent_file =~ /([^\/]+).pem/ {
      # $next_command = "HOME=/root && export HOME && puppet infrastructure run regenerate_agent_certificate agent=${1}"
      # $next_command = run_task('certificate_utilities::run_agent_recert', $ca_target, 'agent' => $1, '_catch_errors' => true)
      $next_command = run_plan( 'peadm::subplans::modify_certificate', 'tester.azcender.com',
        'primary_host'     => 'puppet.azcender.com',
        'primary_certname' => 'puppet.azcender.com',
        'force_regenerate' => true
      )

      # Failure print notify
      # if($recert_results.first.status == 'failure') {
      #   $failed_agents << "Agent ${1} failed"
      # }
  #   }
  # }

  # Return failures
  # return $failed_agents
  out::message($next_command.first.message)
}
