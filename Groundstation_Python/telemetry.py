import serial
import signal
import time
import SPUStatus

DEFAULT_PORT = "COM5"
DEFAULT_BAUD = 19200
TELEMETRY_FRAME_SIZE = 60

run = True 

def SignalHandler(sig, frame):
    global run 
    run = False 

def FillHex(value, length):
    hexStr = str(hex(value))[2:]
    if (len(hexStr) < length):
       for i in range( length - len(hexStr)):
           hexStr = "0" + hexStr
    return hexStr

def Hexdump(buffer):
    offset = 0
    counter = 0
    line = ""
    byteStr = ""
    for i in range(len(buffer)):
        byteStr = byteStr + FillHex(buffer[i], 2) + " "
        counter = counter + 1
        if (counter == 16):
            line = FillHex(offset, 6) + " " + byteStr 
            byteStr  = ""
            offset = offset + 16
            counter = 0
            print(line)
    line = FillHex(offset, 6) + " " + byteStr 
    print(line)

def EvalBuffer(buffer):
    telemetry = SPUStatus.Telemetry()
    telemetry.ParseBuffer(buffer)
    telemetry.Print()
       


signal.signal(signal.SIGINT, SignalHandler)

ser = serial.Serial(DEFAULT_PORT, DEFAULT_BAUD)
ser.close()
ser.open()
ser.reset_input_buffer()

start = time.time()
while (run):
    rx = ser.read(TELEMETRY_FRAME_SIZE)
    Hexdump(rx)
    EvalBuffer(rx)

ser.close()
print("Terminated! Runtime:{:02f}min".format((time.time() - start) / 60))


