This example terraform creates a namespace, policy, userpass auth method, and a sentinel policy that stops the creation of new userpass auth methods.
Apply it to a dev enterprise vault cluster using the below commands.

First terminal window to run dev vault enterprise.
```
export VAULT_LICENSE=$(cat $HOME/Downloads/vault.hclic)
./vault-enterprise server -dev -dev-root-token-id root
```

Second terminal window in the root of this git repository.
```
export VAULT_ADDR="http://127.0.0.1:8200"
export VAULT_TOKEN=root
terraform init
terraform apply -auto-approve
```

Third terminal window to authenticate as an admin user.
```
export VAULT_ADDR="http://127.0.0.1:8200"
export VAULT_NAMESPACE="team-namespace"
vault login -method=userpass username=admin password=passworld123
vault auth enable -path=test_pass userpass #should return an error
vault auth enable ldap
```
