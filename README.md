# Terraform configuration to deploy Nomad multicloud (AWS & GCP) federation cluster in different Nomad regions & DCs secured with mTLS and frontend with nginx reverse proxy. A kitchen test is included

## High Level Overview

<img src="diagrams/nomad-tls-nginx-reverse-proxy-1dc-1region.png" />

## Prerequisites

- git
- terraform (>=0.12)
- own or control registered domain name for the certificate 
- have a DNS record that associates your domain name and your server’s public IP address
- Cloudflare subscription as it is used to manage DNS records automatically
- AWS subscription
- GCP subscription
- ssh key
- Use pre-built nomad server,client and frontend AWS AMIs and GCP Images or bake your own using [Packer](https://www.packer.io)

## How to deploy

- Get the repo

```
git clone https://github.com/achuchulev/terraform-nomad-multicloud.git
cd terraform-nomad-multicloud
```

### Deploy networking infrastructure

- Create
  - 2 VPCs on AWS with one Public and one or more Private subnets each with module [aws-vpcs](https://github.com/achuchulev/terraform-nomad-multicloud/tree/master/networking/aws-vpcs)
  - VPC Peering conncetion between two AWS VPCs with module [aws-vpc-peering](https://github.com/achuchulev/terraform-nomad-multicloud/tree/master/networking/aws-vpc-peering)
  - 1 VPC on GCP with module [gcp-vpc](https://github.com/achuchulev/terraform-nomad-multicloud/tree/master/networking/gcp-vpc)
  - VPN between AWS VPC 1 and GCP VPC with module [aws-gcp-vpn](https://github.com/achuchulev/terraform-nomad-multicloud/tree/master/networking/aws-gcp-vpn)
  - Client VPN endpoint to AWS VPC 1 with module [aws-client-vpn-endpoint](https://github.com/achuchulev/terraform-nomad-multicloud/tree/master/networking/aws-client-vpn-endpoint)
  
### Deploy Nomad infrastructure

- Create `terraform.tfvars` file

```
// ************ GLOBAL ************ //

# Nomad vars
servers_count        = "nomad_servers_count"
clients_count        = "nomad_clients_count"
instance_role        = "client"
nomad_aws_region1    = "nomad_aws_region1_name"
nomad_aws_region1_dc = "nomad_aws_region1_dc_name"
nomad_aws_region2    = "nomad_aws_region2_name"
nomad_aws_region2_dc = "nomad_aws_region2_dc_name"
nomad_gcp_region     = "nomad_gcp_region"
nomad_gcp_region_dc  = "nomad_gcp_dc_name"
authoritative_region = "name_of_the_nomad_authoritative_region"

// ************ FRONTEND ************ //

# Cloudflare vars
cloudflare_email = "someone@example.net"
cloudflare_token = "your_cloudflare_token"
cloudflare_zone  = "example.net"
subdomain_name   = "nomad-multicloud"


// ************ GCP ************ //

gcp_credentials_file_path = "/path/to/your/gcloud/credentials.json"
gcp_project_id            = "your_gcp_project_name"


// ************ AWS ************ //

### vars AWS global
access_key = "your_aws_access_key"
secret_key = "your_aws_secret_key"
public_key    = "your_public_ssh_key"
instance_type = "ec2_instance_type"

### vars AWS region 1
region     = "us-east-1"
server_ami = "ami-0ac8c1373dae0f3e5"
client_ami = "ami-02ffa51d963317aaf"

### vars AWS region 2
region2            = "us-east-2"
region2_server_ami = "ami-0e2aa4ea219d7657e"
region2_client_ami = "ami-0e431df20c101e6b7"
```

- Initialize terraform

```
terraform init
```

- Deploy nginx and nomad instances

```
terraform plan
terraform apply
```

- `Terraform apply` will:
  - create new instances on AWS Region 1 for server/client/frontend
  - create new instances on AWS Region 2 for server/client
  - create new instances on GCP for server/client
  - copy nomad and nginx configuration files
  - install nomad
  - install cfssl (Cloudflare's PKI and TLS toolkit)
  - generate selfsigned certificates for Nomad cluster 
  - configure nginx reverse proxy
  - automatically enable HTTPS for Nomad frontend with EFF's Certbot, deploying Let's Encrypt certificate
  - check for certificate expiration and automatically renew Let’s Encrypt certificate
  - create Nomad federation cluster
  
## To do

 - configure Nomad frontend with LB
 - expose public ip of LB only
  
## Access Nomad

#### via CLI

for example:

```
$ nomad node status
$ nomad server members
```

```
Note

Nomad CLI defaults to communicating via HTTP instead of HTTPS. As Nomad CLI also searches 
environment variables for default values, the process can be simplified exporting environment 
variables like shown below which is done by the provisioning script:

$ export NOMAD_ADDR=https://your.dns.name
```

#### via WEB UI console

Open web browser, access nomad web console using your instance dns name as URL and verify that 
connection is secured and SSL certificate is valid  

## Run nomad job

#### via UI

- go to `jobs`
- click on `Run job`
- author a job in HCL/JSON format or paste the sample nomad job [nomad_jobs/nginx.hcl](https://github.com/achuchulev/terraform-aws-nomad-1dc-1region/blob/master/nomad_jobs/nginx.hcl) that run nginx on docker
- run `Plan`
- review `Job Plan` and `Run` it

#### via CLI

```
$ nomad job run [options] <job file>
```

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

  Command: `terraform state list`
     ✔  stdout should include "module.nomad_server.aws_instance.new_instance"
     ✔  stderr should include ""
     ✔  exit_status should eq 0
  Command: `terraform state list`
     ✔  stdout should include "module.nomad_client.aws_instance.new_instance"
     ✔  stderr should include ""
     ✔  exit_status should eq 0
  Command: `terraform state list`
     ✔  stdout should include "module.nomad_frontend.aws_instance.nginx_instance"
     ✔  stderr should include ""
     ✔  exit_status should eq 0
  Command: `terraform state list`
     ✔  stdout should include "module.nomad_frontend.cloudflare_record.nomad_frontend"
     ✔  stderr should include ""
     ✔  exit_status should eq 0
  Command: `terraform state list`
     ✔  stdout should include "module.nomad_frontend.null_resource.certbot"
     ✔  stderr should include ""
     ✔  exit_status should eq 0

Test Summary: 15 successful, 0 failures, 0 skipped
```
