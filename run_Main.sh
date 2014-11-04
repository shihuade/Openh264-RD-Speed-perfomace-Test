#!/bin/bash

#***************************************************************************************
#  brief:  1. clone cisco openh264 repository to folder ./Source
#          2. open PSNR calculation macro, buid  codec and cony to folder ./Codec
#          3. prepare test space for all test sequences, creat folder ./AllTestData
#          4. run seed and RD performance test for all SCC and SVC test sequences.
#          5. copy finalt test report XXX.csv from ./AllTestData to ./TestResult
#        
#  usage:  ./run_Main.sh  $SCC_TestSequnces.cfg $SVC_TestSequences.cfg  $TestYUVDir
#
#  date: 21/08/2014
#****************************************************************************************
runPrepareCheck()
{
	
	if [ ! -e ${ConfigureFile_SCC} -o ! -e ${ConfigureFile_SVC} ]
	then
		echo ""
		echo -e "\033[31m  Test YUVs list configure file ${ConfigureFile_SCC}  or ${ConfigureFile_SCC} does not exist, please double check!  \033[0m"	
		echo ""
		exit 1
	fi
	if [ ! -d ${SequenceLocation}  ]
	then
		echo ""
		echo -e "\033[31m  Test YUVs directory ${SequenceLocation} does not exist, please double check!  \033[0m"	
		echo ""
		exit 1
	fi
		
	if [ -d ${TestDataFolder} ]
	then
		${ScriptFolder}/run_SafeDelete.sh  ${TestDataFolder}
	fi
	
	if [ -d ${TestResultFolder} ]
	then
		${ScriptFolder}/run_SafeDelete.sh  ${TestResultFolder}
	fi
	
	
	cd ${SequenceLocation}
	SequenceLocation=`pwd`
	cd ${CurrentDir}
	
	echo ""
	echo  -e "\033[32m  Preparing test space......  \033[0m"	
	echo ""
	mkdir  ${TestDataFolder}
	mkdir  ${TestResultFolder}
	return 0
}

runPrepareTestSpcace()
{
	cp ${ScriptFolder}/*   ${TestDataFolder}
	cp ${CodecFodler}/*   ${TestDataFolder}
	cp ${ConfigureFile_SCC}   ${TestDataFolder}
	cp ${ConfigureFile_SVC}   ${TestDataFolder}
	
	return 0
}
runTestAllSequences()
{
	echo ""
	echo "enter into test space.."
	echo ""
	cd  ${TestDataFolder}
	
	#SCC test
	echo ""
	echo  -e "\033[32m  SCC testing........ \033[0m"
	echo ""
	./run_AllTestSequence.sh  SCC  ${ConfigureFile_SCC} ${SequenceLocation}	
	#SVC test
	echo ""
	echo  -e "\033[32m  SVC testing........ \033[0m"
	echo ""
	./run_AllTestSequence.sh  SVC  ${ConfigureFile_SVC} ${SequenceLocation}	
		
	echo ""
	echo "come back to working directory"
	cd ${CurrentDir}	
}
runCopyTestResult()
{
	echo ""	
	echo "copy final result file... "
	cp ${TestDataFolder}/*.csv  ${TestResultFolder}
	echo ""
}
#usage: runMain   ${ConfigureFile} ${SequenceLocation}
runMain()
{
	if [ ! $# -eq 3 ]
	then
		echo ""
		echo -e "\033[31m  usage:  ./run_Main.sh   \${ConfigureFile_SCC} \${ConfigureFile_SVC} \${SequenceLocation} \033[0m"
		echo -e "\033[31m     e.g: ./run_Main.sh  YUV_SCC.cfg  YUV_SVC.cfg   /home/Video/TestYUV  \033[0m"
		echo ""
		return 1
	fi
	
	ConfigureFile_SCC=$1
	ConfigureFile_SVC=$2
	SequenceLocation=$3
	ScriptFolder="Scripts"
	TestDataFolder="AllTestData"
	TestResultFolder="TestResult"
	CodecFolder="Codec"
	
	CurrentDir=`pwd`
	runPrepareCheck
	runPrepareTestSpcace
	runTestAllSequences
	
	runCopyTestResult
	echo ""
	echo  -e "\033[32m  Test has been completed! \033[0m"
	echo  -e "\033[32m  All test result can be found under  folder ${TestResultFolder} \033[0m"
	echo ""
	
	return 0
}
ConfigureFile_SCC=$1
ConfigureFile_SVC=$2
SequenceLocation=$3
runMain   ${ConfigureFile_SCC}  ${ConfigureFile_SVC} ${SequenceLocation}


