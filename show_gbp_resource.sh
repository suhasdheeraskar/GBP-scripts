#!/bin/bash

source /root/keystonerc_admin

echo "Policy-target-list"
gbp policy-target-list

echo "group-list"
gbp group-list

echo "external-policy-list"
gbp external-policy-list

echo "network-service-policy-list"
gbp network-service-policy-list

echo "policy-rule-set-list"
gbp policy-rule-set-list

echo "policy-rule-list"
gbp policy-rule-list

echo "servicechain-spec-list"
gbp servicechain-spec-list

echo "servicechain-node-list"
gbp servicechain-node-list

echo "policy-action-list"
gbp policy-action-list

echo "policy-classifier-list"
gbp policy-classifier-list
~                             
