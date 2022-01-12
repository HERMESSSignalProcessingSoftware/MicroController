
#signal SynchStatusReg           : std_logic_vector(31 downto 0);
#--   31 30 29 28 27 26 25 24 23 22 21 20 19 18 17 16 15 14 13 12 11 10 9  8  7  6  5  4  3  2  1  0
#--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+
#--|PS|PR|U |AE|  |  |O6|O5|O4|O3|O2|O1|RE|RE|RE|RE|RE|RE|RE|RE|R6|R5|R4|R3|R2|R1|M6|M5|M4|M3|M2|M1|
#--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+
#-- M1 - M6: Bitmask for every stamp which has not provied a newAvails signal
#-- R1 - R6: Bitmask for every stamp which is requesting a Resync 
#-- RE: 8 bit counter: the number of ResyncEvents 
#-- O1 - O6: StatusReg2 overflow marker. Means that the difference to the timestamp register is bigger than the size of 5 bits
#-- AE: APB Error Address not known
#-- U: Unused
#-- PR: Pending Reading Interrupt
#-- PS: Pending Synchronizer Interrupt
#-- Timer and Prescaler


SR1_STAMP1_NewAvialable_MISSING = (1 << 0)
SR1_STAMP2_NewAvialable_MISSING = (1 << 1)
SR1_STAMP3_NewAvialable_MISSING = (1 << 2)
SR1_STAMP4_NewAvialable_MISSING = (1 << 3)
SR1_STAMP5_NewAvialable_MISSING = (1 << 4)
SR1_STAMP6_NewAvialable_MISSING = (1 << 5)

SR1_STAMP1_ReqeustResync = (1 << 6)
SR1_STAMP2_ReqeustResync = (1 << 7)
SR1_STAMP3_ReqeustResync = (1 << 8)
SR1_STAMP4_ReqeustResync = (1 << 9)
SR1_STAMP5_ReqeustResync = (1 << 10)
SR1_STAMP6_ReqeustResync = (1 << 11)

SR1_STAMP1_OverflowMarker = (1 << 20)
SR1_STAMP2_OverflowMarker = (1 << 21)
SR1_STAMP3_OverflowMarker = (1 << 22)
SR1_STAMP4_OverflowMarker = (1 << 23)
SR1_STAMP5_OverflowMarker = (1 << 24)
SR1_STAMP6_OverflowMarker = (1 << 25)
SR1_SIGNAL_SOE            = (1 << 26)
SR1_SIGNAL_SODS           = (1 << 27)
SR1_APB_ADDRESS_ERROR     = (1 << 28)
SR1_SIGNAL_LO             = (1 << 29)
SR1_PENDING_READING_INTERRUPT = (1 << 30)
SR1_PENDING_SYNC_INTERRUPT = (1 << 31)

#signal SynchStatusReg2          : std_logic_vector(31 downto 0);
#--  31 30 29 28 27 26 25 24 23 22 21 20 19 18 17 16 15 14 13 12 11 10 9  8  7  6  5  4  3  2  1  0
#--	+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+
#-- |U |U |S6|S6|S6|S6|S6|S5|S5|S5|S5|S5|S4|S4|S4|S4|S4|S3|S3|S3|S3|S3|S2|S2|S2|S2|S2|S1|S1|S1|S1|S1|
#-- +--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+
#-- U: Unused 
#-- S1 5 bit counter; relative distance to the Timestamp value

def GetTimestampOffsets(syncStatusReg2):
    """
    @param syncstatusreg2
    @return touple (mask, value) both as lists 
    """
    mask = []
    ret = []
    for i in range(6):
        value = 0x1f
        mask.append(value << (i * 5))
        ret.append(syncStatusReg2 & (value << (i * 5)))
    return mask, ret 
    
def GetNumberOfResyncs(statusRegValue):
    """
    @param statusRegValue: the value of the status reg as a 32 bit unsigned integer
    @return 8 bit counter of the resyncs
    """
    mask =  0x000ff000
    return statusRegValue & mask

class Telemetry():
    def __init__(self):
        self.timestamp = 0
        self.STAMP11 = 0
        self.STAMP12 = 0

        self.STAMP21 = 0
        self.STAMP22 = 0

        self.STAMP31 = 0
        self.STAMP32 = 0

        self.STAMP41 = 0
        self.STAMP42 = 0

        self.STAMP51 = 0
        self.STAMP52 = 0

        self.STAMP61 = 0
        self.STAMP62 = 0

        self.StatusReg1 =  0
        self.StatusReg2 = 0
    
    def SetValue(self, value, offset):
        if (offset == 0):
            self.timestamp = value
        elif (offset == 1):
            self.STAMP11 = value 
        elif (offset == 2):
            self.STAMP12 = value 
        elif (offset == 3):
            self.STAMP21 = value 
        elif (offset == 4):
            self.STAMP22 = value 
        elif (offset == 5):
            self.STAMP31 = value
        elif (offset == 6):
            self.STAMP32 = value 
        elif (offset == 7):
            self.STAMP41 = value
        elif (offset == 8):
            self.STAMP42 = value
        elif (offset == 9):
            self.STAMP51 = value
        elif (offset == 10):
            self.STAMP52 = value
        elif (offset == 11):
            self.STAMP61 = value
        elif (offset == 12):
            self.STAMP62 = value
        elif (offset == 13):
            self.StatusReg1 = value
        elif (offset == 14):
            self.StatusReg2 = value

    def ParseBuffer(self, buffer):
        offset = 0
        for i in range(4, len(buffer), 4):
            self.SetValue(int.from_bytes(buffer[i - 4: i], "little"), offset)
            offset = offset + 1
    
    def MeaMeaningOfStatusReg1(self):
        retStr = ""
        if (self.StatusReg1 & SR1_STAMP1_NewAvialable_MISSING):
            retStr = retStr + "(S1 Missing) "
        if (self.StatusReg1 & SR1_STAMP2_NewAvialable_MISSING):
            retStr = retStr + "(S2 Missing) "
        if (self.StatusReg1 & SR1_STAMP3_NewAvialable_MISSING):
            retStr = retStr + "(S3 Missing) "
        if (self.StatusReg1 & SR1_STAMP4_NewAvialable_MISSING):
            retStr = retStr + "(S4 Missing) "
        if (self.StatusReg1 & SR1_STAMP5_NewAvialable_MISSING):
            retStr = retStr + "(S5 Missing) "
        if (self.StatusReg1 & SR1_STAMP6_NewAvialable_MISSING):
            retStr = retStr + "(S6 Missing) "

        #Resync Markers
        if (self.StatusReg1 & SR1_STAMP1_ReqeustResync):
            retStr = retStr + "(S1 Request Resync) "
        if (self.StatusReg1 & SR1_STAMP2_ReqeustResync):
            retStr = retStr + "(S2 Request Resync) "
        if (self.StatusReg1 & SR1_STAMP3_ReqeustResync):
            retStr = retStr + "(S3 Request Resync) "
        if (self.StatusReg1 & SR1_STAMP4_ReqeustResync):
            retStr = retStr + "(S4 Request Resync) "
        if (self.StatusReg1 & SR1_STAMP5_ReqeustResync):
            retStr = retStr + "(S5 Request Resync) "
        if (self.StatusReg1 & SR1_STAMP6_ReqeustResync):
            retStr = retStr + "(S6 Request Resync) "
        #Overflow
        if (self.StatusReg1 & (SR1_STAMP1_OverflowMarker)):
            retStr = retStr + "(S1 Overflow) "
        if (self.StatusReg1 & (SR1_STAMP2_OverflowMarker)):
            retStr = retStr + "(S2 Overflow) "
        if (self.StatusReg1 & (SR1_STAMP3_OverflowMarker)):
            retStr = retStr + "(S3 Overflow) "
        if (self.StatusReg1 & (SR1_STAMP4_OverflowMarker)):
            retStr = retStr + "(S4 Overflow) "
        if (self.StatusReg1 & (SR1_STAMP5_OverflowMarker)):
            retStr = retStr + "(S5 Overflow) "
        if (self.StatusReg1 & (SR1_STAMP6_OverflowMarker)):
            retStr = retStr + "(S6 Overflow) "
        #SODS / LO / SOE / Address error
        if (self.StatusReg1 & SR1_SIGNAL_LO):
            retStr = retStr + "(LO) "
        if (self.StatusReg1 & SR1_SIGNAL_SODS):
            retStr = retStr + "(SODS) "
        if (self.StatusReg1 & SR1_SIGNAL_SOE):
            retStr = retStr + "(SOE) "
        if (self.StatusReg1 & SR1_APB_ADDRESS_ERROR):
            retStr = retStr + "(AE) "
        #Pending Interrupts
        if (self.StatusReg1 & SR1_PENDING_READING_INTERRUPT):
            retStr = retStr + "(PRI) "
        if (self.StatusReg1 & SR1_PENDING_SYNC_INTERRUPT):
            retStr = retStr + "(PSI) "
        return retStr

    def Print(self):
        print("TimeStamp: {}".format(hex(self.timestamp)))
        print("STAMP1 SGR1: {}".format(hex(self.STAMP11)))
        print("STAMP1 SGR2: {}".format(hex(self.STAMP12)))
        print("STAMP2 SGR1: {}".format(hex(self.STAMP21)))
        print("STAMP2 SGR2: {}".format(hex(self.STAMP22)))
        print("STAMP3 SGR1: {}".format(hex(self.STAMP31)))
        print("STAMP3 SGR2: {}".format(hex(self.STAMP32)))
        print("STAMP4 SGR1: {}".format(hex(self.STAMP41)))
        print("STAMP4 SGR2: {}".format(hex(self.STAMP42)))
        print("STAMP5 SGR1: {}".format(hex(self.STAMP51)))
        print("STAMP5 SGR2: {}".format(hex(self.STAMP52)))
        print("STAMP6 SGR1: {}".format(hex(self.STAMP61)))
        print("STAMP6 SGR2: {}".format(hex(self.STAMP62)))
        print("Status Register 1: {} {}".format(hex(self.StatusReg1), self.MeaMeaningOfStatusReg1()))
        print("Status Register 2: {}".format(hex(self.StatusReg2)))

       
