
    Deployment steps

Initialise the Terraform remote state on Azure blob storage by running 

./deploy.sh

When the state has been initialized, you can plan the blueprint


./deploy.sh step1-aks plan

Apply changes with

./deploy.sh step1-aks apply


    To allow multiple deployments in the same subscription

One of the goal of this template is to support multiple developers working in parallel in the same azure subscription.

To achieve that the template is using a prefix to used to identify the resource groups:

zlra-TERRAFORM-STATE\
zlra-AKS-CLUSTER1-NETWORKING

This is very convenient as multiple developers will have different prefixes and does not impact each others.

The other benefit is for bug fixing. Sometimes with Terraform fixing a bug breaks the current deployed infrastructure. As you are working towards a stable version of your blueprint you mays want to create a branch and work against a different tfstate file.

You can achieve that with the terraform workspaces who are isolating your different tfstates.

You can map the terraform workspace with the branch name \

terraform workspace list\
  default\
"* master

