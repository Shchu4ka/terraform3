
resource "local_file" "hosts_for" {
  content =  <<-EOT
  
  %{if length(yandex_compute_instance.web) > 0}
  
  [web]
  %{endif}
  %{for i in yandex_compute_instance.web }
  ${i["name"]}   ansible_host=${i["network_interface"][0]["nat_ip_address"]} fqdn=${i["fqdn"]}
  %{endfor}
  
  %{if length(yandex_compute_instance.db) > 0}
  
  [db]
  %{endif}
  %{for i in yandex_compute_instance.db }
  ${i["name"]}   ansible_host=${i["network_interface"][0]["nat_ip_address"]} fqdn=${i["fqdn"]}
  %{endfor}
  
  [disk]
  ${local.storage_name}   ansible_host=${local.storage_ip} fqdn=${local.storage_fqdn}
  EOT
  filename = "${abspath(path.module)}/host.cfg"

}
