This repository provides the implementation of the Topology Consistency (TC) algorithm, designed for user identification across multilayer social networks. TC integrates multiple network layers into a single-layer structure by analyzing the topology consistency of cross-layer common neighbors (CCNs) and establishing shared node pair (SNP) relationships. The method preserves topological features and improves identification accuracy and robustness across platforms.

identity.m Further processing of UINPs, considering the connection relationship between INPs, recalculate the similarity between UINPs, def1 is the returned INP.
main.m The main program of the algorithm.
select.m Select INPs, def is the returned INPs, undef is the returned UINPs.
WF_Func.m The steps of the algorithm are mainly reflected in this program.
