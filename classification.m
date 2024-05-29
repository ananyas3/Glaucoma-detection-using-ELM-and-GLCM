%% Main Performance
clc;
clear all;
close all;

addpath(genpath('Images'))

load FeaturesHog;
InputImage=[];
Acc=[];

%% Training Phase
% features = [Mean,Var,Skewness,Kurtosis,Entropy,Energy];
load group;


% SVMModel = fitcsvm(FeaturesHog,group);

% [label,score] = predict(SVMModel,FeaturesHog);

b_label = zeros(length(group),3);
for i = 1:length(group)
    if strcmp(group{i},'Diabetic')
        b_label(i,1) = 1;
    elseif strcmp(group{i},'Glaucoma')
        b_label(i,2) = 1;
    else strcmp(group{i},'Healthy')
        b_label(i,3) = 1;
    end
end

% b_label = zeros(length(group),1);
% for i = 1:length(group)
%     if strcmp(group{i},'Glaucoma')
%         b_label(i,1) = 1;
%     end
% end