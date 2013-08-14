#! /bin/bash
dataSetActual=/SMS-T6ttHH_2J_mStop2-325to475_mStop-175to325_TuneZ2star_8TeV-madgraph-tauola/Summer12-START53_V19_FSIM-v1/AODSIM
dataSet=`echo ${dataSetActual#/} | sed 's/\/AODSIM//g' | sed 's/\//_/g'`


echo "# Cfg file for dataset $dataSetActual" > cfg/${dataSet}.sh
echo "export workingDirectory=`pwd`" >> cfg/${dataSet}.sh
echo "export executableScript=lib/libsh/makeCMS2ntuple.sh" >> cfg/${dataSet}.sh
echo "export CMSSWRelease=\"CMSSW_5_3_2_patch4\"" >> cfg/${dataSet}.sh
echo "export CMS2Tag=\"V05-03-31\"" >> cfg/${dataSet}.sh
echo "export fileCfg=$workingDirectory/cfg/${dataSet}_cfg.py" >> cfg/${dataSet}.sh
echo "export dataSetActual=/SMS-T6ttHH_2J_mStop2-325to475_mStop-175to325_TuneZ2star_8TeV-madgraph-tauola/Summer12-START53_V19_FSIM-v1/AODSIM" >> cfg/${dataSet}.sh
echo "export dataSet=`echo ${dataSetActual#/} | sed 's/\/AODSIM//g' | sed 's/\//_/g'`" >> cfg/${dataSet}.sh
echo "export outputDir=/hadoop/cms/store/user/$USER/${CMSSWRelease}_${CMS2Tag}/$dataSet" >> cfg/${dataSet}.sh
echo "export CMS2Tar=${CMSSWRelease}_${CMS2Tag}.tgz" >> cfg/${dataSet}.sh



