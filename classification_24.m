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

b_label = zeros(length(group),1);
for i = 1:length(group)
    if strcmp(group{i},'Diabetic')
        b_label(i,1) = 1;
    elseif strcmp(group{i},'Glaucoma')
        b_label(i,1) = 2;
    else strcmp(group{i},'Healthy')
        b_label(i,1) = 3;
    end
end


feat = [FeaturesHog;FeaturesHog;FeaturesHog;FeaturesHog];
label =[b_label;b_label;b_label;b_label];
% Perform neural network 
opts.tf        = 1;
opts.ho        = 0.3;
opts.H         = 10;
opts.Maxepochs = 50;
NN = jnn('ffnn',feat,label,opts); 

% Accuracy
accuracy = NN.acc;
% Confusion matrix
confmat  = NN.con; 
