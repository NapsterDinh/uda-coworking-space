#!/bin/bash
# Automation script for CloudFormation templates. 

TEMPLATE_FILE_NAME=$1
aws cloudformation validate-template --template-body file://$TEMPLATE_FILE_NAME 