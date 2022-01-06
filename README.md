# self-hosted-runner-azure-containers
This repository contains bicep code to create azure container registry (ACR), build and push linux image to it and then create azure container instance (ACI) which will serve as self-hosted github runner.

## Steps to use the code
1. Create resource groups where the ACR and ACI will be hosted
2. Create SPN and give it access to the resource group or subscription to deploy the azure resources. The workflow in this repository uses the OIDC login which is in preview at the time of writing. More details on this [here](https://docs.github.com/en/actions/deployment/security-hardening-your-deployments/configuring-openid-connect-in-azure)
3. Once the ACR is successfully deployed create secret to store `ACR_URL`, `ACR_USERNAME` and `ACR_PASSWORD` All of this can be found from portal
4. Once the image is deployed in ACR you can create ACI. For that two things should be in place:
   - Pass `RUNNER_REPOSITORY_URL` as the repo URL where github runner will be used. You can update the code to use org or enterprise level runner too
   - Create PAT and store it as `GITHUB_TOKEN` in secrets. This is used to connect to repo and deploy agent on it. The permission required for the token is `repo` and `admin:repo_hook`
   - After that run the workflow to deploy ACI and it will be set
5. Your self-hosted github runner is ready to use and it runs in ACI. More details on how to use self-hosted runner [here](https://docs.github.com/en/actions/hosting-your-own-runners/using-self-hosted-runners-in-a-workflow)

#### P.S. A lot of params are hard-coded in the bicep file. Make sure to change the values or pass the values at run time.
