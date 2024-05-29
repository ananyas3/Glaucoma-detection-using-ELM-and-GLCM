%% Main Performance
clc;
clear all;
close all;

addpath(genpath('Images'))

load FeaturesHog_hrf;
InputImage=[];
Acc=[];

%% Training Phase
% features = [Mean,Var,Skewness,Kurtosis,Entropy,Energy];
load group_hrf;


% SVMModel = fitcsvm(FeaturesHog,group);

% [label,score] = predict(SVMModel,FeaturesHog);

% b_label = zeros(length(group),1);
% for i = 1:length(group)
%     if strcmp(group{i},'Diabetic')
%         b_label(i,1) = 'D';
%     elseif strcmp(group{i},'Glaucoma')
%         b_label(i,1) = 'G';
%     else strcmp(group{i},'Healthy')
%         b_label(i,1) = 'H';
%     end
% end

group1={'G';'H';'G';'H';'G';'H';'G';'H';'G';'H';'G';'H';'G';'H';'G';'H';'G';'H';'G';'H';...
    'G';'H';'G';'H';'G';'H';'G';'H';'G';'H';};


feat = [FeaturesHog_hrf;FeaturesHog_hrf;FeaturesHog_hrf];
label =[group1;group1;group1];

Mdl = fitcecoc(feat,label);

predict_L = predict(Mdl,feat);

C = confusionmat(label,predict_L)

confusionchart(C)