#!/bin/bash

source /root/keystonerc_admin

# Release the PTG rule-sets
gbp external-policy-update fw_vpn-consumer --consumed-policy-rule-sets ''
gbp group-update fw_vpn-provider --provided-policy-rule-sets ''

echo "Make sure that policy-targets associated to PTGs are deleted!!"

# Delete PTG/external-policy
gbp external-policy-delete fw_vpn-consumer
gbp group-delete fw_vpn-provider

# Delete network service policy
gbp network-service-policy-delete fw_vpn_nsp

# Delete rule-set
gbp policy-rule-set-delete fw_vpn-webredirect-ruleset

# Delete rules
gbp policy-rule-delete fw_vpn-web-redirect-rule

# Delete classifier
gbp policy-classifier-delete fw_vpn-webredirect

# Delete actions
gbp policy-action-delete redirect-to-fw_vpn

# Delete service chain node and specs
gbp servicechain-spec-delete fw_vpn_chainspec
gbp servicechain-node-delete SITE2SITEVPNNODE
gbp servicechain-node-delete FWNODE
