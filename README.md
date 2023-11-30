# azure-hub-and-spoke
# SUCCESSFUL AND ORDER OF DEPLOYMENTS
1. Key vaault = PUSHED TO REPO
2. spoke vnet = PUSHED TO REPO
3. shared services = PUSHED TO REPO
4. peering = PUSHED TO REPO
5. route table = PUSHED TO REPO
6. spoke linux test vm = PUSHED TO REPO
7. sharedservices linux test vm = PUSHED TO REPO
8. spoke windows vm = PUSHED TO REPO
9. lb and vm backend = PUSHED TO REPO
10. NSG = PUSHED TO REPO
11. Firewall policy 
12. DNS 
*** www.oie-example.com (dns root), subdomain sbweb.oie-example.com
13. P2S VPN 


# VALIDATION:
1. vnet peering connectivity = SUCCESSFUL
2. Loadbalancer dns validation 



# RESOURCE NAME AFTER TERRAFORM DEPLYMENT OUTPUTS
1. key vault name = oie-sandbox-key-vault 

# TERRAFORM CLI COMMANDS

terraform fmt && terraform init && terraform validate && terraform workspace list
terraform workspace new oie && terraform plan 
terraform workspace select oie && terraform plan 
terraform plan 
terraform apply -auto-approve
terraform destroy -auto-approve

The available commands for execution are listed below.
The primary workflow commands are given first, followed by
less common or more advanced commands.

Main commands:
  init          Prepare your working directory for other commands
  validate      Check whether the configuration is valid
  plan          Show changes required by the current configuration
  apply         Create or update infrastructure
  destroy       Destroy previously-created infrastructure

All other commands:
  console       Try Terraform expressions at an interactive command prompt
  fmt           Reformat your configuration in the standard style
  force-unlock  Release a stuck lock on the current workspace
  get           Install or upgrade remote Terraform modules
  graph         Generate a Graphviz graph of the steps in an operation
  import        Associate existing infrastructure with a Terraform resource
  login         Obtain and save credentials for a remote host
  logout        Remove locally-stored credentials for a remote host
  output        Show output values from your root module
  providers     Show the providers required for this configuration
  refresh       Update the state to match remote systems
  show          Show the current state or a saved plan
  state         Advanced state management
  taint         Mark a resource instance as not fully functional
  test          Experimental support for module integration testing
  untaint       Remove the 'tainted' state from a resource instance
  version       Show the current Terraform version
  workspace     Workspace management
