from tkinter import *
from tkinter import messagebox

root=Tk()

root.title("MyMy")
root.geometry("500x300+500+200")    #长500宽300 离屏幕左端500像素，上端200像素
btn01=Button(root)
btn01["text"]="Hello"
btn01.pack()

def greetings(e):
    messagebox.showinfo("Message","hey there")

btn01.bind("<Button-1>",greetings)

root.mainloop()