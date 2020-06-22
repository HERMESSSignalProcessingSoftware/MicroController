# -*- coding: utf-8 -*-
"""
Created on Thu Jun 18 17:05:53 2020

Small Datavisualisation tool for STAMPTEst software.

@bug: visualiation buggy, script does not terminate 

@author: Robin Grimsmann
"""
import serial
import numpy as np  
import signal
import sys
from time import sleep

CMD_START = b'\x01'
CMD_EXIT = b'\x02'
BUFFERSIZE = 512
MA_DEPTH = 8
MEASURMENT_DIFF = True
# Change port 
port = "COM10"
baud = 460800

UPDATE_INT = 10
update_cnt = 0
def GetVoltage(value_b):
    """
        Docu comment
        if the measurment is differencial: negativ values are possible, values below 2**12 / 2 = 2048 are likely a negativ value
    """
    value = ToInt(value_b)
    #differecial measurment buggy due to information leak of adc ref voltage for this mode
    if (MEASURMENT_DIFF == True): 
        # Failed, may the value be wrong..
        return (value / 2**12 ) * (3.3)
    else:
        return (value / 2**12 ) * 3.3

def ToInt(value_b):
    if (MEASURMENT_DIFF == True):
        return int.from_bytes(value_b, "little", signed = True)
    else:
        return int.from_bytes(value_b, "little")

def MA(li):
    return np.average(li)

def signal_handler(sig, frame):
    print('You pressed Ctrl+C!')
    if (ser.is_open):
        ser.write(CMD_EXIT)
        ser.close()
    sys.exit(0)

def log(x, values, fvalues):
    rawV = values[-1]
    voltage = MA(values[:i+10])
    average = np.average(fvalues)
    Vmax = np.max(fvalues) 
    Vmax_n = np.max(values)
    Vmin = np.min(fvalues)
    Vmin_n = np.min(values)
    delta = np.abs(np.max(fvalues) - np.min(fvalues))
    info = "##########################################" + \
    "\nV1: {0:.4f} (RAW) (STUFE: {1})" + \
    "\nV1: {2:.4f} (DIFF, MA {3})" + \
    "\nV1: {4:.4f} (Average)" + \
    "\nVmax: {5:.4f} Vmax(non Filterd): {6:.4f}" + \
    "\nVmin: {7:.4f} Vmin(non Filterd): {8:.4f}" + \
    "\n\u0394V: {9}"
    info = info.format( rawV, 0x00000fff & ToInt(x[-2:]),
                        voltage,
                        MA_DEPTH, 
                        average, 
                        Vmax, Vmax_n, 
                        Vmin, Vmin_n, 
                        delta)
    print(info)

signal.signal(signal.SIGINT, signal_handler)

ser = serial.Serial(port, baud)
ser.close()
ser.open()
ser.write(CMD_START)

while(1):
    values = np.array([])
    x = ser.read(BUFFERSIZE)
    for i in range(0, BUFFERSIZE // 2):
        values = np.append(values, GetVoltage(x[i*2:(i+1)*2]))
    fvalues = np.array([])
    for i in range(0, BUFFERSIZE // 2, MA_DEPTH):
        fvalues = np.append(fvalues, MA(values[:i + MA_DEPTH]))
    update_cnt += 1
    if (update_cnt > UPDATE_INT):
        log(x, values, fvalues)
        update_cnt = 0
    #Do not slow this process down, the data will be send continious
    #the pyserial buffer will safe a low of values you may have to wait some time
    #until the values are matching the measurement
    #sleep(0.5)
