function txt = HaoAudioTxt(m4AFilename)
%语音
global url_use
if isempty(url_use)==1  %检查全局变量是否为空
    api_id = 'eRNXDN8qnn9PPAXMTUa98N3y'; % 我自己的api_id
    secret_key = 'tqYobupqGHJUFjAqCxtEh9lDL0vBxo6k'; % 我自己的secret_key
    url_0 = ['https://openapi.baidu.com/oauth/2.0/token?grant_type=client_credentials&client_id=',api_id,'&client_secret=',secret_key]; %构造了一个 URL，使用提供的凭据从百度获取访问令牌。
    url_cont = webread(url_0);  %使用 webread 调用该 URL 并将访问令牌存储在 url_use 全局变量中。
    url_use = url_cont.access_token;
end

url= 'http://vop.baidu.com/server_api';

[y,Fs] = audioread(m4AFilename);
[P,Q] = rat(16000/Fs);  %计算重新采样比率 (P 和 Q) 将音频转换为 16000 Hz 的采样率
y = resample(y,P,Q);    %重采样更新采样率
Fs = 16000;
wavFilename = 'WavFile.wav';
audiowrite(wavFilename,y,Fs);

%使用辅助函数 base64file 将 WAV 文件内容转换为 base64 编码字符串 (base64string) 及其长度 (base64string_len)。
[base64string,base64string_len] = base64file('WavFile.wav');
options = weboptions('RequestMethod', 'post','HeaderFields',{ 'Content-Type','application/json'});
options.Timeout =20;
m = struct; %定义一个结构
m.format = 'wav';   %指定音频格式
m.lan = 'zh';       %指定语言为中文
m.token = url_use;  %之前获得的访问令牌 (url_use)
m.len = base64string_len;   %编码音频字符串的长度
m.rate = 16000;     %采样率
m.speech = base64string;    %编码音频字符串
m.cuid = 'test';    %自定义用户 ID
m.channel = 1;      %假设单声道音频
Content = webwrite(url,m,options);  %将 POST 请求发送到百度语音识别 API URL，并附带构造的选项和数据 (m)。
if isfield(Content,'result')    %检查响应 (Content) 是否包含名为 “result” 的字段
    txt = Content.result{:};    %从响应的 “result” 字段中提取识别出的文本 (txt)
else
    txt = '';                   %则将输出文本 (txt) 设置为空字符串。
end
end

function [base64string,base64string_len] = base64file(file)
fid = fopen(file,'rb');
bytes = fread(fid);
fclose(fid);
base64string_len = size(bytes,1);
encoder = org.apache.commons.codec.binary.Base64;
base64string = char(encoder.encode(bytes))';
end