#!/bin/bash

terraform apply -input=false -var-file=../environments/$1.tfvars