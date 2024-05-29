%% Main Performance
clc;
clear all;
close all;

addpath(genpath('images_gh'))

load FeaturesHog_hrf;

%% Training Phase
% features = [Mean,Var,Skewness,Kurtosis,Entropy,Energy];
load group_hrf;

b_label = zeros(length(group_hrf),1);
for i = 1:length(group_hrf)
    if strcmp(group_hrf{i},'Glaucoma')
        b_label(i,1) = 1;
    else strcmp(group_hrf{i},'Healthy')
        b_label(i,1) = 0;
    end
end

feat = [FeaturesHog_hrf;FeaturesHog_hrf;FeaturesHog_hrf];
labels =[b_label;b_label;b_label];

X = feat;
Y = labels;

% Split train and test data
[tr, ts] = dividerand(length(Y), 0.8, 0.2);
X_train = X(tr, :);
Y_train = Y(tr);
X_test = X(ts, :);
Y_test = Y(ts);

% Adjust data
X_test = (X_test - mean(X_train)) ./ std(X_train);
X_train = (X_train - mean(X_train)) ./ std(X_train);

%% Train model and predict output

mdl = extreme_learning_machine_classifier(X_train, Y_train); % Train ELM
y = mdl.predict(X_test); % Predict

% Print result
fprintf("-------------------\n");
fprintf("Model Acc.: %.2f%%\n", ...
    100 * sum(y == Y_test) / length(Y_test));
fprintf("-------------------\n");


