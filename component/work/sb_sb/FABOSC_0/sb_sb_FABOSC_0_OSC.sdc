set_component sb_sb_FABOSC_0_OSC
# Microsemi Corp.
# Date: 2021-Dec-28 12:41:18
#

create_clock -ignore_errors -period 20 [ get_pins { I_RCOSC_25_50MHZ/CLKOUT } ]
