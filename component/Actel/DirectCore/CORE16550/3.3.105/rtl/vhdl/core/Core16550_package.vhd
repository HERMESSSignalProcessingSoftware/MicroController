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
--  Project       : H16550S Synchronous UART
--
--  File          : Core16550_package.vhd
--  Package Name  : Core16550_package
--
--  Dependencies  : none
--
--  Description   : Types and Constant values for H16550S
-- 
--  Designer      : JS
--
--  QA Engineer   : JH
--
--  Creation Date : 29-January-2002
--
--  Last Update   : 23-April-2002
--
--  Version       : 1H20N00S00
--
------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

package Core16550_package is

   -- Receiver state machine
   type RX_STATE_MACHINE is (WAITING_START, REC1_BIT0, REC1_BIT1, REC1_BIT2, REC1_BIT3, REC1_BIT4,
                          REC1_BIT5, REC1_BIT6, REC1_BIT7, REC1_PARITY, REC1_STOP0, REC1_STOP1,
                          WAITING2, REC2_BIT0, REC2_BIT1, REC2_BIT2, REC2_BIT3, REC2_BIT4,
                          REC2_BIT5, REC2_BIT6, REC2_BIT7, REC2_PARITY, REC2_STOP0, REC2_STOP1);

   -- Transceiver state machine
   type TX_STATE_MACHINE is (WAITING1, SEND_START1, SEND_START2, SEND1_BIT0, SEND1_BIT1, SEND1_BIT2,
                          SEND1_BIT3, SEND1_BIT4, SEND1_BIT5, SEND1_BIT6, SEND1_BIT7, SEND1_PARITY,
                          SEND1_STOP0, SEND1_STOP1, SEND2_BIT0, SEND2_BIT1, SEND2_BIT2,
                          SEND2_BIT3, SEND2_BIT4, SEND2_BIT5, SEND2_BIT6, SEND2_BIT7, SEND2_PARITY,
                          SEND2_STOP0, SEND2_STOP1);

   type RXMEM is array (integer range 0 to 15) of std_logic_vector(10 downto 0);
   type TXMEM is array (integer range 0 to 15) of std_logic_vector(7 downto 0);

   constant DATA_WIDTH : integer := 8;
   constant ADDR_WIDTH : integer := 3;

   constant ZERO16 : std_logic_vector(15 downto 0) := "0000000000000000";
   constant ONE16 : std_logic_vector(15 downto 0) := "0000000000000001";
   constant TWO16 : std_logic_vector(15 downto 0) := "0000000000000010";

   constant FIFOMAXVALUE : std_logic_vector(4 downto 0) := "10000";   -- fifo size is 16 byte
   constant HALFFULLVALUE : std_logic_vector(4 downto 0) := "01000";   -- fifo size is 16 byte
 
   constant START : std_logic := '0';
   constant STOP : std_logic := '1';
   
   function SYNC_MODE_SEL( FAMILY: INTEGER) return INTEGER;
 
end Core16550_package;


package body Core16550_package is

	FUNCTION SYNC_MODE_SEL (FAMILY: INTEGER) RETURN INTEGER IS
        VARIABLE return_val : INTEGER := 0;
        BEGIN
		IF(FAMILY = 25) THEN
		    return_val := 1;
		ELSE
		    return_val := 0;
		END IF;
		RETURN return_val; 
	END SYNC_MODE_SEL;
		
end Core16550_package;