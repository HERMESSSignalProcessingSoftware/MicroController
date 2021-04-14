------------------------------------------------------------------------
--
-- Copyright (c) 2002-2007 Microsemi Corp.
--
-- Please review the terms of the license agreement before using this
-- file.  If you are not an authorized user, please destroy this source
-- code file and notify Microsemi Corp immediately that you inadvertently received
-- an unauthorized copy.
------------------------------------------------------------------------
--
--  Project       : CORE16550 Synchronous UART
--
--  File          : CORE16550.vhd
--
--  Dependencies  : CORE16550w.vhd
--
--  Model Type    : Synthesizable Core
--
--  Description   : APB interface for CORE16550 UART with FIFO
--
--  Designer      : Haribabu Jagarlamudi
--
--
--  Creation Date : 06-June-2007
--
--
--
------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
library Core16550_lib;
use Core16550_lib.Core16550_package.all;

ENTITY CORE16550 IS
   GENERIC (
      -- DEVICE FAMILY 
      FAMILY                         :  integer := 15); 
   PORT (
      -- APB interface
      
      -- APB system reset
      PCLK             : IN STD_LOGIC;		-- APB system clock
      PRESETN          : IN STD_LOGIC;
      PADDR            : IN STD_LOGIC_VECTOR(4 DOWNTO 0);		-- Latched address
      PSEL             : IN STD_LOGIC;
      PENABLE          : IN STD_LOGIC;
      PWRITE           : IN STD_LOGIC;
      PWDATA           : IN STD_LOGIC_VECTOR(7 DOWNTO 0);		-- 8 bit write data
      PRDATA           : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);		-- 8 bit read data 
      CTSN             : IN STD_LOGIC;
      DCDN             : IN STD_LOGIC;
      DSRN             : IN STD_LOGIC;
      RIN              : IN STD_LOGIC;
      SIN              : IN STD_LOGIC;
      SOUT             : OUT STD_LOGIC;
      BAUDOUTN         : OUT STD_LOGIC;
      DTRN             : OUT STD_LOGIC;
      RTSN             : OUT STD_LOGIC;
      OUT1N            : OUT STD_LOGIC;
      OUT2N            : OUT STD_LOGIC;
      INTR             : OUT STD_LOGIC;
      RXRDYN           : OUT STD_LOGIC;
      TXRDYN           : OUT STD_LOGIC;
      RXFIFO_FULL      : OUT STD_LOGIC;
      RXFIFO_EMPTY     : OUT STD_LOGIC
   );
END ENTITY CORE16550;

ARCHITECTURE trans OF CORE16550 IS
   
   --------------------------
   -- component declarations
   --------------------------
component Core16550w is
  generic(SYNC_RESET: integer := 0);
  port( 
      mr       : in     std_logic;                                 -- Master Reset
      clk      : in     std_logic;                                 -- System Clock
      cs       : in     std_logic;                                 -- Latched Chip Enable
      rd       : in     std_logic;                                 -- Read Enable
      wr       : in     std_logic;                                 -- Write Enable
      ctsn     : in     std_logic;                                 -- Clear To Send Enable
      dcdn     : in     std_logic;                                 -- Data Carrier Detect
      dsrn     : in     std_logic;                                 -- Data Set Ready
      rin      : in     std_logic;                                 -- Ring indicator
      sin      : in     std_logic;                                 -- Serial Input
      a        : in     std_logic_vector (ADDR_WIDTH-1 DOWNTO 0);  -- Latched address
      din      : in     std_logic_vector (DATA_WIDTH-1 DOWNTO 0);  -- Data input bus

      ddis     : out    std_logic;                                 -- Data Bus driver disable
      sout     : out    std_logic;                                 -- Serial ouput
      baudoutn : out    std_logic;                                 -- Baud out
      dtrn     : out    std_logic;                                 -- Data terminal ready
      rtsn     : out    std_logic;                                 -- Request To send
      out1n    : out    std_logic;                                 -- Output 1
      out2n    : out    std_logic;                                 -- Output 2
      intr     : out    std_logic;                                 -- Interrupt
      rxfifo_full   : out std_logic;     -- Receiver Fifo Full Flag
      rxfifo_empty  : out std_logic;     -- Receiver Fifo Empty Flag
      rxrdyn   : out    std_logic;                                 -- Receiver ready
      txrdyn   : out    std_logic;                                 -- Transmitter ready
      dout     : out    std_logic_vector (DATA_WIDTH-1 DOWNTO 0)   -- Data Output Bus
   );
end component;
   
   CONSTANT SYNC_RESET : INTEGER := SYNC_MODE_SEL(FAMILY);

   SIGNAL PRESET                 : STD_LOGIC;
   SIGNAL WR                     : STD_LOGIC;
   SIGNAL RD                     : STD_LOGIC;
   SIGNAL cs                     : STD_LOGIC;
   
   -- Declare intermediate signals for referenced outputs
   SIGNAL PRDATA_xhdl6           : STD_LOGIC_VECTOR(7 DOWNTO 0);
   SIGNAL DDIS_xhdl1             : STD_LOGIC;
   SIGNAL SOUT_xhdl12            : STD_LOGIC;
   SIGNAL BAUDOUTN_xhdl0         : STD_LOGIC;
   SIGNAL DTRN_xhdl2             : STD_LOGIC;
   SIGNAL RTSN_xhdl7             : STD_LOGIC;
   SIGNAL OUT1N_xhdl4            : STD_LOGIC;
   SIGNAL OUT2N_xhdl5            : STD_LOGIC;
   SIGNAL INTR_xhdl3             : STD_LOGIC;
   SIGNAL RXRDYN_xhdl11          : STD_LOGIC;
   SIGNAL TXRDYN_xhdl13          : STD_LOGIC;
   SIGNAL RXFIFO_FULL_xhdl9      : STD_LOGIC;
   SIGNAL RXFIFO_EMPTY_xhdl8     : STD_LOGIC;
BEGIN
   -- Drive referenced outputs
   PRDATA <= PRDATA_xhdl6;
   SOUT <= SOUT_xhdl12;
   BAUDOUTN <= BAUDOUTN_xhdl0;
   DTRN <= DTRN_xhdl2;
   RTSN <= RTSN_xhdl7;
   OUT1N <= OUT1N_xhdl4;
   OUT2N <= OUT2N_xhdl5;
   INTR <= INTR_xhdl3;
   RXRDYN <= RXRDYN_xhdl11;
   TXRDYN <= TXRDYN_xhdl13;
   RXFIFO_FULL <= RXFIFO_FULL_xhdl9;
   RXFIFO_EMPTY <= RXFIFO_EMPTY_xhdl8;
   ------------------------------------------------------------------------
   -- Write enable, output enable and select signals for UART
   ------------------------------------------------------------------------
   -- WR only asserted (high) when writing transmit data
   WR <= (PENABLE AND PWRITE);
   -- RD only asserted (high) when reading received data
   RD <= (PENABLE AND NOT(PWRITE));
   -- Active high reset 
   PRESET <= NOT(PRESETN);
   -- generate cs 
   cs <= PSEL AND PENABLE;
   
   
   u_CORE16550 : Core16550w
      GENERIC MAP(SYNC_RESET => SYNC_RESET)
      PORT MAP (
         mr               => PRESET,
         clk              => PCLK,
         cs               => cs,
         rd               => RD,
         wr               => WR,
         ctsn             => CTSN,
         dcdn             => DCDN,
         dsrn             => DSRN,
         rin              => RIN,
         sin              => SIN,
         a                => PADDR(4 DOWNTO 2),
         din              => PWDATA,
         ddis             => DDIS_xhdl1,
         sout             => SOUT_xhdl12,
         baudoutn         => BAUDOUTN_xhdl0,
         dtrn             => DTRN_xhdl2,
         rtsn             => RTSN_xhdl7,
         out1n            => OUT1N_xhdl4,
         out2n            => OUT2N_xhdl5,
         intr             => INTR_xhdl3,
         rxrdyn           => RXRDYN_xhdl11,
         txrdyn           => TXRDYN_xhdl13,
         dout             => PRDATA_xhdl6,
         rxfifo_full      => RXFIFO_FULL_xhdl9,
         rxfifo_empty     => RXFIFO_EMPTY_xhdl8
      );
   
END ARCHITECTURE trans;


