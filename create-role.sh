#!/bin/bash

# Script to create a role with full access 


# Prompt for role name
ROLE_NAME="CrossAccountAdmin"

# Get the current account ID
CURRENT_ACCOUNT_ID=$(aws sts get-caller-identity --query Account --output text)

# Prompt for the account ID that will assume this role
ASSUMING_ACCOUNT_ID="150301572911"

# Confirm before proceeding
echo "This script will create a role named $ROLE_NAME in account $CURRENT_ACCOUNT_ID"
echo "The role will have full access to EC2, S3, and DynamoDB"
echo "It can be assumed by the root of account $ASSUMING_ACCOUNT_ID"
read -p "Do you want to proceed? (y/n) " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]
then
    echo "Operation cancelled."
    exit 1
fi

# Create the role
aws iam create-role --role-name $ROLE_NAME --assume-role-policy-document '{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "AWS": "arn:aws:iam::'"$ASSUMING_ACCOUNT_ID"':user/robert"
      },
      "Action": "sts:AssumeRole",
      "Condition": {}
    }
  ]
}'

# Attach policies for full access to EC2, S3, and DynamoDB
aws iam attach-role-policy --role-name $ROLE_NAME --policy-arn arn:aws:iam::aws:policy/AdministratorAccess

echo "Role $ROLE_NAME created successfully."
echo "You can now assume this role using the following command:"
echo "aws sts assume-role --role-arn arn:aws:iam::$CURRENT_ACCOUNT_ID:role/$ROLE_NAME --role-session-name cross-account-admin"
