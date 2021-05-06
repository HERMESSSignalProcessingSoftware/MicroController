----------------------------------------------------------------------------------
-- Company: REXUS HERMESS MESS II 
-- Engineer: Laura Federico and Robin Grimsmann
-- 
-- Create Date:    12.03.2021
-- Design Name: MESS II
-- Module Name: RAM design
-- Project Name: HERMESS
-- Target Devices: 
-- Tool versions: 
-- Description: 
-- Memory will store the value of databus_i by readWrite = 0. Memory(to_integer(unsigend(addr))) <= databus_i 
-- readWrite = High => databus_o <= Memory(to_integer(unsigend(addr))) 
-- Dependencies: 
-- Revision: 
-- Revision 0.01 - File Created
-- Revision 1.0  - Update logic
-- Additional Comments: 
--
----------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

ENTITY ram IS
GENERIC(
	MAXWIDTH : INTEGER := 32;
	ADDRWIDTH : INTEGER := 8 -- Correction: 
);
PORT(
	clk          : IN STD_LOGIC;
	nReset	  	 : IN STD_LOGIC; -- correction: The customer wants a nREset signal, it was missing. 
	din          : IN STD_LOGIC_VECTOR(MAXWIDTH-1 DOWNTO 0);  --Daten Eingang
 	adr          : IN STD_LOGIC_VECTOR(ADDRWIDTH-1 DOWNTO 0); -- Correction use different address bus size than databus size
	writeEN      : IN STD_LOGIC;                              --enabled den schreib vorgang
	dout         : OUT STD_LOGIC_VECTOR(MAXWIDTH-1 DOWNTO 0)   --Daten Ausgang
);
END ram;

ARCHITECTURE arch_ram OF ram IS
TYPE ram IS ARRAY (0 TO (2**ADDRWIDTH)-1) OF STD_LOGIC_VECTOR (MAXWIDTH-1 DOWNTO 0); -- Correction: use 2^addrwidth - 1, for example: 2^8 = 256 - 1 words
SIGNAL memory : ram;

BEGIN
   PROCESS(clk, nReset)
    BEGIN
		IF (nReset = '0') THEN
			memory <=  (OTHERS => X"00000000");
		ELSIF RISING_EDGE(clk) THEN
			IF writeEN = '1' THEN
				memory(TO_INTEGER(UNSIGNED(adr)))<= din; --Hier wird in den Memory geschrieben
			ELSE 
				dout <= memory(TO_INTEGER(UNSIGNED(adr)));          --Hier wird aus dem memory in den Daten Ausgang geschrieben
			END IF;
		END IF;
   	END PROCESS;
  
END arch_ram;
