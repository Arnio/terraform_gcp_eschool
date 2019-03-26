output "public_ip_db" {
   value = ["${google_sql_database_instance.instance.*.ip_address}"]
}