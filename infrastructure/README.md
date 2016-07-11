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
