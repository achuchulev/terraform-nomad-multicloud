describe command('terraform output') do
  its('stdout') { should include "peering_status" }
  its('stdout') { should match "peering_status = active" }
  its('stderr') { should include '' }
  its('exit_status') { should eq 0 }
end
describe command('terraform output') do
  its('stdout') { should include "peering_connection_id" }
  its('stderr') { should include '' }
  its('exit_status') { should eq 0 }
end
describe command('terraform output') do
  its('stdout') { should include "requester_azs" }
  its('stderr') { should include '' }
  its('exit_status') { should eq 0 }
end
describe command('terraform output') do
  its('stdout') { should include "requester_subnet_ids" }
  its('stderr') { should include '' }
  its('exit_status') { should eq 0 }
end
describe command('terraform output') do
  its('stdout') { should include "requester_vpc_id" }
  its('stderr') { should include '' }
  its('exit_status') { should eq 0 }
end
describe command('terraform output') do
  its('stdout') { should include "requester_vpc_name" }
  its('stderr') { should include '' }
  its('exit_status') { should eq 0 }
end
describe command('terraform output') do
  its('stdout') { should include "accepter_azs" }
  its('stderr') { should include '' }
  its('exit_status') { should eq 0 }
end
describe command('terraform output') do
  its('stdout') { should include "accepter_subnet_ids" }
  its('stderr') { should include '' }
  its('exit_status') { should eq 0 }
end
describe command('terraform output') do
  its('stdout') { should include "accepter_vpc_id" }
  its('stderr') { should include '' }
  its('exit_status') { should eq 0 }
end
describe command('terraform output') do
  its('stdout') { should include "accepter_vpc_name" }
  its('stderr') { should include '' }
  its('exit_status') { should eq 0 }
end