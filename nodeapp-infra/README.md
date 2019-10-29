# Node APP Infrastructure

This folder is made up of terraform files to build the cloud infrastrcuture needed to run the project. The parent folder `terraform` contains files to build networks, security groups, ECS resources, Load Balancers etc. The sub folders `data_infra` and `cicd-infra` contianes files to provision a managed Document DB, Redis and Code Suite Resources on AWS. You're expected to run the parent folder first and then retrieve the env variable values needed for the data store resources like VPC, Subnets and Security Groups. 

## Steps

- Install [Terraform](https://www.terraform.io/downloads.html)
- To build the first layer of the infrastructure, Update the needed env variables in `nodeapp.tfvars`
- Run
```
terraform init
terraform plan -var-file=nodeapp.tfvars
terraform apply -var-file=nodeapp.tfvars
```
- Also repeat similar steps for the data-infra folder but this time adding the needed variables in `data_store.tfvars`.
- Once the base and data infrastructure have been built, you can then go ahead and build the pipeline infrastructure. 
- The files are in the `cicd-infra` folder. 
- Update the values for your `ci_cd.tfvars`
- Run 
```
terraform init
terraform plan -var-file=ci_cd.tfvars
terraform apply -var-file=ci_cd.tfvars
```