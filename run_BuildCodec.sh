#!/bin/bash
#***************************************************************************************
#  brief:  build and copy  codec to Codec folder
#          1. open PSNR calculaition macro
#          2. buid codec
#          3. copy codec and cfg files to folder ./Codec 
#
#  usage: run_BuildCodec.sh  ${CodecDir}
#       
#  date:  5/08/2014 Created
#***************************************************************************************

runYUVPSNRMacroOpen()
{
	if [ ! $# -eq 1 ]
	then
		echo "useage:  runYUVDumpMacroOpen   \${Openh264Dir}"
		return 1
	fi
	local File=$1
	local TempFile="${File}.Team.h"
	local PreviousLine=""
	if [ ! -f  "$File"   ]
	then
		echo "file ${File} does not exist! when tring to open YUV dump macro "
		return 1
	fi
	echo "">${TempFile}
	while read line
	do
		if [[  ${PreviousLine} =~ "#endif//MEMORY_CHECK"  ]]
		then
			echo "#define FRAME_INFO_OUTPUT">>${TempFile}
			echo "#define STAT_OUTPUT">>${TempFile}
			echo "#define ENABLE_PSNR_CALC">>${TempFile}
		fi
		echo "${line}">>${TempFile}
		PreviousLine=$line
	done < ${File}
	
	rm -f ${File}
	mv  ${TempFile}  ${File}
}

#useage: ./runBuildCodec  ${Openh264Dir}
runBuildCodec()
{
	if [ ! $# -eq 1 ]
	then
		echo "useage: ./runBuildCodec  \${Openh264Dir}"
		return 1
	fi
	local OpenH264Dir=$1
	local CurrentDir=`pwd`
	local BuildLog="${CurrentDir}/build.log"
	
	if [  ! -d ${OpenH264Dir} ]
	then
		echo "openh264 dir is not right!"
		return 1
	fi
	
	cd ${OpenH264Dir}
	make clean  >${BuildLog}
	make >>${BuildLog}
	
	if [ ! -e h264enc  ]
	then
		echo "encoder build failed"
		cd ${CurrentDir}
		return 1
	elif [ ! -e h264dec  ]
	then
		echo "decoder build failed"
		cd ${CurrentDir}
		return 1
	else
		cd ${CurrentDir}
		return 0
	fi
}
#useage:  runCopyFile  ${Openh264Dir}
runCopyFile()
{
	if [ ! $# -eq 1 ]
	then
		echo "useage:  runCopyFile  \${Openh264Dir}"
		return 1
	fi
	local OpenH264Dir=$1

	cp -f ${OpenH264Dir}/h264enc  ${CodecDir}
	cp -f ${OpenH264Dir}/h264dec  ${CodecDir}
	cp -f ${OpenH264Dir}/testbin/layer2.cfg      ${CodecDir}
	cp -f ${OpenH264Dir}/testbin/welsenc.cfg     ${CodecDir}
}
#useage: ./run_BuildCodec.sh   ${Openh264Dir}
runMain()
{
	if [ ! $# -eq 1 ]
	then
		echo "useage: ./run_BuildCodec.sh   \${Openh264Dir}"
		return 1
	fi
	
	Openh264Dir=$1
	CurrentDir=`pwd`
	CodecDir="${CurrentDir}/Codec"
	YUVDumpMacroFileName="as264_common.h"
	YUVDumpMacroFileDir="codec/encoder/core/inc"
	TestBitStreamFileDir=""
	YUVDumpMacroFile=""
	
	if [ ! -d  ${Openh264Dir} ]
	then
		echo "openh264 dir  ${Openh264Dir}  does not exist!"
		exit 1
	fi
	
	if [ ! -d  ${CodecDir} ]
	then
		echo "Codec dir  ${CodecDir}  does not exist!"
		exit 1
	fi
	
	cd ${Openh264Dir}
	Openh264Dir=`pwd`
	cd ${CurrentDir}
	
	YUVDumpMacroFile="${Openh264Dir}/${YUVDumpMacroFileDir}/${YUVDumpMacroFileName}"
	echo ""
	echo "enable macro for Rec YUV dump!"
	echo "file is ${YUVDumpMacroFile}"
	echo ""
	runYUVPSNRMacroOpen  "${YUVDumpMacroFile}"
	if [ ! $? -eq 0 ]
	then
		echo "failed to open PSNR macro !"
		exit 1
	fi
	
	
	echo ""
	echo "building codec"
	echo ""
	runBuildCodec  ${Openh264Dir}
	if [ ! $? -eq 0 ]
	then
		echo "Codec Build failed"
		exit 1
	fi
	
	
	echo ""
	echo "copying h264 codec"
	echo ""
	runCopyFile  ${Openh264Dir}
	if [ ! $? -eq 0 ]
	then
		echo "copy files failed"
		exit 1
	fi
	
	return 0
}
Openh264Dir=$1
runMain ${Openh264Dir}

