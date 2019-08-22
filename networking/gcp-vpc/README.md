# Sample terraform configuration to create VPC on Google Cloud Platform (GCP). A Kitchen test is included to verify that expected resources are being deployed

# Prerequisites

- git
- terraform (>= 0.12)
- GCP subscription

## How to use

- Get the repo

```
git clone https://github.com/achuchulev/terraform-nomad-multicloud.git
cd networking/gcp-vpc
```

- Create `terraform.tfvars` file

```
gcp_credentials_file_path = "/path/to/your/gcloud/credentials.json"

gcp_project_id = "your-gcp-project-id"
```

#### Inputs

| Name  |	Description |	Type |  Default |	Required
| ----- | ----------- | ---- |  ------- | --------
| gcp_credentials_file_path | Locate the GCP credentials .json file. | string  | - | yes
| gcp_project_id | GCP Project ID. | string  | - | yes
| gcp_region | GCP region | string  | us-east4 | yes
| gcp_subnet1_cidr | VPC subnet CIDR block | string  | 10.24.0.0/24 | yes

- Initialize terraform and plan/apply

```
terraform init
terraform plan
terraform apply
```

- `Terraform apply` will:
  - create new VPC on specified GCP region
  - create subnet for VPC
  - create firewall rules to allow ICMP, SSH and Internet traffic 
  - create default routes for the VPC and for Internet
 
#### Outputs

| Name  |	Description 
| ----- | ----------- 
| gcp_vpc_network_id | VPC Network id
| gcp_vpc_network_subnet_id  | VPC subnet id

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
     ✔  stdout should include "gcp_vpc_network_id"
     ✔  stderr should include ""
     ✔  exit_status should eq 0
  Command: `terraform output`
     ✔  stdout should include "gcp_vpc_network_subnet_id"
     ✔  stderr should include ""
     ✔  exit_status should eq 0

Test Summary: 6 successful, 0 failures, 0 skipped
```
