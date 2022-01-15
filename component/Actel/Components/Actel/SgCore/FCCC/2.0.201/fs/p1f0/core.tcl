#CCC gen
# ===============================================            
# Util Functions
# ===============================================            

set GndInstName  "gnd_inst"
set GndNetName   "gnd_net"
set VccInstName  "vcc_inst"
set VccNetName   "vcc_net"

proc boolConvert { val } \
{
  if { $val == "1" || $val == "true" } \
  {
    return "true"
  } else \
  {
    return "false"
  }
}

proc boolConvert2 { val } \
{
  if { $val == "1" || $val == "true" } \
  {
    return 1
  } else \
  {
    return 0
  }
}

# -----------------------------------------------------------------------------
# Create gnd net
# -----------------------------------------------------------------------------
proc createGndNet { GndInstName GndNetName } \
{
    addInstance $GndInstName GND
    NET -name $GndNetName
      PIN -name Y -inst_name $GndInstName
    END_NET
}

proc createVccNet { VccInstName VccNetName } \
{
    addInstance $VccInstName VCC
    NET -name $VccNetName
      PIN -name Y -inst_name $VccInstName
    END_NET
}

# -----------------------------------------------------------------------------
# Connect a net to a pin (scalar or a bus)
# -----------------------------------------------------------------------------
proc connectNetToPin { netName pinName msb lsb instName  } \
{
    NET  -name $netName
    if { ( $msb == "" ) || ( $msb == "-1" ) } \
    {
      PIN -name $pinName -inst_name $instName
    } else \
    {
      PIN -name $pinName -msb $msb -lsb $lsb -inst_name $instName
    }
    END_NET
}

# -----------------------------------------------------------------------------
# Connect a port to a pin (scalar or a bus but same msb, lsb)
# -----------------------------------------------------------------------------
proc connectPortToPin { portName pinName msb lsb instName  } \
{   
    NET  -name "${portName}_padnet"
    if { ( $msb == "" ) || ( $msb == "-1" ) } \
    {
      PIN -name $portName
      PIN -name $pinName -inst_name $instName
    } else \
    {
      PIN -name $portName -msb $msb -lsb $lsb
      PIN -name $pinName -msb $msb -lsb $lsb -inst_name $instName
    }
    END_NET
}

# -----------------------------------------------------------------------------
# Connect a pin to another pin (scalar or a bus but same msb, lsb)
# -----------------------------------------------------------------------------
proc connectPinToPin { pin1Name pin2Name msb lsb inst1Name inst2Name  } \
{
    NET  -name "${pin2Name}_net"
    if { ( $msb == "" ) || ( $msb == "-1" ) } \
    {
      PIN -name $pin1Name -inst_name $inst1Name
      PIN -name $pin2Name -inst_name $inst2Name
    } else \
    {
      PIN -name $pin1Name -inst_name $inst1Name
      # PIN -name $pin1Name -msb $msb -lsb $lsb -inst_name $inst1Name
      PIN -name $pin2Name -msb $msb -lsb $lsb -inst_name $inst2Name
    }
    END_NET
}

# -----------------------------------------------------------------------------
# -----------------------------------------------------------------------------
proc connectInterface { connections IoInstName ipInstName GndNetName } \
{
  foreach net $connections \
  {
      set type      [lindex $net 0]
      set p1        [lindex $net 1]
      set msb       [lindex $net 2]
      set lsb       [lindex $net 3]
      set p2        [lindex $net 4]
      
      if { $type == "GND_IP" } \
      {
        connectNetToPin $GndNetName $p1 $msb $lsb $ipInstName
      } elseif { $type == "GND_IO" } \
      {
        connectNetToPin $GndNetName $p1 $msb $lsb $IoInstName
      } elseif { $type == "TOP_IO" } \
      {
        connectPortToPin $p1 $p2 $msb $lsb $IoInstName
      } elseif { $type == "TOP_IP" } \
      {
        connectPortToPin $p1 $p2 $msb $lsb $ipInstName
      } elseif { $type == "IO_IP" } \
      {
        connectPinToPin $p1 $p2 $msb $lsb $IoInstName $ipInstName
      }
  }
}

proc connectInterfaceTopIoOutputToGnd { connections IoInstName ipInstName GndNetName } \
{
  foreach net $connections \
  {
      set type      [lindex $net 0]
      set p1        [lindex $net 1]
      set msb       [lindex $net 2]
      set lsb       [lindex $net 3]
      set p2        [lindex $net 4]
      
      if { $type == "TOP_IO" } \
      {
         if { ( $msb == "" ) || ( $msb == "-1" ) } \
         {
            NET -name $GndNetName
                PIN -name $p1 
            END_NET
         } else {
             NET -name $GndNetName
                PIN -name $p1 -msb $msb -lsb $lsb
            END_NET
         }
      }
  }
}
                                                               
# -----------------------------------------------------------------------------
# Add ports to the def. Must be the same port list as in the pakaged core
# -----------------------------------------------------------------------------
proc addPorts { Ports isUsed } \
{

  if { [boolConvert $isUsed] == "true" }  \
  {
      foreach port $Ports \
      {
          set name      [lindex $port 0]
          set msb       [lindex $port 1]
          set lsb       [lindex $port 2]
          set dir       [lindex $port 3]

          if { $dir == "IN" } \
          {
            set direction "input"
          } elseif { $dir == "OUT" } \
          {
            set direction "output"
          } else \
          {
            set direction "inout"
          }
          
          if { ( $msb == "" ) || ( $msb == "-1" ) } \
          {
            PORT -name $name -direction $direction 
          } else \
          {
            PORT -name $name -direction $direction -msb $msb -lsb $lsb 
          }
      } 
  }
}

# -----------------------------------------------------------------------------
# Add an instance to the top def
# -----------------------------------------------------------------------------
proc addInstance { instName proto } \
{
  INST -name $instName -def_name $proto
}

# -----------------------------------------------------------------------------
# Connect top ports to the IP
# -----------------------------------------------------------------------------
proc connectPortsToPins { PortsToPromoteToTop ipCoreInstName } \
{
  foreach port $PortsToPromoteToTop \
  {
      set topPortName   [lindex $port 0]
      set msb           [lindex $port 1]
      set lsb           [lindex $port 2]
      set dir           [lindex $port 3]
      set ipPortName    [lindex $port 4]

      if { ( $msb == "" ) || ( $msb == "-1" ) } \
      {
        NET -name "${topPortName}_net"
          PIN -name $topPortName
          PIN -name $ipPortName -inst_name $ipCoreInstName
        END_NET
      } else \
      {
        NET -name "${topPortName}_net"   -msb $msb -lsb $lsb
          PIN -name $topPortName -msb $msb -lsb $lsb
          PIN -name $ipPortName -inst_name $ipCoreInstName -msb $msb -lsb $lsb
        END_NET
      }
  }
}


proc connectOutputPortsToDefaultPWR { ports instName } \
{
  global GndNetName
  global VccNetName

  foreach port $ports \
  {
      set topPortName   [lindex $port 0]
      set msb           [lindex $port 1]
      set lsb           [lindex $port 2]
      set dir           [lindex $port 3]
      set pinName       [lindex $port 4]
      set default_pwr   [lindex $port 5]

      if { $dir == "OUT" } \
      {
        set pwr_net $GndNetName

        if { ( $msb == "" ) || ( $msb == "-1" ) } \
        {
          NET -name $GndNetName
            PIN -name $topPortName
          END_NET
        } else \
        {
          NET -name $GndNetName
            PIN -name $topPortName -msb $msb -lsb $lsb
          END_NET
        }
      }
   }
}

proc connectInputPortsToDefaultPWR { ports instName } \
{
  global GndNetName
  global VccNetName

  foreach port $ports \
  {
      set topPortName   [lindex $port 0]
      set msb           [lindex $port 1]
      set lsb           [lindex $port 2]
      set dir           [lindex $port 3]
      set pinName       [lindex $port 4]
      set default_pwr   [lindex $port 5]

      if { $dir == "IN" } \
      {
        set pwr_net $GndNetName
        if { $default_pwr == "VCC" } {
          set pwr_net $VccNetName
        }

        if { ( $msb == "" ) || ( $msb == "-1" ) } \
        {
          NET -name $pwr_net
            PIN -name $pinName -inst_name $instName
          END_NET
        } else \
        {
          NET -name $pwr_net
            PIN -name $pinName -inst_name $instName -msb $msb -lsb $lsb
          END_NET
        }
      }
   }
}

# -----------------------------------------------------------------------------
# Process regular Ports. Show them or not
# -----------------------------------------------------------------------------
proc connectConditionalPortsToPins { ports instName isUsed } \
{
  global GndNetName
  if { [boolConvert $isUsed] == "true" } \
  {
    connectPortsToPins $ports $instName
  } else \
  {
    connectInputPortsToDefaultPWR $ports $instName
    #connectOutputPortsToDefaultPWR $ports $instName
  }
}

# -----------------------------------------------------------------------------
# -----------------------------------------------------------------------------
# ACT_CONFIG creation
# -----------------------------------------------------------------------------
# -----------------------------------------------------------------------------
# Same from the core tcl to have the same order.
# This is the order in which the ACT_CONFIG will be written to
# Don't change the order.
# Make sure also to update defaultValOfParametersWhenNotUsed list
# -----------------------------------------------------------------------------

# -----------------------------------------------------------------------------
# Can be different than just 0 if we want to see a different values when
# a block is not used
# _USED parameters are used to define if the block is used or not
# just add them to have the complete list of param
# Added 4 parameters that are deduced from the others which will go to
# the ACT_CONFIG (DPI_INIT ones)
# The order is not important here.
# -----------------------------------------------------------------------------
set defaultValOfParametersWhenNotUsed { \
                                      }

# Used to get the new hex value when we need to set the last bit to 1.
# Assume it's not more that 3 bit hex value
set hex3To4BitTable { \
                      { 0   8 } \
                      { 1   9 } \
                      { 2   A } \
                      { 3   B } \
                      { 4   C } \
                      { 5   D } \
                      { 6   E } \
                      { 7   F } \
             }

# -----------------------------------------------------------------------------
# 4bit binary to a 1 bit hex
set 4bitBinary2HexTable { \
                    { 0000   0 } \
                    { 0001   1 } \
                    { 0010   2 } \
                    { 0011   3 } \
                    { 0100   4 } \
                    { 0101   5 } \
                    { 0110   6 } \
                    { 0111   7 } \
                    { 1000   8 } \
                    { 1001   9 } \
                    { 1010   A } \
                    { 1011   B } \
                    { 1100   C } \
                    { 1101   D } \
                    { 1110   E } \
                    { 1111   F } \
                 }

# -----------------------------------------------------------------------------
# Set the 4 bit to 1 and return the new hex value
# -----------------------------------------------------------------------------
proc getHexValueFrom4BitBinary { binVal } \
{
  global 4bitBinary2HexTable
  
  foreach table $4bitBinary2HexTable \
  {
      set bVal   [lindex $table 0]
      set hexVal [lindex $table 1]
      
      if { $bVal == $binVal } \
      {
        return $hexVal
      }
  }

  exit 1
}
                   
# -----------------------------------------------------------------------------
# return what's the size of the hex depending on the number of bits
# -----------------------------------------------------------------------------
proc getSizeOfHex { width } \
{
  set val [expr (1 + int(($width - 1 )/4))]
  return $val
}

# -----------------------------------------------------------------------------
# getHexValue --
#   Get hex number
# Arguments:
#   hex         number in hex format
# Returns:
#   Remove the 0x prefix
#
# -----------------------------------------------------------------------------
proc getHexValue { hex width } \
{
    regsub {^0[xX]} $hex {} hex
    
    # Append 0 depending on the width
    set size [getSizeOfHex $width]
    set length [string length $hex]

    for { set i $length } { $i < $size } { incr i } \
    {
      set hex 0$hex
    }

    return $hex
}



# -----------------------------------------------------------------------------
# Set the 4 bit to 1 and return the new hex value
# -----------------------------------------------------------------------------
proc get4BitHexValue { hex } \
{
  global hex3To4BitTable
  
  foreach table $hex3To4BitTable \
  {
      set hexVal    [lindex $table 0]
      set newHexVal [lindex $table 1]
      if { $hex == $hexVal } \
      {
        return $newHexVal
      }
  }
  exit 1
}


# -----------------------------------------------------------------------------
# Assume it's a boolean value.
# return 1 or 0
# -----------------------------------------------------------------------------
proc getBoolValue { val } \
{
  if { (($val == "true") || ($val == 1)) } \
  {
    return "1"
  } else \
  {
    return "0"
  }
}
 
# -----------------------------------------------------------------------------
# -----------------------------------------------------------------------------
proc getDefaultVal { param list } \
{
  foreach defaultVal $list \
  {
      set p    [lindex $defaultVal 0]
      set val  [lindex $defaultVal 1]
      if { $param == $p } \
      {
        return $val
      }
  }

  return "0"
}

# -----------------------------------------------------------------------------
# upvar 1 : because the vriable are defined in another level
# -----------------------------------------------------------------------------
proc addActConfig { ipCoreInstName } \
{
   global INIT 
   global VCOFREQUENCY
   global PLL_EXT_FB_GL

   PROP_INST -name $ipCoreInstName -prop INIT -value $INIT
   PROP_INST -name $ipCoreInstName -prop VCOFREQUENCY -value $VCOFREQUENCY
   if { $PLL_EXT_FB_GL == "EXT_FB_GL0" } {
      PROP_INST -name $ipCoreInstName -prop PLL_EXTERNAL_FEEDBACK_OUTPUT -value "GL0"
   } elseif { $PLL_EXT_FB_GL == "EXT_FB_GL1" } {
      PROP_INST -name $ipCoreInstName -prop PLL_EXTERNAL_FEEDBACK_OUTPUT -value "GL1"
   } elseif { $PLL_EXT_FB_GL == "EXT_FB_GL2" } {
      PROP_INST -name $ipCoreInstName -prop PLL_EXTERNAL_FEEDBACK_OUTPUT -value "GL2"
   } elseif { $PLL_EXT_FB_GL == "EXT_FB_GL3" } {
      PROP_INST -name $ipCoreInstName -prop PLL_EXTERNAL_FEEDBACK_OUTPUT -value "GL3"
   } 
}

# =======================================================================================================
# Must create all ports even if they are not used to match the core
# Copy the list from the core definition
# isPad Group are not used
# =======================================================================================================
# name msb lsb dir isPad Group
set Ports { \

      { PRDATA             7  0   OUT   REG                       } \
      { PRESET_N          -1 -1   IN    REG                       } \
      { PCLK              -1 -1   IN    REG                       } \
      { PSEL              -1 -1   IN    REG                       } \
      { PWRITE            -1 -1   IN    REG                       } \
      { PENABLE           -1 -1   IN    REG                       } \
      { PADDR              7  2   IN    REG                       } \
      { PWDATA             7  0   IN    REG                       } \

      { CLK0              -1 -1   IN    REG                       } \
      { CLK1              -1 -1   IN    REG                       } \
      { CLK2              -1 -1   IN    REG                       } \
      { CLK3              -1 -1   IN    REG                       } \
      { CLK0_PAD          -1 -1   IN    PAD                       } \
      { CLK1_PAD          -1 -1   IN    PAD                       } \
      { CLK2_PAD          -1 -1   IN    PAD                       } \
      { CLK3_PAD          -1 -1   IN    PAD                       } \
      { CLK0_PADN         -1 -1   IN    PAD                       } \
      { CLK1_PADN         -1 -1   IN    PAD                       } \
      { CLK2_PADN         -1 -1   IN    PAD                       } \
      { CLK3_PADN         -1 -1   IN    PAD                       } \
      { CLK0_PADP         -1 -1   IN    PAD                       } \
      { CLK1_PADP         -1 -1   IN    PAD                       } \
      { CLK2_PADP         -1 -1   IN    PAD                       } \
      { CLK3_PADP         -1 -1   IN    PAD                       } \
      { RCOSC_25_50MHZ    -1 -1   IN    REQ                       } \
      { RCOSC_1MHZ        -1 -1   IN    REQ                       } \
      { XTLOSC            -1 -1   IN    REQ                       } \
      { GL0               -1 -1   OUT   REG                       } \
      { GL1               -1 -1   OUT   REG                       } \
      { GL2               -1 -1   OUT   REG                       } \
      { GL3               -1 -1   OUT   REG                       } \
      { GL0_EN            -1 -1   IN    REG                       } \
      { GL1_EN            -1 -1   IN    REG                       } \
      { GL2_EN            -1 -1   IN    REG                       } \
      { GL3_EN            -1 -1   IN    REG                       } \
      { Y0                -1 -1   OUT   REG                       } \
      { Y1                -1 -1   OUT   REG                       } \
      { Y2                -1 -1   OUT   REG                       } \
      { Y3                -1 -1   OUT   REG                       } \
                          
      { GPD0_ARST_N       -1 -1   IN    REG                       } \
      { GPD1_ARST_N       -1 -1   IN    REG                       } \
      { GPD2_ARST_N       -1 -1   IN    REG                       } \
      { GPD3_ARST_N       -1 -1   IN    REG                       } \
      { NGMUX0_SEL        -1 -1   IN    REG                       } \
      { NGMUX1_SEL        -1 -1   IN    REG                       } \
      { NGMUX2_SEL        -1 -1   IN    REG                       } \
      { NGMUX3_SEL        -1 -1   IN    REG                       } \
      { NGMUX0_HOLD_N     -1 -1   IN    REG                       } \
      { NGMUX1_HOLD_N     -1 -1   IN    REG                       } \
      { NGMUX2_HOLD_N     -1 -1   IN    REG                       } \
      { NGMUX3_HOLD_N     -1 -1   IN    REG                       } \
      { NGMUX0_ARST_N     -1 -1   IN    REG                       } \
      { NGMUX1_ARST_N     -1 -1   IN    REG                       } \
      { NGMUX2_ARST_N     -1 -1   IN    REG                       } \
      { NGMUX3_ARST_N     -1 -1   IN    REG                       } \
      { PLL_BYPASS_N      -1 -1   IN    REG                       } \
      { PLL_ARST_N        -1 -1   IN    REG                       } \
      { PLL_POWERDOWN_N   -1 -1   IN    REG                       } \
       
      { LOCK              -1 -1   OUT   REG                       } \
}


# -----------------------------------------------------------------------------
# -----------------------------------------------------------------------------
# CCC Block
# -----------------------------------------------------------------------------
# -----------------------------------------------------------------------------

set CCC_APB_Ports { \
    { PRDATA    7  0   OUT PRDATA   NA } \
    { PCLK     -1 -1   IN  PCLK     VCC } \
    { PRESET_N -1 -1   IN  PRESET_N GND  } \
    { PSEL     -1 -1   IN  PSEL     VCC } \
    { PWRITE   -1 -1   IN  PWRITE   VCC } \
    { PENABLE  -1 -1   IN  PENABLE  VCC } \
    { PADDR     7  2   IN  PADDR    VCC } \
    { PWDATA    7  0   IN  PWDATA   VCC } \
}

set CCC_RegularPorts { \
    { Y0            -1 -1   OUT    Y0             } \
    { Y1            -1 -1   OUT    Y1             } \
    { Y2            -1 -1   OUT    Y2             } \
    { Y3            -1 -1   OUT    Y3             } \
}
                     
set RCOSC_50MHZ_Ports { { RCOSC_25_50MHZ -1 -1 IN RCOSC_25_50MHZ GND } }
set RCOSC_1MHZ_Ports  { { RCOSC_1MHZ     -1 -1 IN RCOSC_1MHZ     GND } }
set XTLOSC_Ports      { { XTLOSC         -1 -1 IN XTLOSC         GND } }

set CLK0_Ports  { { CLK0 -1 -1 IN CLK0  VCC } }
set CLK1_Ports  { { CLK1 -1 -1 IN CLK1  VCC } }
set CLK2_Ports  { { CLK2 -1 -1 IN CLK2  VCC } }
set CLK3_Ports  { { CLK3 -1 -1 IN CLK3  VCC } }

set GPD0_ARST_N_Ports { { GPD0_ARST_N -1 -1 IN GPD0_ARST_N VCC } }
set GPD1_ARST_N_Ports { { GPD1_ARST_N -1 -1 IN GPD1_ARST_N VCC } }
set GPD2_ARST_N_Ports { { GPD2_ARST_N -1 -1 IN GPD2_ARST_N VCC } }
set GPD3_ARST_N_Ports { { GPD3_ARST_N -1 -1 IN GPD3_ARST_N VCC } }

set NGMUX0_HOLD_Ports { \
    { NGMUX0_HOLD_N  -1 -1 IN NGMUX0_HOLD_N VCC } \
}

set NGMUX0_Ports { \
    { NGMUX0_SEL     -1 -1 IN NGMUX0_SEL    GND } \
    { NGMUX0_ARST_N  -1 -1 IN NGMUX0_ARST_N VCC } \
}

set NGMUX1_HOLD_Ports { \
    { NGMUX1_HOLD_N  -1 -1 IN NGMUX1_HOLD_N VCC } \
}

set NGMUX1_Ports { \
    { NGMUX1_SEL     -1 -1 IN NGMUX1_SEL    GND } \
    { NGMUX1_ARST_N  -1 -1 IN NGMUX1_ARST_N VCC } \
}

set NGMUX2_HOLD_Ports { \
    { NGMUX2_HOLD_N  -1 -1 IN NGMUX2_HOLD_N VCC } \
}

set NGMUX2_Ports { \
    { NGMUX2_SEL     -1 -1 IN NGMUX2_SEL    GND } \
    { NGMUX2_ARST_N  -1 -1 IN NGMUX2_ARST_N VCC } \
}

set NGMUX3_HOLD_Ports { \
    { NGMUX3_HOLD_N  -1 -1 IN NGMUX3_HOLD_N VCC } \
}

set NGMUX3_Ports { \
    { NGMUX3_SEL     -1 -1 IN NGMUX3_SEL    GND } \
    { NGMUX3_ARST_N  -1 -1 IN NGMUX3_ARST_N VCC } \
}
                
set PLL_Ports { \
    { LOCK             -1 -1 OUT LOCK            NA  } \
}

set PLL_Used_Resets_Ports { \
    { PLL_ARST_N       -1 -1 IN  PLL_ARST_N      VCC } \
    { PLL_POWERDOWN_N  -1 -1 IN  PLL_POWERDOWN_N VCC } \
}

set PLL_Unused_Resets_Ports { \
    { PLL_ARST_N       -1 -1 IN  PLL_ARST_N      GND } \
    { PLL_POWERDOWN_N  -1 -1 IN  PLL_POWERDOWN_N GND } \
}

set PLL_Bypass_Port { \
    { PLL_BYPASS_N     -1 -1 IN  PLL_BYPASS_N    VCC } \
}

set CCC_CLK0_PADPort { \
    { TOP_IO  CLK0_PAD  -1  -1  PAD } \
    { IO_IP   Y    -1  -1  CLK0_PAD  } \
}

set CCC_CLK0_PADPort_Top { \
    { CLK0_PAD -1 -1 IN PAD } \
}

set CCC_CLK1_PADPort { \
    { TOP_IO  CLK1_PAD  -1  -1  PAD } \
    { IO_IP   Y    -1  -1  CLK1_PAD  } \  
}

set CCC_CLK1_PADPort_Top { \
    { CLK1_PAD -1 -1 IN PAD } \
}

set CCC_CLK2_PADPort { \
    { TOP_IO  CLK2_PAD  -1  -1  PAD } \
    { IO_IP   Y    -1  -1  CLK2_PAD  } \ 
}

set CCC_CLK2_PADPort_Top { \
    { CLK2_PAD -1 -1 IN PAD } \
}

set CCC_CLK3_PADPort { \
    { TOP_IO  CLK3_PAD -1  -1  PAD } \
    { IO_IP   Y        -1  -1  CLK3_PAD  } \ 
}

set CCC_CLK3_PADPort_Top { \
    { CLK3_PAD -1 -1 IN PAD } \
}


set CCC_CLK0_DIFF_PADPort { \
    { TOP_IO  CLK0_PADN  -1  -1  PADN } \
    { TOP_IO  CLK0_PADP  -1  -1  PADP } \
    { IO_IP   Y    -1  -1  CLK0_PAD  } \
}

set CCC_CLK0_DIFF_PADPort_Top { \
    { CLK0_PADN -1 -1 IN PAD } \
    { CLK0_PADP -1 -1 IN PAD } \
}

set CCC_CLK1_DIFF_PADPort { \
    { TOP_IO  CLK1_PADN  -1  -1  PADN } \
    { TOP_IO  CLK1_PADP  -1  -1  PADP } \
    { IO_IP   Y    -1  -1  CLK1_PAD  } \  
}

set CCC_CLK1_DIFF_PADPort_Top { \
    { CLK1_PADN -1 -1 IN PAD } \
    { CLK1_PADP -1 -1 IN PAD } \
}

set CCC_CLK2_DIFF_PADPort { \
    { TOP_IO  CLK2_PADN  -1  -1  PADN } \
    { TOP_IO  CLK2_PADP  -1  -1  PADP } \
    { IO_IP   Y    -1  -1  CLK2_PAD  } \ 
}

set CCC_CLK2_DIFF_PADPort_Top { \
    { CLK2_PADN -1 -1 IN PAD } \
    { CLK2_PADP -1 -1 IN PAD } \
}

set CCC_CLK3_DIFF_PADPort { \
    { TOP_IO  CLK3_PADN  -1  -1  PADN } \
    { TOP_IO  CLK3_PADP  -1  -1  PADP } \
    { IO_IP   Y        -1  -1  CLK3_PAD  } \ 
}

set CCC_CLK3_DIFF_PADPort_Top { \
    { CLK3_PADN -1 -1 IN PAD } \
    { CLK3_PADP -1 -1 IN PAD } \
}


set CCC_GL0GatedPort_Top { \
    { GL0 -1 -1 OUT REG } \
    { GL0_EN -1 -1 IN REG } \
}

set CCC_GL0Port_Top { \
    { GL0 -1 -1 OUT REG } \
}
                     
set CCC_GL0GatedPort { \
    { TOP_IO  GL0    -1  -1  Y    } \
    { IO_IP   A      -1  -1  GL0  } \
    { TOP_IO  GL0_EN -1  -1  EN   } \
}

set CCC_Y0Port_Top { \
    { Y0 -1 -1 OUT Y0 } \
}

set CCC_GL0Port { \
    { TOP_IO  GL0  -1  -1  Y    } \
    { IO_IP   A    -1  -1  GL0  } \
}


set CCC_GL1GatedPort_Top { \
    { GL1 -1 -1 OUT REG } \
    { GL1_EN -1 -1 IN REG } \
}

set CCC_GL1Port_Top { \
    { GL1 -1 -1 OUT REG } \
}

set CCC_Y1Port_Top { \
    { Y1 -1 -1 OUT Y1 } \
}

set CCC_GL1GatedPort { \
          { TOP_IO  GL1  -1  -1  Y       } \
          { IO_IP   A    -1  -1  GL1  } \
          { TOP_IO  GL1_EN    -1  -1  EN   } \
}

set CCC_GL1Port { \
          { TOP_IO  GL1  -1  -1  Y       } \
          { IO_IP   A    -1  -1  GL1  } \
}


set CCC_GL2GatedPort_Top { \
    { GL2 -1 -1 OUT REG } \
    { GL2_EN -1 -1 IN REG } \
}

set CCC_GL2Port_Top { \
    { GL2 -1 -1 OUT REG } \
}

set CCC_Y2Port_Top { \
    { Y2 -1 -1 OUT Y2 } \
}

set CCC_GL2GatedPort { \
          { TOP_IO  GL2  -1  -1  Y       } \
          { IO_IP   A    -1  -1  GL2  } \
          { TOP_IO  GL2_EN    -1  -1  EN   } \
}

set CCC_GL2Port { \
          { TOP_IO  GL2  -1  -1  Y       } \
          { IO_IP   A    -1  -1  GL2  } \
}

set CCC_GL3GatedPort_Top { \
    { GL3 -1 -1 OUT REG } \
    { GL3_EN -1 -1 IN REG } \
}

set CCC_GL3Port_Top { \
    { GL3 -1 -1 OUT REG } \
}

set CCC_Y3Port_Top { \
    { Y3 -1 -1 OUT Y3 } \
}

set CCC_GL3GatedPort { \
          { TOP_IO  GL3  -1  -1  Y       } \
          { IO_IP   A    -1  -1  GL3  } \
          { TOP_IO  GL3_EN    -1  -1  EN   } \
}

set CCC_GL3Port { \
          { TOP_IO  GL3  -1  -1  Y       } \
          { IO_IP   A    -1  -1  GL3  } \
}
               
        

                                        
set CCCInstName  "CCC_INST"
set CCCDefName   "CCC"

set CCC_GlobalDefName   "CLKINT"
set CCC_GatedGlobalDefName   "GCLKINT"

set CCC_PllIntDefName   "CLKINT"
set CCC_PadIntDefName   "INBUF"
set CCC_PadDiffIntDefName   "INBUF_DIFF"


proc connectCLKDiffIn { IS_USED InstName InstDef CLPorts CCCInstName pin GndNetName } \
{
    if { $IS_USED == "true" } \
    {
        addInstance $InstName  $InstDef
        connectInterface  $CLPorts $InstName $CCCInstName $GndNetName  
    } else \
    {
        connectNetToPin $GndNetName $pin -1 -1 $CCCInstName 
    }
}

proc connectCLKIn { IS_USED InstName InstDef CLPorts CCCInstName pin GndNetName } \
{
    if { $IS_USED == "true" } \
    {
        addInstance $InstName  $InstDef
        connectInterface  $CLPorts $InstName $CCCInstName $GndNetName  
    } else \
    {
        connectNetToPin $GndNetName $pin -1 -1 $CCCInstName 
    }
}


proc connectGL { GL_IS_USED GL_OUT_IS_GATED CCC_GLGatedPort CCC_GLPort InstName CCCInstName GndNetName } \
{
    global CCC_GlobalDefName   "CLKINT"
    global CCC_GatedGlobalDefName   "GCLKINT"
    
    if { $GL_IS_USED == "true" } \
    {
        if { $GL_OUT_IS_GATED == "true" } \
        {
            addInstance $InstName  $CCC_GatedGlobalDefName
            connectInterface  $CCC_GLGatedPort $InstName $CCCInstName $GndNetName  
        } else \
        {
            addInstance $InstName  $CCC_GlobalDefName
            connectInterface  $CCC_GLPort $InstName $CCCInstName $GndNetName  
        }
    } else \
    {
        #connectInterfaceTopIoOutputToGnd $CCC_GLPort $InstName $CCCInstName $GndNetName  
    }
} 

# -----------------------------------------------------------------------------
# -----------------------------------------------------------------------------
proc addCCC { } \
{
   global CCCInstName
   global CCCDefName
   global CCC_GlobalDefName
   global CCC_GatedGlobalDefName
   global CCC_PadIntDefName
   global CCC_PadDiffIntDefName
   global CCC_PllIntDefName
   global CCC_APB_Ports
   global CCC_RegularPorts
   global CCC_GlobalPorts
   global CLK0_Ports  
   global CLK1_Ports  
   global CLK2_Ports  
   global CLK3_Ports  
   global CCC_CLK0_PADPort
   global CCC_CLK1_PADPort
   global CCC_CLK2_PADPort 
   global CCC_CLK3_PADPort       
   global CCC_CLK0_DIFF_PADPort
   global CCC_CLK1_DIFF_PADPort
   global CCC_CLK2_DIFF_PADPort 
   global CCC_CLK3_DIFF_PADPort 
   global CCC_GL0GatedPort
   global CCC_GL0Port 
   global CCC_GL1GatedPort 
   global CCC_GL1Port 
   global CCC_GL2GatedPort 
   global CCC_GL2Port 
   global CCC_GL3GatedPort 
   global CCC_GL3Port 
   global CCC_CLK0_PADPort_Top
   global CCC_CLK1_PADPort_Top
   global CCC_CLK2_PADPort_Top
   global CCC_CLK3_PADPort_Top       
   global CCC_CLK0_DIFF_PADPort_Top
   global CCC_CLK1_DIFF_PADPort_Top
   global CCC_CLK2_DIFF_PADPort_Top
   global CCC_CLK3_DIFF_PADPort_Top 
   global CCC_GL0GatedPort_Top
   global CCC_GL0Port_Top 
   global CCC_GL1GatedPort_Top
   global CCC_GL1Port_Top 
   global CCC_GL2GatedPort_Top 
   global CCC_GL2Port_Top 
   global CCC_GL3GatedPort_Top 
   global CCC_GL3Port_Top 
   global GPD0_ARST_N_Ports
   global GPD1_ARST_N_Ports
   global GPD2_ARST_N_Ports
   global GPD3_ARST_N_Ports
   
   global CCC_Y0Port_Top
   global CCC_Y1Port_Top
   global CCC_Y2Port_Top
   global CCC_Y3Port_Top

   global GndNetName
   global CCC_IO_NOTUSED_Connections
   
   global GL0_IS_USED
   global GL1_IS_USED
   global GL2_IS_USED
   global GL3_IS_USED
   
   global Y0_IS_USED
   global Y1_IS_USED
   global Y2_IS_USED
   global Y3_IS_USED
   
   global GL0_OUT_IS_GATED
   global GL1_OUT_IS_GATED
   global GL2_OUT_IS_GATED
   global GL3_OUT_IS_GATED
   
   global CLK0_IS_USED
   global CLK1_IS_USED
   global CLK2_IS_USED
   global CLK3_IS_USED
   
   global GPD0_IS_USED
   global GPD1_IS_USED
   global GPD2_IS_USED
   global GPD3_IS_USED
   
   global CLK0_PAD_IS_USED
   global CLK1_PAD_IS_USED
   global CLK2_PAD_IS_USED
   global CLK3_PAD_IS_USED
   
   global RCOSC_25_50MHZ_IS_USED
   global RCOSC_1MHZ_IS_USED
   global XTLOSC_IS_USED
   
   global PLL_IS_USED
   global PLL_EXPOSE_BYPASS
   global PLL_EXPOSE_RESETS
   global NGMUX0_IS_USED
   global NGMUX1_IS_USED
   global NGMUX2_IS_USED
   global NGMUX3_IS_USED
   global NGMUX0_HOLD_IS_USED
   global NGMUX1_HOLD_IS_USED
   global NGMUX2_HOLD_IS_USED
   global NGMUX3_HOLD_IS_USED
   
      
   global IO_HARDWIRED_0_IS_DIFF
   global IO_HARDWIRED_1_IS_DIFF
   global IO_HARDWIRED_2_IS_DIFF
   global IO_HARDWIRED_3_IS_DIFF
      
   global DYN_CONF_IS_USED
   global GPD_EXPOSE_RESETS
   
   global RCOSC_50MHZ_Ports 
   global RCOSC_1MHZ_Ports 
   global XTLOSC_Ports 
   global NGMUX0_Ports 
   global NGMUX1_Ports 
   global NGMUX2_Ports 
   global NGMUX3_Ports 
   global NGMUX0_HOLD_Ports 
   global NGMUX1_HOLD_Ports 
   global NGMUX2_HOLD_Ports 
   global NGMUX3_HOLD_Ports 
   global PLL_Ports 
   global PLL_Bypass_Port
   global PLL_Unused_Resets_Ports 
   global PLL_Used_Resets_Ports 

   global PLL_EXT_FB_GL
   
   # addInstance $I2CInstName $I2CDefName
   addInstance $CCCInstName  $CCCDefName

   addPorts $CCC_Y0Port_Top $Y0_IS_USED
   connectConditionalPortsToPins $CCC_Y0Port_Top $CCCInstName $Y0_IS_USED
   
   addPorts $CCC_Y1Port_Top $Y1_IS_USED
   connectConditionalPortsToPins $CCC_Y1Port_Top $CCCInstName $Y1_IS_USED
   
   addPorts $CCC_Y2Port_Top $Y2_IS_USED
   connectConditionalPortsToPins $CCC_Y2Port_Top $CCCInstName $Y2_IS_USED
   
   addPorts $CCC_Y3Port_Top $Y3_IS_USED
   connectConditionalPortsToPins $CCC_Y3Port_Top $CCCInstName $Y3_IS_USED

   addPorts $CCC_APB_Ports $DYN_CONF_IS_USED
   connectConditionalPortsToPins $CCC_APB_Ports $CCCInstName $DYN_CONF_IS_USED
   
   addPorts $RCOSC_50MHZ_Ports $RCOSC_25_50MHZ_IS_USED
   connectConditionalPortsToPins $RCOSC_50MHZ_Ports $CCCInstName $RCOSC_25_50MHZ_IS_USED
   addPorts $RCOSC_1MHZ_Ports $RCOSC_1MHZ_IS_USED
   connectConditionalPortsToPins $RCOSC_1MHZ_Ports  $CCCInstName $RCOSC_1MHZ_IS_USED
   addPorts $XTLOSC_Ports $XTLOSC_IS_USED
   connectConditionalPortsToPins $XTLOSC_Ports      $CCCInstName $XTLOSC_IS_USED
   
   addPorts $NGMUX0_Ports $NGMUX0_IS_USED
   connectConditionalPortsToPins $NGMUX0_Ports $CCCInstName $NGMUX0_IS_USED
   addPorts $NGMUX0_HOLD_Ports $NGMUX0_HOLD_IS_USED
   connectConditionalPortsToPins $NGMUX0_HOLD_Ports $CCCInstName $NGMUX0_HOLD_IS_USED
   
   addPorts $NGMUX1_Ports $NGMUX1_IS_USED
   connectConditionalPortsToPins $NGMUX1_Ports $CCCInstName $NGMUX1_IS_USED
   addPorts $NGMUX1_HOLD_Ports $NGMUX1_HOLD_IS_USED
   connectConditionalPortsToPins $NGMUX1_HOLD_Ports $CCCInstName $NGMUX1_HOLD_IS_USED
   
   addPorts $NGMUX2_Ports $NGMUX2_IS_USED
   connectConditionalPortsToPins $NGMUX2_Ports $CCCInstName $NGMUX2_IS_USED
   addPorts $NGMUX2_HOLD_Ports $NGMUX2_HOLD_IS_USED
   connectConditionalPortsToPins $NGMUX2_HOLD_Ports $CCCInstName $NGMUX2_HOLD_IS_USED
   
   addPorts $NGMUX3_Ports $NGMUX3_IS_USED
   connectConditionalPortsToPins $NGMUX3_Ports $CCCInstName $NGMUX3_IS_USED
   addPorts $NGMUX3_HOLD_Ports $NGMUX3_HOLD_IS_USED
   connectConditionalPortsToPins $NGMUX3_HOLD_Ports $CCCInstName $NGMUX3_HOLD_IS_USED

   addPorts $PLL_Ports $PLL_IS_USED
   connectConditionalPortsToPins $PLL_Ports $CCCInstName $PLL_IS_USED
   addPorts $PLL_Bypass_Port $PLL_EXPOSE_BYPASS
   connectConditionalPortsToPins $PLL_Bypass_Port $CCCInstName $PLL_EXPOSE_BYPASS
  
   if { $PLL_IS_USED } {
       addPorts $PLL_Used_Resets_Ports $PLL_EXPOSE_RESETS
       connectConditionalPortsToPins $PLL_Used_Resets_Ports $CCCInstName $PLL_EXPOSE_RESETS
   } else {
       addPorts $PLL_Unused_Resets_Ports $PLL_IS_USED
       connectConditionalPortsToPins $PLL_Unused_Resets_Ports $CCCInstName $PLL_IS_USED
   }
 

   addPorts $CLK0_Ports $CLK0_IS_USED
   connectConditionalPortsToPins $CLK0_Ports $CCCInstName $CLK0_IS_USED 
   addPorts $CLK1_Ports $CLK1_IS_USED
   connectConditionalPortsToPins $CLK1_Ports $CCCInstName $CLK1_IS_USED 
   addPorts $CLK2_Ports $CLK2_IS_USED
   connectConditionalPortsToPins $CLK2_Ports $CCCInstName $CLK2_IS_USED 
   addPorts $CLK3_Ports $CLK3_IS_USED
   connectConditionalPortsToPins $CLK3_Ports $CCCInstName $CLK3_IS_USED 
  
   set EXPOSE_GPD0_RST [expr [boolConvert2 ${GPD_EXPOSE_RESETS}] & [boolConvert2 ${GPD0_IS_USED}]] 
   addPorts $GPD0_ARST_N_Ports $EXPOSE_GPD0_RST 
   connectConditionalPortsToPins $GPD0_ARST_N_Ports $CCCInstName $EXPOSE_GPD0_RST 
   
   set EXPOSE_GPD1_RST [expr [boolConvert2 ${GPD_EXPOSE_RESETS}] & [boolConvert2 ${GPD1_IS_USED}]] 
   addPorts $GPD1_ARST_N_Ports $EXPOSE_GPD1_RST 
   connectConditionalPortsToPins $GPD1_ARST_N_Ports $CCCInstName $EXPOSE_GPD1_RST 
   
   set EXPOSE_GPD2_RST [expr [boolConvert2 ${GPD_EXPOSE_RESETS}] & [boolConvert2 ${GPD2_IS_USED}]] 
   addPorts $GPD2_ARST_N_Ports $EXPOSE_GPD2_RST 
   connectConditionalPortsToPins $GPD2_ARST_N_Ports $CCCInstName $EXPOSE_GPD2_RST 
   
   set EXPOSE_GPD3_RST [expr [boolConvert2 ${GPD_EXPOSE_RESETS}] & [boolConvert2 ${GPD3_IS_USED}]] 
   addPorts $GPD3_ARST_N_Ports $EXPOSE_GPD3_RST 
   connectConditionalPortsToPins $GPD3_ARST_N_Ports $CCCInstName $EXPOSE_GPD3_RST
   
   if { $IO_HARDWIRED_0_IS_DIFF } {
       addPorts $CCC_CLK0_DIFF_PADPort_Top $CLK0_PAD_IS_USED    
       connectCLKDiffIn $CLK0_PAD_IS_USED "CLK0_PAD_INST" $CCC_PadDiffIntDefName $CCC_CLK0_DIFF_PADPort $CCCInstName "CLK0_PAD" $GndNetName 
   } else {
       addPorts $CCC_CLK0_PADPort_Top $CLK0_PAD_IS_USED    
       connectCLKIn $CLK0_PAD_IS_USED "CLK0_PAD_INST" $CCC_PadIntDefName $CCC_CLK0_PADPort $CCCInstName "CLK0_PAD" $GndNetName 
   }
   if { $IO_HARDWIRED_1_IS_DIFF } {
       addPorts $CCC_CLK1_DIFF_PADPort_Top $CLK1_PAD_IS_USED    
       connectCLKDiffIn $CLK1_PAD_IS_USED "CLK1_PAD_INST" $CCC_PadDiffIntDefName $CCC_CLK1_DIFF_PADPort $CCCInstName "CLK1_PAD" $GndNetName 
   } else {
       addPorts $CCC_CLK1_PADPort_Top $CLK1_PAD_IS_USED    
       connectCLKIn $CLK1_PAD_IS_USED "CLK1_PAD_INST" $CCC_PadIntDefName $CCC_CLK1_PADPort $CCCInstName "CLK1_PAD" $GndNetName 
   }
   if { $IO_HARDWIRED_2_IS_DIFF } {
       addPorts $CCC_CLK2_DIFF_PADPort_Top $CLK2_PAD_IS_USED    
       connectCLKDiffIn $CLK2_PAD_IS_USED "CLK2_PAD_INST" $CCC_PadDiffIntDefName $CCC_CLK2_DIFF_PADPort $CCCInstName "CLK2_PAD" $GndNetName 
   } else {
       addPorts $CCC_CLK2_PADPort_Top $CLK2_PAD_IS_USED    
       connectCLKIn $CLK2_PAD_IS_USED "CLK2_PAD_INST" $CCC_PadIntDefName $CCC_CLK2_PADPort $CCCInstName "CLK2_PAD" $GndNetName 
   }
   if { $IO_HARDWIRED_3_IS_DIFF } {
       addPorts $CCC_CLK3_DIFF_PADPort_Top $CLK3_PAD_IS_USED    
       connectCLKDiffIn $CLK3_PAD_IS_USED "CLK3_PAD_INST" $CCC_PadDiffIntDefName $CCC_CLK3_DIFF_PADPort $CCCInstName "CLK3_PAD" $GndNetName 
   } else {
       addPorts $CCC_CLK3_PADPort_Top $CLK3_PAD_IS_USED    
       connectCLKIn $CLK3_PAD_IS_USED "CLK3_PAD_INST" $CCC_PadIntDefName $CCC_CLK3_PADPort $CCCInstName "CLK3_PAD" $GndNetName 
   }
   
   if { $GL0_OUT_IS_GATED } {
      addPorts $CCC_GL0GatedPort_Top $GL0_IS_USED    
   } else {
      addPorts $CCC_GL0Port_Top $GL0_IS_USED    
   }
   
   if { $GL1_OUT_IS_GATED } {
      addPorts $CCC_GL1GatedPort_Top $GL1_IS_USED    
   } else {
      addPorts $CCC_GL1Port_Top $GL1_IS_USED    
   }
   
   if { $GL2_OUT_IS_GATED } {
      addPorts $CCC_GL2GatedPort_Top $GL2_IS_USED    
   } else {
      addPorts $CCC_GL2Port_Top $GL2_IS_USED    
   }
   
   if { $GL3_OUT_IS_GATED } {
      addPorts $CCC_GL3GatedPort_Top $GL3_IS_USED    
   } else {
      addPorts $CCC_GL3Port_Top $GL3_IS_USED    
   }
   
   connectGL $GL0_IS_USED $GL0_OUT_IS_GATED $CCC_GL0GatedPort $CCC_GL0Port "GL0_INST" $CCCInstName $GndNetName  
   connectGL $GL1_IS_USED $GL1_OUT_IS_GATED $CCC_GL1GatedPort $CCC_GL1Port "GL1_INST" $CCCInstName $GndNetName  
   connectGL $GL2_IS_USED $GL2_OUT_IS_GATED $CCC_GL2GatedPort $CCC_GL2Port "GL2_INST" $CCCInstName $GndNetName  
   connectGL $GL3_IS_USED $GL3_OUT_IS_GATED $CCC_GL3GatedPort $CCC_GL3Port "GL3_INST" $CCCInstName $GndNetName  
}

# -----------------------------------------------------------------------------
# -----------------------------------------------------------------------------
# -----------------------------------------------------------------------------
# -----------------------------------------------------------------------------
# main
# -----------------------------------------------------------------------------
# -----------------------------------------------------------------------------
# -----------------------------------------------------------------------------
# -----------------------------------------------------------------------------


DEF -name $IP_MODULE_NAME


# -----------------------------------------------------------------------------
# Create a GND/VCC net that we can use to tie off unused pins
# -----------------------------------------------------------------------------
createGndNet $GndInstName $GndNetName
createVccNet $VccInstName $VccNetName

# -----------------------------------------------------------------------------
# CCC block
# -----------------------------------------------------------------------------
addCCC 

# -----------------------------------------------------------------------------
# Create ActConfig to be added as property to the IP instance
# Put it on the MMUART inst for now
# -----------------------------------------------------------------------------
addActConfig $CCCInstName

# -----------------------------------------------------------------------------
# End DEF
# -----------------------------------------------------------------------------
END_DEF
SET_TOP_DEF -name $IP_MODULE_NAME

