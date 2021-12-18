----------------------------------------------------------------------
-- Created by Microsemi SmartDesign Thu Apr  1 23:26:38 2021
-- Parameters for CORE16550
----------------------------------------------------------------------


LIBRARY ieee;
   USE ieee.std_logic_1164.all;
   USE ieee.std_logic_unsigned.all;
   USE ieee.numeric_std.all;

package coreparameters is
    constant FAMILY : integer := 19;
    constant HDL_license : string( 1 to 1 ) := "U";
    constant testbench : string( 1 to 4 ) := "User";
end coreparameters;
