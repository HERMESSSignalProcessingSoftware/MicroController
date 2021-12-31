import serial 
import time 
import signal
from ctypes import *

DEFAULT_COM = "COM4"
DEFAULT_BAUD = 115200

ser = serial.Serial(DEFAULT_COM, DEFAULT_BAUD, timeout = 1)
ser.close()
ser.open()
run = True 
textModeRun = True 

modes = ["normal", "textmode"]
mode = "normal"

def signal_handler(sig, frame):
    global mode 
    global textModeRun 
    global run 
    if (mode == "textmode"):
        textModeRun = False
        mode = "normal"
    else:
        run = False
        ser.close()
        exit(0)
        
signal.signal(signal.SIGINT, signal_handler)

cmds = {"Read": "Read the complet memory",
        "Erase": "Deletes all the content on the memory (this may take a while)",
        "TestMemory": "Performs a simple memory test, you need to erase the device after this test",
        "exit": "terminates this application",
        "meta": "Reads the highst address form the meta data",
        "text": "Reads serial line",
        "textmode": "Reads serial line",
        "flush": "Resets serial RX buffer",
        "read until": "Read until a page number is reached"}


CMD_ERASE       = b"\xAA\x00\x17\xF0"
CMD_TEST        = b"\x20\x00\x17\xF0"
CMD_READ        = b"\x01\x00\x17\xF0"
CMD_META        = b"\x11\x00\x17\xF0"
CMD_WRITE_Page  = b"\x12\x00\x17\xF0" # not impelemented yet!
CMD_TEST        = b"\x13\x00\x17\xF0" 
CMD_READ_UNTIL  = b"\x02"
CMD_CLOSING     = b"\x17\xF0"

# TODO: Add buffer evaluation
def FlushAndEval():
    rx = ser.read(1)
    rxBuffer = [rx]
    while (rx != b''):
        rx = ser.read(1)
        rxBuffer.append(rx)
    print("Cleared {} bytes".format(len(rxBuffer)))
    print("Flushing Done! Reset RX Buffer!")


def Read(): 
    start = time.time()
    startCont = time.time()
    ser.write(CMD_READ)
    rx = ser.read(5)
    pages = int.from_bytes(rx[1:],"big")
    print("Reading: {} pages...".format(pages))
    for i in range(pages):
        with open("dump.bin", "ab") as f:
            content = ser.read(512)
            f.write(content)
        if (i % 1000 == 0):
            print("{} von {} (Took {:.2f}s)".format(i, pages, time.time() - startCont))
            startCont = time.time()
    print("Finised readback! Took {0:.2f}s".format(time.time() - start))

def Test():
    start = time.time()
    ser.write(CMD_TEST)
    rx = ser.read(8)
    if (rx[5] & (1 << 0)):
        print("Memory: Meta data writer: passed")
    else:
        print("TEST 1 failed! (not implemented yet)")
    if (rx[5] & (1 << 1)):
        pass
    else:
        print("TEST 2 failed! (not implemented yet)")
    if (rx[5] & (1 << 2)):
        pass
    else:
        print("TEST 3 failed! (not implemented yet)")
    if (rx[5] & (1 << 3)):
        pass
    else:
        print("TEST 4 failed! (not implemented yet)")
    if (rx[5] & (1 << 4)):
        pass
    else:
        print("TEST 5 failed! (not implemented yet)")
    if (rx[5] & (1 << 5)):
        pass
    else:
        print("TEST 6 failed! (not implemented yet)")
    if (rx[5] & (1 << 6)):
        pass
    else:
        print("TEST 7 failed! (not implemented yet)")
    if (rx[5] & (1 << 7)):
        pass
    else:
        print("TEST 8 failed! (not implemented yet)")
    print("Finised, took {0:.2f}s".format(time.time() - start))

def TextMode():
    global mode 
    global textModeRun
    mode = "textmode"
    rxBuffer = []
    outputStr = ""
    textModeRun = True 
    print("Press CTRL + C to exit textmode")
    try:
        while (textModeRun == True):
            rx =  ser.read(1)
            if (rx != b''):
                toInt = int.from_bytes(rx, "big")
            else:
                toInt = 0
            if (toInt == 0x20 or  toInt > 0x30 and toInt < 0x76): # space + all other characters
                rxBuffer.append(rx)
                outputStr = outputStr + rx.decode("UTF-8")
            elif (toInt == 0x0A or toInt == 0x0D): #CR LF 
                print(outputStr)
                outputStr = ""
    except Exception as e:
        run = False 

def Erase():
    start = time.time()
    print("Erase:")
    ser.write(CMD_ERASE)
    rx = ser.read(1)
    while(rx == b''):
        rx = ser.read(1)
    rx = ser.read(7)
    print("DONE, Took {0:.2f}".format(time.time() - start))

def Help():
    print("May the force be with you\n")
    for key in sorted(cmds.keys()):
        print("{}\t: {}".format(key, cmds[key]))

#Implement this to show the rx buffer
def Print():
    pass 



def Meta(quite = False ):
    if (quite == False):
        print("Reading meta data...")
    ser.write(CMD_META)
    rx = ser.read(12)
    endPage = int.from_bytes(rx[6:9], "big")
    if (quite == False):
        print("Highest Page: {}\n".format(hex(endPage)))
    return endPage

def TestMemory():
    ser.write(CMD_TEST)
    rx = ser.read(9)
    testResult = rx[5]
    if (testResult & 0x01):
        print("Flash 1/2 memory test passed!")
    else:
        print("Flash 1/2 memory test failed!")
    if (testResult & (1 << 1)):
        print("Flash 2/2 memory test passed!")
    else:
        print("Flash 2/2 memory test failed!")
    inputCMD = input("Erase device? ")
    if (inputCMD.lower() in ["yes", "true"]):
        Erase()

def ReadUntil(pages):
    global ser 
    pages = pages - 0x200
    b = pages.to_bytes(4, byteorder='big')
    ser.write(CMD_READ_UNTIL)
    ser.write(b)
    ser.write(CMD_CLOSING)
    content = b''
    print("Starting Download!")
    start = time.time()
    rx = ser.read(7) # ignore the default answer.
    ser.close()
    ser = serial.Serial(DEFAULT_COM, DEFAULT_BAUD) # open again without timeout
    ser.close()
    ser.open()
    for i in range(pages):
        content = ser.read(1024)
        with open("dump.bin", "ab") as f:
            f.write(content)
            f.close()
    print("Finished! {:.2}s".format(time.time() - start))

while (run == True ):
    ser.flush()
    readInput = input("Enter CMD: (help for all commands) ").lower()
    if (readInput == "read"):
        Read()
    elif (readInput in ["readu", "ru", "read until"]):
        rInput = input("Page Addr? (number(hex) or auto) ")
        endPage = 0
        if (rInput == "auto"):
            endPage = Meta(quite = True)
        else:
            endPage = int(rInput, 16)
        ReadUntil(endPage)
    elif (readInput == "erase"):
        Erase()
    elif (readInput == "testmemory"):
        TestMemory()
    elif (readInput in ["exit", "terminate", "halt"]):
        run = False
    elif (readInput == "meta"):
        Meta( quite = False)
    elif (readInput == "test"):
        Test()
    elif (readInput == "flush"):
        FlushAndEval()
        ser.reset_input_buffer()
    elif (readInput in ["text", "textmode"]):
        TextMode()
    elif (readInput == "print"):
        Print()
    else:
        Help()

print("FINISHED APPLICATION")
ser.close()


