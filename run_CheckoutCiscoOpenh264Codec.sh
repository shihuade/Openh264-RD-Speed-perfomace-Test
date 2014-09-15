#!/bin/bash

#*********************************************************************************
# brief: clone repository from given github address to given destination folder.
#
# usage: run_CheckoutCiscoOpenh264Codec.sh $GithubAddress  $DestinationFolder
#
# date: 21/08/2014
#*********************************************************************************
runCheckParameter()
{

	if [ ! -d ${SourceFolder} ]
	then
		echo ""
		echo -e "\033[31m  Source folder ${SourceFolder} does not exist, please double check!  \033[0m"	
		echo ""
		exit 1
	fi
	
	return 0
}


runMain()
{

	if [ ! $# -eq 2 ]
	then
		echo ""
		echo -e "\033[31m  usage:  ./run_CheckoutCiscoOpenh264Codec.sh  \${GitRepositoryAddr} \${SourceFolder}  \033[0m"
		echo ""
		return 1
	fi

	GitRepositoryAddr=$1
	SourceFolder=$2
	
	runCheckParameter	
	git clone ${GitRepositoryAddr}  ${SourceFolder}
	
	return 0
}
GitRepositoryAddr=$1
SourceFolder=$2
runMain  ${GitRepositoryAddr} ${SourceFolder}

