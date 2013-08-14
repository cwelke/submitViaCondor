#! /bin/bash




##
# This is the main usage file. Make sure the cfg is written properly. Also, Make sure you have all the permissions to write out to any necessary directories on hadoop. 
# usage:
# ./submitCMS2Job.sh cfg/sample_cfg.sh

configFile=$1
source $configFile

jobnumber=1

#ensures that there is a directory to stageout to
if [ ! -d $outputDir ]; then
	echo "$outputDir does not exist. Attempting to make."
	mkdir -p $outputDir/unmerged
	mkdir -p $outputDir/log
	didMakeDir1=$?
	didMakeDir2=$?
else
	didMakeDir1=0;
	didMakeDir2=0;
fi

if [ "$didMakeDir1" == "0" ]; then
	echo "Directory $outputDir/unmerged made successfully. "
else
	echo "Directory $outputDir/unmerged not made successfully. Exiting."
	exit 11
fi

if [ "$didMakeDir2" == "0" ]; then
	echo "Directory $outputDir/log made successfully. "
else
	echo "Directory $outputDir/log not made successfully. Exiting."
	exit 12
fi

#this gets the list of lists
filesList=`dbsql find file where dataset=${dataSetActual} | grep root`

#chooses how to call the log submission file
dateS=`date '+%Y.%m.%d-%H.%M.%S'`
if [ ! -d /data/tmp/$USER/$dataSet/submit/std_logs/ ]; then
	mkdir -p /data/tmp/$USER/$dataSet/submit/std_logs/
fi

numjobssubmitted=0
#This loops over the merged file lists and submits a job for each list
for list in $filesList; do

	if [ $jobnumber == 2 ]; then
		exit
	fi
	
	fileIn=$list
	inputArguments="$CMSSWRelease $fileCfg $fileIn $outputDir $CMS2Tag $CMS2Tar $jobnumber"
	inputFiles=cms2tar/$CMS2Tar,$executableScript,$fileCfg
	outFileName=ntuple_${jobnumber}.root
	jobnumber=$(($jobnumber+1))

# this takes care of "resubmission. When all your condor jobs are done, this will check that the files are there, and if they are not, it will resubmit a job. If you find a job that has output a corrupted file (which it shouldn't unless stageout fails) just delete the file and run this script again."
# outputfilename="ntuple_jobnumber"
	# outFileName=`echo $list | sed 's/list/ntuple/g' | sed 's/txt/root/g'`
	# ls -l $outputDir | grep "$outFileName" 
	ls -l $outputDir/$outFileName > /dev/null 2>&1
	doesExist=$?
	if [ $doesExist == 0 ]; then
		echo "File exists, will not submit job for $outputDir/$outFileName."
	else
		echo "submitting job for file $outFileName"
		lib/libsh/submit.sh -e $executableScript -a "$inputArguments" -i $inputFiles -u ${workingDirectory}/${dataSet}_cfg -l /data/tmp/$USER/$dataSet/testlog_$dateS.log -L /data/tmp/$USER/$dataSet/submit/std_logs/

		numjobssubmitted=$(($numjobssubmitted+1))
	fi
done

echo "$numjobssubmitted jobs submitted. Check status of jobs with condor_q $USER"
