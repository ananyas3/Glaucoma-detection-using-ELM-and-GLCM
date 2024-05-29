clc
clear all
close all

file_g = dir('D:\7th sem\7 Project\AI imgs\Glaucomatous eye images\*.jpg');
file_n = dir('D:\7th sem\7 Project\AI imgs\Normal eye\*.jpg');

file = [file_g ; file_n];

b_label = zeros(length(file),1);

% for i = 1:length(group)
%     b_label(1:149,1) = 
% end

