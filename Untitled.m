[y, Fs] = audioread('F:\MATProject\Recording\ZhanDouShuang.wav');
p=audioplayer(y,Fs);
play(p);
y=y(:,1);
y=y';
noiseAmplitude = 0.2; % 噪声幅度
noiseFrequency = 440; % 噪声频率
noise = noiseAmplitude * sin(2 * pi * noiseFrequency * (1:length(y)) / Fs);
yn = y + noise;
sound(yn, Fs);