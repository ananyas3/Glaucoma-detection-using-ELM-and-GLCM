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

group1={'D';'G';'H';'D';'G';'H';'D';'G';'H';'D';'G';'H';'D';'G';'H';'D';'G';'H';'D';'G';'H';'D';'G';'H';'D';'G';'H';'D';'G';'H';...
    'D';'G';'H';'D';'G';'H';'D';'G';'H';'D';'G';'H';'D';'G';'H';};


feat = [FeaturesHog;FeaturesHog;FeaturesHog;FeaturesHog];
label =[group1;group1;group1;group1];

Mdl = fitcecoc(feat,label);

predict_L = predict(Mdl,FeaturesHog);

C = confusionmat(group1,predict_L)

confusionchart(C)