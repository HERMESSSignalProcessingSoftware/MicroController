import serial
import pickle 
import time
import numpy as np
import matplotlib.pyplot as plt 
import scipy.fftpack

COM = "COM10"
BAUD = 460800

CMD_START = b'\x01'
CMD_END = b'\x02'

BUFFER = 512

CHANNEL6 = (1 << 13)
CHANNEL7 = (1 << 14)

MA_LEN = 16

WORKINGDIR = "D:\\Data\\"

supply = 3.3
# Measure supply voltage to calibrate the system  
calibrated = False 

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

def MA(values):
    return np.average(values)

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


def ReadData(howMuch = BUFFER):
    ser.close()
    ser.open()
    ser.write(CMD_START)
    x = ser.read(howMuch)
    ser.write(CMD_END)
    ser.close()
    return  x

def GetSpeed():
    start = time.time()
    ReadData()
    end = time.time()
    print("{:.6f}s Datarate: {:.2f} byte/s ".format(end -  start,  BUFFER / (end - start)))

raw = "no"
def Calibration():
    global supply
    global raw
    global calibrated
    print("Make sure you connected the ADC Channel 6 AND 7 to the supply voltage of the bridge!")
    if (calibrated == True):
        return 
    if (raw == "no"):
        raw = input("Connected [yes: defalut(no)]: ")
    if (raw.lower() == "yes"):
        ser.close()
        ser.open()
        ser.write(CMD_START)
        start = time.time()
        DATA_LEN = 2**15
        x = ser.read(DATA_LEN)
        data_col  = time.time() - start
        print("Data Collected! Time: {0:.2f} ({1:.2f})".format(data_col, DATA_LEN / data_col))
        ser.write(CMD_END)
        ser.close()
        values = np.array([])
        for i in range(0, DATA_LEN // 2):
            values = np.append(values, Voltage(0x00000fff & ToInt(x[i*2: (i+1)*2])))
        
        pickle.dump([values,x], open("{}rectSupply.p".format(WORKINGDIR), "wb"))
        plt.figure()
        plt.plot(values)
        plt.title("Supply Voltage")
        supply = np.average(values)
        calibrated = True 
        print("Set Ref Voltage {0}".format(supply))
        print("Done! Took {0:.2f}s".format(time.time() - start))
        local = time.localtime()
        plt.savefig("{}supply_{}_{}_{}.png".format(WORKINGDIR, local.tm_sec, local.tm_min, local.tm_hour))

def _MeasureBridge(length):
    x = ReadData(length) # READ 2048 bytes, 2 byte per value => 1024 values, each second form channel 7 => 512 data points
    values = np.array([])
    measurment = np.array([])
    for i in range(0, length // 2):
        values = np.append(values, Voltage(0x00000FFF & ToInt(x[i*2:(i+1)*2])))
    for i in range(0, len(values), 2):
        measurment = np.append(measurment, values[i] - values[i+1])
    filterd = np.array([])
    for i in range(0, len(measurment), MA_LEN):
        filterd = np.append(filterd, MA(measurment[i:i+MA_LEN]))
    filterd2 = np.array([])
    for i in range(0, len(measurment), MA_LEN * 2):
        filterd2 = np.append(filterd2, MA(measurment[i:i+(MA_LEN * 2)]))

    local = time.localtime()

    plt.figure(dpi=200)
    plt.subplot(211)
    plt.plot(measurment)
    #plt.plot(np.mean(measurment))
    plt.grid(True)
    #plt.xticks(np.arange(0, len(measurment))))
    plt.title("Bridge Measurement")
    plt.subplot(212)
    plt.plot(np.repeat(np.mean(measurment), len(measurment)))
    plt.grid(True)
    plt.title("Average {:.8}V".format(np.mean(measurment)))
    plt.subplots_adjust(hspace=1.5)
    plt.savefig("{}measurement1_{}_{}_{}.png".format(WORKINGDIR, local.tm_hour, local.tm_min, local.tm_sec))
    plt.figure(dpi=200)
    plt.subplot(211)
    plt.plot(filterd)
    plt.title("Moving Average {}".format(MA_LEN))
    plt.grid(True)
    plt.subplot(212)
    plt.plot(filterd2)
    plt.title("Moving Average {}".format(MA_LEN * 2))
    plt.grid(True)
    plt.subplots_adjust(hspace=1.5)
    plt.savefig("{}measurement2_{}_{}_{}.png".format(WORKINGDIR, local.tm_hour, local.tm_min, local.tm_sec))


def MeasureBridge(length = 64 * BUFFER):
    print("Connect Channel 6 and 7 to the measurement points! Done? [default(yes), no]")
    raw = input()
    if (raw.lower() != "no"):
       _MeasureBridge(length)

noLoadOffset = 0.0
def Abgleich():
    global noLoadOffset
    print("Make sure, that nothing applied any load to your wheatstone bridge!")
    raw = input("Start? [default(yes); no]")
    if (raw.lower() != 'no'):
        x = ReadData(16 * BUFFER)
        values = np.array([])
        for i in range(8 * BUFFER):
            values = np.append(values, Voltage(0x00000fff & ToInt(x[i*2:(i+1)*2])))
        wheatstonevalues = np.array([])
        for i in range(0, len(values),2):
            wheatstonevalues = np.append(wheatstonevalues, values[i] - values[i+1])
        noLoadOffset = np.average(wheatstonevalues)
        print("No Load offset: {:.8f}V".format(noLoadOffset))
#Calibration()
GetSpeed()
Abgleich()
MeasureBridge()
