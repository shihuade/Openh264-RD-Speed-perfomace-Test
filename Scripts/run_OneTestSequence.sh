#!/bin/bash
#*************************************************************************************
#  brief: run test for given test YUV under given use type(SCC or SVC)
#         1. four QP point's performance test 
#         2. four bit rate point's performance test
#            four bit rate points are based on the actal output of four QP point
#         3. output performance info to statitical file
#
#  usae: run_OneTestSequence.sh  $UseType  $InputYUV  $StatisticalFile
#
#  e.g:  run_OneTestSequence.sh  SCC  ABC_1281X720.yuv   AllTestReport_SCC.csv
#
#  date: 21/08/2014
#**************************************************************************************
runSCCPerformance()
{
	local LogFile=""
	local OutputFile=""
	
	declare -a aTargetBitRate
	#initial, will be updated based on QP result(kbps)
	aTargetBitRate=(100 500 1000 1500)
	
	#QP mode
	for((i=0;i<4;i++))
	do
		LogFile="openh264_${YUVName}_SCC_QP_${aOpenh264QP[$i]}.log"
		OutputFile="openh264_${YUVName}_SCC_QP_${aOpenh264QP[$i]}.264"
		./run_TestOpenh264.sh  0  ${InputYUV} ${OutputFile}   ${aOpenh264QP[$i]}   ${LogFile}
		aPerformanceSCC_QP[$i]=`./run_GetPerfInfo_openh264.sh   ${LogFile}`
		aTargetBitRate[$i]=`echo ${aPerformanceSCC_QP[$i]} | awk 'BEGIN {FS="."} {print $1}'`
		
		cat ${LogFile}
	done
	
	#RC mode
	for((i=0;i<4;i++))
	do
		LogFile="openh264_${YUVName}_SCC_BR_${aTargetBitRate[$i]}.log"
		
		OutputFile="openh264_${YUVName}_SCC_BR_${aTargetBitRate[$i]}.264"
		./run_TestOpenh264.sh  1  ${InputYUV} ${OutputFile}   ${aTargetBitRate[$i]}   ${LogFile}
		aPerformanceSCC_BR[$i]=`./run_GetPerfInfo_openh264.sh   ${LogFile}`
		
		cat ${LogFile}
	done
	return 0	
}
runSVCPerformance()
{
	local LogFile=""
	local OutputFile=""
	declare -a aTargetBitRate
	#initial, will be updated based on QP result(kbps)
	aTargetBitRate=(100 500 1000 1500)
	
	#QP mode
	for((i=0;i<4;i++))
	do
		LogFile="openh264_${YUVName}_SVC_QP_${aOpenh264QP[$i]}.log"
		OutputFile="openh264_${YUVName}_SVC_QP_${aOpenh264QP[$i]}.264"
		
		./run_TestOpenh264.sh  2  ${InputYUV} ${OutputFile}   ${aOpenh264QP[$i]}   ${LogFile}
		aPerformanceSVC_QP[$i]=`./run_GetPerfInfo_openh264.sh   ${LogFile}`
		aTargetBitRate[$i]=`echo ${aPerformanceSVC_QP[$i]} | awk 'BEGIN {FS="."} {print $1}'`
		
		cat ${LogFile}
		echo "QP mode: ./run_TestOpenh264.sh  0  ${InputYUV} ${OutputFile}   ${aOpenh264QP[$i]}   ${LogFile}"
		echo ""
		echo "aPerformanceSVC_QP[$i] is ${aPerformanceSVC_QP[$i]}"
		echo "aTargetBitRate[$i]  is ${aTargetBitRate[$i]}"
		echo ""
	done
	
	#RC mode
	for((i=0;i<4;i++))
	do
		LogFile="openh264_${YUVName}_SVC_BR_${aTargetBitRate[$i]}.log"
		OutputFile="openh264_${YUVName}_SVC_BR_${aTargetBitRate[$i]}.264"
		
		./run_TestOpenh264.sh  3  ${InputYUV} ${OutputFile}   ${aTargetBitRate[$i]}   ${LogFile}>>${TempLog}
		aPerformanceSVC_BR[$i]=`./run_GetPerfInfo_openh264.sh   ${LogFile}`
		
		cat ${LogFile}
		echo ""
		echo "RC mode: ./run_TestOpenh264.sh  1  ${InputYUV} ${OutputFile}   ${aTargetBitRate[$i]}   ${LogFile}"
		echo "aPerformanceSVC_BR[$i] is ${aPerformanceSVC_BR[$i]}"
		echo ""
		
	done
	return 0	
}
runTestOneSequence()
{
	local QP=""
	local TargetBR=""
	if [ ${UseType} = "SCC" ]
	then
		runSCCPerformance >>${TempLog}
		for((i=0;i<4;i++))
		do
			QP=${aOpenh264QP[$i]}
			TargetBR=`echo ${aPerformanceSCC_QP[$i]} |awk 'BEGEIN {FS=","} {print $1}'`
			echo "${YUVName}, ,${QP},${aPerformanceSCC_QP[$i]}, ,${TargetBR},${aPerformanceSCC_BR[$i]}">>${StatisticFile}
		done		
	elif [ ${UseType} = "SVC" ]
	then
		runSVCPerformance >>${TempLog}
		for((i=0;i<4;i++))
		do
			QP=${aOpenh264QP[$i]}
			TargetBR=`echo ${aPerformanceSVC_QP[$i]} | awk 'BEGEIN {FS=","} {print $1}'`
			echo "${YUVName}, ,${QP},${aPerformanceSVC_QP[$i]}, ,${TargetBR},${aPerformanceSVC_BR[$i]}">>${StatisticFile}
		done	
	fi
}
runMain()
{
	if [ ! $# -eq 3 ]
	then
		echo  "usage: ./run_OneTestSequence.sh \${UseType} \${InputYUV}  \${StatisticFile}"
		exit 1
	fi
	
	UseType=$1
	InputYUV=$2
	StatisticFile=$3
	
	declare -a aOpenh264QP	
	declare -a aPerformanceSCC_QP
	declare -a aPerformanceSCC_BR
	declare -a aPerformanceSVC_QP
	declare -a aPerformanceSVC_BR
	aOpenh264QP=(24   28  32    36 )
	YUVName=`echo  ${InputYUV} | awk 'BEGIN {FS="/"}  {print $NF}'`
	
	TempLog="${YUVName}_${UseType}_Console.log"
	echo "">${TempLog}
	runTestOneSequence
	
	return 0
}
UseType=$1
InputYUV=$2
StatisticFile=$3
runMain  ${UseType} ${InputYUV}  ${StatisticFile}

