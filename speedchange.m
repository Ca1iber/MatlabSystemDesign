function [Y,Fs] = speedchange(y,fs,alpha)
L=length(y);%音频信号长度
N=0.05*fs;%取50ms为每一帧的长度
N=floor(N);
Ha=floor(N*0.25);
Hs=floor(Ha*alpha);
%给定synthesis hopsize-Hs和α来确定analysis hopsize-Ha
tempy=enframe(y,hanning(N),Ha);%分帧加窗，得到每一帧的系数
%Ha为分帧加窗时非重叠部分点数，Hs为重组成新的信号时的非重叠部分点数
%加汉宁窗，减弱音爆（矩形窗会有更严重的信号突变）
nf=fix((L-N+Ha)/Ha);%帧数
y1=zeros(1,(nf-1)*Hs+N);%构造输出信号，新建一个0矩阵用于存放输出信号
%总时长(nf-1)*Hs+N=((L-N+Ha)/Ha-1)*Hs+N=(L-N)*Hs/Ha+N=(L-N)*alpha+Hs
y1(1:N)=tempy(1,:);%第一帧加入输出信号中
for i=1:nf-1
    y1(1+i*Hs:i*Hs+N)=y1(1+i*Hs:i*Hs+N)+tempy(i+1,1:N);%重组成输出信号
end
%用OLA法得到输出信号
Y=y1;
Fs=fs;
end

