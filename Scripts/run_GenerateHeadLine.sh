#!/bin/bash
#****************************************************************************
#  brief: generate head line for statistical file
#
#  usage: run_GenerateHeadLine.sh  ${UseType} ${FinalResultFile} 
#
#  e.g:  run_GenerateHeadLine.sh  SCC  AllTestSequenceTestReport_SCC.csv
#  date: 21/08/2014
#***************************************************************************
runGenerateHeadLine()
{
	if [ ! $# -eq 2 ]
	then
		echo "usage: ./run_GenerateHeadLine.sh  \${UseType} \${FinalResultFile} "
		return 1
	fi
	
	UseType=$1
	FinalResultFile=$2
	
	local HeadLineOpenh264_1="TestSequence, ,QP,openh264_SCC_QP,       ,      ,   ,   , ,TargetBR,openh264_SCC_BR,       ,      ,   ,   ,   ,"
	local HeadLineOpenh264_2="            , ,  ,BR,     PSNR_Y , PSNR_U,PSNR_V,FPS, ET, ,        ,BR,    PSNR_Y  , PSNR_U,PSNR_V,FPS, ET,"
	
	local HeadLineOpenh264_3="TestSequence, ,QP,openh264_SVC_QP,       ,      ,   ,   , , TargetBR, openh264_SVC_BR,       ,      ,   ,   ， ,"
	local HeadLineOpenh264_4="            , ,  ,BR,     PSNR_Y , PSNR_U,PSNR_V,FPS, ET, ,         ，BR,    PSNR_Y  , PSNR_U,PSNR_V,FPS, ET,"
	
	
	if [ ${UseType} = "SCC" ]
	then
		echo "${HeadLineOpenh264_1}">${FinalResultFile}
		echo "${HeadLineOpenh264_2}">>${FinalResultFile}
	elif [ ${UseType} = "SVC" ]
	then
		echo "${HeadLineOpenh264_3} ">${FinalResultFile}
		echo "${HeadLineOpenh264_4} ">>${FinalResultFile}
	fi
	
	return 0
}
UseType=$1
FinalResultFile=$2
runGenerateHeadLine  ${UseType}  ${FinalResultFile} 

