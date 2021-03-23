# packer-vultr-condor
Pre-provisioned image for use with the [Condor](https://registry.terraform.io/modules/vultr/condor/vultr/latest) Terraform Module. Using a pre-provisioned image provides additional stability when you may wish to test OS level changes prior to cluster updates. Note: This will result in a slightly longer deployment time due to needing to transfer and restore the snapshot.

## Usage
1. Clone this repository
2. Configure your Vultr API Key

``` sh
$ export VULTR_API_KEY="<api-key-here>"
```
3. Change any other default variable values by your [preferred method](https://www.packer.io/guides/hcl/variables#assigning-variables), if necessary.
4. Build the snapshot
```sh
$ make build
```
5. Provide the snapshot description for the resulting image to the [custom_snapshot_description](https://registry.terraform.io/modules/vultr/condor/vultr/latest?tab=inputs) input in the [Condor](https://registry.terraform.io/modules/vultr/condor/vultr/latest) terraform module, and deploy.
```sh
$ terraform apply
```
