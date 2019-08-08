# Sample terraform configuration to create VPC on Google Cloud Platform (GCP)

# Prerequisites

- git
- terraform (>= 0.12)
- GCP subscription

## How to use

- Get the repo

```
git clone https://github.com/achuchulev/terraform-gcp-vpc.git
cd terraform-gcp-vpc
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
| gcp_region | Requester AWS secret key | string  | us-east4 | yes
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
