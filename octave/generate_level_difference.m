#!/usr/bin/env octave


clear all
close all
clc

pkg load signal

arg_list = argv ();
if length(arg_list) > 0
  dataName = arg_list{1};
  dataFolder1 = arg_list{2};
  dataFolder2 = arg_list{3};
else
  [arg_list] = input('Please input parameters','s');
end

dataFile1 = [dataFolder1 dataName];
dataFile2 = [dataFolder2 dataName];

data1 = dlmread(dataFile1,'\t',2,0);
data2 = dlmread(dataFile2,'\t',2,0);

data1(find(data1<0)) = 0;
data2(find(data2<0)) = 0
data_diff = data1 - data2;

fid = fopen(dataFile1);
firstline = fgetl(fid);
secondline = fgetl(fid);
fclose(fid);

data_diff_file = [dataFile1 '_diff'];
fileID = fopen(data_diff_file,'w');
fprintf(fileID, '%s\n',firstline)
fprintf(fileID, '%s\n',secondline)
fclose(fileID);

dlmwrite(data_diff_file,data_diff,'\t', '-append');
