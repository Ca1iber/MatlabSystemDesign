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

% Last Modified by GUIDE v2.5 04-Apr-2024 20:53:53

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

function UI_OpeningFcn(hObject, eventdata, handles, varargin)

handles.output = hObject;

guidata(hObject, handles);


function varargout = UI_OutputFcn(hObject, eventdata, handles) 

varargout{1} = handles.output;

%播放预选音频

function Button1_Callback(hObject, eventdata, handles)
%检测是否选择音频，如果没有则出现提示语，同时终止函数                (可复用于其他按钮，检测音频路径的有效性)
if ~isfield(handles,'audioFilePath')
    msgbox('请先选择音频再尝试播放音频。', '提示', 'warn');
    return;
end
% 从共享变量中获取路径信息
audioFilePath=handles.audioFilePath;
[y,Fs]=audioread(audioFilePath);
sound(y,Fs);
% set(hObject,'String','暂停');


%选择音频

function pushbutton2_Callback(hObject, eventdata, handles)
[filename, pathname] = uigetfile('F:\MATProject\Recording\*.wav', '选择一个音频文件');%更改为相应的路径
audioFilePath = fullfile(pathname, filename);
%存储路径信息到共享变量。将audioFilePath传出去以供其他组件使用
handles.audioFilePath=audioFilePath;
guidata(hObject,handles);
%在静态文本框中显示音频路径
set(handles.text4,'String',audioFilePath);

function pushbutton3_Callback(hObject, eventdata, handles)
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
    plot(handles.axes1,t,y);
    xlabel(handles.axes1,'时间 (s)');
    ylabel(handles.axes1,'振幅');
    title(handles.axes1,'时域图');    
elseif v==2
    %画出频谱图
    %fplot(handles.axes1,@sin,[0,4*pi]);
    Y = fft(y);
    L = length(y);
    P2 = abs(Y/L);
    P1 = P2(1:L/2+1);
    P1(2:end-1) = 2*P1(2:end-1);
    f = Fs*(0:(L/2))/L;
    plot(handles.axes1,f,P1);
    xlabel(handles.axes1,'频率 (Hz)');
    ylabel(handles.axes1,'|P1(f)|');
    title(handles.axes1,'频谱图');
end

% --- Executes on selection change in popupmenu1.
function popupmenu1_Callback(hObject, eventdata, handles)
function popupmenu1_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

%可编辑文本框，用于显示音频路径
function edit1_Callback(hObject, eventdata, handles)

function edit1_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
%录音按钮
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
warning('off', 'all');
delete('F:\MATProject\Recording\AddNoise.wav');
warning('on', 'all');
close all;


% --- Executes on slider movement.
function slider2_Callback(hObject, eventdata, handles)

function slider2_CreateFcn(hObject, eventdata, handles)


if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

function popupmenu4_Callback(hObject, eventdata, handles)


function popupmenu4_CreateFcn(hObject, eventdata, handles)

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
SelectedSpeed=str2double(Speed{v1});%选中的变速倍率

% 从共享变量中获取路径信息
audioFilePath=handles.audioFilePath;
[y,Fs]=audioread(audioFilePath);
% sound(y,Fs*SelectedSpeed);

%%WSOLA实现变速不变调部分
L = Fs/1000 * 20;       %计算帧长，以20毫秒为单位
Nfft = L;               %设置FFT长度为帧长。
S = L/2;                %设置帧移，这里是50%的重叠，即10毫秒。
win = hanning (L, 'periodic');  %周期汉宁窗
delta = round(Fs/1000 * 5);    %分析帧与参考帧之间的偏移量，通常为44.1*5=220.5，每帧移动220个样本
TSR = 1/SelectedSpeed;             %拉伸长度>1放慢，<1加快
Sout = S;               %输出帧移
Sin = round(Sout/TSR);  %输入帧移

pin=0; pout=0; nseg = 1; %初始化输出输入位置
inlen = length(y);          %ez
outlen = ceil(TSR*inlen+delta); %计算输出信号的长度
output_signal = zeros(outlen,1);%初始化输出信号
synthesis_frame = zeros(L,1);%初始化合成帧
deltas = [];                %用于存储delta的数组
output_signal(pout+1:pout+L) = y(pin+1:pin+L);%将输入信号的一部分复制到输出信号中。
pref = pin + Sout;                              %更新输入和输出的位置。
pin = pin + Sin;                                %|
pout = pout + Sout;                             %更新输入和输出的位置。

while ( (pref + L) < inlen ) && ( (pin+L+delta) < inlen )    %开始主要的处理循环，直到输入信号处理完毕。
    reference_frame = y(pref+1:pref+L);                      %获取参考帧
    analysis_frame = y(pin+1-delta:pin+L+delta);             %获取分析帧，加上了delta。
    [ xc, lags ] = xcorr(analysis_frame, reference_frame, 2*delta);%计算分析帧和参考帧的互相关。
    aligned = 2*delta+1;                                    %选择相关结果中的合适部分。
    xc_delta = xc(aligned:aligned+2*delta);                 
    [ ~, i ] = max(abs(xc_delta));                          %找到互相关最大值的索引。

    xc_rms = rms(buffer(analysis_frame(1:L+2*delta),L,L-1,'nodelay'));%计算帧的均方根。
    [ ~, i ] = max(abs(xc_delta./xc_rms')); %使用归一化的互相关结果找到最大值的索引。
    idx = i-1;                              %得到delta。
    deltas = [ deltas idx ];                %将delta添加到数组中。
    synthesis_frame = analysis_frame(idx+1:idx+L);%将根据delta选择合成帧。
	output_signal(pout+1:pout+L) = ...      %
        output_signal(pout+1:pout+L) + synthesis_frame .* win;  %将合成帧加到输出信号中。 
    pref = pin - delta + idx + Sout;    %更新输入和输出的位置。
    pin = pin + Sin;    
    pout = pout + Sout;
    nseg = nseg + 1;    %增加片段计数器。
end

n_seg = nseg - 1;   %计算片段数

sound(output_signal(1:outlen),Fs);
%% --- Executes on button press in pushbutton8.
function pushbutton8_Callback(hObject, eventdata, handles)

clear sound;

function popupmenu6_Callback(hObject, eventdata, handles)

function popupmenu6_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white','BorderRadius',10);
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

% --- Executes on button press in edit1.
function pushbutton11_Callback(hObject, eventdata, handles)


function edit2_Callback(hObject, eventdata, handles)


function edit2_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton12.
function pushbutton12_Callback(hObject, eventdata, handles)
min = str2num(get(handles.edit1,'String'));
max = str2num(get(handles.edit2,'String'));
if isempty(get(handles.edit1,'String'))
    msgbox('请输入滤波器下限频率（Hz）','确认','error');
end
if isempty(get(handles.edit2,'String'))
    msgbox('请输入滤波器上限频率(Hz)','确认','error');
end
if (isempty(min) && ~isempty(get(handles.edit1,'String')))
    msgbox('小淘气，请输入数字','确认','error');
end
if (isempty(max) && ~isempty(get(handles.edit2,'String')))
    msgbox('小淘气，请输入数字','确认','error');
end
if (min>= max)
    msgbox('小淘气，分不清大小吗','确认','error');
end
if (~(isempty(min) || isempty(max)) && min < max)
% 设计带通滤波器
% 使用butter函数设计N阶带通滤波器，'bandpass'指定为带通
%检测是否选择音频，如果没有则出现提示语，同时终止函数                (可复用于其他按钮，检测音频路径的有效性)
if ~isfield(handles,'audioFilePath')
    msgbox('请先选择音频再尝试滤波。', '提示', 'warn');
    return;
end
% 从共享变量中获取路径信息
audioFilePath=handles.audioFilePath;
[y,Fs]=audioread(audioFilePath);
N = 4; % 滤波器的阶数，可根据需要调整
[b, a] = butter(N, [min, max] / (Fs / 2), 'bandpass');

% 应用滤波器到音频信号
filteredAudio = filter(b, a, y);
sound(filteredAudio,Fs)
% 或使用filtfilt进行零相位滤波处理
% filteredAudio = filtfilt(b, a, audioData);
end




% --- Executes on selection change in popupmenu8.
function popupmenu8_Callback(hObject, eventdata, handles)


% --- Executes during object creation, after setting all properties.
function popupmenu8_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton13.
function pushbutton13_Callback(hObject, eventdata, handles)
%检测是否选择音频，如果没有则出现提示语，同时终止函数                (可复用于其他按钮，检测音频路径的有效性)
if ~isfield(handles,'audioFilePath')
    msgbox('请先选择音频再尝试添加噪声。', '提示', 'warn');
    return;
end
% 从共享变量中获取路径信息
audioFilePath=handles.audioFilePath;
[y,Fs]=audioread(audioFilePath);
v3=get(handles.popupmenu8,'value');
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
    handles.NoiseFilePath='F:\MATProject\Recording\AddNoise.wav';
    guidata(hObject,handles);
    %存储路径信息到共享变量。将NoiseFilePath传出去以供其他组件使用
%     handles.audioFilePath=audioFilePath;
%     guidata(hObject,handles);
elseif v3==2
    %添加高斯白噪声
    Noise=randn(size(y));
    yn=y+0.05*Noise;
    sound(yn,Fs);
    audiowrite('F:\MATProject\Recording\AddNoise.wav',yn,Fs);
    handles.NoiseFilePath='F:\MATProject\Recording\AddNoise.wav';
    guidata(hObject,handles);
end

% --- Executes on selection change in popupmenu9.
function popupmenu9_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu9 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu9


% --- Executes during object creation, after setting all properties.
function popupmenu9_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

%加噪信号绘图
% --- Executes on button press in pushbutton15.
function pushbutton15_Callback(hObject, eventdata, handles)
%检测是否选择音频，如果没有则出现提示语，同时终止函数                (可复用于其他按钮，检测音频路径的有效性)
if ~isfield(handles,'NoiseFilePath')
    msgbox('请先选择音频再尝试添加噪声。', '提示', 'warn');
    return;
end
% 从共享变量中获取路径信息
NoiseFilePath=handles.NoiseFilePath;
[y,Fs]=audioread(NoiseFilePath);
v=get(handles.popupmenu9,'value');
if v==1
    t = (0:length(y)-1)/Fs; % 时间向量
    plot(handles.axes3,t,y);
    xlabel(handles.axes3,'时间 (s)');
    ylabel(handles.axes3,'振幅');
    title(handles.axes3,'加噪时域图'); 
elseif v==2
    Y = fft(y);
    L = length(y);
    P2 = abs(Y/L);
    P1 = P2(1:L/2+1);
    P1(2:end-1) = 2*P1(2:end-1);
    f = Fs*(0:(L/2))/L;
    plot(handles.axes3,f,P1);
    xlabel(handles.axes3,'频率 (Hz)');
    ylabel(handles.axes3,'|P1(f)|');
    title(handles.axes3,'加噪频谱图');
end



%测试
% --- Executes on button press in pushbutton16.
function pushbutton16_Callback(hObject, eventdata, handles)
%检测是否选择音频，如果没有则出现提示语，同时终止函数                (可复用于其他按钮，检测音频路径的有效性)
if ~isfield(handles,'audioFilePath')
    msgbox('请先选择音频再尝试语音文字转换。', '提示', 'warn');
    return;
end
% 从共享变量中获取路径信息
audioFilePath=handles.audioFilePath;
[y,Fs]=audioread(audioFilePath);
% sound(y,Fs);
ext=HaoAudioTxt(audioFilePath);
Text=['识别结果："',ext,'"'];
disp(Text);
set(handles.text7,'String',Text);



% --- Executes on button press in pushbutton17.
function pushbutton17_Callback(hObject, eventdata, handles)
% 创建一个音频录制对象
Recorder=audiorecorder;
%创建一个进度条
WB=waitbar(0,'Recording...');
%开始录音,持续4秒
record(Recorder);
for i=1:3
    pause(1);%暂停一秒
    waitbar(i/3,WB);%更新进度条
end
%停止录制
stop(Recorder);
%关闭进度条
close(WB);
y=getaudiodata(Recorder);
audiowrite('F:\MATProject\Recording\4Trans.wav',y,Recorder.SampleRate);
ext=HaoAudioTxt('F:\MATProject\Recording\4Trans.wav');
Text=['识别结果："',ext,'"'];
disp(Text);
set(handles.text7,'String',Text);




%打开文字转语音API
function pushbutton18_Callback(hObject, eventdata, handles)
disp('打开');
winopen('F:\GPT_SoVITS\GPT-SoVITS-beta0217\go-inferencewebui1.bat');
