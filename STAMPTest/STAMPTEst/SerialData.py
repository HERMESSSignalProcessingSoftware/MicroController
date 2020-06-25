import serial
import pickle 
import time
import numpy as np

COM = "COM10"
BAUD = 460800

CMD_START = b'\x01'
CMD_END = b'\x02'

BUFFER = 512

supply = 3.3

def Voltage(stufe):
    return (stufe / 2**12) * supply

def ToInt(byte_d):
    return int.from_bytes(byte_d, "little")

ser = serial.Serial(COM, BAUD)
ser.close()
ser.open()
#ser.write(CMD_START)
#x = ser.read(512)
#values = []
#voltages = []
#for i in range(BUFFER // 2):
#    v = x[i*2:(i+1)*2]
#    values.append(ToInt(v))
#    voltages.append(Voltage(0x00000fff & ToInt(v)))

#for i in range(0, len(voltages),2):
#    v1 = voltages[i]
#    v2 = voltages[i+1]
#    x1 = 0x00000fff &  values[i]
#    x2 = 0x00000fff &  values[i+1]
#    print("{0:.4f} - {1:.4f} = {2:.4f} ({3} - {4} = {5})".format(v1, v2, v1 - v2, x1, x2, x1 - x2))

def Calibration():
    global supply
    print("Make sure you connected the ADC Channel 6 to the supply voltage of the bridge!")
    raw = input("Connected [yes: defalut(no)]: ")
    if (raw.lower() == "yes"):
        ser.close()
        ser.open()
        ser.write(CMD_START)
        start = time.time()
        x = ser.read(2 * BUFFER * 2**12)
        print("Data Collected!")
        ser.close()
        values = np.array([])
        for i in range(0, 2 * BUFFER * 2**12, 2):
            values = np.append(Voltage(0x00000FFF & ToInt(x[i*2:(i+1)*2])))
        supply = np.average(values)
        print("Set Ref Voltage {0}".format(supply))
        print("Took {0:.2f}s".format(time.time() - start))

def PraseInput(raw):
    global RUNNING 
    raw = raw.lower()
    raw = raw.replace("<", "").replace(">", "")
    if (raw == "end"):
        RUNNING = False
    elif(raw == "calibrate"):
        Calibration()
    elif(raw == "help"):
        hlp =   "calibrate\t\t sets the reference voltage, default 3.3V\n" +  \
                "end\t\t ends this script \n" + \
                "help\t\t prints this menu\n" + \
                "save <name>\t\t save the data as pickle file default path is CWD\n"
        print(hlp)

RUNNING = True
while(RUNNING):
    raw_in = input("#")
    PraseInput(raw_in)
