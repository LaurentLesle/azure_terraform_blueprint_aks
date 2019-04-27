output "names" {
    depends_on  = ["azurerm_resource_group.rg.*"]
    
    value = "${
      "${zipmap(local.rg_list,azurerm_resource_group.rg.*.name)}"
    }"
}

output "ids" {
    depends_on  = ["azurerm_resource_group.rg.*"]
    
    value = "${
      "${zipmap(local.rg_list,azurerm_resource_group.rg.*.id)}"
    }"
}
