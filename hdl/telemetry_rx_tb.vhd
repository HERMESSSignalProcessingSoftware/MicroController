-- FILE: Temetry testbenach
-- AUTOR: R. Grimsmann
-- DATE: 21.01.2022

LIBRARY IEEE;
USE IEEE.std_logic_1164.all;
USE ieee.numeric_std.all;

entity telemetry_RX_tb is
end telemetry_RX_tb;

architecture testbench of telemetry_RX_tb is
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

    -- constanten
    constant T         : time := 20 ns;
   
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

    PCLK <= not PCLK after T / 2;
    PRESETN <= '0' after 15 ns, '1' after 30 ns;
    process
    variable start     : integer := 0;
    begin 
        
        if (start = 0) then
            wait until rising_edge(PRESETN); -- Wait until reset is done
            start := 1;
        else 
            if (INTERRUPT = '0') then
                    RX <= '1'; 
                    wait for 26.04 us;
                    RX <= '0'; -- start bit
                    wait for 26.04 us;
                    RX <= '1'; -- bit 0
                    wait for 26.04 us;
                    RX <= '0'; -- bit 1
                    wait for 26.04 us;
                    RX <= '1'; -- bit 2
                    wait for 26.04 us;
                    RX <= '0'; -- bit 3
                    wait for 26.04 us;
                    RX <= '1'; -- bit 4
                    wait for 26.04 us;
                    Rx <= '0'; -- bit 5
                    wait for 26.04 us;
                    RX <= '1'; -- bit 6
                    wait for 26.04 us;
                    RX <= '1'; -- bit 7
                    wait for 26.04 us;
            else 
                report "Interrupt appered!" severity warning;
                wait;
            end if;
        end if;
    end process;
    -- configure baud rate and enable interrupt
    PSEL <= '1' after 100 ns, '0' after 180 ns;
    PWRITE <= '1' after 100 ns, '0' after 180 ns;
    PENABLE <= '1' after 100 ns, '0' after 180 ns;
    -- Address with modifier normal 4 byte address last two bits have to be 00
    PADDR <=    X"004" after 100 ns,
                X"00C" after 140 ns;

    PWDATA  <=  X"00000001" after 100 ns,
                X"00000516" after 140 ns;

end architecture;