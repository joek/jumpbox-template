#!/bin/sh


parameters="ParameterKey=BoshNetworkCidrBlock,ParameterValue=${BOSH_NETWORK_CIDR_BLOCK} ParameterKey=JumpboxNetworkCidrBlock,ParameterValue=${JUMPBOX_NETWORK_CIDR_BLOCK} ParameterKey=VPCName,ParameterValue=${STACK_NAME} ParameterKey=VPCCidrBlock,ParameterValue=${VPC_CIDR_BLOCK} ParameterKey=SSHKeyName,ParameterValue=${SSH_KEY_NAME}"
echo ${parameters}
getStatus() {
  aws cloudformation describe-stacks --stack-name ${STACK_NAME} > /dev/null 2>&1
  if [ $? -ne 0 ]
  then
    echo "NOT_CREATED"
    return 0
  fi
  aws cloudformation describe-stacks --stack-name ${STACK_NAME} | grep StackStatus | sed "s/.*: \"//" | sed "s/\",//" | sed "s/.*_//"
}


echo "Get status"
getStatus
if [ $(getStatus) == "NOT_CREATED" ]
then
  echo "Create Stack"
  aws cloudformation create-stack \
    --stack-name ${STACK_NAME} --template-body file://jumpbox-template/template.json \
    --parameters ${parameters}

else
  echo "Update Stack"
  aws cloudformation update-stack \
    --stack-name ${STACK_NAME} --template-body file://jumpbox-template/template.json \
    --parameters ${parameters}
fi


while ! [[ $(getStatus) = COMPLETE ]]
do
  echo "Wait until processing is finished"
  sleep 10
done

aws cloudformation describe-stacks --stack-name ${STACK_NAME}

status=`aws cloudformation describe-stacks --stack-name ${STACK_NAME} | grep StackStatus | sed "s/.*: \"//" | sed "s/\",//"`

if [ ${status} == "CREATE_COMPLETE" ]
then
  exit 0
fi


if [ ${status} == "UPDATE_COMPLETE" ]
then
  exit 0
fi

exit 1
