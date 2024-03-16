function varargout = UI(varargin)
% UI MATLAB code for UI.fig
%      UI, by itself, creates a new UI or raises the existing
%      singleton*.
%
%      H = UI returns the handle to a new UI or the handle to
%      the existing singleton*.
%
%      UI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in UI.M with the given input arguments.
%
%      UI('Property','Value',...) creates a new UI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before UI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to UI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help UI

% Last Modified by GUIDE v2.5 16-Mar-2024 21:16:09

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @UI_OpeningFcn, ...
                   'gui_OutputFcn',  @UI_OutputFcn, ...
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


% --- Executes just before UI is made visible.
function UI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no outp ut args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to UI (see VARARGIN)

% Choose default command line output for UI
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes UI wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = UI_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

%播放预选音频
% --- Executes on button press in Button1.
function Button1_Callback(hObject, eventdata, handles)
% hObject    handle to Button1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%
%检测是否选择音频，如果没有则出现提示语，同时终止函数                (可复用于其他按钮，检测音频路径的有效性)
if ~isfield(handles,'audioFilePath')
    msgbox('请先选择音频再尝试播放音频。', '提示', 'warn');
    return;
end
% 从共享变量中获取路径信息
audioFilePath=handles.audioFilePath;
[y,Fs]=audioread(audioFilePath);
sound(y,Fs);

%选择音频
% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[filename, pathname] = uigetfile('F:\MATProject\Recording\*.wav', '选择一个音频文件');%更改为相应的路径
audioFilePath = fullfile(pathname, filename);
%存储路径信息到共享变量。将audioFilePath传出去以供其他组件使用
handles.audioFilePath=audioFilePath;
guidata(hObject,handles);
%在静态文本框中显示音频路径
set(handles.text4,'String',audioFilePath);



% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%
%检测是否选择音频，如果没有则出现提示语，同时终止函数                (可复用于其他按钮，检测音频路径的有效性)
if ~isfield(handles,'audioFilePath')
        msgbox('请先选择音频再尝试绘图。', '提示', 'warn');
    return;
end
% 从共享变量中获取路径信息
audioFilePath=handles.audioFilePath;
[y,Fs]=audioread(audioFilePath);
%获得弹出菜单的value值，意为选定了哪一个：时域图or频谱图
v=get(handles.popupmenu1,'value');
if v==1
    %画出时域图
    %fplot(handles.axes1,@sin,[0,2*pi]);
    t = (0:length(y)-1)/Fs; % 时间向量
    plot(t,y);
    xlabel('时间 (s)');
    ylabel('振幅');
    title('时域图');    
elseif v==2
    %画出频谱图
    %fplot(handles.axes1,@sin,[0,4*pi]);
    Y = fft(y);
    L = length(y);
    P2 = abs(Y/L);
    P1 = P2(1:L/2+1);
    P1(2:end-1) = 2*P1(2:end-1);
    f = Fs*(0:(L/2))/L;
    plot(f,P1);
    xlabel('频率 (Hz)');
    ylabel('|P1(f)|');
    title('单边频谱');
    title('频谱图');
end

% --- Executes on selection change in popupmenu1.
function popupmenu1_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu1


% --- Executes during object creation, after setting all properties.
function popupmenu1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


%可编辑文本框，用于显示音频路径
function edit1_Callback(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit1 as text
%        str2double(get(hObject,'String')) returns contents of edit1 as a double


% --- Executes during object creation, after setting all properties.
function edit1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

%录音按钮
% --- Executes on button press in pushbutton4.
function pushbutton4_Callback(hObject, eventdata, handles)
% 创建一个音频录制对象
Recorder=audiorecorder;
%创建一个进度条
WB=waitbar(0,'Recording...');
%开始录音,持续4秒
record(Recorder);
for i=1:4
    pause(1);%暂停一秒
    waitbar(i/4,WB);%更新进度条
end
%停止录制
stop(Recorder);
%关闭进度条
close(WB);
y=getaudiodata(Recorder);
audiowrite('F:\MATProject\Recording\Myrecording.wav',y,Recorder.SampleRate);
%recordblocking(Recorder,4);


% --- Executes on button press in togglebutton1.
function togglebutton1_Callback(hObject, eventdata, handles)
% hObject    handle to togglebutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of togglebutton1

%倒放
% --- Executes on button press in pushbutton5.
function pushbutton5_Callback(hObject, eventdata, handles)
%检测是否选择音频，如果没有则出现提示语，同时终止函数                (可复用于其他按钮，检测音频路径的有效性)
if ~isfield(handles,'audioFilePath')
        msgbox('请先选择音频再尝试倒放。', '提示', 'warn');
    return;
end
% 从共享变量中获取路径信息
audioFilePath=handles.audioFilePath;
[y,Fs]=audioread(audioFilePath);
%准备倒放
y_reversed=flipud(y);
sound(y_reversed,Fs);
audiowrite('F:\MATProject\Recording\Reverse.wav', y_reversed, Fs);

%退出程序
% --- Executes on button press in pushbutton6.
function pushbutton6_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
clear all;
close all;


% --- Executes on slider movement.
function slider2_Callback(hObject, eventdata, handles)
% hObject    handle to slider2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function slider2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on selection change in popupmenu4.
function popupmenu4_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu4 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu4


% --- Executes during object creation, after setting all properties.
function popupmenu4_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

%变速齿轮
% --- Executes on button press in pushbutton7.
function pushbutton7_Callback(hObject, eventdata, handles)
%检测是否选择音频，如果没有则出现提示语，同时终止函数                (可复用于其他按钮，检测音频路径的有效性)
if ~isfield(handles,'audioFilePath')
    msgbox('请先选择音频再尝试倍速播放。', '提示', 'warn');
    return;
end
%得到变速倍率
Speed=get(handles.popupmenu4,'string');%首先获得所有的值
v1=get(handles.popupmenu4,'value');%获得空间上对应的value值
SelectedSpeed=str2double(Speed{v1});

% 从共享变量中获取路径信息
audioFilePath=handles.audioFilePath;
[y,Fs]=audioread(audioFilePath);
sound(y,Fs*SelectedSpeed);
%计算新的采样率
%newFs=Fs*SelectedSpeed;
%用resample函数对音频进行变速播放
%y_resampled=resample(y,newFs,Fs);
%sound(y_resampled,newFs);


% --- Executes on button press in pushbutton8.
function pushbutton8_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
clear sound;


% --- Executes on selection change in popupmenu6.
function popupmenu6_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu6 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu6


% --- Executes during object creation, after setting all properties.
function popupmenu6_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

%变声播放
% --- Executes on button press in pushbutton9.
function pushbutton9_Callback(hObject, eventdata, handles)
%检测是否选择音频，如果没有则出现提示语，同时终止函数                (可复用于其他按钮，检测音频路径的有效性)
if ~isfield(handles,'audioFilePath')
    msgbox('请先选择音频再尝试变声播放。', '提示', 'warn');
    return;
end
% 从共享变量中获取路径信息
audioFilePath=handles.audioFilePath;
[y,Fs]=audioread(audioFilePath);
%得到变声音色选择
% Voice=get(handles.popupmenu6,'string');%获得所有的值
v2=get(handles.popupmenu6,'value');
% SelectedVoice=Voice{v2};
if v2==1
    disp('男声');
elseif v2==2
    disp('女声');
elseif v2==3
%     n1=length(y);
    y1=y(:,1);%转换为单声道
    y1=y1';%转换为行向量
%     geshu=length(y1);
    echolength=20000;%回声延时间隔
    int0=zeros(1,echolength);
    temp1=[y1,int0,int0,int0];%原始声音
    temp2=[int0,0.3*y1,int0,int0];%第一层回声是原始的0.3倍
    temp3=[int0,int0,0.1*y1,int0];%第二层回声是原始的0.1倍
%     temp4=[int0,int0,int0,0.05*y1];
    Echo=temp1+temp2+temp3;
%     NN=length(Echo);
    sound(Echo,Fs);
elseif v2==4
    disp('机器人声');
    y1=y(:,1);  %提取单声道
    f0=pitch(y1,Fs);    %计算每小段的基频
    f0_filtered = f0(f0 <= 350);    %滤掉过高的部分
    f00=mean(f0_filtered);      %平均得到基频
    if f00>205  %判定为女声
        ys=shiftPitch(y,-16);
    elseif f00<205  %判定为男声
        ys=shiftPitch(y,-8);
    end
    sound(ys,Fs);
elseif v2==5
    disp('小黄人声');
    y1=y(:,1);  %提取单声道
    f0=pitch(y1,Fs);    %计算每小段的基频
    f0_filtered = f0(f0 <= 350);    %滤掉过高的部分
    f00=mean(f0_filtered);      %平均得到基频
    if f00>205  %判定为女声
        ys=shiftPitch(y,5);    
    elseif f00<205  %判定为男声
        ys=shiftPitch(y,13); 
    end
    sound(ys,Fs);
elseif v2==6
    disp('空谷传响');
    y1=y;
    %创建混响对象，PD参数是混响开始前的延迟时间，单位为秒，
    reverb=reverberator('PreDelay',0.1,'WetDryMix',1);
    y1=reverb(y1);
    sound(y1,Fs);
elseif v2==7
    disp('电话音');
    factor = 0.2;
    y_s = resample(y, round(Fs * factor), Fs);
    sound(y_s,round(Fs * factor));
%if SelectedVoice=='男性声音'
%    disp('男声');
%elseif SelectedVoice=='女性声音'
%    disp('女声');
%elseif SelectedVoice=='开阔回声'
%    disp('回声');
%elseif SelectedVoice=="机器人声"
%    disp('机器');
%elseif SelectedVoice=="小黄人声"
%    disp('小黄人');
end

%对选中的音频加噪并输出
% --- Executes on button press in pushbutton11.
function pushbutton11_Callback(hObject, eventdata, handles)
%检测是否选择音频，如果没有则出现提示语，同时终止函数                (可复用于其他按钮，检测音频路径的有效性)
if ~isfield(handles,'audioFilePath')
    msgbox('请先选择音频再尝试添加噪声。', '提示', 'warn');
    return;
end
% 从共享变量中获取路径信息
audioFilePath=handles.audioFilePath;
[y,Fs]=audioread(audioFilePath);
v3=get(handles.popupmenu7,'value');
if v3==1
    %添加正弦噪声
    y1=y(:,1);%取单声道
    y1=y1';%列向量变为行向量
    noiseAmplitude = 0.2; % 噪声幅度
    noiseFrequency = 440; % 噪声频率
    Noise = noiseAmplitude * sin(2 * pi * noiseFrequency * (1:length(y)) / Fs);
    yn=y1+Noise;
    sound(yn,Fs);
    audiowrite('F:\MATProject\Recording\AddNoise.wav',yn,Fs);
elseif v3==2
    %添加高斯白噪声
    Noise=randn(size(y));
    yn=y+0.05*Noise;
    sound(yn,Fs);
    audiowrite('F:\MATProject\Recording\AddNoise.wav',yn,Fs);
end


% --- Executes on selection change in popupmenu7.
function popupmenu7_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu7 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu7


% --- Executes during object creation, after setting all properties.
function popupmenu7_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
