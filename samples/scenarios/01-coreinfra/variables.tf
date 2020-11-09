# This is very similar to the output context, this context is missing
# the final resource group name, and is just used to create
# the ressource group, after that we can use the output of the 
# resource group module.
variable context {
    default = {
        application_name = "myapp"
        environment_name = "dev"
        location         = "East US"
        location_suffix  = "east-us"
    }
}