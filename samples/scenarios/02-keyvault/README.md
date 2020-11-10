# Building on coreinfra

The purpose of this demo is to show how you can build on the outputs of the coreinfra (namely the context)
created there and use that on modules that require a
context variable input.

Some of the core outputs (context, observability_setttings) are expected as inputs to other modules so that we can create and properly setup logging in the modules.

In our opinionated view, anything we create should have
observabiltiy built into it.  So the observability_settings are passsed into the KeyVault module and KeyVault will log to the workspace they provide.

To keep things simple we do not attempt a shared state
to pull in the assets created in 01-coreinfra.  So to 
run this demo you need to destroy any 01-coreinfra that have been deployed as they will have naming conflicts.