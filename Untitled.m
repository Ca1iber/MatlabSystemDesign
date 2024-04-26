a='你叫什么名字呀';
save('tempQuestion','a');
system('python Gemini_API_Test.py');

% dataaa=load('text.pkl');
% b=dataaa.bb;
% disp(b);

datat=load('TempData.mat');
ans=datat.a;
disp(ans);

b=fileread('an.txt');
disp(b);