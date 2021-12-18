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
--  Project       : Core16550 Synchronous UART
--
--  File          : uart_fifo_smartfusion2.vhd
--
--  Dependencies  : none 
--
--  Model Type    : Synthesizable Core
--
--  Description   : Core16550 FIFO implemented using Microsemi Smartfusion2 embedded memory
--
--  Designer      : EOR
--
--  QA Engineer   : XXX
--
--  Creation Date : 27-January-2012
--
--  Last Update   : 27-January-2012
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
library smartfusion2;

entity uart_fifo is
   generic (FIFOREG : integer range 0 to 1 := 0);
   port ( clk           : in  std_logic;    -- System Clock
          wr            : in  std_logic;    -- Write Enable
          mr            : in  std_logic;    -- Master Reset 
          reset_rxfifo  : in  std_logic;    -- Reset receiver fifo
          reset_txfifo  : in  std_logic;    -- Reset transceiver fifo
          txfifo_wr     : in  std_logic;    -- Write Transmit holding register enable
          rxfifo_wr     : in  std_logic;    -- Write Receiver Fifo enable
          d             : in  std_logic_vector(DATA_WIDTH-1 downto 0);  -- Data input  
          rxf           : in  std_logic_vector(10 downto 0);  -- Receiver Fifo data
          rxwr_addr     : in  std_logic_vector(3 downto 0);   -- Receiver Write Fifo address
          rxrd_addr     : in  std_logic_vector(3 downto 0);   -- Receiver Read fifo address
          txwr_addr     : in  std_logic_vector(3 downto 0);   -- Transmitter Write Fifo address
          txrd_addr     : in  std_logic_vector(3 downto 0);   -- Transmitter Read Fifo address

          threg         : out std_logic_vector(DATA_WIDTH-1 downto 0);  -- Transmitter hold register
          rbreg         : out std_logic_vector(DATA_WIDTH-1 downto 0);  -- Receiver buffer register
          rbreg_rxf     : out std_logic_vector(2 downto 0)   -- Receiver Status buffer register
          );
end uart_fifo;


architecture rtl of uart_fifo is

   signal rbreg_rxf_int : std_logic_vector(10 downto 0);
   signal mrn, rx_wrenb, tx_wrenb : std_logic;
   signal DOUT_rx, DOUT_tx : std_logic_vector(17 downto 0);
   signal A_ADDR_rx_int, A_ADDR_tx_int : std_logic_vector(9 downto 0);
   signal B_ADDR_rx_int, B_ADDR_tx_int: std_logic_vector(9 downto 0);
   signal C_ADDR_rx_int, C_ADDR_tx_int : std_logic_vector(9 downto 0);
   signal C_DIN_rx_int, C_DIN_tx_int : std_logic_vector(17 downto 0);
   
   
   
   
 COMPONENT RAM64x18
  port(
                             A_DOUT : out   STD_LOGIC_VECTOR(17 downto 0);
                             B_DOUT : out   STD_LOGIC_VECTOR(17 downto 0);
                               BUSY : out   STD_LOGIC;
                         A_ADDR_CLK : in    STD_LOGIC;
                         A_DOUT_CLK : in    STD_LOGIC;
                      A_ADDR_SRST_N : in    STD_LOGIC;
                      A_DOUT_SRST_N : in    STD_LOGIC;
                      A_ADDR_ARST_N : in    STD_LOGIC;
                      A_DOUT_ARST_N : in    STD_LOGIC;
                          A_ADDR_EN : in    STD_LOGIC;
                          A_DOUT_EN : in    STD_LOGIC;
                              A_BLK : in    STD_LOGIC_VECTOR(1 downto 0);
                             A_ADDR : in    STD_LOGIC_VECTOR(9 downto 0);
                         B_ADDR_CLK : in    STD_LOGIC;
                         B_DOUT_CLK : in    STD_LOGIC;
                      B_ADDR_SRST_N : in    STD_LOGIC;
                      B_DOUT_SRST_N : in    STD_LOGIC;
                      B_ADDR_ARST_N : in    STD_LOGIC;
                      B_DOUT_ARST_N : in    STD_LOGIC;
                          B_ADDR_EN : in    STD_LOGIC;
                          B_DOUT_EN : in    STD_LOGIC;
                              B_BLK : in    STD_LOGIC_VECTOR(1 downto 0);
                             B_ADDR : in    STD_LOGIC_VECTOR(9 downto 0);
                              C_CLK : in    STD_LOGIC;
                             C_ADDR : in    STD_LOGIC_VECTOR(9 downto 0);
                              C_DIN : in    STD_LOGIC_VECTOR(17 downto 0);
                              C_WEN : in    STD_LOGIC;
                              C_BLK : in    STD_LOGIC_VECTOR(1 downto 0);
                               A_EN : in    STD_LOGIC;
                         A_ADDR_LAT : in    STD_LOGIC;
                         A_DOUT_LAT : in    STD_LOGIC;
                            A_WIDTH : in    STD_LOGIC_VECTOR(2 downto 0);
                               B_EN : in    STD_LOGIC;
                         B_ADDR_LAT : in    STD_LOGIC;
                         B_DOUT_LAT : in    STD_LOGIC;
                            B_WIDTH : in    STD_LOGIC_VECTOR(2 downto 0);
                               C_EN : in    STD_LOGIC;
                            C_WIDTH : in    STD_LOGIC_VECTOR(2 downto 0);
                           SII_LOCK : in    STD_LOGIC
  );
END COMPONENT;
 
    component VCC
        port( Y : out std_logic);
    end component;

    component GND
        port( Y : out std_logic);
    end component;

    signal VCC_1_net, GND_1_net : std_logic ;
    signal rclkb: std_logic ;

begin

   -------------
   -- RCVR FIFO 
   -------------

   VCC_2_net : VCC port map(Y => VCC_1_net);
   GND_2_net : GND port map(Y => GND_1_net);
   mrn <= not(mr);
   rx_wrenb <= not(rxfifo_wr);
   rbreg_rxf_int <= DOUT_rx(10 downto 0);
   threg <= DOUT_tx(7 downto 0);
   rbreg <= rbreg_rxf_int(10 downto 3);
   rbreg_rxf <= rbreg_rxf_int(2 downto 0);
   rclkb <= not clk;
   A_ADDR_rx_int <= "0000000000";
   A_ADDR_tx_int <= "0000000000";
   B_ADDR_rx_int <= "00" & rxrd_addr & "0000";
   B_ADDR_tx_int <= "00" & txrd_addr & "0000";
   C_ADDR_rx_int <= "00" & rxwr_addr & "0000";
   C_ADDR_tx_int <= "00" & txwr_addr & "0000";
   C_DIN_rx_int <= "0000000" & rxf;
   C_DIN_tx_int <= "0000000000" & d;
   
    u_rx_fifo_ram : RAM64x18		
    PORT MAP( 
                A_DOUT => open,
                B_DOUT => DOUT_rx, 
                BUSY => open, 
                A_ADDR_CLK => GND_1_net, 
                A_DOUT_CLK => GND_1_net,
                A_ADDR_SRST_N => VCC_1_NET,
                A_DOUT_SRST_N => VCC_1_NET, 
                A_ADDR_ARST_N => VCC_1_NET, 
                A_DOUT_ARST_N => VCC_1_NET,
                A_ADDR_EN => GND_1_NET, 
                A_DOUT_EN => GND_1_NET,
                A_BLK => "00",
                A_ADDR => A_ADDR_rx_int, 
                B_ADDR_CLK => rclkb, 
                B_DOUT_CLK => VCC_1_NET,
                B_ADDR_SRST_N => mrn, 
                B_DOUT_SRST_N => mrn, 
                B_ADDR_ARST_N => mrn, 
                B_DOUT_ARST_N => mrn, 
                B_ADDR_EN => VCC_1_NET, 
                B_DOUT_EN => VCC_1_NET, 
                B_BLK => "11",
                B_ADDR => B_ADDR_rx_int, 
                C_CLK => clk,
                C_ADDR => C_ADDR_rx_int,
                C_DIN => C_DIN_rx_int,
                C_WEN => rxfifo_wr,
                C_BLK => "11",
                A_EN => GND_1_net,
                A_ADDR_LAT => GND_1_NET, 
                A_DOUT_LAT => GND_1_NET,
                B_EN => VCC_1_NET, 
                B_ADDR_LAT => GND_1_NET, 
                B_DOUT_LAT => VCC_1_NET, 
                C_EN => VCC_1_NET, 
                A_WIDTH => "101",
                B_WIDTH => "101",
                C_WIDTH => "101",
                SII_LOCK => VCC_1_net);			
   -------------
   -- XMIT FIFO 
   -------------
   tx_wrenb <= (txfifo_wr and wr);

    u_tx_fifo_ram : RAM64x18
    PORT MAP( 
                A_DOUT => open,
                B_DOUT => DOUT_tx, 
                BUSY => open, 
                A_ADDR => B_ADDR_tx_int,
                A_EN => GND_1_NET,
                A_ADDR_LAT => GND_1_NET, 
                A_DOUT_LAT => GND_1_NET,
				A_ADDR_CLK => GND_1_NET,
                A_DOUT_CLK => GND_1_NET,
                A_ADDR_SRST_N => VCC_1_NET,
                A_DOUT_SRST_N => VCC_1_NET, 
                A_ADDR_ARST_N => VCC_1_NET, 
                A_DOUT_ARST_N => VCC_1_NET,
                A_ADDR_EN => GND_1_NET, 
                A_DOUT_EN => GND_1_NET,
                A_BLK => "00",
                B_ADDR_SRST_N => mrn, 
                B_DOUT_SRST_N => mrn, 
                B_ADDR_ARST_N => mrn, 
                B_DOUT_ARST_N => mrn, 
                B_ADDR_EN => VCC_1_NET, 
                B_DOUT_EN => VCC_1_NET, 
                B_BLK => "11",
                B_ADDR => B_ADDR_tx_int,
				B_EN => VCC_1_NET, 
				B_ADDR_CLK => rclkb, 
                B_DOUT_CLK => VCC_1_NET,
				B_ADDR_LAT => GND_1_NET, 
                B_DOUT_LAT => VCC_1_NET, 	
                C_CLK => clk,
                C_ADDR => C_ADDR_tx_int,
                C_DIN => C_DIN_tx_int,
                C_WEN => tx_wrenb,
                C_BLK => "11",
                C_EN => VCC_1_NET, 
                A_WIDTH => "101",
                B_WIDTH => "101",
                C_WIDTH => "101",
                SII_LOCK => VCC_1_net);		

end rtl;

