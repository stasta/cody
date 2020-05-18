Remote state
___

The backend configuration is loaded by Terraform extremely early, before
the core of Terraform can be initialized. This is necessary because the backend
dictates the behavior of that core. The core is what handles interpolation
processing. Because of this, interpolations cannot be used in backend
configuration.

Due to that, one should create the remote-state module first before uncommenting 
the remote state configuration in the main file.