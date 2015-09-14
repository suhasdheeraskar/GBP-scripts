#!/bin/bash

source /root/keystonerc_admin

#Service chain node and spec creation                                                                                 
gbp servicechain-node-create --service-profile oneconvergence_vpn --template-file ./templates/vpn.template SITE2SITEVPNNODE
gbp servicechain-node-create --service-profile oneconvergence_fw --template-file ./templates/fw_template.yml FWNODE
gbp servicechain-node-create --service-profile oneconvergence_lb --template-file ./templates/haproxy.template LBNODE
gbp servicechain-spec-create --nodes "SITE2SITEVPNNODE FWNODE LBNODE" s2svpn_fw_lb-chainspec

#Redirect actions, classifier, PR and PRS creation
gbp policy-action-create --action-type REDIRECT --action-value s2svpn_fw_lb-chainspec redirect-to-s2svpn_fw_lb
gbp policy-classifier-create --protocol tcp --direction bi s2svpn_fw_lb-webredirect
gbp policy-rule-create --classifier s2svpn_fw_lb-webredirect --actions redirect-to-s2svpn_fw_lb s2svpn_fw_lb-web-redirect-rule
gbp policy-rule-set-create --policy-rules s2svpn_fw_lb-web-redirect-rule s2svpn_fw_lb-webredirect-ruleset

#network service policy creation                                
gbp network-service-policy-create --network-service-params type=ip_single,name=vip_ip,value=self_subnet s2svpn_fw_lb-nsp

#Provider group creation
gbp group-create s2svpn_fw_lb-provider --provided-policy-rule-sets 's2svpn_fw_lb-webredirect-ruleset=None' --network-service-policy s2svpn_fw_lb-nsp
 
#For N-S create external-policy, for E-W create policy-target-group(consumer-group)
gbp external-policy-create --external-segments default --consumed-policy-rule-sets 's2svpn_fw_lb-webredirect-ruleset=None' s2svpn_fw_lb-consumer                                                                                 
#(or for E-W)
#gbp group-create s2svpn_fw_lb-consumer --consumed-policy-rule-sets "s2svpn_fw_lb-webredirect-ruleset=None"
