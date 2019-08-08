# Sample terraform configuration to setup a VPN Between VPCs in GCP and AWS

## Prerequisites

- git
- terraform (>= 0.12)
- GCP subscription
- AWS subscription

## How to use

- Get the repo

```
git clone https://github.com/achuchulev/terraform-nomad-multicloud.git
cd networking/aws-gcp-vpn
```

- Create `terraform.tfvars` file

```
gcp_credentials_file_path = "/path/to/your/gcloud/credentials.json"
aws_credentials_file_path = "/path/to/your/aws/credentials"
gcp_project_id = "your_project_id"
```

#### Inputs

| Name  |	Description |	Type |  Default |	Required
| ----- | ----------- | ---- |  ------- | --------
| gcp_credentials_file_path | Locate the GCP credentials .json file. | string  | - | yes
| gcp_project_id | GCP Project ID. | string  | - | yes
| gcp_region | GCP region | string  | yes | yes
| aws_credentials_file_path | Locate the AWS credentials file | string  | - | yes
| aws_region | AWS region | string  | yes | yes
| GCP_TUN1_VPN_GW_ASN | Tunnel 1 - Virtual Private Gateway ASN | number  | yes | yes
| GCP_TUN1_CUSTOMER_GW_INSIDE_NETWORK_CIDR | Tunnel 1 - Customer Gateway from Inside IP Address CIDR block | number  | yes | yes
| GCP_TUN2_VPN_GW_ASN | Tunnel 2 - Virtual Private Gateway ASN | number  | yes | yes
| GCP_TUN2_CUSTOMER_GW_INSIDE_NETWORK_CIDR | Tunnel 2 - Customer Gateway from Inside IP Address CIDR block | number  | yes | yes


- Initialize terraform and plan/apply

```
terraform init
terraform plan
terraform apply
```

- `Terraform apply` will create:
  - on AWS
    - VPN Gateway 
    - Customer Gateway
    - default Internet route
    - security groups to allow ICMP, SSH, VPN ans Internet traffic
    
  - on GCP 
    - public IP address
    - VPN GW
    - forwarding rules for IP protocols ESP, UDP 500 & 4500 and
    - two VPN tunnels
    - 2 routers
    - 2 router interfaces
    - 2 router peers
    - FW rules to allow traffic from the VPN subnets
   
