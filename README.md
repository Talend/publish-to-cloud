# GitHub Action to publish data integration jobs and data services to Talend Cloud

With the Talend Publish to Cloud Action for GitHub, you can automate your workflow to deploy [Talend jobs](https://www.talend.com/products/data-integration/) and [microservices](https://www.talend.com/solutions/information-technology/service-oriented-architecture/) to Talend Cloud using GitHub Actions.

[Try Talend Cloud free for 14 days!](https://iam.us.cloud.talend.com/idp/trial-registration?type=productspage)

The definition of this Github Action is in [action.yml](https://github.com/Talend/publish-to-cloud/blob/master/action.yml).
  
### Sample workflow to build and publish a project to Talend Cloud

```yaml

# File: .github/workflows/workflow.yml

on: push

jobs:
  build-and-publish-to-cloud:
    runs-on: ubuntu-latest
    steps:
    # checkout the repo
    - name: 'Checkout Github Action'
      uses: actions/checkout@master
    
    - name: Publish to Talend Cloud
      uses: Talend/publish-to-cloud@master
      with:
        args: -e -am
        project: <YOUR_PROJECT_NAME>
        updatesite_path: <YOUR_UPDATESITE_URL>
        service_url: https://tmc.<REGION>.cloud.talend.com/inventory/
        cloud_token: ${{ secrets.cloud_token }}
        nexus_url: <YOUR_NEXUS_URL>
        nexus_username: ${{ secrets.nexus_username }}
        nexus_password: ${{ secrets.nexus_password }}
        license_path: license.gpg
        license_passphrase: ${{ secrets.LARGE_SECRET_PASSPHRASE }}
        
```

#### Configure deployment credentials:

For any credentials like Talend Personal Access Token, Nexus username and passwords etc add them as [secrets](https://help.github.com/en/actions/automating-your-workflow-with-github-actions/creating-and-using-encrypted-secrets#creating-encrypted-secrets) in the GitHub repository and then use them in the workflow.

For the storing the Talend license we highly recommand to follow [Github Actions best practises to store large secrets](https://help.github.com/en/actions/automating-your-workflow-with-github-actions/creating-and-using-encrypted-secrets#limits-for-secrets).

*Example*:

1. Run the following command from your terminal to encrypt the my_secret.json file using gpg and the AES256 cipher algorithm.
```
gpg --symmetric --cipher-algo AES256 license
```

2. You will be prompted to enter a passphrase. Remember the passphrase, because you'll need to create a new secret on GitHub that uses the passphrase as the value.

3. Create a new secret in your repository to store the passphrase. For example, create a new secret with the name `LARGE_SECRET_PASSPHRASE` and set the value of the secret to the passphrase you selected in the step above.

4. Copy your encrypted file into your repository and commit it. In this example, the encrypted file is my_secret.json.gpg.