

LIBRARY IEEE;

USE IEEE.std_logic_1164.all;
USE ieee.std_logic_arith.all;
USE ieee.numeric_std.all;


ENTITY Synchronizer IS
    GENERIC(
        async_threshold : INTEGER RANGE 0 TO 63 := 5; -- number of cycles, the STAMP components may carry their offset
        max_resync_attempts : INTEGER RANGE -1 TO 30 := 5; -- number of allowed resync attempts
        min_resync_gap : INTEGER RANGE 0 TO 16777215 := 16777215 -- 24 bit; minimum time between two resync attempts
    );
    PORT(
        resetn : IN STD_LOGIC;
        clk : IN STD_LOGIC;
        new_avail : IN STD_LOGIC_VECTOR(5 downto 0);
        request_resync : IN STD_LOGIC_VECTOR(5 downto 0);
        components_resetn : OUT STD_LOGIC := '1';
        adc_start : OUT STD_LOGIC := '1'
    );
END Synchronizer;



ARCHITECTURE architecture_synchronizer OF Synchronizer IS
    signal test : STD_LOGIC := '1';
BEGIN
    adc_start <= test;
    components_resetn <= '1';
END architecture_synchronizer;