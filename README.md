$$$$$$$$\                  $$\     $$\                 $$\ $$\                      $$$$$$\                                          $$\                               
$$  _____|                 $$ |    $$ |                $$ |$$ |                    $$  __$$\                                         \__|                              
$$ |    $$$$$$\   $$$$$$\$$$$$$\   $$$$$$$\   $$$$$$\  $$ |$$ |                    $$ /  $$ | $$$$$$\   $$$$$$\   $$$$$$\  $$$$$$$\  $$\  $$$$$$$\  $$$$$$\   $$$$$$\  
$$$$$\ $$  __$$\ $$  __$$\_$$  _|  $$  __$$\  \____$$\ $$ |$$ |      $$$$$$\       $$ |  $$ |$$  __$$\ $$  __$$\  \____$$\ $$  __$$\ $$ |$$  _____|$$  __$$\ $$  __$$\ 
$$  __|$$ /  $$ |$$ /  $$ |$$ |    $$ |  $$ | $$$$$$$ |$$ |$$ |      \______|      $$ |  $$ |$$ |  \__|$$ /  $$ | $$$$$$$ |$$ |  $$ |$$ |\$$$$$$\  $$$$$$$$ |$$ |  \__|
$$ |   $$ |  $$ |$$ |  $$ |$$ |$$\ $$ |  $$ |$$  __$$ |$$ |$$ |                    $$ |  $$ |$$ |      $$ |  $$ |$$  __$$ |$$ |  $$ |$$ | \____$$\ $$   ____|$$ |      
$$ |   \$$$$$$  |\$$$$$$  |\$$$$  |$$$$$$$  |\$$$$$$$ |$$ |$$ |                     $$$$$$  |$$ |      \$$$$$$$ |\$$$$$$$ |$$ |  $$ |$$ |$$$$$$$  |\$$$$$$$\ $$ |      
\__|    \______/  \______/  \____/ \_______/  \_______|\__|\__|                     \______/ \__|       \____$$ | \_______|\__|  \__|\__|\_______/  \_______|\__|      
                                                                                                       $$\   $$ |                                                      
                                                                                                       \$$$$$$  |                                                      
                                                                                                        \______/                                                       

A project to automate organising local football games

Utilises:
- Terraform
- AWS
- Python

# Clone

This repo utilises git modules therefore has a slightly different clone command than the normal one.

If this is a first time clone, use the following command:
- `git clone git@github.com:Ishaaq-dev/Football-Organiser.git --recursive`

if you cloned the repo before the introduction of sub-modules in this project, then run the following command:
- `git submodule update --init`

# Prerequisites

The following have been installed and setup:
- Terraform
- AWS CLI v2
- Pyhton3
- AWS IAM login for the Football-Organiser AWS Account
- Programmatic access to AWS
- Git Cli (windows)
- Visual Studio Code (or IDE of your preference)

Optional and recommended but not necessary:
- `ssh` for GitHub
- `gpg` for GitHub
- Package manager installed:
  - `brew` for mac
  - `chocolatey` / `choco` for windows

If you are unsure whether you have the correct setup/environment, please contact a member of the team for assistance

# How to run

There are four steps to creating your own stack:

1. Create copies of the `.tfvars` files
2. Setup the terraform backend
3. Add personal prefix
4. Run script for terraform `init | plan | apply | destroy`

## Step 0

Open the project with `visual studio code`

## Step 1 - Create copies of the `.tfvars` files

- Open `deployment/vars/` in the file explorer
- There will be two files:
  - `pers.tfvars.example`
  - `providers.tfvars.example`
  - **Do not delete, rename or edit these files**
- Copy and paste these files into the same location
- Rename the copies to:
  - `pers.tfvars`
  - `providers.tfvars`

If you have done this step correctly, you should have four files in `deployment/vars`:
- `pers.tfvars.example`
- `providers.tfvars.example`
- `pers.tfvars`
- `providers.tfvars`

## Step 2 - Setup the terraform backend

Open the `deployment/vars/providers.tfvars` file, there will be one variable:
- `key = "<your name>/terraform.tfstate"`

replace `<your name>` with your name, or a unique identifier

Make sure the value you choose is unique to you and that **no one** in the team is using the same value

If you have done this step correctly, the `providers.tfvars` file should look something like the following:
- `key = "ishaaq/terraform.tfstate"`


## Step 3 - Add personal prefix

Open the `deployment/vars/pers.tfvars` file, there will be two variables:
- `prefix = "<your name>"`
- `project = "football-organiser"`

replace `<your name>` with your name, or any unique identifier.

Make sure the value you choose is unique to you and that **no one** in the team is using the same value

If you have done this setep correctly, the `pers.tfvars` file should look something like the following:
- `prefix = "ishaaq"`
- `project = "football-organiser"`

Before advancing to the next step, check the following:
- `deployment/vars/` has four files
  - `pers.tfvars.example`
  - `providers.tfvars.example`
  - `pers.tfvars`
  - `providers.tfvars`
- The `.tfvars.example` files should **NOT** have been edited
- The `.tfvars` files should contain values that can be used to identify you

Run `git status`
There should be no changes noticed by git 

If this is **NOT** the case, please speak to a member of the team for assistance before advancing the setup.

## Step 4 - Run script for terraform `init | plan | apply | destroy`

`cd` into `deployment/`

The following commands are avaible for you to run into terminal:
- `./scripts/terraform.sh init`
  - Initialises terraform and the backend
- `./scripts/terraform.sh plan`
  - Outputs the changes terraform will make to the infrastructure
- `./scripts/terraform.sh apply`
  - Outputs and **makes** the changes to the infrastructure
- `./scripts/terraform.sh destroy`
  - Destroys in the infrastructure created by terraform

**SETUP COMPLETE**

Login to the AWS Console

Make sure your region is `eu-west-1` / `ireland`

You will have created lambdas and a dynamoDB instance.

They will be viewable in the AWS Console.

# ------------------------------------------------------
# Project Practice & Learning

Bilal: "Hey guys just doing a test"

Yushua: "Glad to say your test worked Bilal"

Ibraheem: "We got it working"

Is'haaq: "AYYYYYYYYYYY"

Yaaseen: "Aur boys"
