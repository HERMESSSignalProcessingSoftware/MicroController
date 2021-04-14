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
--  Project       : Core16550w Synchronous UART
--
--  File          : Core16550w.vhd
--
--  Dependencies  : rwcontrol.vhd, uart_reg.vhd, intcontrol.vhd, baudgen.vhd,
--                  rxblock.vhd, txblock.vhd, fifoctrl.vhd 
--
--  Model Type    : Synthesizable Core
--
--  Description   : Core16550 UART with FIFO
-- 
--  Designer      : JU
--
--  QA Engineer   : JH
--
--  Creation Date : 02-January-2002
--
--  Last Update   : 23-January-2007
--
--  Version       : 1H20N00S00
--
------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
library Core16550_lib;
use Core16550_lib.Core16550_package.all;

entity Core16550w is
  generic(SYNC_RESET: INTEGER := 0);
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
end Core16550w;


----------------------------------
-- architecture for entity h16550s
----------------------------------
architecture str of Core16550w is

--------------------------
-- component declarations
--------------------------
   component rwcontrol
      generic(SYNC_RESET: INTEGER := 0);
      port ( cs          : in  std_logic;
             rd          : in  std_logic;
             mr          : in  std_logic;
             clk         : in  std_logic;
             fcreg0      : in  std_logic;
             a           : in  std_logic_vector(ADDR_WIDTH-1 downto 0);
             rbreg       : in  std_logic_vector(DATA_WIDTH-1 downto 0);
             dmreg       : in  std_logic_vector(DATA_WIDTH-1 downto 0);
             dlreg       : in  std_logic_vector(DATA_WIDTH-1 downto 0);
             iereg       : in  std_logic_vector(3 downto 0);
             iireg       : in  std_logic_vector(3 downto 0);
             lcreg       : in  std_logic_vector(DATA_WIDTH-1 downto 0);
             lsreg       : in  std_logic_vector(DATA_WIDTH-1 downto 0);
             mcreg       : in  std_logic_vector(4 downto 0);
             msreg       : in  std_logic_vector(DATA_WIDTH-1 downto 0);
             sreg        : in  std_logic_vector(DATA_WIDTH-1 downto 0);
             ena_ier     : out std_logic;
             ena_lcr     : out std_logic;
             ena_mcr     : out std_logic;
             ena_sr      : out std_logic;
             read_msr    : out std_logic;
             read_lsr    : out std_logic;
             wrfcr_rdiir : out std_logic;
             wrthr_rdrbr : out std_logic;
             write_dlr   : out std_logic;
             write_dmr   : out std_logic;
             ddis        : out std_logic;
             d           : out std_logic_vector(DATA_WIDTH-1 downto 0);
             msrl        : out std_logic_vector(3 downto 0);
			 msrpres     : out std_logic_vector(3 downto 0)
			 );
   end component;

   component uart_reg
      generic(SYNC_RESET: INTEGER := 0);
      port ( clk         : in  std_logic;
             mr          : in  std_logic;
             cs          : in  std_logic;
             rd          : in  std_logic;
             wr          : in  std_logic;
             rclk_enb    : in  std_logic;
             wrthr_rdrbr : in  std_logic;
             write_dlr   : in  std_logic;
             write_dmr   : in  std_logic;
             ena_ier     : in  std_logic;
             ena_lcr     : in  std_logic;
             ena_mcr     : in  std_logic;
             ena_sr      : in  std_logic;
             read_msr    : in  std_logic;
             wrfcr_rdiir : in  std_logic;
             prevrdlsr   : in  std_logic;
             ctsn        : in  std_logic;
             dsrn        : in  std_logic;
             dcdn        : in  std_logic;
             rin         : in  std_logic;
             read_txfifo : in  std_logic;
             txfifo_empty: in  std_logic;
             txfifo_1char: in  std_logic;
             write_rxfifo: in  std_logic;
             rxfifo_full : in  std_logic;
             lsreg_b2    : in  std_logic;
             lsreg_b3    : in  std_logic;
             lsreg_b4    : in  std_logic;
             lsreg_b7    : in  std_logic;
             temt        : in  std_logic;
             sin         : in  std_logic;
             sout_org    : in  std_logic;
             rxfifo_value: in  std_logic_vector(4 downto 0);
             d           : in  std_logic_vector(DATA_WIDTH-1 downto 0);
             sin_org     : out std_logic;
             rtsn        : out std_logic;
             dtrn        : out std_logic;
             out1n       : out std_logic;
             out2n       : out std_logic;
             sout        : out std_logic;
             dmreg       : out std_logic_vector(DATA_WIDTH-1 downto 0);
             dlreg       : out std_logic_vector(DATA_WIDTH-1 downto 0);
             fcreg       : out std_logic_vector(5 downto 0);
             iereg       : out std_logic_vector(3 downto 0);
             lcreg       : out std_logic_vector(DATA_WIDTH-1 downto 0);
             lsreg       : out std_logic_vector(DATA_WIDTH-1 downto 0);
             mcreg       : out std_logic_vector(4 downto 0);
             msreg       : out std_logic_vector(DATA_WIDTH-1 downto 0);
             sreg        : out std_logic_vector(DATA_WIDTH-1 downto 0);
			 msrl        : in std_logic_vector(3 downto 0);
			 msrpres     : in std_logic_vector(3 downto 0)
             );
   end component;

   component intcontrol
      generic(SYNC_RESET: INTEGER := 0);
      port ( clk           : in  std_logic;
             cs            : in  std_logic;
             rd            : in  std_logic;
             wr            : in  std_logic;
             mr            : in  std_logic;
             rclk_enb      : in  std_logic;
             d0            : in  std_logic;
             d1            : in  std_logic;
             rxbaud        : in  std_logic;
             rxfifo_empty  : in  std_logic;
             txfifo_empty  : in  std_logic;
             write_rxfifo  : in  std_logic;
             read_txfifo   : in  std_logic;
             wrfcr_rdiir   : in  std_logic;
             ena_ier       : in  std_logic;
             wrthr_rdrbr   : in  std_logic;
             fcreg0        : in  std_logic;
             fcreg1        : in  std_logic;
             fcreg2        : in  std_logic;
             rxfifo_full   : in  std_logic;
             txfifo_2char  : in  std_logic;
             stop_state    : in  std_logic;
             lsreg         : in  std_logic_vector(DATA_WIDTH-1 downto 0);
             msreg         : in  std_logic_vector(3 downto 0);
             iereg         : in  std_logic_vector(3 downto 0);
             frame_size    : in  std_logic_vector(3 downto 0);
             rxfifo_value  : in  std_logic_vector(4 downto 0);
             trig          : in  std_logic_vector(3 downto 0);
             intr          : out std_logic;
             iireg         : out std_logic_vector(3 downto 0)
             );
   end component;

   component baudgen
      generic(SYNC_RESET: INTEGER := 0);
      port ( clk          : in  std_logic;
             mr           : in  std_logic;
             dlreg        : in  std_logic_vector(DATA_WIDTH-1 downto 0);
             dmreg        : in  std_logic_vector(DATA_WIDTH-1 downto 0);
             rclk_enb     : out std_logic;
             baudoutn     : out std_logic;
             txbaud       : out std_logic
             );
   end component;

   component rxblock
      generic(SYNC_RESET: INTEGER := 0);
      port ( clk          : in  std_logic;
             mr           : in  std_logic;
             cs           : in  std_logic;
             rd           : in  std_logic;
             rclk_enb     : in  std_logic;
             fcreg1       : in  std_logic;
             prevrdlsr    : in  std_logic;
             sin_org      : in  std_logic;
             lcreg        : in  std_logic_vector(5 downto 0);
             write_rxfifo : out std_logic;
             rxbaud       : out std_logic;
             frame_size   : out std_logic_vector(3 downto 0);
             rxf          : out std_logic_vector(10 downto 0)
             );
   end component;

   component txblock
      generic(SYNC_RESET: INTEGER := 0);
      port ( clk           : in  std_logic;
             mr            : in  std_logic;
             txbaud        : in  std_logic;
             txfifo_empty  : in  std_logic;
             lcreg         : in  std_logic_vector(6 downto 0);
             threg         : in  std_logic_vector(DATA_WIDTH-1 downto 0);
             temt          : out std_logic;
             stop_state    : out std_logic;
             read_txfifo   : out std_logic;
             sout_org      : out std_logic
             );
   end component;

   component fifoctrl
      generic(SYNC_RESET: INTEGER := 0);
      port ( clk          : in  std_logic;
             cs           : in  std_logic;
             rd           : in  std_logic;
             wr           : in  std_logic;
             rclk_enb     : in  std_logic;
             mr           : in  std_logic;
             write_rxfifo : in  std_logic;
             read_txfifo  : in  std_logic;
             wrthr_rdrbr  : in  std_logic;
             wrfcr_rdiir  : in  std_logic;
             read_lsr     : in  std_logic;
             d            : in  std_logic_vector(DATA_WIDTH-1 downto 0);
             fcreg        : in  std_logic_vector(5 downto 0);
             rxf          : in  std_logic_vector(10 downto 0);
             lsreg        : in  std_logic_vector(DATA_WIDTH-1 downto 0);
             prevrdlsr    : out std_logic;
             lsreg_b2     : out std_logic;
             lsreg_b3     : out std_logic;
             lsreg_b4     : out std_logic;
             lsreg_b7     : out std_logic;
             txfifo_empty : out std_logic;
             txfifo_2char : out std_logic;
             txfifo_1char : out std_logic;
             rxfifo_full  : out std_logic;
             rxfifo_empty : out std_logic;
             rxrdyn       : out std_logic;
             txrdyn       : out std_logic;
             trig         : out std_logic_vector(3 downto 0);
             rxfifo_value : out std_logic_vector(4 downto 0);
             rbreg        : out std_logic_vector(DATA_WIDTH-1 downto 0);
             threg        : out std_logic_vector(DATA_WIDTH-1 downto 0)
             );
   end component;

   signal rbreg         : std_logic_vector(DATA_WIDTH-1 downto 0);
   signal dmreg         : std_logic_vector(DATA_WIDTH-1 downto 0);
   signal dlreg         : std_logic_vector(DATA_WIDTH-1 downto 0);
   signal lcreg         : std_logic_vector(DATA_WIDTH-1 downto 0);
   signal fcreg         : std_logic_vector(5 downto 0);
   signal mcreg         : std_logic_vector(4 downto 0);
   signal iereg         : std_logic_vector(3 downto 0);
   signal iireg         : std_logic_vector(3 downto 0);
   signal trig          : std_logic_vector(3 downto 0);
   signal rxfifo_value  : std_logic_vector(4 downto 0);
   signal msreg         : std_logic_vector(DATA_WIDTH-1 downto 0);
   signal sreg          : std_logic_vector(DATA_WIDTH-1 downto 0);
   signal lsreg         : std_logic_vector(DATA_WIDTH-1 downto 0);
   signal threg         : std_logic_vector(DATA_WIDTH-1 downto 0);
   signal rxf           : std_logic_vector(10 downto 0);
   signal frame_size    : std_logic_vector(3 downto 0);
   signal lsreg_b3      : std_logic;
   signal lsreg_b4      : std_logic;
   signal lsreg_b2      : std_logic;
   signal ena_ier       : std_logic;
   signal ena_lcr       : std_logic;
   signal ena_mcr       : std_logic;
   signal ena_sr        : std_logic;
   signal write_rxfifo  : std_logic;
   signal read_txfifo   : std_logic;
   signal read_msr      : std_logic;
   signal wrfcr_rdiir   : std_logic;
   signal wrthr_rdrbr   : std_logic;
   signal read_lsr      : std_logic;
   signal txbaud        : std_logic;
   signal sin_org       : std_logic;
   signal sout_org      : std_logic;
   signal write_dlr     : std_logic;
   signal write_dmr     : std_logic;
   signal temt          : std_logic;
   signal txfifo_empty  : std_logic;
   signal txfifo_2char  : std_logic;
   signal txfifo_1char  : std_logic;
   signal lsreg_b7      : std_logic;
   signal rclk_enb      : std_logic;
   signal prevrdlsr     : std_logic;
   signal rxbaud        : std_logic;
   signal stop_state    : std_logic;
   signal rxfifo_full_xhdl9      : std_logic;
   signal rxfifo_empty_xhdl8     : std_logic;
   signal msrl          : std_logic_vector(3 downto 0);
   signal msrpres       : std_logic_vector(3 downto 0);

begin

   rxfifo_full <= rxfifo_full_xhdl9;
   rxfifo_empty <= rxfifo_empty_xhdl8;

   u_rwcontrol : rwcontrol
      generic map(SYNC_RESET => SYNC_RESET)
      port map(
         a           => a,
         cs          => cs,
         rd          => rd,
         mr          => mr,
         clk         => clk,
         fcreg0      => fcreg(0),
         rbreg       => rbreg,
         dmreg       => dmreg,
         dlreg       => dlreg,
         iereg       => iereg,
         iireg       => iireg,
         lcreg       => lcreg,
         lsreg       => lsreg,
         mcreg       => mcreg,
         msreg       => msreg,
         sreg        => sreg,
         ena_ier     => ena_ier,
         ena_lcr     => ena_lcr,
         ena_mcr     => ena_mcr,
         ena_sr      => ena_sr,
         read_msr    => read_msr,
         wrfcr_rdiir => wrfcr_rdiir,
         read_lsr    => read_lsr,
         wrthr_rdrbr => wrthr_rdrbr,
         write_dlr   => write_dlr,
         write_dmr   => write_dmr,
         ddis        => ddis,
         d           => dout,
		 msrl        => msrl,
		 msrpres     => msrpres
         );

   u_uart_reg : uart_reg
      generic map(SYNC_RESET => SYNC_RESET)
      port map(
         clk         => clk,
         mr          => mr,
         cs          => cs,
         rd          => rd,
         wr          => wr,
         rclk_enb    => rclk_enb,
         wrthr_rdrbr => wrthr_rdrbr,
         write_dlr   => write_dlr,
         write_dmr   => write_dmr,
         ena_ier     => ena_ier,
         ena_lcr     => ena_lcr,
         ena_mcr     => ena_mcr,
         ena_sr      => ena_sr,
         read_msr    => read_msr,
         wrfcr_rdiir => wrfcr_rdiir,
         prevrdlsr   => prevrdlsr,
         ctsn        => ctsn,
         dsrn        => dsrn,
         dcdn        => dcdn,
         rin         => rin,
         sin         => sin,
         read_txfifo => read_txfifo,
         txfifo_empty=> txfifo_empty,
         txfifo_1char=> txfifo_1char,
         write_rxfifo=> write_rxfifo,
         rxfifo_full => rxfifo_full_xhdl9,
         lsreg_b2    => lsreg_b2,
         lsreg_b3    => lsreg_b3,
         lsreg_b4    => lsreg_b4,
         lsreg_b7    => lsreg_b7,
         temt        => temt,
         sout_org    => sout_org,
         rxfifo_value=> rxfifo_value,
         d           => din,
         sin_org     => sin_org,
         rtsn        => rtsn,
         dtrn        => dtrn,
         out1n       => out1n,
         out2n       => out2n,
         sout        => sout,
         dmreg       => dmreg,
         dlreg       => dlreg,
         iereg       => iereg,
         lcreg       => lcreg,
         lsreg       => lsreg,
         mcreg       => mcreg,
         msreg       => msreg,
         fcreg       => fcreg,
         sreg        => sreg,
		 msrl        => msrl,
		 msrpres     => msrpres
         );

   u_intcontrol : intcontrol
      generic map(SYNC_RESET => SYNC_RESET)
      port map(
         clk           => clk,
         cs            => cs,
         rd            => rd,
         wr            => wr,
         mr            => mr,
         rclk_enb      => rclk_enb,
         d0            => din(0),
         d1            => din(1),
         rxbaud        => rxbaud,
         rxfifo_empty  => rxfifo_empty_xhdl8,
         txfifo_empty  => txfifo_empty,
         write_rxfifo  => write_rxfifo,
         read_txfifo   => read_txfifo,
         wrfcr_rdiir   => wrfcr_rdiir,
         ena_ier       => ena_ier,
         wrthr_rdrbr   => wrthr_rdrbr,
         fcreg0        => fcreg(0),
         fcreg1        => fcreg(1),
         fcreg2        => fcreg(2),
         rxfifo_full   => rxfifo_full_xhdl9,
         txfifo_2char  => txfifo_2char,
         stop_state    => stop_state,
         lsreg         => lsreg,
         msreg         => msreg(3 downto 0),
         iereg         => iereg,
         frame_size    => frame_size,
         rxfifo_value  => rxfifo_value,
         trig          => trig,
         intr          => intr,
         iireg         => iireg
         );

   u_baudgen : baudgen
      generic map(SYNC_RESET => SYNC_RESET)
      port map(
         clk          => clk,
         mr           => mr,
         dlreg        => dlreg,
         dmreg        => dmreg,
         rclk_enb     => rclk_enb,
         baudoutn     => baudoutn,
         txbaud       => txbaud
         );

   u_txblock : txblock
      generic map(SYNC_RESET => SYNC_RESET)
      port map(
         clk          => clk,
         mr           => mr,
         txbaud       => txbaud,
         txfifo_empty => txfifo_empty,
         lcreg        => lcreg(6 downto 0),
         threg        => threg,
         temt         => temt,
         stop_state   => stop_state,
         read_txfifo  => read_txfifo,
         sout_org     => sout_org
         );

   u_rxblock : rxblock
      generic map(SYNC_RESET => SYNC_RESET)
      port map(
         clk          => clk,
         mr           => mr,
         cs           => cs,
         rd           => rd,
         rclk_enb     => rclk_enb,
         prevrdlsr    => prevrdlsr,
         lcreg        => lcreg(5 downto 0),
         fcreg1       => fcreg(1),
         sin_org      => sin_org,
         rxf          => rxf,
         rxbaud       => rxbaud,
         frame_size   => frame_size,
         write_rxfifo => write_rxfifo
         );

   u_fifoctrl : fifoctrl
      generic map(SYNC_RESET => SYNC_RESET)
      port map(
         clk           => clk,
         cs            => cs,
         rd            => rd,
         wr            => wr,
         rclk_enb      => rclk_enb,
         mr            => mr,
         write_rxfifo  => write_rxfifo,
         read_txfifo   => read_txfifo,
         wrthr_rdrbr   => wrthr_rdrbr,
         wrfcr_rdiir   => wrfcr_rdiir,
         read_lsr      => read_lsr,
         d             => din,
         fcreg         => fcreg,
         rxf           => rxf,
         lsreg         => lsreg,
         prevrdlsr     => prevrdlsr,
         lsreg_b2      => lsreg_b2,
         lsreg_b3      => lsreg_b3,
         lsreg_b4      => lsreg_b4,
         lsreg_b7      => lsreg_b7,
         txfifo_empty  => txfifo_empty,
         txfifo_2char  => txfifo_2char,
         txfifo_1char  => txfifo_1char,
         rxfifo_full   => rxfifo_full_xhdl9,
         rxfifo_empty  => rxfifo_empty_xhdl8,
         rxrdyn        => rxrdyn,
         txrdyn        => txrdyn,
         trig          => trig,
         rxfifo_value  => rxfifo_value,
         rbreg         => rbreg,
         threg         => threg
         );

end str;  -- h16550s

