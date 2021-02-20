--------------------------------------------------------------------------------
-- HERMESS Project
-- 
-- This is designed for use with 3 ADS114x with a shared SPI bus.
--------------------------------------------------------------------------------

LIBRARY IEEE;
USE IEEE.std_logic_1164.all;
USE ieee.std_logic_arith.all;
USE ieee.std_logic_unsigned.all;


ENTITY STAMP IS
    GENERIC(
        async_threshold : INTEGER := 5
    );
    PORT(
        new_avail : OUT STD_LOGIC;
        -- apb3 ports
        PCLK : IN STD_LOGIC;
        PRESETN : IN STD_LOGIC;
        PADDR : IN STD_LOGIC_VECTOR(5 downto 0);
        PSEL : IN STD_LOGIC;
        PENABLE : IN STD_LOGIC;
        PWRITE : IN STD_LOGIC;
        PWDATA : IN STD_LOGIC_VECTOR(31 downto 0);
        PRDATA : OUT STD_LOGIC_VECTOR(31 downto 0);
        PREADY : OUT STD_LOGIC;
        PSLVERR : OUT STD_LOGIC;
        -- the SPI ports
        spi_clock : OUT STD_LOGIC;
        spi_miso : IN STD_LOGIC;
        spi_mosi : OUT STD_LOGIC;
        spi_dms1_cs : OUT STD_LOGIC;
        spi_dms2_cs : OUT STD_LOGIC;
        spi_temp_cs : OUT STD_LOGIC;
        -- the interrupt input pins
        ready_dms1 : IN STD_LOGIC;
        ready_dms2 : IN STD_LOGIC;
        ready_temp : IN STD_LOGIC
    );
END STAMP;


ARCHITECTURE architecture_STAMP of STAMP IS
    -- contains all status bits
    signal status_register : STD_LOGIC_VECTOR(0 to 15) := (others => '0');
    signal status_dms1_newVal : STD_LOGIC := '0';
    signal status_dms2_newVal : STD_LOGIC := '0';
    signal status_temp_newVal : STD_LOGIC := '0';
	-- contains the last measured 
    signal measurement_dms1 : STD_LOGIC_VECTOR(15 downto 0) := (others => '0');
	signal measurement_dms2 : STD_LOGIC_VECTOR(15 downto 0) := (others => '0');
	signal measurement_temp : STD_LOGIC_VECTOR(15 downto 0) := (others => '0');

BEGIN
    status_register(0) <= status_dms1_newVal;
    status_register(1) <= status_dms2_newVal;
    status_register(2) <= status_temp_newVal;

   
END architecture_STAMP;
