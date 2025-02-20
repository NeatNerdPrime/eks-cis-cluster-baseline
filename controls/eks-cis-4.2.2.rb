control 'eks-cis-4.2.2' do
  title 'Minimize the admission of containers wishing to share the host
  process ID namespace'
  desc  "Do not generally permit containers to be run with the `hostPID` flag
set to true."
  desc  'rationale', "
A container running in the host's PID namespace can inspect processes running outside 
the container. If the container also has access to ptrace capabilities this can be used to 
escalate privileges outside of the container.

There should be at least one admission control policy defined which does not permit 
containers to share the host PID namespace.

If you need to run containers which require hostPID, this should be defined in a 
separate policy and you should carefully check to ensure that only limited service 
accounts and users are given permission to use that policy.  "
  desc  'check', "
List the policies in use for each namespace in the cluster, ensure that each policy disallows the admission of hostPID containers"
  desc 'fix', "Add policies to each namespace in the cluster which has user workloads to restrict the admission of hostPID containers."
  impact 0.5
  tag severity: 'medium'
  tag gtitle: nil
  tag gid: nil
  tag rid: nil
  tag stig_id: nil
  tag fix_id: nil
  tag cci: nil
  tag nist: ['AC-6 (9)', 'AC-6 (9)', 'AC-6 (2)']
  tag cis_level: 1
  tag cis_controls: [
    { '6' => ['5.1'] },
    { '7' => ['4.3'] },
    { '8' => ['5.4'] }
  ]
  tag cis_rid: '4.2.2'

  unless input("alternative_policy_enforcement")
    k = command(
      "kubectl get ns --selector=\'pod-security.kubernetes.io/enforce notin (restricted,baseline)\' -o jsonpath=\'{.items[*].metadata.name}\'"
    ).stdout.strip.split(' ') - input("allowed_namespaces_privileged")

    describe "List of namespaces with a pod security admission policy (PSA) which allows admission of hostPID containers" do
      subject { k }
      it { should be_empty }
    end
  else
    describe "Third-party policy enforcement in use" do
      skip "Input set to indicate use of third-party policy enforcement mechanism; manually review third-party policy enforcement method to ensure compliance with security policies"
    end
  end
end

