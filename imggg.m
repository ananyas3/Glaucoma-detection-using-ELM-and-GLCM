%% Main Program
clc;
clear all;
close all;

addpath(genpath('images'))

%% pathToFeatures 
base_path='D:\REVA\Research_REVA\5thSEM\HRF Dataset';
image_path=strcat(base_path,'/images');

dd=dir(image_path);

image_folder=char(dd.name);
image_folder=image_folder(3:end,:);

%% HOG & Features

for Index=1:length(image_folder)
% name = sprintf('%s.jpg',image_folder(Index,1:5)); %image_folder(1,1:5)
name = sprintf('%s',image_folder(Index,:));
II{Index}=imread(name); 
Img=II{Index};
Img=imresize(Img,[512 512]);
I=rgb2gray(Img);

% Adaptive Hist Equalization
GR = adapthisteq(I,'NumTiles',[8 8],'ClipLimit',0.01,'Distribution','uniform');

% Gabor filter
M=15;
N=5;
a=(0.4 / 0.05)^(1/(M-1));
count=1;
[JT1]=gabor(M,N,a,count,GR);

% Feature Extraction
feat=hog_vector(JT1); 

% Energy calculation
E=feat.^2;
Energy=(sum(E(:)))/(512*512);

%features set
features = [mean(feat(:)),var(feat(:)),skewness(feat(:)),kurtosis(feat(:)),entropy(feat(:)),Energy];
FeaturesHog(Index,:)=features;
end


group={'Normal';'Normal';'Normal';'Normal';'Normal';'Normal';'Normal';'Normal';'Normal';'Normal';'Normal';'Normal';'Normal';'Normal';'Normal';...
        'Glaucoma';'Glaucoma';'Glaucoma';'Glaucoma';'Glaucoma';'Glaucoma';'Glaucoma';'Glaucoma';'Glaucoma';'Glaucoma';'Glaucoma';'Glaucoma';'Glaucoma';'Glaucoma';'Glaucoma'};
save('FeaturesHog','FeaturesHog');
save('group','group');
