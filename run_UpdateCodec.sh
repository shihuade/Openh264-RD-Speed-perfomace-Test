
#!/bin/bash

#***************************************************************************************
#  brief:  1. clone cisco openh264 repository to folder ./Source
#          2. open PSNR calculation macro, buid  codec and cony to folder ./Codec
#        
#  usage:  ./run_UpdateCodec.sh 
#
#  note:  default repository for openh264 is the official branch Cisco/master
#
#  date: 21/08/2014
#****************************************************************************************
runPrepareCheck()
{
	if [ -d ${CodecFodler} ]
	then
		${ScriptFolder}/run_SafeDelete.sh  ${CodecFodler}
	fi
	if [ -d ${SourceFolder} ]
	then
		${ScriptFolder}/run_SafeDelete.sh  ${SourceFolder}
	fi	
	
	mkdir  ${CodecFodler}
	mkdir  ${SourceFolder}	
	return 0
}
runPrepareLatestCodec()
{
	echo ""
	echo  -e "\033[32m  cloning codec......  \033[0m"	
	echo ""	
	./run_CheckoutCiscoOpenh264Codec.sh   ${CodecAddress} ${SourceFolder}	
	if [ ! $? -eq 0 ]
	then
		echo ""
		echo  -e "\033[31m  codec source checkout failed!  \033[0m"	
		echo ""	
		exit 1
	fi
	
	echo ""
	echo  -e "\033[32m  building codec......  \033[0m"	
	echo ""		
	./run_BuildCodec.sh  ${SourceFolder}
	if [ ! $? -eq 0 ]
	then
		echo ""
		echo  -e "\033[31m  codec build failed!  \033[0m"	
		echo ""	
		exit 1
	fi
	
	return 0
}

#usage: runMain   ${ConfigureFile} ${SequenceLocation}
runMain()
{
	CodecFodler="Codec"
	SourceFolder="Source"
	ScriptFolder="Scripts"
	
	CodecAddress="https://github.com/cisco/openh264"
	runPrepareCheck
	runPrepareLatestCodec
	
	return 0
}
runMain 

