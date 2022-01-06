# self-hosted-runner-azure-containers
This repository contains bicep code to create azure container registry (ACR), build and push linux image to it and then create azure container instance (ACI) which will serve as self-hosted github runner.

##Steps to use the code
1. Create resource groups where the ACR and ACI will be hosted
2. Create SPN and give it access to the resource group or subscription to deploy
