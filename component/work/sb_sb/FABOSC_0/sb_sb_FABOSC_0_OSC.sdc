set_component sb_sb_FABOSC_0_OSC
# Microsemi Corp.
# Date: 2022-Feb-14 21:43:22
#

create_clock -ignore_errors -period 20 [ get_pins { I_RCOSC_25_50MHZ/CLKOUT } ]
