# Configure the Vault provider
provider "vault" {
  address = "http://127.0.0.1:8200"
}


# Create a new Vault namespace
resource "vault_namespace" "example" {
  path = "team-namespace"
}

resource "vault_policy" "admins" {
  name = "admins"
  namespace = vault_namespace.example.path_fq
  policy = file("admins.hcl")
}


resource "vault_auth_backend" "userpass" {
  type = "userpass"
  namespace = vault_namespace.example.path_fq
}

resource "vault_generic_endpoint" "userpass_user" {
  depends_on           = [vault_auth_backend.userpass]
  path = "${vault_namespace.example.path_fq}/auth/userpass/users/admin"
  ignore_absent_fields = true

  data_json = <<EOT
{
  "policies": ["admins"],
  "password": "passworld123"
}
EOT
}

# Upload the Sentinel policy to Vault
resource "vault_egp_policy" "block-userpass" {
  namespace = vault_namespace.example.path_fq
  name              = "block-userpass"
  paths             = ["sys/auth/*"]
  enforcement_level = "soft-mandatory"
  policy = file("deny-userauth-path.sentinel")
}
