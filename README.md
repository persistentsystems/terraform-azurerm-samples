# terraform-azurerm-samples

This is a companion to our terraform-azurerm repository and contains
demos and insights about how to use the terraform-azurerm repository.

## This repository has a couple of main directories:

## samples/scenarios

Contains folders with various demonstations of 
how to deploy working infrastructure.  They will provision several 
azure resources to provide a demonstration of how to create a working
infrastructure that say: Provisions Azure Functions, API Management and FrontDoor.

Each folder is designed so that you can take the code and modify to 
your particular needs.

## sampels/services

Contains folders that demonstrate how to call
individual modules in our terraform-azurerm repository.  Unlike the
sometimes sparse documentation found for terraform, our goal is that
each module has a fairly realistc demonstration code of how to use it
in a non-trivial manner.
We want to document each input variable with real world scenario data
so that you know what you need to create before calling the module,
and how to format the input variables to the module.

## submodules/terraform-azurerm

There are a couple of ways of referencing external modules in terraform.
The simplest way is:

```HCL
module "rg" {
  source  = "github.com/persistentsystems/terraform-azurerm/services/resource-group/base/v1"
```

This is perfectly acceptable but has some slight scaling issues.  If you 
are loading dozens of modules from terrafrom-azurerm, you will get a full
copy of the repository for each reference in your .terraform folder.  

In this demonstration code we have moved to referencing the modules as
such:

```HCL
module log_analytics {
    source = "../../../submodules/terraform-azurerm/services/log-analytics/workspace/base/v1"
```

This will not make copies of the entire repo for each module, and if you 
are using linux, terraform should use symlinks.  This method also 
has the advantage that the source to the module you are calling is 
in the same source tree.

For this to work, you need to have a modern-ish version of git that
does submodule processing by default.  If you get errors in the demos
and this folder is empty, then please follow a blog to have git pull
in the submodules of this demonstration repo.

## Where to start

The best place to start digesting the information in the repo is in 
*samples/scenarios/01-coreinfra* tha folder creates a resource group, 
Application Insights and Log Analyics resources.  Those core pieces of
infrastructure are required for almost every module in terraform.

Make sure that /submoudles/terraform-azurerm contains files.  If not,
please make sure that you git pull is processing submodules.