#!/bin/bash

terraform plan -input=false -var-file=../environments/$1.tfvars