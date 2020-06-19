# -*- coding: utf-8 -*-
"""
Created on Thu Jun 18 17:05:53 2020

@author: Robin Grimsmann
"""

import serial  
import numpy as np
from multiprocessing import Process, Pool, Lock 
import threading
import time
from matplotlib.backends.backend_tkagg import FigureCanvasTkAgg
from matplotlib.figure import Figure
import tkinter as Tk
import matplotlib.pyplot as plt
import matplotlib.animation as animation
from PIL import ImageTk, Image
port = "COM10"
baud = 460800

ser = serial.Serial(port, baud)

CMD_START = b'\x01'
BUFFERSIZE = 4096
 
MEASURMENT_DIFF = True
GLOBAL_EXIT = False 

rawDataLock = Lock()
rawData = b'\x00'
rawDataCnt = 0

valueLock = Lock()
values = np.array([])

top = Tk.Tk()
top.title("Measurement")
top.geometry("1000x800")

fig = plt.Figure()

x = np.arange(0, 2*np.pi, 0.01)        # x-array


def GetVoltage(value_b):
    """
        Docu comment
        if the measurment is differencial: negativ values are possible, values below 2**12 / 2 = 2048 are likely a negativ value
    """
    value = int.from_bytes(value_b, "little")
    if (MEASURMENT_DIFF == True):
        faktor = 1
        if (value < 2**11):
            faktor = -1
        return faktor*(value /2**12 ) * (3.3 / 2)
    else:
        return (value /2**12 ) * 3.3

def animate(i):
    valueLock.acquire()
    line.set_ydata(values[i])  # update the data
    valueLock.release()
    return line,

def DataGathering():
    ser.close()
    ser.open()
    ser.write(CMD_START)
    while(GLOBAL_EXIT == False):
        x = ser.read(BUFFERSIZE)
        rawDataLock.acquire()
        rawData = rawData + x
        rawDataCnt += 1
        rawDataLock.release()
            

def DataProcessing():
    while(GLOBAL_EXIT == False):
        rawDataLock.acquire()
        localdata = b''
        if (rawDataCnt >= 1):
            localdata = rawData[0:BUFFERSIZE]
            rawDataCnt -= 1
        rawDataLock.relase()
        valueLock.acquire()
        for i in range(BUFFERSIZE // 2):
            values = np.append(values, GetVoltage(localdata[i*2:(i+1)*2]))
        valueLock.release()
        
# content of the button = start
def startMeasurment():
    if (start_Str.get() == "Start"):
        start_Str.set("Stop")
        t = threading.Thread(target=DataGathering, args=none)
        t2 = threading.Thread(target=DataProcessing, args=none)
        t.join()
        t2.join()
    else:
        start_Str.set("Start")
    

label = Tk.Label(top,text="Scope").grid(column=0, row=0)

canvas = FigureCanvasTkAgg(fig, master=top)
canvas.get_tk_widget().grid(column=1,row=1)

start_Str = Tk.StringVar()
start_Str.set("Start")
button_start = Tk.Button(top, textvariable=start_Str, command = startMeasurment).grid(column=0,row=2)

button_trigger = Tk.Button(top, text="Trigger", command = startMeasurment).grid(column=1,row=2)
ax = fig.add_subplot(111)
line, = ax.plot(np.linspace(0,1,40))
ani = animation.FuncAnimation(fig, animate, np.arange(1, BUFFERSIZE // 2), interval=1, blit=False)


top.mainloop()

        