function varargout = HOG(varargin)
% HOG M-file for HOG.fig
%      HOG, by itself, creates a new HOG or raises the existing
%      singleton*.
%
%      H = HOG returns the handle to a new HOG or the handle to
%      the existing singleton*.
%
%      HOG('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in HOG.M with the given input arguments.
%
%      HOG('Property','Value',...) creates a new HOG or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before HOG_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to HOG_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help HOG

% Last Modified by GUIDE v2.5 02-Apr-2017 01:45:51

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @HOG_OpeningFcn, ...
                   'gui_OutputFcn',  @HOG_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before HOG is made visible.
function HOG_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to HOG (see VARARGIN)
imshow([255 255 255;255 255 255;255 255 255]);
% Choose default command line output for HOG
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes HOG wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = HOG_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
clc;
for Index=1:30
name = sprintf('%d.jpg',Index); 
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
set(handles.Disp, 'String', 'Feature Extraction Complete');


% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
load group;
load FeaturesHog;
wxtrain=[FeaturesHog(:,2),FeaturesHog(:,4)];
wSVMStruct = svmtrain(wxtrain,group,'kernel_function','polynomial','Polyorder',12,'showplot',true);
save('wSVMStruct','wSVMStruct');
set(handles.Disp, 'String', 'SVM Train Complete');


% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
load group;
load FeaturesHog;
wxtrain=[FeaturesHog(:,2),FeaturesHog(:,4)];
wNB = NaiveBayes.fit(wxtrain,group,'dist','normal');
save('wNB','wNB');
set(handles.Disp, 'String', 'Naive Bayes Train Complete');


% --- Executes on button press in pushbutton4.
function pushbutton4_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[filename pathname] = uigetfile({'*.jpg'},'File Selector');
Image = strcat(pathname, filename);
A=double(filename(1:2))-48;

if A(2)>=0
   Index=A(1)*10+A(2);
else
   Index=A(1);
end
load FeaturesHog;
wtest=[FeaturesHog(Index,2),FeaturesHog(Index,4)];
save ('wtest','wtest');
imshow(Image);
set(handles.Disp, 'String', 'Input Image');


% --- Executes on button press in pushbutton5.
function pushbutton5_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
load wSVMStruct;
load wtest;
wspecies_svm = svmclassify(wSVMStruct,wtest);
set(handles.Disp, 'String', wspecies_svm);



% --- Executes on button press in pushbutton6.
function pushbutton6_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
load wNB;
load wtest;
[post,wspecies_nb]=posterior(wNB,wtest);
set(handles.Disp, 'String', wspecies_nb);

% --- Executes during object creation, after setting all properties.
function Disp_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Disp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
