#!/bin/bash

# ['reqid', 'timestampms', 'fill_price', 'model_price', 'model_ver', 'model_name', 'imp_price', 'real_cost']
sample="\"04466a1e-b9fd-4c3b-996a-e7d4fd92ebec\",1574400464261,0.33016518,1.038165,\"v1.0av1\",\"name\",0,0"

function getTimestampms(){
	# current=`date "+%Y-%m-%d %H:%M:%S"`     #获取当前时间，例：2016-06-06 15:40:41       
	# timeStamp=`date -d "$current" +%s`      #将current转换为时间戳，精确到秒
	# currentTimeStamp=$((timeStamp*1000+`date "+%N"`/1000000)) #将current转换为时间戳，精确到毫秒
	timestamp=$(date -j -f "%a %b %d %T %Z %Y" "`date`" "+%s")
	currentms=$((timestamp*1000)) #将current转换为时间戳，精确到毫秒
	echo $currentms
}   

function rand(){
  min=$1
  max=$(($2-$min+1))
  # num=$(($RANDOM+1000000000)) #增加一个10位的数再求余
  num=$RANDOM #增加一个10位的数再求余
  echo $(($num%$max+$min))
}

function randBi(){
	echo $(($RANDOM % 2))
}
     
num=12000
# num=12

model_va="v1.0av1"
model_vb="v1.0bv1"
model_va0="av1"


# for((i=1; i<=12; i++));
# do
# 	num=$RANDOM
# 	echo ======$num
# 	echo ======$(($num%2))
# done

for((i=1; i<=$num; i++));
do
	uuid=`uuidgen`
	timestampms=$(getTimestampms)

	f_model_price=$(rand 1 3)
	s_model_price=$(rand 1 999)

	f_fill_price=`expr $f_model_price + 1`
	s_fill_price=`expr $s_model_price + $(rand 1 999)`

	fill_price=$f_fill_price.$s_fill_price
	model_price=0

	s_ssp_price=$s_fill_price
	f_ssp_price=$f_fill_price

	imp_price=0
	real_cost=0
	model_ver="${model_vb}"
	model_name="name"

	use_model=$(($RANDOM%2))
	if [ $use_model -eq 1 ];then
		model_price=$(echo ${f_model_price}.${s_model_price})
		model_ver="${model_va}"

		s_ssp_price=$s_model_price
		f_ssp_price=$f_model_price
		#echo $model_price=======$model_ver======
	fi
	is_imp=$(($RANDOM%10))
	# echo $use_model***********$is_imp
	if [ $is_imp -eq 1 ];then
		s_imp_price=`expr $s_ssp_price - $(rand 0 1)`
		imp_price=$(echo $f_ssp_price.$s_imp_price)

		s_real_cost=`expr $s_ssp_price + $(rand 0 20)`
		real_cost=$(echo $f_fill_price.$s_real_cost)

		#echo $real_cost=======$model_ver======
	fi

	echo \"$uuid\",$timestampms,$fill_price,$model_price,\"$model_ver\",\"$model_name\",$imp_price,$real_cost
done
