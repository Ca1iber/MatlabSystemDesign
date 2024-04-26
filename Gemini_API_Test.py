import pathlib
import textwrap

import google.generativeai as genai
import scipy.io as sio

y=sio.loadmat('tempQuestion.mat')
quest=y['a']
print(quest)

from IPython.display import display
from IPython.display import Markdown

def to_markdown(text):
  text = text.replace('•', '  *')
  return Markdown(textwrap.indent(text, '> ', predicate=lambda _: True))

genai.configure(api_key='AIzaSyAW0h89VMsY5LH_M9bcRSwMl69H8y1EAio',transport="rest")
for m in genai.list_models():
  if 'generateContent' in m.supported_generation_methods:
    print(m.name)
model = genai.GenerativeModel('gemini-pro')
response = model.generate_content(quest)
print(response.text)
bb=response.text
answer=bb
# sio.savemat('Answer.mat',{'answer':answer})
with open('an.txt','w') as f:
  f.write(answer)









# print(answer)











# print(type(response.text))






