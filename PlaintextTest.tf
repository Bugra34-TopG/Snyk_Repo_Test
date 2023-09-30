# Setzen Sie Ihre sensiblen Informationen in Umgebungsvariablen
export API_KEY="your-api-key"
export API_SECRET="your-api-secret"

# Terraform-Konfiguration, die auf diese Umgebungsvariablen zugreift
provider "some_provider" {
  api_key    = "${var.api_key}"
  api_secret = "${var.api_secret}"
}

# Variablen-Datei, um auf die Umgebungsvariablen zuzugreifen
variable "api_key" {
  description = "API Key"
  default     = "${lookup(env, "API_KEY")}"
}

variable "api_secret" {
  description = "API Secret"
  default     = "${lookup(env, "API_SECRET")}"
}

