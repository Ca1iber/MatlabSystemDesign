FilePath='F:\MATProject\Recording\CXK.wav';
% [y,Fs]=audioread(FilePath);
[y, Fs] = audioread(FilePath);

L = Fs/1000 * 20;       %计算帧长，以20毫秒为单位
Nfft = L;               %设置FFT长度为帧长。
S = L/2;                %设置帧移，这里是50%的重叠，即10毫秒。
win = hanning (L, 'periodic');  %周期汉宁窗
delta = round(Fs/1000 * 5);    %分析帧与参考帧之间的偏移量，通常为44.1*5=220.5，每帧移动220个样本
TSR = 1.25;             %拉伸长度>1放慢，<1加快
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