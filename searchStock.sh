#!/bin/bash
SHELL_FOLDER=$(cd "$(dirname "$0")";pwd)
shellPath=$SHELL_FOLDER/.shell
tempPath=$SHELL_FOLDER/.temp
infoPath=$SHELL_FOLDER/.info
stockPath=$tempPath/stock
jqpath=$shellPath/jq

echo '欢迎使用MacBookPro库存查询脚本'
echo 'Author: Darvin'
echo 'Create: 2021-11-14'
echo 'Update: 2022-09-16'

nameDict=([0]='0')
modelDict=([0]='0')

function chooseDevice(){
	read -p '请输入需要查询的设备类型(iPhone，MacBookPro)：' device
	index=1
#	
	if [[ "$device" == "MacBookPro" ]]; then
		nameDict=([1411]='14寸灰色8核+14核+16G+512G' [1412]='14寸银色8核+14核+16G+512G' [1421]='14寸灰色10核+16核+16G+1T' [1422]='14寸银色10核+16核+16G+1T' [1611]='16寸灰色10核+16核+16G+512G' [1612]='16寸银色10核+16核+16G+512G' [1621]='16寸灰色10核+16核+16G+1T' [1622]='16寸银色10核+16核+16G+1T' [1631]='16寸灰色10核+32核+32G+1T' [1632]='16寸银色10核+32核+32G+1T')
		modelDict=([1411]='MKGP3CH/A' [1412]='MKGR3CH/A' [1421]='MKGQ3CH/A' [1422]='MKGT3CH/A' [1611]='MK183CH/A' [1612]='MK1E3CH/A' [1621]='MK193CH/A' [1622]='MK1F3CH/A' [1631]='MK1A3CH/A' [1632]='MK1H3CH/A')
	elif [[ "$device" == "iPhone" ]]; then
		nameDict=([14112]='iPhone 14 Pro 256GB 金色' [14122]='iPhone 14 Pro 256GB 深空黑色' [14142]='iPhone 14 Pro 256GB 银色' [14132]='iPhone 14 Pro 256GB 暗紫色' [14231]='iPhone 14 Pro Max 128GB 暗紫色' [14211]='iPhone 14 Pro Max 128GB 金色' [14241]='iPhone 14 Pro Max 128GB 银色' [14221]='iPhone 14 Pro Max 128GB 深空黑色' [14134]='iPhone 14 Pro 1TB 暗紫色' [14144]='iPhone 14 Pro 1TB 银色' [14124]='iPhone 14 Pro 1TB 深空黑色' [14114]='iPhone 14 Pro 1TB 金色' [14113]='iPhone 14 Pro 512GB 金色' [14133]='iPhone 14 Pro 512GB 暗紫色' [14123]='iPhone 14 Pro 512GB 深空黑色' [14143]='iPhone 14 Pro 512GB 银色' [14212]='iPhone 14 Pro Max 256GB 金色' [14242]='iPhone 14 Pro Max 256GB 银色' [14222]='iPhone 14 Pro Max 256GB 深空黑色' [14232]='iPhone 14 Pro Max 256GB 暗紫色' [14214]='iPhone 14 Pro Max 1TB 金色' [14224]='iPhone 14 Pro Max 1TB 深空黑色' [14234]='iPhone 14 Pro Max 1TB 暗紫色' [14244]='iPhone 14 Pro Max 1TB 银色' [14121]='iPhone 14 Pro 128GB 深空黑色' [14131]='iPhone 14 Pro 128GB 暗紫色' [14141]='iPhone 14 Pro 128GB 银色' [14111]='iPhone 14 Pro 128GB 金色' [14213]='iPhone 14 Pro Max 512GB 金色' [14223]='iPhone 14 Pro Max 512GB 深空黑色' [14233]='iPhone 14 Pro Max 512GB 暗紫色' [14243]='iPhone 14 Pro Max 512GB 银色')
		modelDict=([14112]='MQ143CH/A' [14122]='MQ0M3CH/A' [14142]='MQ0W3CH/A' [14132]='MQ1C3CH/A' [14231]='MQ863CH/A' [14211]='MQ853CH/A' [14241]='MQ843CH/A' [14221]='MQ833CH/A' [14134]='MQ2Y3CH/A' [14144]='MQ2K3CH/A' [14124]='MQ2D3CH/A' [14114]='MQ2R3CH/A' [14113]='MQ203CH/A' [14133]='MQ263CH/A' [14123]='MQ1J3CH/A' [14143]='MQ1R3CH/A' [14212]='MQ893CH/A' [14242]='MQ883CH/A' [14222]='MQ873CH/A' [14232]='MQ8A3CH/A' [14214]='MQ8L3CH/A' [14224]='MQ8H3CH/A' [14234]='MQ8M3CH/A' [14244]='MQ8J3CH/A' [14121]='MPXR3CH/A' [14131]='MQ0D3CH/A' [14141]='MPXY3CH/A' [14111]='MQ053CH/A' [14213]='MQ8F3CH/A' [14223]='MQ8D3CH/A' [14233]='MQ8G3CH/A' [14243]='MQ8E3CH/A')
	else 
		index=0
	fi
	
	if [ $index -eq 0 ]; then
		chooseDevice
	fi
}


if [ ! -d $infoPath  ];then
	mkdir $infoPath
fi

chooseDevice

echo '请选择需要查询的设备型号: '
for key in ${!modelDict[*]};do
	model=${modelDict[$key]}
	modelInfoPath=$infoPath/$(echo ${model/\//_}).txt
	modelInfo=${nameDict[$key]}
	touch $modelInfoPath
	echo $modelInfo>$modelInfoPath
	echo "编号: $key 配置: ${nameDict[$key]}"
done

deviceModels=()
parts=''

function inputModels(){
	read -p '请输入需要查询的配置编号, 多个配置编号用空格隔开: ' searchList
	index=0
	
	for value in $(echo $searchList);do
		model=${modelDict[$value]}
		if [[ "$model" != "" ]];then
			deviceModels[$index]=$(echo ${model/\//_})
			parts="$parts&parts.$index=$model"
			let index+=1
		fi
	done
	
	if [ $index -eq 0 ];then
		inputModels
	fi
}

inputModels

read -p '请输入地址: (默认:广东+深圳+南山区); (查询库存会根据地址查询附近的多个直营店库存): ' location

if [ $(echo ${#location}) -eq 0 ];then
	location='广东+深圳+南山区'
fi

read -p '请输入想要取货的城市: (默认:深圳): ' pickLocation

if [ $(echo ${#pickLocation}) -eq 0 ];then
	pickLocation='深圳'
fi

read -p '请输入iMessage联系人: (如果不需要iMessage通知直接回车, 多个联系人空格隔开): ' toUser

echo '即将开始查询'
echo '查询的配置是: '

index=0
for value in ${deviceModels[*]};do
	modelInfoPath=$infoPath/$value.txt
	touch $modelInfoPath
	echo "型号: $value 配置: `cat $modelInfoPath`"
	let index+=1
done

echo "查询的地址是: $location"
echo "取件城市: $pickLocation"

iMessages=''
for value in $(echo $toUser);do
	if [ $(echo ${#iMessages}) -gt 0 ]; then
		iMessages="$iMessages, "
	fi
	iMessages="$iMessages$value"
done

if [ $(echo ${#iMessages}) -gt 0 ];then
	echo "iMessage: $iMessages"
fi

interval=30
function inputInterval(){
	read -p '请输入轮询时间间隔，不小于15秒（默认30s）: ' temp
	value=`echo ${temp}`
	if [ ${#value} -lt 2 ]; then
		value=30
	fi
	if [ $value -lt 15 ]; then
		inputInterval
		return
	fi
	interval=$value
}
inputInterval

read -p '请敲回车开始查询' temp

for user in $(echo $toUser);do
	osascript ./sendMessage.scpt "$user" "开始查询Apple线下库存"
done

url="https://www.apple.com.cn/shop/fulfillment-messages?$parts&location=$location&mt=regular"

while true ; do
	rm -rf $tempPath/*
	
	if [ ! -d $tempPath  ];then
		mkdir $tempPath
	fi
	if [ ! -d $stockPath  ];then
		mkdir $stockPath
	fi
	
	echo `date +"%Y-%m-%d %H:%M:%S"`
	stores=`curl -s "$url" | $jqpath '.body.content.pickupMessage.stores'`
	stores=`echo $stores`
	index=0
	while (( $index>=0 )); do
		store=`echo $stores | $jqpath ".[$index]"`
		let index++
		if [[ $store == "null" ]]; then
			index=-1
		else
			storeName=$(echo $store | $jqpath ".storeName" | sed 's/\"//g')
			city=$(echo $store | $jqpath ".city" | sed 's/\"//g')
			partsAvailability=$(echo $store | $jqpath ".partsAvailability")
			partsAvailability=$(echo ${partsAvailability/\//_})
			for model in ${deviceModels[*]}; do
				enabled=$(echo $partsAvailability | $jqpath ".$model.messageTypes.regular.storeSelectionEnabled")
				if [ "$enabled" == 'true' ]; then
					if [[ "$storeName" == `echo $city`* ]]; then
						storeName=`echo $storeName`
					else
						storeName=`echo "$city$storeName"`
					fi
					touch $tempPath/$model.txt
					content=$(echo "`cat $tempPath/$model.txt` $storeName")
					echo $content>$tempPath/$model.txt

					if [[ $pickLocation == *`echo $city`* ]]; then
						touch $stockPath/$model.txt
						content=$(echo "`cat $stockPath/$model.txt` $storeName")
						echo $content>"$stockPath/$model.txt"
					fi
				fi
			done
		fi
	done

	for model in ${deviceModels[*]}; do
		touch $stockPath/$model.txt
		touch $infoPath/$model.txt
		touch $tempPath/$model.txt
		
		name=`cat $infoPath/$model.txt`
		stores=`cat $tempPath/$model.txt`
		stocks=`cat $stockPath/$model.txt`
		
		if [[ ${#stocks} > 0 ]];then
			message=$(echo "通知: $stocks $name 可取货")
			echo $message
			for user in $(echo $toUser);do
				osascript ./sendMessage.scpt "$user" "通知: $stocks $name 可取货"
			done
		else
			echo "$name 暂时无货"
		fi
	done

	sleep $interval
done
