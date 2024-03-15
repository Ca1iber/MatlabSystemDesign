[y,Fs]=audioread('F:\MATProject\Recording\DingZhen.wav');

y_s=shiftPitch(y,-8);
sound(y_s,Fs);
%audiowrite("F:\MATProject\Recording\DingZheng.wav",Traudio,frqratio*fs);



%audiowrite('F:\MATProject\Recording\DingZheng.wav',y_r,newFs);