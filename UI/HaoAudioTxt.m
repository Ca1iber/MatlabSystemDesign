function txt = HaoAudioTxt(m4AFilename)
%”Ô“Ù
global url_use
if isempty(url_use)==1
    api_id = 'eRNXDN8qnn9PPAXMTUa98N3y'; % Replace the api key
    secret_key = 'tqYobupqGHJUFjAqCxtEh9lDL0vBxo6k'; % Replace the secret key
    url_0 = ['https://openapi.baidu.com/oauth/2.0/token?grant_type=client_credentials&client_id=',api_id,'&client_secret=',secret_key];
    url_cont = webread(url_0);
    url_use = url_cont.access_token;
end

url= 'http://vop.baidu.com/server_api';

[y,Fs] = audioread(m4AFilename);
[P,Q] = rat(16000/Fs);
y = resample(y,P,Q);
Fs = 16000;
wavFilename = 'WavFile.wav';
audiowrite(wavFilename,y,Fs);

[base64string,base64string_len] = base64file('WavFile.wav');
options = weboptions('RequestMethod', 'post','HeaderFields',{ 'Content-Type','application/json'});
options.Timeout =20;
m = struct;
m.format = 'wav';
m.lan = 'zh';
m.token = url_use;
m.len = base64string_len;
m.rate = 16000;
m.speech = base64string;
m.cuid = 'test';
m.channel = 1;
Content = webwrite(url,m,options);
if isfield(Content,'result')
    txt = Content.result{:};
else
    txt = '';
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