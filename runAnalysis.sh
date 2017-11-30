#! /bin/bash

exit_on_error() {
    result=$1
    code=$2
    message=$3

    if [ $1 != 0 ]; then
        echo $3
        exit $2
    fi
} 

#### FRAMEWORK SANDBOX SETUP ####
# Load cmssw_setup function
source cmssw_setup.sh

# Setup CMSSW Base
export VO_CMS_SW_DIR=/cvmfs/cms.cern.ch
source $VO_CMS_SW_DIR/cmsset_default.sh

# Download sandbox
sandbox_name="sandbox-CMSSW_7_2_3-553bbfa.tar.bz2"
wget --no-check-certificate --progress=bar "http://stash.osgconnect.net/+khurtado/${sandbox_name}" || exit_on_error $? 150 "Could not download sandbox."

# Setup framework from sandbox
cmssw_setup $sandbox_name || exit_on_error $? 151 "Could not unpack sandbox"
#### END OF FRAMEWORK SANDBOX SETUP ####

# Name my input channel
channel_rootpath="$1"
channel_name="$(basename $channel_rootpath)"

# Enter script directory
cd $CMSSW_BASE/src/ttH-13TeVMultiLeptons/TemplateMakers/test

#Download ROOTLogon to define plotting styles and load some libraries
wget --no-check-certificate --progress=bar "http://stash.osgconnect.net/+khurtado/rootlogon.C" || exit_on_error $? 150 "Could not download rootlogon."

# Execute ROOT script
root -b -q -l addvarstotree.C+"(\"$channel_rootpath/*.root\",\"$channel_name.root\")" || exit_on_error $? 152 "Failed running ROOT script."

echo "Output file size: "
du -hs "$channel_name.root"

# Stage-out to FNAL EOS
# mydate=$(date +%Y_%m_%d_%k_%M)
# xrdcp -f "$channel_name.root" "root://cmseos.fnal.gov:1094//eos/uscms/store/user/kenai/xrootd_test/${channel_name}_${mydate}.root" 2>&1

# Clean up
rm rootlogon.C
cd -
rm $sandbox_name
