## from https://github.com/terraform-community-modules/tf_aws_availability_zones

# tf_aws_availability_zones

Terraform module to get the AZs you have access to.

Needs the aws cli installed to shell out to.

Also needs you to run 'make' in the directory after _terraform get_ to build the lists.

*NOTE*: This module should be considered highly experimental, with the interface likely to change at any time!

## Outputs:

  * primary - The primary AZ (always defined)
  * secondary - The secondary AZ (always defined)
  * tertiary - The third AZ (may not be defined!)
  * list_all - A comma seperated list of all AZs
  * list_letters - A comma seperated list of the trailing letter of the AZ
  * az_count - The number of AZs in this account/region

## Example:

In your terraform code, add something like this:

    module "az" {
      source = "github.com/terraform-community-module/tf_aws_availability_zones"
      region = "eu-central-1"
    }

    resource "aws_subnet" "primary-front" {
      availability_zone = "${module.az.primary}"
    }

# LICENSE

Apache2 - See the included LICENSE file for more details.
