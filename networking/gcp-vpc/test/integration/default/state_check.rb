describe command('terraform output') do
  its('stdout') { should include "gcp_vpc_network_id" }
  its('stderr') { should include '' }
  its('exit_status') { should eq 0 }
end
describe command('terraform output') do
  its('stdout') { should include "gcp_vpc_network_subnet_id" }
  its('stderr') { should include '' }
  its('exit_status') { should eq 0 }
end