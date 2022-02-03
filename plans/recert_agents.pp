plan certificate_utilities::recert_agents (
  Optional[Pattern[/\d\d\d\d-\d\d-\d\d/]] $date = undef,
) {
  $ca = puppetdb_query('resources[certname] { type = "Class" and title = "Puppet_enterprise::Profile::Certificate_authority" }')[0]

  $ca_target = get_target($ca)

  $expiring_agents = run_task('ca_extend::check_agent_expiry', $ca_target, 'date' => $date)['expiring']

  out::message("Expiring agents ${expiring_agents}")
}
