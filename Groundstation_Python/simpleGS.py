import serial 
ser = serial.Serial("COM6", 115200)
ser.close()
ser.open()
cmds = {"Read": "Read the complet memory",
        "Erase": "Deletes all the content on the memory (this may take a while)",
        "TestMemory": "Performs a simple memory test, you need to erase the device after this test",
        "exit": "terminates this application",
        "meta": "Reads the highst address form the meta data"}

run = True 
CMD_ERASE       = b"\xAA\x00\x17\xF0"
CMD_TEST        = b"\x20\x00\x17\xF0"
CMD_READ        = b"\x01\x00\x17\xF0"
CMD_META        = b"\x11\x00\x17\xF0"
CMD_WRITE_Page  = b"\x12\x00\x17\xF0" # not impelemented yet!
CMD_TEST        = b"\x13\x00\x17\xF0" # 

def Read(): 
    ser.write(CMD_READ)
    rx = ser.read(5)
    pages = int.from_bytes(rx[1:],"big")
    print("Reading: {} pages...".format(pages))
    for i in range(pages):
        content = ser.read(512)
        if (i % 1000 == 0):
            print("{} von {}".format(i, pages))

def Test():
    ser.write(CMD_TEST)
    rx = ser.read(8)
    if (rx[5] & (1 << 0)):
        pass
    else:
        print("TEST 1 failed!")
    if (rx[5] & (1 << 1)):
        pass
    else:
        print("TEST 2 failed!")
    if (rx[5] & (1 << 2)):
        pass
    else:
        print("TEST 3 failed!")
    if (rx[5] & (1 << 3)):
        pass
    else:
        print("TEST 4 failed!")
    if (rx[5] & (1 << 4)):
        pass
    else:
        print("TEST 5 failed!")
    if (rx[5] & (1 << 5)):
        pass
    else:
        print("TEST 6 failed!")
    if (rx[5] & (1 << 6)):
        pass
    else:
        print("TEST 7 failed!")
    if (rx[5] & (1 << 7)):
        pass
    else:
        print("TEST 8 failed!")


def Erase():
    print("Erase:")
    ser.write(CMD_ERASE)
    ser.read(8)
    print("DONE")

def Help():
    print("May the force be with you\n")
    for key in sorted(cmds.keys()):
        print("{}\t: {}".format(key, cmds[key]))

def Meta():
    print("Reading meta data...")
    ser.write(CMD_META)
    rx = ser.read(12)
    endPage = int.from_bytes(rx[6:9], "big")
    print("Highest Page: {}\n".format(hex(endPage)))

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

while (run == True ):
    ser.flush()
    readInput = input("Enter CMD: (help for all commands) ").lower()
    if (readInput == "read"):
        Read()
    elif (readInput == "erase"):
        Erase()
    elif (readInput == "testmemory"):
        TestMemory()
    elif (readInput in ["exit", "terminate", "halt"]):
        run = False
    elif (readInput == "meta"):
        Meta()
    elif (readInput == "test"):
        Test()
    else:
        Help()

print("FINISHED APPLICATION")
ser.close()


