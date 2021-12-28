--------------------------------------------------------------------------------
-- !!! was bei ADC resync? Was bei ADC reset?
-- !!! Conf reset komplett zu 0 geeignet? Was mit ID? Unterschied Hard/Soft notwendig?
-- HERMESS Project
-- 
-- This is designed for use with 3 ADS114x on a shared SPI bus.
-- 
-- ADDRESS:
-- Always usable Modifiers:
-- 1XXX XXXX 0000       Atomic operation
-- X1XX XXXX 0000       Reset status register after finishing operation
-- Writing to ADCs:
-- XX00 1XXX 0000       Polling request: Only exits once the drdy line goes down again.
-- XX00 XXX1 0000       ADC for DMS1 (write only the least significant 16 bits)
-- XX00 XX1X 0000       ADC for DMS2 (write only the least significant 16 bits)
-- XX00 X1XX 0000       ADC for PT100 (write only the least significant 16 bits)
-- Other registers and commands:
-- XX00 0000 0000       NOP
-- XX00 1000 0000       Last ADC reading (read only the least significant 16 bits)
-- XX01 0000 0000       DMS1 & DMS2 (read only)
-- XX01 1000 0000       Temp & Status register (read only)
-- XX10 0000 0000       Access 32 bit configuration register
-- XX11 1000 0000       Access 32 bit dummy register
-- All others are undefined and enable FLOMESS legacy mode (unpredictable behavior)
--------------------------------------------------------------------------------

LIBRARY IEEE;
USE IEEE.std_logic_1164.all;
USE ieee.numeric_std.all;



ENTITY STAMP_tb IS
    
END STAMP_tb;

architecture tb of STAMP_tb is 
    component STAMP IS
        GENERIC(
            async_prescaler : INTEGER RANGE 0 TO 65535 := 2500 -- 16 bit; default 0.05ms @ 50MHz
        );
        PORT(
            -- general IO for interfacing with other FPGA components
            new_avail : OUT STD_LOGIC; -- goes high, when new data of both DMS are available
            request_resync : OUT STD_LOGIC; -- goes high, when there is an offset
            data_frame : OUT STD_LOGIC_VECTOR(63 downto 0); -- [DMS1, DMS2, TEMP, STATUS]
            reset_status : IN STD_LOGIC; -- will reset status register (including new_avail) when
                    -- high. Note, that it should be kept high, until new_avail went low again,
                    -- as ongoing SPI communications blocks this feature to prevent racing conditions
            -- apb3 ports
            PCLK : IN STD_LOGIC;
            PRESETN : IN STD_LOGIC; -- does only reset the block, not the ADCs
            PADDR : IN STD_LOGIC_VECTOR(11 downto 0);
            PSEL : IN STD_LOGIC;
            PENABLE : IN STD_LOGIC;
            PWRITE : IN STD_LOGIC;
            PWDATA : IN STD_LOGIC_VECTOR(31 downto 0);
            PRDATA : OUT STD_LOGIC_VECTOR(31 downto 0);
            PREADY : OUT STD_LOGIC;
            PSLVERR : OUT STD_LOGIC; -- not supported by this component
            -- the adc SPI ports
            spi_clock : OUT STD_LOGIC; -- period: <= 520ns
            spi_miso : IN STD_LOGIC;
            spi_mosi : OUT STD_LOGIC;
            spi_dms1_cs : OUT STD_LOGIC;
            spi_dms2_cs : OUT STD_LOGIC;
            spi_temp_cs : OUT STD_LOGIC;
            -- the adc interrupt input pins
            ready_dms1 : IN STD_LOGIC;
            ready_dms2 : IN STD_LOGIC;
            ready_temp : IN STD_LOGIC
        );
    end component STAMP;


signal new_avail        : STD_LOGIC; -- goes high, when new data of both DMS are available
signal request_resync   : STD_LOGIC; -- goes high, when there is an offset
signal data_frame       : STD_LOGIC_VECTOR(63 downto 0); -- [DMS1, DMS2, TEMP, STATUS]
signal reset_status     : STD_LOGIC := '0'; -- will reset status register (including new_avail) when
signal PCLK             : STD_LOGIC := '0';
signal PRESETN          : STD_LOGIC := '1'; -- does only reset the block, not the ADCs
signal PADDR            : STD_LOGIC_VECTOR(11 downto 0) := (others => '0');
signal PSEL             : STD_LOGIC := '0';
signal PENABLE          : STD_LOGIC := '0';
signal PWRITE           : STD_LOGIC := '0';
signal PWDATA           : STD_LOGIC_VECTOR(31 downto 0) := (others => '0');
signal PRDATA           : STD_LOGIC_VECTOR(31 downto 0) := (others => '0');
signal PREADY           : STD_LOGIC;
signal PSLVERR          : STD_LOGIC; -- not supported by this component
signal spi_clock        : STD_LOGIC; -- period: <= 520ns
signal spi_miso         : STD_LOGIC := '0';
signal spi_mosi         : STD_LOGIC;
signal spi_dms1_cs      : STD_LOGIC;
signal spi_dms2_cs      : STD_LOGIC;
signal spi_temp_cs      : STD_LOGIC;
signal ready_dms1       : STD_LOGIC := '0';
signal ready_dms2       : STD_LOGIC := '0';
signal ready_temp       : STD_LOGIC := '0';

begin

    DUT : STAMP generic map (2500) 
                port map (new_avail => new_avail, 
                    request_resync => request_resync,
                    data_frame     => data_frame,
                    reset_status   => reset_status,
                    PCLK           => PCLK,
                    PRESETN        => PRESETN,
                    PADDR          => PADDR,
                    PSEL           => PSEL,
                    PENABLE        => PENABLE,
                    PWRITE         => PWRITE,
                    PWDATA         => PWDATA,
                    PRDATA         => PRDATA,
                    PREADY         => PREADY,
                    PSLVERR        => PSLVERR,
                    spi_clock      => spi_clock,
                    spi_miso       => spi_miso,
                    spi_mosi       => spi_mosi,
                    spi_dms1_cs    => spi_dms1_cs,
                    spi_dms2_cs    => spi_dms2_cs,
                    spi_temp_cs    => spi_temp_cs,
                    ready_dms1     => ready_dms1,
                    ready_dms2     => ready_dms2,
                    ready_temp     => ready_temp);

PCLK <= not PCLK after 10 ns;
PRESETN <= '0' after 15 ns, '1' after 45 ns;
PSEL <= '1' after 50 ns;
PENABLE <= '1' after 50 ns;
PWRITE <= '1' after 50 ns;
PADDR(7 downto 4) <= "1111" after 50 ns;
ready_dms1 <= '1' after 9 us;
ready_dms2 <= '1' after 9 us;
ready_temp <= '1' after 9 us;

end tb ; -- arch