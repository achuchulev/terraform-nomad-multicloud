describe command('terraform output') do
  its('stdout') { should include "aws_customer_gateway_id" }
  its('stderr') { should include '' }
  its('exit_status') { should eq 0 }
end
describe command('terraform output') do
  its('stdout') { should include "aws_vpn_gateway_id" }
  its('stderr') { should include '' }
  its('exit_status') { should eq 0 }
end
describe command('terraform output') do
  its('stdout') { should include "google_compute_vpn_gateway_id" }
  its('stderr') { should include '' }
  its('exit_status') { should eq 0 }
end
describe command('terraform output') do
  its('stdout') { should include "google_compute_vpn_tunnel1_status" }
  its('stdout') { should match "google_compute_vpn_tunnel1_status = Tunnel is up and running." }
  its('stderr') { should include '' }
  its('exit_status') { should eq 0 }
end
describe command('terraform output') do
  its('stdout') { should include "google_compute_vpn_tunnel2_status" }
  its('stdout') { should match "google_compute_vpn_tunnel2_status = Tunnel is up and running." }
  its('stderr') { should include '' }
  its('exit_status') { should eq 0 }
end