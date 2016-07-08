variable "region" {}

output "primary" {
    value = "${lookup(var.primary_azs, var.region)}"
}
output "secondary" {
    value = "${lookup(var.secondary_azs, var.region)}"
}
output "tertiary" {
    value = "${lookup(var.tertiary_azs, var.region)}"
}
output "list_all" {
    value = "${lookup(var.list_all, var.region)}"
}
output "az_count" {
    value = "${lookup(var.az_counts, var.region)}"
}
output "list_letters" {
    value = "${lookup(var.list_letters, var.region)}"
}
