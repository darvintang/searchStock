#!/bin/bash
SHELL_FOLDER=$(cd "$(dirname "$0")";pwd)
shellPath=$SHELL_FOLDER/.shell
jqpath=$shellPath/jq

for model in "MQ143CH/A"  "MQ0M3CH/A"  "MQ0W3CH/A"  "MQ1C3CH/A"  "MQ863CH/A"  "MQ853CH/A"  "MQ843CH/A"  "MQ833CH/A"  "MQ2Y3CH/A"  "MQ2K3CH/A"  "MQ2D3CH/A"  "MQ2R3CH/A"  "MQ203CH/A"  "MQ263CH/A"  "MQ1J3CH/A"  "MQ1R3CH/A"  "MQ893CH/A"  "MQ883CH/A"  "MQ873CH/A"  "MQ8A3CH/A"  "MQ8L3CH/A"  "MQ8H3CH/A"  "MQ8M3CH/A"  "MQ8J3CH/A"  "MPXR3CH/A"  "MQ0D3CH/A"  "MPXY3CH/A"  "MQ053CH/A"  "MQ8F3CH/A"  "MQ8D3CH/A"  "MQ8G3CH/A"  "MQ8E3CH/A"
do
	url="https://www.apple.com.cn/shop/fulfillment-messages?pl=true&mts.0=regular&mts.1=compact&parts.0=$model"
	pickup=`echo $(curl -s "$url" | $jqpath '.body.content.pickupMessage.pickupEligibility')`
	echo  `echo $pickup | $jqpath ".\"${model}\".messageTypes.compact.storePickupProductTitle"` $model
done