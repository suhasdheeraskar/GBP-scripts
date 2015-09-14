#!/bin/bash

source /root/keystonerc_admin

# Service chain node and spec creation
gbp servicechain-node-create --service-profile oneconvergence_fw --template-file ./templates/fw_template.yml FWNODE
gbp servicechain-node-create --service-profile oneconvergence_lb --template-file ./templates/haproxy.template LBNODE
gbp servicechain-spec-create --nodes "FWNODE LBNODE" fw_lb_chainspec

# REDIRECT action, classifier, rule and rule-set
gbp policy-action-create --action-type REDIRECT --action-value fw_lb_chainspec redirect-to-fw_lb
gbp policy-classifier-create --protocol tcp --direction bi fw_lb-webredirect
gbp policy-rule-create --classifier fw_lb-webredirect --actions redirect-to-fw_lb fw_lb-web-redirect-rule
gbp policy-rule-set-create --policy-rules "fw_lb-web-redirect-rule" fw_lb-webredirect-ruleset

# Network service policy
gbp network-service-policy-create --network-service-params type=ip_single,name=vip_ip,value=self_subnet fw_lb_nsp

# Provider PTG
gbp group-create fw_lb-provider --provided-policy-rule-sets "fw_lb-webredirect-ruleset=None" --network-service-policy fw_lb_nsp

#   For N-S create external-policy, for E-W create policy-target-group(consumer-group)
#gbp external-policy-create --external-segments default --consumed-policy-rule-sets webredirect-ruleset=None web-consumer-external-policy
#	(or for E-W)                                           
gbp group-create fw_lb-consumer --consumed-policy-rule-sets "fw_lb-webredirect-ruleset=None"

