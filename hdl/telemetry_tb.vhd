-- FILE: Temetry testbenach
-- AUTOR: R. Grimsmann
-- DATE: 21.01.2022

LIBRARY IEEE;
USE IEEE.std_logic_1164.all;
USE ieee.numeric_std.all;

entity telemetry_tb is
end telemetry_tb;

architecture testbench of telemetry_tb is
    component telemetry is
        port (
          PCLK        : IN STD_LOGIC;
          PRESETN     : IN STD_LOGIC; -- does only reset the block, not the ADCs
          PADDR       : IN STD_LOGIC_VECTOR(11 downto 0);
          PSEL        : IN STD_LOGIC;
          PENABLE     : IN STD_LOGIC;
          PWRITE      : IN STD_LOGIC;
          PWDATA      : IN STD_LOGIC_VECTOR(31 downto 0);
          PRDATA      : OUT STD_LOGIC_VECTOR(31 downto 0);
          PREADY      : OUT STD_LOGIC;
          PSLVERR     : OUT STD_LOGIC; -- not supported by this component
          RX          : IN STD_LOGIC;
          TX          : OUT STD_LOGIC;
          INTERRUPT   : OUT STD_LOGIC
          );
    end component telemetry;
    signal PCLK        : STD_LOGIC  := '0';
    signal PRESETN     : STD_LOGIC  := '1'; -- does only reset the block, not the ADCs
    signal PADDR       : STD_LOGIC_VECTOR(11 downto 0) := X"000";
    signal PSEL        : STD_LOGIC  := '0';
    signal PENABLE     : STD_LOGIC  := '0';
    signal PWRITE      : STD_LOGIC  := '0';
    signal PWDATA      : STD_LOGIC_VECTOR(31 downto 0)  := (others => '0');
    signal PRDATA      : STD_LOGIC_VECTOR(31 downto 0)  := (others => '0');
    signal PREADY      : STD_LOGIC  := '0';
    signal PSLVERR     : STD_LOGIC; -- not supported by this component
    signal RX          : STD_LOGIC  := '1';
    signal TX          : STD_LOGIC;
    signal INTERRUPT   : STD_LOGIC; 
begin 
    DUT : telemetry port map(PCLK => PCLK,
                            PRESETN => PRESETN,
                            PADDR => PADDR,
                            PSEL => PSEL,
                            PENABLE => PENABLE,
                            PWRITE => PWRITE,
                            PWDATA => PWDATA,
                            PRDATA => PRDATA,
                            PSLVERR => PSLVERR,
                            RX => RX,
                            TX => TX,
                            INTERRUPT => INTERRUPT);

    PCLK <= not PCLK after 10 ns;
    PRESETN <= '0' after 15 ns, '1' after 30 ns;
    -- APB Data
    PSEL <= '1' after 100 ns, '0' after 1180 ns, '1' after 36 ms, '0' after 36.008 ms;
    PWRITE <= '1' after 100 ns, '0' after 1180 ns, '1' after 36 ms, '0' after 36.008 ms;
    PENABLE <= '1' after 100 ns, '0' after 1180 ns, '1' after 36 ms, '0' after 36.008 ms;
    -- Address with modifier normal 4 byte address last two bits have to be 00
    PADDR <=    X"100" after 100 ns,
                X"104" after 140 ns,
                X"108" after 180 ns,
                X"10C" after 220 ns,
                X"110" after 260 ns,
                X"114" after 300 ns,
                X"118" after 340 ns,
                X"11C" after 380 ns,
                X"120" after 420 ns,
                X"124" after 460 ns,
                X"128" after 500 ns,
                X"12C" after 540 ns,
                X"130" after 580 ns,
                X"134" after 620 ns,
                X"138" after 660 ns,
                X"13C" after 700 ns,
                X"140" after 740 ns,
                X"144" after 780 ns,
                X"148" after 820 ns,
                X"14C" after 860 ns,
                X"150" after 900 ns,
                X"154" after 940 ns,
                X"158" after 980 ns,
                X"15C" after 1020 ns,
                X"004" after 1060 ns,
                X"010" after 1100 ns,
                X"00C" after 1140 ns,
                X"008" after 36 ms,
                X"004" after 36.004 ms;

    PWDATA <=   X"AAAAAAAA" after 100 ns,
        	    X"00000007" after 1060 ns,
                X"000249f0" after 1100 ns,
                X"00000516" after 1140 ns,
                X"00000005" after 36 ms,
                X"00000007" after 36.004 ms;
    
end testbench;