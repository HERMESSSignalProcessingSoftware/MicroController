
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

def LogStatus(syncstatusreg1):
    SR1_STAMP1_NewAvialable_MISSING 
    SR1_STAMP2_NewAvialable_MISSING 
    SR1_STAMP3_NewAvialable_MISSING 
    SR1_STAMP4_NewAvialable_MISSING 
    SR1_STAMP5_NewAvialable_MISSING 
    SR1_STAMP6_NewAvialable_MISSING 

    SR1_STAMP1_ReqeustResync
    SR1_STAMP2_ReqeustResync
    SR1_STAMP3_ReqeustResync
    SR1_STAMP4_ReqeustResync
    SR1_STAMP5_ReqeustResync 
    SR1_STAMP6_ReqeustResync 

    SR1_STAMP1_OverflowMarker
    SR1_STAMP2_OverflowMarker
    SR1_STAMP3_OverflowMarker
    SR1_STAMP4_OverflowMarker
    SR1_STAMP5_OverflowMarker
    SR1_STAMP6_OverflowMarker

    SR1_APB_ADDRESS_ERROR

    SR1_PENDING_READING_INTERRUPT
    SR1_PENDING_SYNC_INTERRUPT