Intro
-----

This is the infrastructure description for this lab. It consists of
re-usable building blocks (in `modules`) and an environment
description invoking those blocks (in `main.tf`). The language this is
described in is terraform (https://terraform.io).


Terraform basics
----------------
To get running with terraform follow this guide:
https://www.terraform.io/intro/getting-started/install.html

We'll provide you with AWS keys that you plug in to `main.tf` and you
should be good to go.

Terraform basicly manages resources. Resources can be bundled into
modules (as they are in `./modules`). Resources and modules both have
inputs and outputs. Inputs can be regions, zones, sizes, placment,
networking any and all configuration. Outputs can be IDs of the
generated components, sizes or other relevant data.

Resource inputs can be strings, lists of strings or in some cases
complex objects. Modules inputs can only be strings. All outputs is
can only be strings. This can be a little limiting, but terraform has
nice interpolation syntax to work around it
(https://www.terraform.io/docs/configuration/interpolation.html).


Working with Terraform
----------------------
On the first run of terraform (or when you add new modules) do :

    terraform get

This will cache the modules you need for terraform to find.

Now you iterate on your infrastructure (`main.tf`). When you think
it's ready do:

    terraform plan

This will give you a preview of the resources that is to be created, updated or
deleted. It will also tell you about any syntax errors you may have
and if all inputs are satisfied.

Once you are feel confident that your changes are good to go do:

    terraform apply

This will put your changes into effect. It will also create
`terraform.tfstate` and `terraform.tfstate.backup` files - ignore
those, but don't delete them. You should now be able to see your
infrastructure in the AWS console (make sure to choose the right region).
