# Sample terraform code to create Client VPN Endpoint on AWS. A Kitchen test is included to verify that resource is being deployed

## Prerequisites

- git
- terraform ( ~> 0.12 )
- AWS subscription

## How to use

### Clone the repo

```
git clone https://github.com/achuchulev/terraform-nomad-multicloud.git
cd networking/aws-client-vpn-endpoint
```

### Create `terraform.tfvars` file

#### Inputs

| Name  |	Description |	Type |  Default |	Required
| ----- | ----------- | ---- |  ------- | --------
| aws_access_key | AWS access key | string  | -   | yes
| aws_secret_key | AWS secret key | string  | -   | yes
| aws_region | AWS region     | string  | yes | yes
| cert_dir | Some certificate directory name     | string  | yes | no
| domain | Some domain name     | string  | yes | no

### Issue self signed server and client sertificates

Run `scripts/gen_acm_cert.sh <cert_dir> <domain>`

- Script will:
  - create private Certificate Authority (CA)
  - issue server certificate
  - issue client certificate

### Initialize terraform and plan/apply

```
terraform init
terraform plan
terraform apply
```

- `Terraform apply` will:
  - upload server certificate to AWS Certificate Manager (ACM)
  - upload client certificate to AWS Certificate Manager (ACM)
  - create new Client VPN Endpoint on AWS 
  - make VPN network association with specified VPC subnet
  - authorize all clients vpn ingress
  - create new route to allow Internet access for VPN clients
  - export client config file

### Import client config file in your preffered vpn client

### Connect to VPN server

  #### Outputs

| Name  |	Description 
| ----- | ----------- 
| client_vpn_endpoint_id | Client VPN Endpoint id


## Run kitchen test using kitchen-terraform plugin to verify that AWS Client VPN Endpoint is being deployed

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

  Command: `terraform state list`
     ✔  stdout should include "client_vpn_endpoint_id"
     ✔  stderr should include ""
     ✔  exit_status should eq 0

Test Summary: 3 successful, 0 failures, 0 skipped
```
