# Terraform code to create two VPCs in different AWS regions and make peering in-between. To verify that expected resources are being deployed a Kitchen test is included

## Prerequisites

- git
- terraform ( >= 0.12 )
- AWS subscription

## How to use

### Clone the repo

```
git clone https://github.com/achuchulev/terraform-nomad-multicloud.git
cd networking/aws-vpc-peering
```

### Create `terraform.tfvars` file

#### Inputs

| Name  |	Description |	Type |  Default |	Required
| ----- | ----------- | ---- |  ------- | --------
| requester_aws_access_key | Requester AWS access key | string  | - | yes
| accepter_aws_access_key | Accepter AWS access key | string  | - | yes
| requester_aws_secret_key | Requester AWS secret key | string  | - | yes
| accepter_aws_secret_key | Accepter AWS secret key | string  | - | yes
| requester_region | Requester AWS region | string  | - | yes
| accepter_region | Accepter AWS region | string  | - | yes
| requester_vpc_cidr_block  | Requester VPC CIDR block | string | 10.100.0.0/16 | yes
| accepter_vpc_cidr_block  | Accepter VPC CIDR block | string | 10.200.0.0/16 | yes
| requester_vpc_subnet_cidr_blocks  | Requester VPC CIDR block | list | 10.100.0.0/24, 10.100.1.0/24 | yes
| accepter_vpc_subnet_cidr_blocks  | Accepter VPC CIDR block | list | 10.200.0.0/24, 10.200.1.0/24 | yes
| activate_peering  | Prevent the module from creating or accessing any resources | string  | `true` | no
| requester_vpc_name  | Set a VPC name | string  | "" | no
| accepter_vpc_name | Set a VPC name  | string  | "" | no


### Initialize terraform and plan/apply

```
terraform init
terraform plan
terraform apply
```

- `Terraform apply` will:
  - create new VPC on each AWS region
  - create subnet(s) for each VPC
  - create Internet GW and route for each VPC
  - assosciate VPC main route table with subnet(s)
  - create new security group for each VPC to allow traffic needed for ssh and icmp echo request/reply
  - create a peering connection between both VPCs
  - create routes from requestor to acceptor
  - create routes from acceptor to requestor
  
  
#### Outputs

| Name  |	Description 
| ----- | ----------- 
| requester_vpc_id | Requester VPC id
| accepter_vpc_id | Accepter VPC id
| requester_azs | Requester VPC Availability Zone names
| accepter_azs | Accepter VPC Availability Zone names
| requester_subnet_ids | Requester VPC Subnet ids
| accepter_subnet_ids | Accepter VPC Subnet ids
| requester_vpc_name | Requester VPC name
| accepter_vpc_name | Accepter VPC name
| peering_connection_id | Peering connection id
| peering_status  | Peering connection status


## Run kitchen test using kitchen-terraform plugin to verify that expected resources are being deployed

### on Mac

#### Prerequisites

##### Install rbenv to use ruby version 2.3.1

```
brew install rbenv
rbenv install 2.3.1
rbenv local 2.3.1
rbenv versions
```

##### Add the following lines to your ~/.bash_profile:

```
eval "$(rbenv init -)"
true
export PATH="$HOME/.rbenv/bin:$PATH"
```

##### Reload profile: 

`source ~/.bash_profile`

##### Install bundler

```
gem install bundler
bundle install
```

#### Run the test: 

```
bundle exec kitchen list
bundle exec kitchen converge
bundle exec kitchen verify
bundle exec kitchen destroy
```

### on Linux

#### Prerequisites

```
gem install test-kitchen
gem install kitchen-inspec
gem install kitchen-vagrant
```

#### Run kitchen test 

```
kitchen list
kitchen converge
kitchen verify
kitchen destroy
```

### Sample output

```
Target:  local://

  Command: `terraform output`
     ✔  stdout should include "peering_status"
     ✔  stdout should match "peering_status = active"
     ✔  stderr should include ""
     ✔  exit_status should eq 0
  Command: `terraform output`
     ✔  stdout should include "peering_connection_id"
     ✔  stderr should include ""
     ✔  exit_status should eq 0
  Command: `terraform output`
     ✔  stdout should include "requester_azs"
     ✔  stderr should include ""
     ✔  exit_status should eq 0
  Command: `terraform output`
     ✔  stdout should include "requester_subnet_ids"
     ✔  stderr should include ""
     ✔  exit_status should eq 0
  Command: `terraform output`
     ✔  stdout should include "requester_vpc_id"
     ✔  stderr should include ""
     ✔  exit_status should eq 0
  Command: `terraform output`
     ✔  stdout should include "requester_vpc_name"
     ✔  stderr should include ""
     ✔  exit_status should eq 0
  Command: `terraform output`
     ✔  stdout should include "accepter_azs"
     ✔  stderr should include ""
     ✔  exit_status should eq 0
  Command: `terraform output`
     ✔  stdout should include "accepter_subnet_ids"
     ✔  stderr should include ""
     ✔  exit_status should eq 0
  Command: `terraform output`
     ✔  stdout should include "accepter_vpc_id"
     ✔  stderr should include ""
     ✔  exit_status should eq 0
  Command: `terraform output`
     ✔  stdout should include "accepter_vpc_name"
     ✔  stderr should include ""
     ✔  exit_status should eq 0

Test Summary: 31 successful, 0 failures, 0 skipped
```