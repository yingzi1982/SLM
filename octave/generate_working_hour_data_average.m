#!/usr/bin/env octave


clear all
close all
clc


dataNameList={"LAeq","LAF10","LAF90"};
dataFolderList = {"../data/office/Ludvika/","../data/office/Vasteras/"};

for j=1:length(dataNameList)
data_mean=[];
for i=1:length(dataFolderList)
data = dlmread([dataFolderList{i} dataNameList{j}]);
data_mean=[data_mean;log_mean(data)];
end
fileToWrite=["../data/office/" dataNameList{j} ''];
fileID = fopen(fileToWrite,'w');
fprintf(fileID, '%s\n',"LudvikaAndVasteras")
fprintf(fileID, '%s\n',"NoName")
fclose(fileID);

dlmwrite(fileToWrite,data_mean, '-append');
end
