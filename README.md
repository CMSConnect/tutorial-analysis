# tutorial-analysis
[title]: - "CMSSW analysis example"

The following tutorial shows an analysis example that requires to run some CMSSW based analysis code to make flat trees from a group of ROOT files living in different directories and accessible via XRootD. So, for each directory, we want to be able to use all ROOT files on it to create a flat tree. This workflow would require:

* Create a sandbox with a user-based CMSSW framework
 * Setup a CMSSW area
 * Compile some user-customized analysis code on it
 * Create a sandbox with it for the jobs to use
* Create a job wrapper to use the previously created sandbox
* Create a submission file to run this code using different input file directories from a list.

You can find more details at: http://docs.uscms.org/CMSSW+Analysis+example
