# -*- coding: utf-8 -*-
"""
Created on Thu Jun 18 17:05:53 2020

Small Datavisualisation tool for STAMPTEst software.

@bug: visualiation buggy, script does not terminate 

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
from matplotlib import style

#defines
style.use('ggplot')
CMD_START = b'\x01'
CMD_EXIT = b'\x02'
BUFFERSIZE = 512
RUNNING = False
MEASURMENT_DIFF = False
GLOBAL_EXIT = False 

rawDataLock = Lock()
rawData = b''
rawDataCnt = 0

valueLock = Lock()
values = np.linspace(-5,0)
proc_cnt = 0

port = "COM10"
baud = 460800

DATAPOINTS = 128

#Create Window


def animate(i):
    global values
    #print(values)
    valueLock.acquire()
    start = time.time()
    if (len(values) > DATAPOINTS):
        a.clear()   
        a.plot(np.linspace(-5,5, DATAPOINTS), values[0:DATAPOINTS])
        values = values[DATAPOINTS:]
    end  = time.time() - start
    if (end > 0):
        proc_cnt_str.set("FPS: {0:.1f} Data ahead: {1}".format(1.0 / end, len(values)))
    else:
        proc_cnt_str.set("FPS: #DIVZERO")
    valueLock.release()
   #if (len(values > DATAPOINTS)):
   #    line.set_ydata(values[-:])
   #    values = values[1:]
#defining the serial port
ser = serial.Serial(port, baud)


def GetVoltage(value_b):
    """
        Docu comment
        if the measurment is differencial: negativ values are possible, values below 2**12 / 2 = 2048 are likely a negativ value
    """
    value = ToInt(value_b)
    if (MEASURMENT_DIFF == True):
        faktor = 1
        if (value < 2**11):
            faktor = -1
        return faktor * (value / 2**12 ) * (3.3 / 2)
    else:
        return (value / 2**12 ) * 3.3

def ToInt(value_b):
    return int.from_bytes(value_b, "little")

def MA(li):
    return np.sum(li) / len(li)

def DataGathering(arg):
    global rawData
    global rawDataCnt
    global GLOBAL_EXIT
    global values
    ser.close()
    ser.open()
    print("Hello Form DataGathering!")
    ser.write(CMD_START)
    start_t = time.time()
    while(GLOBAL_EXIT == False):
        x = ser.read(BUFFERSIZE)
        rawDataCnt += 1
        valueLock.acquire()
        values = np.array([])
        for i in range(0, BUFFERSIZE // 2):
            values = np.append(values, GetVoltage(x[i*2:(i+1)*2]))
        value_str.set("V (filterd): {0:.2f} delta V: {1:.2f}".format(MA(values[-10:]), 
                      np.abs(np.max(values) - np.min(values))))
        valueLock.release()    
        cnt_str.set("{0:.2f} bytes/s".format((rawDataCnt * BUFFERSIZE) / (time.time() - start_t)))
        # Generate image and show
    print("Leaving data gathering loop")
    ser.write(CMD_EXIT)
    ser.close()

def DataProcessing(arg):
    
    pass

            
                        
            
t = threading.Thread(target=DataGathering, args=(0,))
# content of the button = start
def startMeasurment():
    global GLOBAL_EXIT
    global RUNNING
    global t
    t = threading.Thread(target=DataGathering, args=(0,))
    t2 = threading.Thread(target=DataProcessing, args=(0,))  
    if (start_Str.get() == "Start"):
        start_Str.set("Stop")
        GLOBAL_EXIT = False
        t.start()
        #t2.start()
       # t3.start()
    else:
        start_Str.set("Start")
        GLOBAL_EXIT = True
        
        t.join()
        #t2.join()
       # t3.join()
        RUNNING = False

def cancle():
    global GLOBAL_EXIT
    global values
    global t
    values = np.array([])
    GLOBAL_EXIT = True
    start_Str.set("Start")
    if RUNNING == True:
        t.join()
        #t2.join()
        #t3.join()

def onExit():
    global top
    cancle()
    top.destroy()


top = Tk.Tk()
top.title("Measurement")
top.geometry("1000x800")

fig = Figure(figsize=(16,9), dpi=100)
a = fig.add_subplot(111)
a.clear()
line, = a.plot(np.linspace(-5,5, DATAPOINTS), np.linspace(0,0,DATAPOINTS))

value_str = Tk.StringVar()
value_str.set("#WERT")
cnt_str = Tk.StringVar()
cnt_str.set("#WERT")
proc_cnt_str = Tk.StringVar()
proc_cnt_str.set("#WERT")

label = Tk.Label(top,textvariable="Scope").pack(pady=10, padx=10)
label1 = Tk.Label(top,textvariable=value_str).pack()
label2 = Tk.Label(top,textvariable=cnt_str).pack()
label3 = Tk.Label(top,textvariable=proc_cnt_str).pack()


start_Str = Tk.StringVar()
start_Str.set("Start")
              
button_start = Tk.Button(top, textvariable=start_Str, command = lambda: startMeasurment()).pack()

button_trigger = Tk.Button(top, text="Trigger")

canvas = FigureCanvasTkAgg(fig, master=top)
canvas.get_tk_widget().pack(side=Tk.TOP, fill=Tk.BOTH, expand=1)

#Darstellung Buggy, stützt laufend ab. keine Ahnung warum. Bei Messbrücke sollte das aber egal sein.
#ani = animation.FuncAnimation(fig, animate, interval=1000)

top.bind("<Return>", lambda e: startMeasurment())
top.bind('<Escape>', lambda e: cancle())
#top.bind('<Enter>', lambda e: startMeasurment())
top.protocol("WM_DELETE_WINDOW", onExit)


top.mainloop()

        