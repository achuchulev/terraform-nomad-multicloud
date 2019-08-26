# Terraform code to make peering between two existing VPCs located in different AWS regions

## Prerequisites

- git
- terraform ( < 0.12.xx )
- AWS subscription

## How to use

### Clone the repo

```
git clone https://github.com/achuchulev/terraform-aws-existing-vpcs-peering.git
cd terraform-aws-existing-vpcs-peering
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
| requester_vpc_id  | Requester VPC id | string | - | yes
| accepter_vpc_id | Accepter VPC id | string | - | yes
| activate_peering | Prevent the module from creating or accessing any resources | string  | `true` | no
| requester_peer_tags | Set a VPC tags `Name` | map  | `<map>` | no
| accepter_peer_tags | Set a VPC tags `Name`  | map  | `<map>` | no


### Initialize terraform and plan/apply

```
terraform init
terraform plan
terraform apply
```

- `Terraform apply` will:
  - create a peering connection between both VPCs
  
  
#### Outputs

| Name  |	Description 
| ----- | ----------- 
| connection_id | Peering connection id
| accept_status  | Peering connection status
