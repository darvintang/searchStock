#!/bin/zsh
SHELL_FOLDER=$(cd "$(dirname "$0")";pwd)
shellPath=$SHELL_FOLDER/.shell
tempPath=$SHELL_FOLDER/.temp
infoPath=$SHELL_FOLDER/.info
stockPath=$tempPath/stock

echo '欢迎使用MacBookPro库存查询脚本'
echo 'Author: Darvin'
echo 'Create: 2021-11-14'


nameDict=([1411]='14寸灰色8核+14核+16G+512G' [1412]='14寸银色8核+14核+16G+512G' [1421]='14寸灰色10核+16核+16G+1T' [1422]='14寸银色10核+16核+16G+1T' [1611]='16寸灰色10核+16核+16G+512G' [1612]='16寸银色10核+16核+16G+512G' [1621]='16寸灰色10核+16核+16G+1T' [1622]='16寸银色10核+16核+16G+1T' [1631]='16寸灰色10核+32核+32G+1T' [1632]='16寸银色10核+32核+32G+1T')
modelDict=([1411]='MKGP3CH/A' [1412]='MKGR3CH/A' [1421]='MKGQ3CH/A' [1422]='MKGT3CH/A' [1611]='MK183CH/A' [1612]='MK1E3CH/A' [1621]='MK193CH/A' [1622]='MK1F3CH/A' [1631]='MK1A3CH/A' [1632]='MK1H3CH/A')


if [ ! -d $infoPath  ];then
	mkdir $infoPath
fi

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
		if [[ "$model" == MK* ]];then
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



read -p '请输入地址: (默认:广东+广州+天河区); (查询库存会根据地址查询附近的多个直营店库存): ' location

if [ $(echo ${#location}) -eq 0 ];then
	location='广东+广州+天河区'
fi

read -p '请输入想要取货的城市: (默认:广州): ' pickLocation

if [ $(echo ${#pickLocation}) -eq 0 ];then
	pickLocation='广州'
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

interval=60
function inputInterval(){
	read -p '请输入轮询时间间隔，不小于60秒（默认120s）: ' temp
	value=`echo ${temp}`
	if [ ${#value} -lt 2 ]; then
		value=120
	fi
	if [ $value -lt 60 ]; then
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
jqpath=$shellPath/jq

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
				enabled=$(echo $partsAvailability | $jqpath ".$model.storeSelectionEnabled")
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
		echo "$name 在 $stores 有货"

		if [[ ${#stocks} > 0 ]];then
			message=$(echo "通知: $stocks $name 可取货")
			echo $message
			for user in $(echo $toUser);do
				osascript ./sendMessage.scpt "$user" "通知: $stocks $name 可取货"
			done

		fi
	done

	sleep $interval
done
