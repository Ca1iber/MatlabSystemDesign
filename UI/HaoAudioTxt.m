function txt = HaoAudioTxt(m4AFilename)
%����
global url_use
if isempty(url_use)==1  %���ȫ�ֱ����Ƿ�Ϊ��
    api_id = 'eRNXDN8qnn9PPAXMTUa98N3y'; % ���Լ���api_id
    secret_key = 'tqYobupqGHJUFjAqCxtEh9lDL0vBxo6k'; % ���Լ���secret_key
    url_0 = ['https://openapi.baidu.com/oauth/2.0/token?grant_type=client_credentials&client_id=',api_id,'&client_secret=',secret_key]; %������һ�� URL��ʹ���ṩ��ƾ�ݴӰٶȻ�ȡ�������ơ�
    url_cont = webread(url_0);  %ʹ�� webread ���ø� URL �����������ƴ洢�� url_use ȫ�ֱ����С�
    url_use = url_cont.access_token;
end

url= 'http://vop.baidu.com/server_api';

[y,Fs] = audioread(m4AFilename);
[P,Q] = rat(16000/Fs);  %�������²������� (P �� Q) ����Ƶת��Ϊ 16000 Hz �Ĳ�����
y = resample(y,P,Q);    %�ز������²�����
Fs = 16000;
wavFilename = 'WavFile.wav';
audiowrite(wavFilename,y,Fs);

%ʹ�ø������� base64file �� WAV �ļ�����ת��Ϊ base64 �����ַ��� (base64string) ���䳤�� (base64string_len)��
[base64string,base64string_len] = base64file('WavFile.wav');
options = weboptions('RequestMethod', 'post','HeaderFields',{ 'Content-Type','application/json'});
options.Timeout =20;
m = struct; %����һ���ṹ
m.format = 'wav';   %ָ����Ƶ��ʽ
m.lan = 'zh';       %ָ������Ϊ����
m.token = url_use;  %֮ǰ��õķ������� (url_use)
m.len = base64string_len;   %������Ƶ�ַ����ĳ���
m.rate = 16000;     %������
m.speech = base64string;    %������Ƶ�ַ���
m.cuid = 'test';    %�Զ����û� ID
m.channel = 1;      %���赥������Ƶ
Content = webwrite(url,m,options);  %�� POST �����͵��ٶ�����ʶ�� API URL�������������ѡ������� (m)��
if isfield(Content,'result')    %�����Ӧ (Content) �Ƿ������Ϊ ��result�� ���ֶ�
    txt = Content.result{:};    %����Ӧ�� ��result�� �ֶ�����ȡʶ������ı� (txt)
else
    txt = '';                   %������ı� (txt) ����Ϊ���ַ�����
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