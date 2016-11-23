#! /bin/bash

#### FRAMEWORK SANDBOX SETUP ####
# Load cmssw_setup function
source cmssw_setup.sh

echo "After executing setup"
# Setup CMSSW Base
export VO_CMS_SW_DIR=/cvmfs/cms.cern.ch
source $VO_CMS_SW_DIR/cmsset_default.sh

# Download sandbox
wget --no-check-certificate "http://stash.osgconnect.net/+khurtado/sandbox-CMSSW_7_2_3-86c7ff0.tar.bz2"
# Setup framework from sandbox
cmssw_setup sandbox-CMSSW_7_2_3-86c7ff0.tar.bz2

#### END OF FRAMEWORK SANDBOX SETUP ####

# Name my input directory
channel_rootpath=$1

#Download ROOTLogon to define plotting styles and load some libraries
wget --no-check-certificate "http://stash.osgconnect.net/+khurtado/rootlogon.C"

# Execute ROOT script
cd $CMSSW_BASE/src/ttH-13TeVMultiLeptons/TemplateMakers/test
channel_name = $(echo $channel_rootpath | awk -F '/' '{print $NF}')
root -b -q -l addvarstotree.C+"(\"$channel_path/*.root\",\"$channel_name.root\")"

# Stage out result via GFAL to Notre Dame
# gfal-copy "file://$PWD/$channel.root" "srm://eddie.crc.nd.edu:8443/srm/v2/server?SFN=/hadoop/store/user/khurtado/xrootd_test/${channel_name}.root" 2>&1
