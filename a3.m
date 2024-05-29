clc;
clear all
close all;

%Input Image
I = imread('08_g.jpg');
figure;imshow(I)

Img=imresize(I,[512 512]);
figure;imshow(Img)

%RGB 2 gray
Ir=rgb2gray(Img);
figure;imshow(Ir)

GR = adapthisteq(Ir);
figure;imshow(GR)

GR1 = adapthisteq(Ir,'NumTiles',[8 8],'ClipLimit',0.5,'Distribution','uniform');
figure;imshow(GR1)

% Gabor filter
M=15;
N=5;
a=(0.4 / 0.05)^(1/(M-1));
count=1;
[JT1]=gabor(M,N,a,count,GR);
figure;imshow(uint8(JT1))

% Feature Extraction
feat=hog_vector(JT1); 

% Energy calculation
E=feat.^2;
Energy=(sum(E(:)))/(512*512);

%features set
features = [mean(feat(:)),var(feat(:)),skewness(feat(:)),kurtosis(feat(:)),entropy(feat(:)),Energy];
