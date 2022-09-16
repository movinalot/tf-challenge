# Terraform Challenge

## Terraform Challenge Steps

1. Login to [Azure Portal](https://portal.azure.com)
1. Connect to Azure Cloudshell
1. Clone Github Repository
  `git clone https://github.com/movinalot/tf-challenge`
1. Switch to `tf-challenge` directory
  `cd tf-challenge`
1. Run the Terraform commands

    ```sh
    terraform init
    terraform validate
    terraform plan
    terraform apply

    terraform output credentials
    ```

1. Login to the FortiGate
1. Destroy the environment

    ```sh
    terraform destroy
    ```
