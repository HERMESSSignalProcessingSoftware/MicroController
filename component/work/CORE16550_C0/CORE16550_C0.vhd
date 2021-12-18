----------------------------------------------------------------------
-- Created by SmartDesign Thu Apr  1 23:26:38 2021
-- Version: v12.6 12.900.20.24
----------------------------------------------------------------------

----------------------------------------------------------------------
-- Component Description (Tcl) 
----------------------------------------------------------------------
--# Exporting Component Description of CORE16550_C0 to TCL
--# Family: SmartFusion2
--# Part Number: M2S010-VF400
--# Create and Configure the core component CORE16550_C0
--create_and_configure_core -core_vlnv {Actel:DirectCore:CORE16550:3.3.105} -component_name {CORE16550_C0} -params { }
--# Exporting Component Description of CORE16550_C0 to TCL done

----------------------------------------------------------------------
-- Libraries
----------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;

library smartfusion2;
use smartfusion2.all;
library CORE16550_LIB;
use CORE16550_LIB.all;
use CORE16550_LIB.components.all;
----------------------------------------------------------------------
-- CORE16550_C0 entity declaration
----------------------------------------------------------------------
entity CORE16550_C0 is
    -- Port list
    port(
        -- Inputs
        CTSN         : in  std_logic;
        DCDN         : in  std_logic;
        DSRN         : in  std_logic;
        PADDR        : in  std_logic_vector(4 downto 0);
        PCLK         : in  std_logic;
        PENABLE      : in  std_logic;
        PRESETN      : in  std_logic;
        PSEL         : in  std_logic;
        PWDATA       : in  std_logic_vector(7 downto 0);
        PWRITE       : in  std_logic;
        RIN          : in  std_logic;
        SIN          : in  std_logic;
        -- Outputs
        BAUDOUTN     : out std_logic;
        DTRN         : out std_logic;
        INTR         : out std_logic;
        OUT1N        : out std_logic;
        OUT2N        : out std_logic;
        PRDATA       : out std_logic_vector(7 downto 0);
        RTSN         : out std_logic;
        RXFIFO_EMPTY : out std_logic;
        RXFIFO_FULL  : out std_logic;
        RXRDYN       : out std_logic;
        SOUT         : out std_logic;
        TXRDYN       : out std_logic
        );
end CORE16550_C0;
----------------------------------------------------------------------
-- CORE16550_C0 architecture body
----------------------------------------------------------------------
architecture RTL of CORE16550_C0 is
----------------------------------------------------------------------
-- Component declarations
----------------------------------------------------------------------
-- CORE16550   -   Actel:DirectCore:CORE16550:3.3.105
-- using entity instantiation for component CORE16550
----------------------------------------------------------------------
-- Signal declarations
----------------------------------------------------------------------
signal APBslave_PRDATA       : std_logic_vector(7 downto 0);
signal BAUDOUTN_net_0        : std_logic;
signal DTRN_net_0            : std_logic;
signal INTR_net_0            : std_logic;
signal OUT1N_net_0           : std_logic;
signal OUT2N_net_0           : std_logic;
signal RTSN_net_0            : std_logic;
signal RXFIFO_EMPTY_net_0    : std_logic;
signal RXFIFO_FULL_net_0     : std_logic;
signal RXRDYN_net_0          : std_logic;
signal SOUT_net_0            : std_logic;
signal TXRDYN_net_0          : std_logic;
signal BAUDOUTN_net_1        : std_logic;
signal DTRN_net_1            : std_logic;
signal INTR_net_1            : std_logic;
signal OUT1N_net_1           : std_logic;
signal OUT2N_net_1           : std_logic;
signal RTSN_net_1            : std_logic;
signal RXFIFO_EMPTY_net_1    : std_logic;
signal RXFIFO_FULL_net_1     : std_logic;
signal RXRDYN_net_1          : std_logic;
signal SOUT_net_1            : std_logic;
signal TXRDYN_net_1          : std_logic;
signal APBslave_PRDATA_net_0 : std_logic_vector(7 downto 0);

begin
----------------------------------------------------------------------
-- Top level output port assignments
----------------------------------------------------------------------
 BAUDOUTN_net_1        <= BAUDOUTN_net_0;
 BAUDOUTN              <= BAUDOUTN_net_1;
 DTRN_net_1            <= DTRN_net_0;
 DTRN                  <= DTRN_net_1;
 INTR_net_1            <= INTR_net_0;
 INTR                  <= INTR_net_1;
 OUT1N_net_1           <= OUT1N_net_0;
 OUT1N                 <= OUT1N_net_1;
 OUT2N_net_1           <= OUT2N_net_0;
 OUT2N                 <= OUT2N_net_1;
 RTSN_net_1            <= RTSN_net_0;
 RTSN                  <= RTSN_net_1;
 RXFIFO_EMPTY_net_1    <= RXFIFO_EMPTY_net_0;
 RXFIFO_EMPTY          <= RXFIFO_EMPTY_net_1;
 RXFIFO_FULL_net_1     <= RXFIFO_FULL_net_0;
 RXFIFO_FULL           <= RXFIFO_FULL_net_1;
 RXRDYN_net_1          <= RXRDYN_net_0;
 RXRDYN                <= RXRDYN_net_1;
 SOUT_net_1            <= SOUT_net_0;
 SOUT                  <= SOUT_net_1;
 TXRDYN_net_1          <= TXRDYN_net_0;
 TXRDYN                <= TXRDYN_net_1;
 APBslave_PRDATA_net_0 <= APBslave_PRDATA;
 PRDATA(7 downto 0)    <= APBslave_PRDATA_net_0;
----------------------------------------------------------------------
-- Component instances
----------------------------------------------------------------------
-- CORE16550_C0_0   -   Actel:DirectCore:CORE16550:3.3.105
CORE16550_C0_0 : entity CORE16550_LIB.CORE16550
    generic map( 
        FAMILY => ( 19 )
        )
    port map( 
        -- Inputs
        CTSN         => CTSN,
        DCDN         => DCDN,
        DSRN         => DSRN,
        PADDR        => PADDR,
        PCLK         => PCLK,
        PENABLE      => PENABLE,
        PRESETN      => PRESETN,
        PSEL         => PSEL,
        PWDATA       => PWDATA,
        PWRITE       => PWRITE,
        RIN          => RIN,
        SIN          => SIN,
        -- Outputs
        BAUDOUTN     => BAUDOUTN_net_0,
        DTRN         => DTRN_net_0,
        INTR         => INTR_net_0,
        OUT1N        => OUT1N_net_0,
        OUT2N        => OUT2N_net_0,
        PRDATA       => APBslave_PRDATA,
        RTSN         => RTSN_net_0,
        RXFIFO_EMPTY => RXFIFO_EMPTY_net_0,
        RXFIFO_FULL  => RXFIFO_FULL_net_0,
        RXRDYN       => RXRDYN_net_0,
        SOUT         => SOUT_net_0,
        TXRDYN       => TXRDYN_net_0 
        );

end RTL;
