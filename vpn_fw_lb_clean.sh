#!/bin/bash

source /root/keystonerc_admin

# Release the PTG rule-sets
gbp external-policy-update s2svpn_fw_lb-consumer --consumed-policy-rule-sets ''
gbp group-update s2svpn_fw_lb-provider --provided-policy-rule-sets ''

echo "Make sure that policy-targets associated to PTGs are deleted!!"

# Delete PTG/external-policy
gbp external-policy-delete s2svpn_fw_lb-consumer
gbp group-delete s2svpn_fw_lb-provider

# Delete network service policy
gbp network-service-policy-delete s2svpn_fw_lb-nsp

# Delete rule-set
gbp policy-rule-set-delete s2svpn_fw_lb-webredirect-ruleset

# Delete rules
gbp policy-rule-delete s2svpn_fw_lb-web-redirect-rule

# Delete classifier
gbp policy-classifier-delete s2svpn_fw_lb-webredirect

# Delete actions
gbp policy-action-delete redirect-to-s2svpn_fw_lb

# Delete service chain node and specs
gbp servicechain-spec-delete s2svpn_fw_lb-chainspec
gbp servicechain-node-delete SITE2SITEVPNNODE
gbp servicechain-node-delete FWNODE
gbp servicechain-node-delete LBNODE
