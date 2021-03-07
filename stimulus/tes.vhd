----------------------------------------------------------------------
-- Created by Microsemi SmartDesign Tue Mar  2 11:57:45 2021
-- Testbench Template
-- This is a basic testbench that instantiates your design with basic 
-- clock and reset pins connected.  If your design has special
-- clock/reset or testbench driver requirements then you should 
-- copy this file and modify it. 
----------------------------------------------------------------------

--------------------------------------------------------------------------------
-- Company: <Name>
--
-- File: tes.vhd
-- File history:
--      <Revision number>: <Date>: <Comments>
--      <Revision number>: <Date>: <Comments>
--      <Revision number>: <Date>: <Comments>
--
-- Description: 
--
-- <Description here>
--
-- Targeted device: <Family::SmartFusion2> <Die::M2S010> <Package::400 VF>
-- Author: <Name>
--
--------------------------------------------------------------------------------


library ieee;
use ieee.std_logic_1164.all;

entity tes is
end tes;

architecture behavioral of tes is

    constant SYSCLK_PERIOD : time := 100 ns; -- 10MHZ

    signal SYSCLK : std_logic := '0';
    signal NSYSRESET : std_logic := '0';
    signal s_psel : STD_LOGIC := '0';
    signal s_penable : STD_LOGIC := '0';
    signal s_paddr : STD_LOGIC_VECTOR(7 downto 0) := (others => '0');
    signal s_pwrite : STD_LOGIC := '0';
    signal s_pwdata : STD_LOGIC_VECTOR(31 downto 0) := (others => '0');
    

    component STAMP
        PORT (-- Inputs
            PCLK : in std_logic;
            PRESETN : in std_logic;
            PADDR : in std_logic_vector(7 downto 0);
            PSEL : in std_logic;
            PENABLE : in std_logic;
            PWRITE : in std_logic;
            PWDATA : in std_logic_vector(31 downto 0);
            spi_miso : in std_logic;
            ready_dms1 : in std_logic;
            ready_dms2 : in std_logic;
            ready_temp : in std_logic;

            -- Outputs
            debug : out std_logic;
            new_avail : out std_logic;
            request_resync : out std_logic;
            PRDATA : out std_logic_vector(31 downto 0);
            PREADY : out std_logic;
            PSLVERR : out std_logic;
            spi_clock : out std_logic;
            spi_mosi : out std_logic;
            spi_dms1_cs : out std_logic;
            spi_dms2_cs : out std_logic;
            spi_temp_cs : out std_logic);
    end component;
    
    
        

begin

    process
        variable vhdl_initial : BOOLEAN := TRUE;

    begin
        if ( vhdl_initial ) then
            -- Assert Reset
            NSYSRESET <= '0';
            wait for ( SYSCLK_PERIOD * 10 );
            
            NSYSRESET <= '1';
            wait for ( SYSCLK_PERIOD * 10 );
            s_psel <= '1';
            s_pwrite <= '1';
            s_pwdata <= "10101010101010101010101010101010";
            wait for ( SYSCLK_PERIOD * 1 );
            s_penable <= '1';
            s_paddr <= "00000011";
            wait;
        end if;
    end process;

    -- Clock Driver
    SYSCLK <= not SYSCLK after (SYSCLK_PERIOD / 2.0 );

    -- Instantiate Unit Under Test:  STAMP
    STAMP_0 : STAMP
        -- port map
        port map( 
            -- Inputs
            PCLK => SYSCLK,
            PRESETN => NSYSRESET,
            PADDR => s_paddr,
            PSEL => s_psel,
            PENABLE => s_penable,
            PWRITE => '0',
            PWDATA => (others=> '0'),
            spi_miso => SYSCLK,
            ready_dms1 => '0',
            ready_dms2 => '0',
            ready_temp => '0',

            -- Outputs
            new_avail =>  open,
            request_resync =>  open,
            PRDATA => open,
            PREADY =>  open,
            PSLVERR =>  open,
            spi_clock =>  open,
            spi_mosi =>  open,
            spi_dms1_cs =>  open,
            spi_dms2_cs =>  open,
            spi_temp_cs =>  open

            -- Inouts

        );

end behavioral;

