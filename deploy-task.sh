#!/bin/sh


aws cloudformation create-stack \
  --stack-name ${STACK_NAME} --template-body file://jumpbox-template/template.json \
  --parameters \
  ParameterKey=BoshNetworkCidrBlock,ParameterValue=${BOSH_NETWORK_CIDR_BLOCK} \
  ParameterKey=JumpboxNetworkCidrBlock,ParameterValue=${JUMPBOX_NETWORK_CIDR_BLOCK} \
  ParameterKey=VPCName,ParameterValue=${STACK_NAME} \
  ParameterKey=VPCCidrBlock,ParameterValue=${VPC_CIDR_BLOCK}




  aws cloudformation list-stacks
