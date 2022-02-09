plan certificate_utilities::find_at_risk_certificates (
  Optional[Integer] $max_days_to_expiration = 90,
) {
  # Obtain cas and grab the first one for query
  $cert_results = puppetdb_query('resources[certname] { }')

  $agent_certs = $cert_results.map | Integer $index, Hash $values | { $values['certname'] }

  $agent_targets = get_targets($agent_certs)

  $expiring_agents_results = run_task('certificate_utilities::find_at_risk_certificates', $agent_targets,
    'max_days_to_expiration' => $max_days_to_expiration
  )

  $expiring_agents = $expiring_agents_results.map | Result $result | {
  }

  # Go through each agent one at a time
  $recert_list = $expiring_agents_results.map | Result $result | {
    $agent = $result.message

    out::message("Agent ${result}")

    if $agent =~ /^.+\.com$/ {
      $agent
    }
  }

  return join($recert_list, ',')
}