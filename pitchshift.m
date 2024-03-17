function y=pitchshift(x,Fs,shift)
%x:输入音频信号
%Fs:采样率
%shift:移调量，负数降调、正数升调
if shift == 0
    y=x;
    return;
end

%计算移动的样本数
nShift=round(abs(shift)*length(x)/Fs);

%对输入信号进行STFT分析
wlen=round(50e-3*Fs);%窗口长度为50ms
hop=round(wlen/2);%帧移为窗口长度一半
nfft=2^nextpow2(wlen);%FFT点数为窗口长度的2次幂
[S,F,T]=spectrogram(x,wlen,hop.nfft,Fs);

%对STFT系数进行移调
if shift>0
    S_shift=interp1(F,S,F*(2^(shift/12)),'spline',0);
else
    S_shift=interp1(F,S,F/(2^(-shift/12)),'spline',0);
end

%合成移调后的信号
y=zeros(length(x)+nShift,1);
for i=1:size(S_shift,2)
    y((i-1)*hop+1+nShift/2:(i-1)*hop+wlen+nShift/2)=...
        y((i-1)*hop+1+nShift/2:(i-1)*hop+wlen+nShift/2)+...
        real(ifft(S_shift(:,i),nfft));
end
y=y(wlen+1:end-nfft);
end


