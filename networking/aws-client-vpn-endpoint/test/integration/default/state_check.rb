describe command('terraform output') do
  its('stdout') { should include "client_vpn_endpoint_id" }
  its('stderr') { should include '' }
  its('exit_status') { should eq 0 }
end