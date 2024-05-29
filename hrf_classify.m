%% Main Performance
clc;
clear all;
close all;

% addpath(genpath('images_gh'))

load FeaturesHog_hrf;


%% Training Phase
% features = [Mean,Var,Skewness,Kurtosis,Entropy,Energy];
load group_hrf;


% SVMModel = fitcsvm(FeaturesHog,group);

% [label,score] = predict(SVMModel,FeaturesHog);

b_label = zeros(length(group_hrf),1);
for i = 1:length(group_hrf)
    if strcmp(group_hrf{i},'Glaucoma')
        b_label(i,1) = 1;
    else strcmp(group_hrf{i},'Healthy')
        b_label(i,1) = 2;
    end
end


feat = [FeaturesHog_hrf;FeaturesHog_hrf;FeaturesHog_hrf];
label =[b_label;b_label;b_label];
% Perform neural network 
% opts.tf        = 1;
% opts.ho        = 0.3;
% opts.H         = 10;
opts.Maxepochs = 50;
NN = jnn('ffnn',feat,label,opts); 

% Accuracy
accuracy = NN.acc;
% Confusion matrix
confmat  = NN.con; 
