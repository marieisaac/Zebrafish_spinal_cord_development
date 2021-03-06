% % function Data_Analysis_List_all

all_analysis   = 1:24;
fileAnalyzed   = [1 2 3 18 20 9 10 12 14 17 19 20 23];
fileToAnalysis = all_analysis;
fileToAnalysis(fileAnalyzed) = [];

for nFile = fileToAnalysis
    Neuron_selection_v2(nFile); % add New x, y, z coordinates to analysis
    FACluster_v0_2_2(nFile) % plot LONOM optimal number with dropping the overlapped factors
    FACluster_v0_5_1(nFile) % generate FA evolution video -- Yinan version
    FACluster_v0_7(nFile) % generate networkMat (delay and correlation mat) for 0_8 and 1_2, 1_3 plots
    FACluster_v0_7_1(nFile) % generate networkMat -- the same as FACluster_v0_7 but for different use of data format
    FACluster_v0_9_1(nFile) % plot FA center and size as a function of time : new coordinates
    FACluster_v1_1(nFile) % plot FA size against time
    FACluster_v1_1_1(nFile) % plot max FA size for each side against time
    FACluster_v1_1_2(nFile) % plot FA size with mnx factored time
    FACluster_v1_1_3(nFile) % plot FA size with mnx factored time
    FACluster_v1_2(nFile) % plot delay time -- FA intra Neuron
    FACluster_v1_3(nFile) % plot delay time -- other
    FACluster_v1_5(nFile) % plot randomness of contra FA-FA delay time
    FACluster_v1_8(nFile) % plot FA-FA delay time without std and mean
    FACluster_v1_6(nFile) % plot size and radius of FA as time
    FAEV_v0_0(nFile) % generated EV time mat file
    FAEV_v0_1(nFile) % compute half EV time
    FAEV_v0_2(nFile) % compare half EV time vs activation time
    FAEV_v0_3(nFile) % EV time with location

    MNX_v0_0(nFile) % plot num neurons of time as a function of cell type
    MNX_v0_1(nFile) % plot half EV time as a function of cell type and location
    MNX_v0_2(nFile) % plot half EV time distribution
    MNX_v0_3(nFile)
    MNX_v0_4(nFile)
    MNX_v0_6(nFile)
    MNX_v0_7(nFile) % location
%     MNX_v0_8(nFile) % contra phase evolutions video
%     MNX_v0_9(nFile) % generate FA evolution video -- Yinan version with mnx- tag

    close all;
end
