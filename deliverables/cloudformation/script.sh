#!/bin/bash
# Automation script for CloudFormation templates. 
#
# Parameters
#   $1: Execution mode. Valid values: create, update, deploy, delete, preview.
#   $2: Target region.
#   $3: Name of the cloudformation stack.
#   $4: Name of the template file.
#   $5: Name of the parameters file.
#
# Usage examples:
#   ./run.sh create us-east-1 udacity-scripts-exercise network.yml network-parameters.json
#   ./run.sh update us-east-1 udacity-scripts-exercise network.yml network-parameters.json
#   ./run.sh deploy us-east-1 udacity-scripts-exercise network.yml network-parameters.json
#   ./run.sh preview us-east-1 udacity-scripts-exercise network.yml network-parameters.json
#   ./run.sh delete us-east-1 udacity-scripts-exercise
#

# Validate parameters
if [[ $1 != "create" && $1 != "update" && $1 != "deploy" && $1 != "delete" && $1 != "preview" && $1 != 'validate' ]]; then
    echo "ERROR: Incorrect execution mode. Valid values: validate, create, update, deploy, delete, preview." >&2
    exit 1
fi

EXECUTION_MODE=$1
REGION=$2
STACK_NAME=$3
TEMPLATE_FILE_NAME=$4
PARAMETERS_FILE_NAME=$5

# Execute CloudFormation CLI
if [ $EXECUTION_MODE == "create" ]
then
    aws cloudformation create-stack --stack-name $STACK_NAME \
        --template-body file://$TEMPLATE_FILE_NAME \
        --parameters file://$PARAMETERS_FILE_NAME \
        --capabilities "CAPABILITY_NAMED_IAM"  \
        --region=$REGION
fi
if [ $EXECUTION_MODE == "update" ]
then
    aws cloudformation update-stack --stack-name $STACK_NAME \
        --template-body $TEMPLATE_FILE_NAME \
        --parameters file://$PARAMETERS_FILE_NAME \
        --capabilities "CAPABILITY_NAMED_IAM"  \
        --region=$REGION
fi
if [ $EXECUTION_MODE == "deploy" ]
then
    aws cloudformation deploy \
        --stack-name $STACK_NAME \
        --template-file $TEMPLATE_FILE_NAME \
        --parameter-overrides file://$PARAMETERS_FILE_NAME \
        --capabilities "CAPABILITY_NAMED_IAM" \
        --region=$REGION
fi
if [ $EXECUTION_MODE == "delete" ]
then
    aws cloudformation delete-stack \
        --stack-name $STACK_NAME \
        --region=$REGION
fi
if [ $EXECUTION_MODE == "preview" ]
then
    aws cloudformation deploy \
        --stack-name $STACK_NAME \
        --template-file $TEMPLATE_FILE_NAME \
        --parameter-overrides file://$PARAMETERS_FILE_NAME \
        --capabilities "CAPABILITY_NAMED_IAM"  \
        --no-execute-changeset \
        --region=$REGION 
fi
if [ $EXECUTION_MODE == "validate" ]
then
    aws cloudformation validate-template \
        --template-body file://$TEMPLATE_FILE_NAME 
fi
