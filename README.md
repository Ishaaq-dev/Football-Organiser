# Football-Organiser

A project to help organise local football game
Utilises:
Terraform
AWS
JavaScript

# Info

To create your own stack, you need to:

- Login to AWS Console
- Go to S3
- Click on the personal remote state bucket
- Create your own folder inside the personal bucket
  - You can either name the folder your name or something that represents the ticket your working on

Once the folder/directory has been created in s3, remember what you called it, you will be needing it in following steps.

- Open the project with `visual studio code`
- Open `deployment/football-organiser/providers.tf` file
- Modify the `key` attribute under the `backend s3` block
  - Uncomment the line (remove the hashtag, `ctrl /`)
  - Replace the value `<directory name>` with the name of the directory/folder you created earlier in AWS s3, for example:
    - from `key = <directory name>/terraform.tfstate`
    - to `key = ishaaq/terraform.tfstate`

** make sure you create the folder in aws s3 before you edit the file in vs code or try running any terraform commands **

Once you have successfully completed the steps above, you will be able to run `terraform` commands to create your own personal stack while keeping your `tfstate` online separate from everyone else

To create your own stack of the project:

- cd into `deployment/football-organiser`
- run `terraform plan`
- run `terraform apply`


# ------------------------------------------------------
# Project Practice & Learning

Bilal: "Hey guys just doing a test"

Yushua: "Glad to say your test worked Bilal"

Ibraheem: "We got it working"

Is'haaq: "AYYYYYYYYYYY"


