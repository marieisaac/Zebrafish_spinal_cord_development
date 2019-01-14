# README #

### What is this repository for? ###
This repository is for computational analysis of single-cell reconstruction of emerging population activity from imaging data of developing zebrafish spinal cord.

### How is this repository organized? ###
We partitioned the code into two modules – Image Processing Module and Signal Processing Module, each with their own sub-modules corresponding to the analyses we performed in the spinal cord study. The rationale behind such partition is data management: Image Processing Module contains semi-automatic computational pipelines designed for processing big image data on remote servers/workstations equipped with parallel processing capabilities and visualization/annotation tools for manual data curation; while Signal Processing Module is designed for local processing of extracted calcium traces, completely automated and focus on mathematical modeling and statistical analysis. The output of Image Processing Module serves as the input of the Signal Processing Module.

Here we present a guide to readers who are interested in using our code to run their own analyses, with a focus on 1) how to setup the processing environment and 2) how to practically perform each module as needed. For details on the algorithm for each step of the processing modules, please refer to the Methods section of the manuscript.

## List of Analyses ##

Here is a list of the key computational modules, for detailed documentation on the code, please click on the links or visit the [Wiki Page](https://github.com/zqwei/Zebrafish_spinal_cord_development/wiki)
### Image Processing Module ###
* [Module 1.1: Semi-automatic cell tracking and signal extraction of longitudinal functional imaging](https://github.com/zqwei/Zebrafish_spinal_cord_development/wiki/Module-1.1)
* [Module 1.2: Image registration and signal extraction of ablation experiment](https://github.com/zqwei/Zebrafish_spinal_cord_development/wiki/Module-1.2)

### Signal Processing Module ###
* [Module 2.1: Factor analysis of longitudinal population activity](https://github.com/zqwei/Zebrafish_spinal_cord_development/wiki/Module-2.1)
* [Module 2.2: Mapping activity features to anatomical atlas and cell-type information](https://github.com/zqwei/Zebrafish_spinal_cord_development/wiki/Module-2.2)
* [Module 2.3: Analysis of ablation experiment result](https://github.com/zqwei/Zebrafish_spinal_cord_development/wiki/Module-2.3)

## Directory Structure ##
* Image_Processing -- analysis code for Image Processing Module
* Signal_Processing – analysis code for Signal Processing Module
* FunctionalData [ignored] – data sets of signal from longitudinal functional imaging
* AblationData [ignored] – data sets of signal from ablation experiments
* TempDat [ignored] -- a temporary storage place for intermediate processing result
* Plots [ignored] – figures generated from all analyses
* .gitignore  -- file to be ignored in git update

## Data Availability ##
Raw data can be downloaded from https://www.dropbox.com/sh/g7wahoj4o3f0j04/AAAqjndWq2mjHgcEmqpvoumBa?dl=0

## External software ##
Links to external software used in the computational pipeline. See [Wiki Page](https://github.com/zqwei/Zebrafish_spinal_cord_development/wiki/A-Guide-to-Image-Processing-Module) for details to set up the softwares
* [Fiji](https://fiji.sc/#download)
  * [MTrackJ](https://imagescience.org/meijering/software/mtrackj/)
  * [MaMuT](https://imagej.net/MaMuT)
* [TGMM cell tracking](https://sourceforge.net/projects/tgmm/)
* [Block-based image registration](https://github.com/leoguignard/Time-registration)
* [Vaa3D](https://github.com/Vaa3D/release/releases/)
