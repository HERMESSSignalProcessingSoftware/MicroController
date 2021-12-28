# ----------------------------------------------------------------------
# Commnon utility functions
# @TODO: Move them in another file that can be re-used by other modules
# ----------------------------------------------------------------------

# To cast all boolean parameter to false/true from 0/false and 1/true
set bool(0)     false
set bool(false) false
set bool(1)     true
set bool(true)  true

# Connect a top level port to a pin on an instance
proc topPortPinScalar { portName instName pinName } \
{
  NET -name N_${portName}
  PIN -name ${portName}
  PIN -name ${pinName} -inst_name $instName
  END_NET
}

# --------------------------------------
# Start the actual OSC macro description
# --------------------------------------

set def(RCOSC_25_50MHZ) RCOSC_25_50MHZ
set def(RCOSC_1MHZ)     RCOSC_1MHZ
set def(XTLOSC)         XTLOSC

proc mode {} \
{
  global XTLOSC_SRC
  global XTLOSC_FREQ

  if { $XTLOSC_SRC == "RC_NETWORK" } { return 0 }

  if { $XTLOSC_FREQ >= 2.0 } { return 3 }

  if { $XTLOSC_FREQ >= 0.075 } { return 2 }

  return 1
}

proc core {} \
{
  global bool
  global def

  # Passed from generator (C++)

  # module name
  global IP_MODULE_NAME

  # TGI parameters (from the core description)
  global XTLOSC_IS_USED
  global RCOSC_25_50MHZ_IS_USED
  global RCOSC_1MHZ_IS_USED

  global XTLOSC_SRC
  global XTLOSC_FREQ
  global XTLOSC_DRIVES_CCC
  global XTLOSC_DRIVES_FAB

  global RCOSC_25_50MHZ_DRIVES_CCC
  global RCOSC_25_50MHZ_DRIVES_FAB

  global RCOSC_1MHZ_DRIVES_CCC
  global RCOSC_1MHZ_DRIVES_FAB

  global VOLTAGE_IS_1_2

  # Start macro description
  DEF -name $IP_MODULE_NAME

  # WARNING: The list of declared ports much match that of the package core
  # unless the SD_EXPORT_HIDDEN_PORTS variable is set to false in the core XML
  PORT -name XTL -direction input

  foreach osc {RCOSC_25_50MHZ RCOSC_1MHZ XTLOSC} \
  {
    foreach signal {CCC O2F} \
    {
      PORT -name ${osc}_${signal} -direction output
    }
  }

  foreach osc {RCOSC_25_50MHZ RCOSC_1MHZ XTLOSC} \
  {
    set def_osc $def($osc)

    upvar 0 ${osc}_IS_USED osc_is_used

    if { $bool($osc_is_used) == "true" } \
    {
      INST -name I_${osc} -def_name $def_osc

      if { $osc == "XTLOSC" } \
      {
          PROP_INST -name I_${osc} -prop MODE -value [mode]
          PROP_INST -name I_${osc} -prop FREQUENCY -value [expr $XTLOSC_FREQ * 1.0]

          topPortPinScalar XTL I_${osc} XTL
      }

      if { $osc == "RCOSC_25_50MHZ" } \
      {
          set freq 50.0
          if { $bool($VOLTAGE_IS_1_2) == "false" } { set freq 25.0 }
          PROP_INST -name I_${osc} -prop FREQUENCY -value $freq
      }

      foreach signal {CCC} \
      {
        upvar 0 ${osc}_DRIVES_${signal} osc_drives_signal

        if { $bool($osc_drives_signal) == "true" } \
        {
          topPortPinScalar ${osc}_${signal} I_${osc} CLKOUT
        }
      }

      upvar 0 ${osc}_DRIVES_FAB osc_drives_fab

      if { $bool($osc_drives_fab) == "true" } \
      {
        INST -name I_${osc}_FAB -def_name ${def_osc}_FAB

        INST -name I_${osc}_FAB_CLKINT -def_name CLKINT

        NET -name N_${osc}_CLKOUT
          PIN -name CLKOUT -inst_name I_${osc}
          PIN -name A      -inst_name I_${osc}_FAB
        END_NET

        NET -name N_${osc}_CLKINT
          PIN -name A      -inst_name I_${osc}_FAB_CLKINT
          PIN -name CLKOUT -inst_name I_${osc}_FAB
        END_NET

        topPortPinScalar ${osc}_O2F I_${osc}_FAB_CLKINT Y
      }
    }
  }

  END_DEF

  return $IP_MODULE_NAME
}

SET_TOP_DEF -name [ core ]
