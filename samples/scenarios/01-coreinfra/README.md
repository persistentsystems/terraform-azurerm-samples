# CoreInfra 

This project is the "Hello World" of the sample projects.  It shows
the basics of how to create a resource group, App Insights, and Log 
Analytics.

The outputs of this sample will be used in other demos to lay down the core infrastructure that the terrafrom-azurerm modules need as
input variables.

This demo doesn't setup remote state as that would vary to personal
preferences.

Usage is typical 'terraform init' , 'terraform plan' , terraform apply.  

If you get an error about not finding modules in terraform-azurerm
repo, please check directory /submodules/terraform-azurerm.

