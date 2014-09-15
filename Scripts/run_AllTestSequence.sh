#!/bin/bash
#*******************************************************************************************
#  brief: run test for all given test sequences under given use type(SCC or SVC)
#         1. script will search YUV file under given YUV folder
#         2. run test for each YUV and output YUV's performance info to statistical file
#
#  usage: run_AllTestSequence.sh  $UseType  $YUVList.cfg  $YUVFolder
#  
#  e.g:   run_AllTestSequence.sh  SCC  YUV_SCC.cfg  /home/XXX/TestYUV
#
#  date: 21/08/2014
#********************************************************************************************
runPamameterCheck()
{
	if [ ! -d ${SequenceLocation}  ]
	then
		echo ""
		echo -e "\033[31m  Test YUVs directory ${SequenceLocation} does not exist, please double check!  \033[0m"	
		echo ""
		exit 1
	fi
}
#usage: runAllTestSequence  ${YUVListConfigureFile} ${SequenceLocation}
runAllTestSequence()
{
        if [ ! $# -eq 3 ]
        then
		echo "usage: ./run_AllTestSequence.sh \${UseType} \${YUVListConfigureFile} \${SequenceLocation} "
		return 1
        fi
		UseType=$1
        YUVListConfigureFile=$2
        SequenceLocation=$3
		
	FinalResultFile="AllTestSequence_${UseType}.csv"
        local TestYUVName=""
        local TestYUV=""
        local line=""
	runPamameterCheck
		
        ./run_GenerateHeadLine.sh  ${UseType}  ${FinalResultFile}
        while read line
        do
		if [ -n "$line"  ]
		then
			TestYUVName="$line"
			echo "current YUV is:  ${TestYUVName}"
			TestYUV=`./run_GetYUVPath.sh  ${TestYUVName}  ${SequenceLocation}`
			if [ $? -eq 0  ]
			then
				echo "test YUV: ${TestYUVName} is under testing..."
				echo "Test yuv full path is ${TestYUV} "
				./run_OneTestSequence.sh  ${UseType} ${TestYUV} ${FinalResultFile}
				echo ""
			else
				echo ""
				echo -e "\033[31m  can not find Test YUV: ${TestYUVName}  \033[0m"
				echo ""
			fi
		fi
        done <${YUVListConfigureFile}
}
UseType=$1
YUVListConfigureFile=$2
SequenceLocation=$3
runAllTestSequence  ${UseType} ${YUVListConfigureFile} ${SequenceLocation} 


