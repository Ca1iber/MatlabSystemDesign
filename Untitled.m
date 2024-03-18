% 读取音频文件
[y, Fs] = audioread('F:\MATProject\Recording\ZhanDouShuang.wav');

% 获取音频数据的第一个声道
data = y(:, 1);

% 计算基音频率
f0 = pitch(data, Fs);

% 排除基音频率小于75Hz和大于350Hz的部分
f0_filtered = f0(f0 <= 350);

% 绘制基音频率曲线
plot(f0_filtered)

% 显示基音频率统计信息
disp(['平均基音频率：' num2str(mean(f0_filtered)) ' Hz'])
disp(['最大基音频率：' num2str(max(f0_filtered)) ' Hz'])
disp(['最小基音频率：' num2str(min(f0_filtered)) ' Hz'])

% ff=pitch(y,Fs);
% disp(ff)
% man_or_woman('F:\MATProject\Recording\Genshin.wav');