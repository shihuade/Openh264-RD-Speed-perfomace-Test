#!/bin/bash
#***************************************************************************************
#  brief: run encdoer test for given YUV based on given encode configure
#         1. OptionIndex 0: SCC_QP test
#         2. OptionIndex 0: SCC_BR test
#         3. OptionIndex 0: SVC_QP test
#         4. OptionIndex 0: SVC_BR test
#
#  usage:  ./run_TestOpenh264.sh  ${OptionIndex}  ${InputYUV} ${OutputFile} \
#                                 ${TargetBR}   ${LogFile}
#
#  e.g    /run_TestOpenh264.sh  0  ABC_1280X720.yuv  ABC_1280X720_SCC_QP_24.264 \
#                               24  ABC_1280X720_SCC_QP_24.log
#  date: 21/08/2014
#***************************************************************************************
runOpenH264_SCC_QP()
{
	EncoderCommand="welsenc.cfg  -numl 1 -frms -1  \
					-lconfig 0 layer2.cfg -utype 1 \
					-sw   ${PicW} -sh   ${PicH}    \
					-dw 0 ${PicW} -dh 0 ${PicH}    \
					-frout 0  ${FPS}  -aq 0        \
					-rc -1  -lqp  0 ${LayerQP}     \
					-bf   ${OutputFile}            \
					-org  ${InputYUV}"
	./h264enc ${EncoderCommand} >${LogFile}
}
runOpenH264_SCC_BR()
{
	EncoderCommand="welsenc.cfg  -numl 1 -frms -1  \
					-lconfig 0 layer2.cfg -utype 1 \
					-sw   ${PicW} -sh   ${PicH}    \
					-dw 0 ${PicW} -dh 0 ${PicH}    \
					-frout 0  ${FPS}   -aq 1       \
					-rc 1 -tarb  ${TargetBR}       \
					-ltarb 0 ${TargetBR}           \
					-bf   ${OutputFile}            \
					-org  ${InputYUV}"		
}
runOpenH264_SVC_QP()
{
	EncoderCommand="welsenc.cfg  -numl 1 -frms -1  \
					-lconfig 0 layer2.cfg -utype 0 \
					-sw   ${PicW} -sh   ${PicH}    \
					-dw 0 ${PicW} -dh 0 ${PicH}    \
					-frout 0  ${FPS}   -aq 0       \
					-rc -1  -lqp  0 ${LayerQP}     \
					-bf   ${OutputFile}            \
					-org  ${InputYUV}"
}
runOpenH264_SVC_BR()
{
	EncoderCommand="welsenc.cfg  -numl 1 -frms -1  \
					-lconfig 0 layer2.cfg -utype 0 \
					-sw   ${PicW} -sh   ${PicH}    \
					-dw 0 ${PicW} -dh 0 ${PicH}    \
					-frout 0  ${FPS}   -aq 1       \
					-rc 1 -tarb  ${TargetBR}       \
					-ltarb 0 ${TargetBR}           \
					-bf   ${OutputFile}            \
					-org  ${InputYUV}"					
}
runPrepareInputParameter()
{
	if [ ! -e ${InputYUV} ]
	then
		echo ""
		echo  -e "\033[31m   Test YUV ${InputYUV}  does not exist! please double check!\033[0m"
		echo ""
		exit 1
	fi
	
	#get YUV detail info $picW $picH $FPS 
	YUVName=`echo  ${InputYUV} | awk 'BEGIN {FS="/"}  {print $FS}'`
	declare -a aYUVInfo
	aYUVInfo=(`./run_ParseYUVInfo.sh  ${InputYUV}`)
	
	PicW=${aYUVInfo[0]}
	PicH=${aYUVInfo[1]}
	FPS=${aYUVInfo[2]}
	if [ $PicW -le 0 -o  $PicH -le 0  ]
	then 
		echo "Picture info is not right "
		exit 1
	fi
	
	if [ $FPS -eq 0 ]
	then 		
		let "FPS=30"
	fi	
	
	return 0
}
runTestOpenh264()
{
	#generate encode command
	if [  ${OptionIndex} -eq 0  ]
	then
		runOpenH264_SCC_QP
	elif [  ${OptionIndex} -eq 1  ]
	then
		runOpenH264_SCC_BR
	elif [  ${OptionIndex} -eq 2  ]
	then
		runOpenH264_SVC_QP
	elif [  ${OptionIndex} -eq 3  ]
	then
		runOpenH264_SVC_BR
	else 
		echo ""
		echo  -e "\033[31m  test option index not support! \033[0m"
		echo ""
		exit 1	
	fi
	
	#encode one sequence
	echo "input yuv is ${InputYUV}"
	echo "Target BitRate is ${TargetBR} "
	echo "Target QP      is ${LayerQP} "	
	echo ""
	echo ${EncoderCommand}
	./h264enc ${EncoderCommand} >${LogFile}
	return 0
}
runMain()
{
	if [ ! $# -eq 5 ]
	then
		echo "not enough parameters!"
		echo "usage: run_TestOpenh264.sh  \$OptionIndex  \${InputYUV} \${OutputFile}  \${TargetBR}   \${LogFile}"
		return 1
	fi
	echo ""
	echo "openh264 encoder....."
	echo ""
	
	OptionIndex=$1
	InputYUV=$2
	OutputFile=$3
	TargetBR=$4
	LayerQP=$4
	LogFile=$5
	EncoderCommand=""
	PicW=""
	PicH=""
	FPS=""
	
	runPrepareInputParameter
	runTestOpenh264	
}
OptionIndex=$1
InputYUV=$2
OutputFile=$3
TargetBR=$4
LogFile=$5
runMain  ${OptionIndex}  ${InputYUV} ${OutputFile}   ${TargetBR}   ${LogFile}


