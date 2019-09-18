describe command('terraform output') do
  its('stdout') { should include "aws_vpc_id" }
  its('stderr') { should include '' }
  its('exit_status') { should eq 0 }
end
describe command('terraform output') do
  its('stdout') { should include "aws_vpc_name" }
  its('stderr') { should include '' }
  its('exit_status') { should eq 0 }
end
describe command('terraform output') do
  its('stdout') { should include "aws_subnet_ids" }
  its('stderr') { should include '' }
  its('exit_status') { should eq 0 }
end
describe command('terraform output') do
  its('stdout') { should include "aws_server_private_ips" }
  its('stderr') { should include '' }
  its('exit_status') { should eq 0 }
end
describe command('terraform output') do
  its('stdout') { should include "aws_client_private_ips" }
  its('stderr') { should include '' }
  its('exit_status') { should eq 0 }
end
describe command('terraform output') do
  its('stdout') { should include "aws_frontend_public_ip" }
  its('stderr') { should include '' }
  its('exit_status') { should eq 0 }
end
describe command('terraform output') do
  its('stdout') { should include "AWS_Nomad_UI_URL" }
  its('stderr') { should include '' }
  its('exit_status') { should eq 0 }
end
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
describe command('terraform output') do
  its('stdout') { should include "gcp_server_private_ips" }
  its('stderr') { should include '' }
  its('exit_status') { should eq 0 }
end
describe command('terraform output') do
  its('stdout') { should include "gcp_client_private_ips" }
  its('stderr') { should include '' }
  its('exit_status') { should eq 0 }
end
describe command('terraform output') do
  its('stdout') { should include "gcp_frontend_public_ip" }
  its('stderr') { should include '' }
  its('exit_status') { should eq 0 }
end
describe command('terraform output') do
  its('stdout') { should include "gcp_Nomad_UI_URL" }
  its('stderr') { should include '' }
  its('exit_status') { should eq 0 }
end
describe command('terraform output') do
  its('stdout') { should include "client_vpn_id" }
  its('stderr') { should include '' }
  its('exit_status') { should eq 0 }
end