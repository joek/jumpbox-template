#!/bin/sh


# aws cloudformation create-stack \
#   --stack-name ${STACK_NAME} --template-body file://jumpbox-template/template.json \
#   --parameters \
#   ParameterKey=BoshNetworkCidrBlock,ParameterValue=${BOSH_NETWORK_CIDR_BLOCK} \
#   ParameterKey=JumpboxNetworkCidrBlock,ParameterValue=${JUMPBOX_NETWORK_CIDR_BLOCK} \
#   ParameterKey=VPCName,ParameterValue=${STACK_NAME} \
#   ParameterKey=VPCCidrBlock,ParameterValue=${VPC_CIDR_BLOCK}

getStatus() {
  aws cloudformation describe-stacks --stack-name ${STACK_NAME} > /dev/null 2>&1
  if [ $? -ne 0 ]
    echo "NOT_CREATED"
    return 0
  fi
  aws cloudformation describe-stacks --stack-name ${STACK_NAME} | grep StackStatus | sed "s/.*: \"//" | sed "s/\",//"
}



echo "Get stack"
aws cloudformation describe-stacks --stack-name ${STACK_NAME}



echo "Get status"
getStatus
