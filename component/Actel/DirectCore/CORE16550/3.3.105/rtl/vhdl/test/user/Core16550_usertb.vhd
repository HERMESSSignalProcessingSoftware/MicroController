------------------------------------------------------------------------
--
-- Copyright (c) 2002-2015 Microsemi Corp.
--
-- Please review the terms of the license agreement before using this
-- file.  If you are not an authorized user, please destroy this source
-- code file and notify Microsemi Corp immediately that you inadvertently received
-- an unauthorized copy.
------------------------------------------------------------------------
--
--  Project       : Core16550 Synchronous UART
--
--  File          : Core16550_usertb.vhd
--
--  Dependencies  : Core16550.vhd
--
--  Model Type    : Simulation Model (Testbench)
--
--  Description   : Core16550 user testbench  
--
--  Designer      : JV
--
--  QA Engineer   : JH
--
--  Creation Date : 13-January-2002
--
--  Last Update   : 15-February-2007
--
--  Version       : 1H20N00S00
--
--  Main Tested Operations:  REGISTERS; write and READ  
--                           XMIT FIFO 
--                           RCVR FIFO
--                           outputs: RXRDY and TXRDY in modes 0 & 1
--                           THRE and TEMT bits in LSReg
--
--   This testbench is designed to write to several registers and read back the
--   status of the UART.  It runs the UART in modes 0 and 1
------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;
use std.textio.all;
use work.coreparameters.all;
library Core16550_lib;

entity Core16550_usertb is
   generic(SCALE: real := 1.0;
           Enable: Boolean := True);  -- used for code-coverage run
end Core16550_usertb;

architecture tb of Core16550_usertb is

component CORE16550 IS
   generic ( FAMILY   : INTEGER range 0  to 99:=25);
   PORT (
      -- APB interface
      
      -- APB system reset
      PCLK             : IN STD_LOGIC;		-- APB system clock
      PRESETN          : IN STD_LOGIC;
      -- Peripheral select signal
      -- Write/nRead signal
      -- Enable (data valid strobe)
      -- Clear To Send Enable
      -- Data Carrier Detect
      -- Data Set Ready
      -- Ring indicator
      -- Serial Input
      PADDR            : IN STD_LOGIC_VECTOR(4 DOWNTO 0);		-- Latched address
      PSEL             : IN STD_LOGIC;
      PENABLE          : IN STD_LOGIC;
      PWRITE           : IN STD_LOGIC;
      PWDATA           : IN STD_LOGIC_VECTOR(7 DOWNTO 0);		-- 8 bit write data
      -- Data Bus driver disable
      -- Serial ouput
      -- Baud out
      -- Data terminal ready
      -- Request To send
      -- Output 1
      -- Output 2
      -- Interrupt
      -- Receiver ready
      -- Transmitter ready
      PRDATA           : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);		-- 8 bit read data 
      CTSN             : IN STD_LOGIC;
      DCDN             : IN STD_LOGIC;
      DSRN             : IN STD_LOGIC;
      RIN              : IN STD_LOGIC;
      SIN              : IN STD_LOGIC;
      SOUT             : OUT STD_LOGIC;
      BAUDOUTN         : OUT STD_LOGIC;
      DTRN             : OUT STD_LOGIC;
      RTSN             : OUT STD_LOGIC;
      OUT1N            : OUT STD_LOGIC;
      OUT2N            : OUT STD_LOGIC;
      INTR             : OUT STD_LOGIC;
      RXRDYN           : OUT STD_LOGIC;
      TXRDYN           : OUT STD_LOGIC;
      RXFIFO_FULL      : OUT STD_LOGIC;
      RXFIFO_EMPTY     : OUT STD_LOGIC
   );
END component;

   signal test_done : boolean   := FALSE;
   signal errors    : integer   := 0;

   signal PRESETN      : std_logic                    := '1';
   signal PADDR       : std_logic_vector(4 downto 0) := (others => '0');
   signal PSEL      : std_logic                    := '0';
   signal PENABLE      : std_logic                    := '0';
   signal PWRITE      : std_logic                    := '0';
   signal PCLK     : std_logic                    := '0';
   signal sin     : std_logic                    := '0';
   signal cts     : std_logic                    := '1';
   signal dsr     : std_logic                    := '1';
   signal dcd     : std_logic                    := '1';
   signal ri      : std_logic                    := '1';
   signal baudout : std_logic;
   signal sout    : std_logic;
   signal rts     : std_logic;
   signal dtr     : std_logic;
   signal out1    : std_logic;
   signal out2    : std_logic;
   signal intr    : std_logic;
   signal rxrdyn   : std_logic;
   signal txrdyn   : std_logic;
   signal PRDATA    : std_logic_vector(7 downto 0);
   signal PWDATA     : std_logic_vector(7 downto 0) := (others => '0');
   signal xhdl0 : STD_LOGIC_VECTOR(4 DOWNTO 0);
   signal RXFIFO_EMPTY           : STD_LOGIC;
   signal RXFIFO_FULL            : STD_LOGIC;
   --signal RXFIFO_HALFFULL        : STD_LOGIC;

   constant PERIOD : time    := 100 ns * SCALE;
   constant CPU_TPD : time := PERIOD/3;
   constant CPU_TRDWR : time := CPU_TPD/2;

-- CONSTANTs to write to registers
-- The value of the Line Control Register constant can be changed to appropriate operation mode
-- The values of the Divisor registers can be changed to modify data speed

   constant INITLCR  : std_logic_vector(7 downto 0) := "00011011";
   constant INITMCR  : std_logic_vector(7 downto 0) := "00000101";
   constant INITIER  : std_logic_vector(7 downto 0) := "00001111";
   constant INITSR   : std_logic_vector(7 downto 0) := "11011111";
   constant INITDLR  : std_logic_vector(7 downto 0) := "00000010";
   constant INITDMR  : std_logic_vector(7 downto 0) := "00000000";
   constant INITFCR0 : std_logic_vector(7 downto 0) := "11001001";
   constant INITFCR1 : std_logic_vector(7 downto 0) := "11000001";
   constant INITFCR2 : std_logic_vector(7 downto 0) := "10001001";
   constant INITFCR3 : std_logic_vector(7 downto 0) := "01001001";
   constant INITFCR4 : std_logic_vector(7 downto 0) := "01001101";
   constant INITFCR5 : std_logic_vector(7 downto 0) := "01001011";
   constant INITTHR0 : std_logic_vector(7 downto 0) := "01010100";
   constant INITTHR1 : std_logic_vector(7 downto 0) := "01000100";
   constant INITTHR2 : std_logic_vector(7 downto 0) := "01001100";
   constant INITTHR3 : std_logic_vector(7 downto 0) := "01011100";
   constant INITTHR4 : std_logic_vector(7 downto 0) := "01011110";

-- ADDRESSES of the registers
-- THESE values can not be changed
   constant RBRADD : std_logic_vector(2 downto 0) := "000";
   constant THRADD : std_logic_vector(2 downto 0) := "000";
   constant DLRADD : std_logic_vector(2 downto 0) := "000";
   constant DMRADD : std_logic_vector(2 downto 0) := "001";
   constant IERADD : std_logic_vector(2 downto 0) := "001";
   constant IIRADD : std_logic_vector(2 downto 0) := "010";
   constant FCRADD : std_logic_vector(2 downto 0) := "010";
   constant LCRADD : std_logic_vector(2 downto 0) := "011";
   constant MCRADD : std_logic_vector(2 downto 0) := "100";
   constant LSRADD : std_logic_vector(2 downto 0) := "101";
   constant MSRADD : std_logic_vector(2 downto 0) := "110";
   constant SRADD  : std_logic_vector(2 downto 0) := "111";

   procedure write(l:inout line; value : in std_logic) is
     variable c : character := '-';
   begin
     case value is
       when 'U' => c := 'U';
       when '1' => c := '1';
       when '0' => c := '0';
       when 'X' => c := 'X';
       when 'L' => c := 'L';
       when 'H' => c := 'H';
       when 'W' => c := 'W';
       when 'Z' => c := 'Z';
       when '-' => c := '-';
     end case;
     write(l,c);
   end;
     
   procedure write(l : inout line; value : in std_logic_vector) is
   begin
      for i in value'high downto value'low loop
          write(l,value(i));
      end loop;
   end;  

begin

   xhdl0 <= (PADDR(2 DOWNTO 0) & "00");
   u1 : CORE16550
		generic map ( FAMILY   => FAMILY)  
      PORT MAP (
         paddr            => xhdl0,
         psel             => PSEL,
         pwrite           => PWRITE,
         penable          => PENABLE,
         presetn          => PRESETN,
         pclk             => PCLK,
         sin              => sin,
         ctsn             => cts,
         dsrn             => dsr,
         dcdn             => dcd,
         rin              => ri,
         baudoutn         => baudout,
         sout             => sout,
         rtsn             => rts,
         dtrn             => dtr,
         out1n            => out1,
         out2n            => out2,
         intr             => intr,
         rxrdyn           => rxrdyn,
         txrdyn           => txrdyn,
         prdata           => PRDATA,
         pwdata           => PWDATA,
         rxfifo_full      => RXFIFO_FULL,
         rxfifo_empty     => RXFIFO_EMPTY
      );

RUN_THIS: if (Enable) generate
---------------------------------------------------
-- Infinite clock generator
---------------------------------------------------
   sin <= sout;

---------------------------------------------------
-- Asynchronous reset
---------------------------------------------------
clk_stim: process
      variable l_out : line;
   begin
      loop
         wait for PERIOD / 2;
         PCLK <= not PCLK;
         if (test_done) then
            write (l_out, string'("TEST COMPLETE"));
            writeline (output, l_out);
            writeline (output, l_out);
            if (errors = 0) then
               write (l_out, string'("There were no errors"));
            else
               write (l_out, string'("There were "));
               write (l_out, errors);
               write (l_out, string'(" Errors"));
            end if;
            writeline (output, l_out);
            wait;
         end if;
      end loop;
   end process;


   process
   begin
      wait for 50 ns;
      PRESETN     <= '0';
      wait for 230 ns;
      PRESETN     <= '1';
      wait;
   end process;

full_test: process

   procedure wait_n_cycle(variable clkcount : inout integer;
                          ncycle : in integer) is
   begin
      for i in ncycle downto 0 loop
         wait until PCLK'event and PCLK = '1';
      end loop;
   end;


   procedure cpu_write( data : in std_logic_vector(7 downto 0);
                        reg_addr  : in std_logic_vector(2 downto 0);
                        dlab : in  boolean := FALSE) is
   variable textline : Line;
   begin
       wait until PCLK'event and PCLK = '0'; 
       PADDR <= ("00" & reg_addr);
       PSEL <= '1';
       PENABLE <= '0';
       PWDATA <= data;
       PWRITE <= '1';
       wait until PCLK'event and PCLK = '0'; 
       PENABLE <= '1';
       wait until PCLK'event and PCLK = '0'; 
       PWRITE <= '0';
       PSEL <= '0';
       PENABLE <= '0';
       PWDATA <= "ZZZZZZZZ";

       write(textline, now);
       write(textline, string'("  MPU write: Register" ));
       case reg_addr is
           when "000" => if dlab then
                            write (textline, string'(" DLR"));
                         else
                            write (textline, string'(" THR"));
                         end if;
           when "001" => if dlab then
                            write (textline, string'(" DMR"));
                         else
                            write (textline, string'(" IER"));
                         end if;
           when "010" => write (textline, string'(" FCR "));
           when "011" => write (textline, string'(" LCR "));
           when "100" => write (textline, string'(" MCR "));
           when "101" => write (textline, string'(" LSR "));
           when "110" => write (textline, string'(" MSR "));
           when "111" => write (textline, string'(" SCR "));
           when others => write (textline, string'(" Unknown "));
       end case;
       write(textline, string'("=" ));
       write(textline, string'("  " ));
       write(textline, data);
       writeline(output,textline);
   end;

   procedure cpu_read(reg_addr : in std_logic_vector(2 downto 0);
                      ref : in std_logic_vector(7 downto 0);
                      dlab : in  boolean := FALSE;
                      check : in  boolean := TRUE) is
   variable textline : Line;
   begin 
      wait until PCLK'event and PCLK = '0'; 
      PADDR <= ("00" & reg_addr);
      PSEL <= '1';
      PENABLE <= '0';
      PWRITE <= '0';
      wait until PCLK'event and PCLK = '0'; 
      PENABLE <= '1';
      wait until PCLK'event and PCLK = '0'; 
      PWRITE <= '1';
      PSEL <= '0';
      PENABLE <= '0';
 
      write(textline, now);
      write(textline, string'("  MPU READ: Register" ));
      case reg_addr is
          when "000" => if dlab then
                           write (textline, string'(" DLR"));
                        else
                           write (textline, string'(" RBR"));
                        end if;
          when "001" => if dlab then
                           write (textline, string'(" DMR"));
                        else
                           write (textline, string'(" IER"));
                        end if;
          when "010" => write (textline, string'(" ISR "));
          when "011" => write (textline, string'(" LCR "));
          when "100" => write (textline, string'(" MCR "));
          when "101" => write (textline, string'(" LSR "));
          when "110" => write (textline, string'(" MSR "));
          when "111" => write (textline, string'(" SCR "));
          when others => write (textline, string'(" Unknown "));
      end case;
      write(textline, string'("=" ));
      write(textline, string'("  " ));
      write(textline, (PRDATA));
      if check then
         if PRDATA /= ref then
             write(textline, string'(" ##### NOK"));
             write(textline, string'(" EXPECTED RESULT IS  "));
             write(textline, ref);
             write(textline, string'(" #####"));
             errors <= errors + 1;
         else
             write(textline, string'("  OK" ));
         end if;
      end if;
 
      wait for CPU_TRDWR;
      PSEL <= '0';
      writeline(output,textline);
      wait until PCLK'event and PCLK = '0'; 
   end;

   variable textline : line;
   variable clkcount : integer := 0;

   begin

      PWDATA <= "00000000";
      PWRITE  <= '0';
      PSEL  <= '0';
      PENABLE  <= '0';
      PADDR   <= "00000";

      wait until PRESETN = '1';
      clkcount := 0; wait_n_cycle(clkcount, 10);

----------------------------------------------------------------------
-- The first action is to write an initial value to every register
-- outputs DTR, RTS, OUT1 and OUT2 will be checked
-- also values of the registers will be checked
----------------------------------------------------------------------

      writeline(output, textline);
      write(textline, string'(" MPU writes initial registers"));
      writeline(output, textline);
      writeline(output, textline);

      -- Line Control register
      cpu_write(INITLCR, LCRADD);
      -- MODEM Control register
      cpu_write(INITMCR, MCRADD);

      writeline(output, textline);
      write(textline, string'(" Enable Interrupts"));
      writeline(output, textline);
      writeline(output, textline);

      wait until PCLK'event and PCLK = '1'; wait for CPU_TPD;
      write(textline, now);
      if intr = '0' then
         write(textline, string'(" INTR = 0 OK"));
         writeline(output, textline);
      else
         write(textline, string'(" INTR = 1 NOK"));
         writeline(output, textline);
         errors <= errors + 1;
      end if;

      -- IE register
      cpu_write(INITIER, IERADD);

      wait until PCLK'event and PCLK = '1'; wait for CPU_TPD;
      write(textline, now);
      if intr = '1' then
         write(textline, string'(" INTR = 1 OK"));
         writeline(output, textline);
      else
         write(textline, string'(" INTR = 0 NOK"));
         writeline(output, textline);
         errors <= errors + 1;
      end if;

      writeline(output, textline);
      write(textline, string'(" write to SCRATCH register"));
      writeline(output, textline);
      cpu_write(INITSR, SRADD);

      writeline(output, textline);
      write(textline, string'(" write to FIFO CONTROL register"));
      writeline(output, textline);
      cpu_write(INITFCR0, FCRADD);

      writeline(output, textline);
      write(textline, string'(" write to LINE CONTROL register"));
      writeline(output, textline);
      cpu_write(('1' & INITLCR(6 downto 0)), LCRADD);

      writeline(output, textline);
      write(textline, string'(" write to DIVISOR LSB register"));
      writeline(output, textline);
      cpu_write(INITDLR, DLRADD, TRUE);

      writeline(output, textline);
      write(textline, string'(" write to DIVISOR MSB register"));
      writeline(output, textline);
      cpu_write(INITDMR, DMRADD, TRUE);

      clkcount := 0; wait_n_cycle(clkcount, 10);

      writeline(output, textline);
      write(textline, string'(" MPU READs initialized registers"));
      writeline(output, textline);
      writeline(output, textline);

      write(textline, string'(" write to LINE CONTROL register"));
      writeline(output, textline);
      cpu_write(INITLCR, LCRADD);

      writeline(output, textline);
      write(textline, string'(" Read LINE CONTROL register"));
      writeline(output, textline);
      cpu_read(LCRADD, INITLCR);

      writeline(output, textline);
      write(textline, string'(" Read MODEM CONTROL register"));
      writeline(output, textline);
      cpu_read(MCRADD, INITMCR);

      writeline(output, textline);
      write(textline, string'(" Read INTERRUPT ENABLE register"));
      writeline(output, textline);
      cpu_read(IERADD, INITIER);

      writeline(output, textline);
      write(textline, string'(" Read SCRATCH register"));
      writeline(output, textline);
      cpu_read(SRADD, INITSR);

-----------------------------------------------
-- Registers have been written and read once  --
-----------------------------------------------

      writeline(output, textline);
      write(textline, string'(" write to LINE CONTROL register"));
      writeline(output, textline);
      cpu_write(('1' & INITLCR(6 downto 0)), LCRADD);

      writeline(output, textline);
      write(textline, string'(" READ DIVISOR LSB register"));
      writeline(output, textline);
      cpu_read(DLRADD, INITDLR, TRUE);

      writeline(output, textline);
      write(textline, string'(" READ DIVISOR MSB register"));
      writeline(output, textline);
      cpu_read(DMRADD, INITDMR, TRUE);

      writeline(output, textline);
      write(textline, string'(" Read MODEM STATUS register"));
      writeline(output, textline);
      cpu_read(MSRADD, "00000000");

      writeline(output, textline);
      write(textline, string'(" Read LINE STATUS register"));
      writeline(output, textline);
      cpu_read(LSRADD, "01100000");

      writeline(output, textline);
      write(textline, string'(" write LINE CONTROL register"));
      writeline(output, textline);
      cpu_write(INITLCR, LCRADD);

      -- RECEIVE BUFFER Register
      cpu_read(RBRADD, "UUUUUUUU", FALSE, FALSE);

      writeline(output, textline);
      write(textline, string'(" Read INTERRUPT IDENTIFICATION register"));
      writeline(output, textline);
      cpu_read(IIRADD, "11000010");

      writeline(output, textline);
      write(textline, string'(" Read MODEM STATUS register"));
      writeline(output, textline);
      cpu_read(MSRADD, "00000000");

---------------------------------------------------------------------------
-- The UART starts to transmit data to itself
-- Number of data and stop bits and parity information is presented to command window
---------------------------------------------------------------------------

      writeline(output, textline);
      write(textline, string'(" TESTING TRANSMISSION AND RECEIVING with few writings to XMIT FIFO"));
      writeline(output, textline);
      write(textline, string'(" and same readings from RCVR FIFO"));
      writeline(output, textline);

      writeline(output, textline);
      write(textline, string'(" UART transmits data to itself"));
      writeline(output, textline);
      writeline(output, textline);

      write(textline, string'(" write LINE CONTROL register"));
      writeline(output, textline);
      cpu_write(INITLCR, LCRADD);

      write(textline, string'(" Check Line status reg, are THRE and TEMP bits active"));
      writeline(output, textline);

      -- LINE STATUS Register
      cpu_read(LSRADD, "01100000");

      write(textline, string'(" write Transmitter holding register"));
      writeline(output, textline);
      cpu_write(INITTHR0, THRADD);

      -- LINE STATUS Register
      cpu_read(LSRADD, "00000000");

      for i in 0 to 4 loop
         -- Write Transmitter Holding register
         cpu_write(INITTHR0, THRADD);
         cpu_write(INITTHR1, THRADD);
         cpu_write(INITTHR2, THRADD);
      end loop;

      -- Transmitter Holding register
      cpu_write(INITTHR2, THRADD);

      writeline(output, textline);
      wait until PCLK'event and PCLK = '1'; wait for CPU_TPD;
      write(textline, now);
      if txrdyn = '1' then
         write(textline, string'(" TXRDY = 1 OK"));
         writeline(output, textline);
      else
         write(textline, string'(" TXRDY = 0 NOK"));
         writeline(output, textline);
         errors <= errors + 1;
      end if;

      clkcount := 0; wait_n_cycle(clkcount, 320);

      -- LINE STATUS Register
      cpu_read(LSRADD, "00000001");

      clkcount := 0; wait_n_cycle(clkcount, 4540);

      wait until PCLK'event and PCLK = '1'; wait for CPU_TPD;
      write(textline, now);
      if rxrdyn = '1' then               -- RXRDY hasn't activated
         write(textline, string'(" RXRDY = 1 OK"));
         writeline(output, textline);
      else
         write(textline, string'(" RXRDY = 0 NOK"));
         writeline(output, textline);
         errors <= errors + 1;
      end if;

      clkcount := 0; wait_n_cycle(clkcount, 40);

      wait until PCLK'event and PCLK = '1'; wait for CPU_TPD;
      write(textline, now);
      if rxrdyn = '0' then               -- RXRDY is active
         write(textline, string'(" RXRDY = 0 OK"));
         writeline(output, textline);
      else
         write(textline, string'(" RXRDY = 1 NOK"));
         writeline(output, textline);
         errors <= errors + 1;
      end if;


      -- MODE 1 TRIGGER LEVEL 14

      -- FIFO Control register ; trigger level 8
      cpu_write(INITFCR2, FCRADD);

      clkcount := 0; wait_n_cycle(clkcount, 1000);

      wait until PCLK'event and PCLK = '1'; wait for CPU_TPD;
      write(textline, now);
      if rxrdyn = '0' then
         write(textline, string'(" RXRDY = 0 OK"));
         writeline(output, textline);
      else
         write(textline, string'(" RXRDY = 1 NOK"));
         writeline(output, textline);
         errors <= errors + 1;
      end if;

      -- LINE STATUS Register
      cpu_read(LSRADD, "00100001");

      -- RECEIVE BUFFER Register
      cpu_read(RBRADD, INITTHR0);
      for i in 0 to 4 loop
         cpu_read(RBRADD, INITTHR0);
         cpu_read(RBRADD, INITTHR1);
         cpu_read(RBRADD, INITTHR2);
      end loop;
      cpu_read(RBRADD, INITTHR2);

      wait until PCLK'event and PCLK = '1'; wait for CPU_TPD;
      write(textline, now);
      if rxrdyn = '1' then
         write(textline, string'(" RXRDY = 1 OK"));
         writeline(output, textline);
      else
         write(textline, string'(" RXRDY = 0 NOK"));
         writeline(output, textline);
         errors <= errors + 1;
      end if;

      clkcount := 0; wait_n_cycle(clkcount, 100);

      -- LINE STATUS Register
      cpu_read(LSRADD, "01100000");

      clkcount := 0; wait_n_cycle(clkcount, 400);

      writeline(output, textline);
      wait until PCLK'event and PCLK = '1'; wait for CPU_TPD;
      write(textline, now);
      if txrdyn = '0' then
         write(textline, string'(" TXRDY = 0 OK"));
         writeline(output, textline);
      else
         write(textline, string'(" TXRDY = 1 NOK"));
         writeline(output, textline);
         errors <= errors + 1;
      end if;

      for i in 0 to 4 loop
         -- Transmitter Holding register
         cpu_write(INITTHR0, THRADD);
         cpu_write(INITTHR1, THRADD);
         cpu_write(INITTHR2, THRADD);
      end loop;

      cpu_write(INITTHR0, THRADD);
      cpu_write(INITTHR1, THRADD);

      writeline(output, textline);
      wait until PCLK'event and PCLK = '1'; wait for CPU_TPD;
      write(textline, now);
      if txrdyn = '1' then
         write(textline, string'(" TXRDY = 1 OK"));
         writeline(output, textline);
      else
         write(textline, string'(" TXRDY = 0 NOK"));
         writeline(output, textline);
         errors <= errors + 1;
      end if;

      clkcount := 0; wait_n_cycle(clkcount, 2750);

      wait until PCLK'event and PCLK = '1'; wait for CPU_TPD;
      write(textline, now);
      if rxrdyn = '1' then               -- RXRDY hasn't activated
         write(textline, string'(" RXRDY = 1 OK"));
         writeline(output, textline);
      else
         write(textline, string'(" RXRDY = 0 NOK"));
         writeline(output, textline);
         errors <= errors + 1;
      end if;

      clkcount := 0; wait_n_cycle(clkcount, 40);

      wait until PCLK'event and PCLK = '1'; wait for CPU_TPD;
      write(textline, now);
      if rxrdyn = '0' then               -- RXRDY is active
         write(textline, string'(" RXRDY = 0 OK"));
         writeline(output, textline);
      else
         write(textline, string'(" RXRDY = 1 NOK"));
         writeline(output, textline);
         errors <= errors + 1;
      end if;

      -- FIFO Control register; trigger level 4
      cpu_write(INITFCR3, FCRADD);

      --if (txrdyn /= '0') then
      --   wait until txrdyn = '0';
      --end if;

      write(textline, now); 
      write(textline, string'(" First Wait"));
      writeline(output, textline); 

      clkcount := 0; wait_n_cycle(clkcount, 3130);

      for i in 0 to 4 loop
         -- RECEIVE BUFFER Register
         cpu_read(RBRADD, INITTHR0);
         cpu_read(RBRADD, INITTHR1);
         cpu_read(RBRADD, INITTHR2);
      end loop;

      cpu_read(RBRADD, INITTHR0);
      cpu_read(RBRADD, INITTHR1);

      for i in 0 to 2 loop
         -- Transmitter Holding register
         cpu_write(INITTHR0, THRADD);
         cpu_write(INITTHR1, THRADD);
         cpu_write(INITTHR2, THRADD);
      end loop;

      clkcount := 0; wait_n_cycle(clkcount, 1370);

      wait until PCLK'event and PCLK = '1'; wait for CPU_TPD;
      write(textline, now);
      if rxrdyn = '1' then               -- RXRDY hasn't activated
         write(textline, string'(" RXRDY = 1 OK"));
         writeline(output, textline);
      else
         write(textline, string'(" RXRDY = 0 NOK"));
         writeline(output, textline);
         errors <= errors + 1;
      end if;

      clkcount := 0; wait_n_cycle(clkcount, 40);

      wait until PCLK'event and PCLK = '1'; wait for CPU_TPD;
      write(textline, now);
      if rxrdyn = '0' then               -- RXRDY is active
         write(textline, string'(" RXRDY = 0 OK"));
         writeline(output, textline);
      else
         write(textline, string'(" RXRDY = 1 NOK"));
         writeline(output, textline);
         errors <= errors + 1;
      end if;

      clkcount := 0; wait_n_cycle(clkcount, 100);

      -- FIFO Control register; RESET XMIT FIFO
      cpu_write(INITFCR4, FCRADD);

      clkcount := 0; wait_n_cycle(clkcount, 250);

      -- FIFO Control register; reset RCVR FIFO
      cpu_write(INITFCR5, FCRADD);

      clkcount := 0; wait_n_cycle(clkcount, 100);

----------------------------------------------------------
-- MODE 0 V
----------------------------------------------------------
      writeline(output, textline);
      write(textline, now);
      write(textline, string'(" MODE 0 test - > "));
      writeline(output, textline);
      writeline(output, textline);

      clkcount := 0; wait_n_cycle(clkcount, 100);

      -- FIFO Control register
      cpu_write(INITFCR1, FCRADD);

      clkcount := 0; wait_n_cycle(clkcount, 100);

      for i in 0 to 3 loop
         -- Transmitter Holding register
         cpu_write(INITTHR0, THRADD);

         if (txrdyn = '1') then
            write(textline, now);
            write(textline, string'(" TXRDY = 1"));
            writeline(output, textline);
         elsif (txrdyn = '0') then
            write(textline, now);
            write(textline, string'(" TXRDY = 0"));
            writeline(output, textline); 
         end if;

         wait until txrdyn = '0';
         write(textline, now);  
         write(textline, string'(" Second Wait #"));
         write(textline, i); 
         writeline(output, textline);

         cpu_write(INITTHR2, THRADD);
         cpu_write(INITTHR1, THRADD);
      end loop;

      clkcount := 0; wait_n_cycle(clkcount, 1250);

      -- RECEIVE BUFFER Register
      cpu_read(RBRADD, INITTHR0);
      cpu_read(RBRADD, INITTHR2);
      cpu_read(RBRADD, INITTHR1);
      cpu_read(RBRADD, INITTHR0);

      for i in 0 to 4 loop
         exit when rxrdyn = '1';
         -- RECEIVE BUFFER Register
         cpu_read(RBRADD, INITTHR2);

         exit when rxrdyn = '1';
         cpu_read(RBRADD, INITTHR1);

         exit when rxrdyn = '1';
         cpu_read(RBRADD, INITTHR0);
      end loop;

      if rxrdyn = '0' then
         write(textline, now); 
         write(textline, string'(" Third Wait"));
         writeline(output, textline);
         cpu_read(RBRADD, INITTHR0);
      end if;

      if rxrdyn = '0' then
         write(textline, now);  
         write(textline, string'(" Fourth Wait"));
         writeline(output, textline);
         cpu_read(RBRADD, INITTHR2);
      end if;

      if rxrdyn = '0' then
         write(textline, now);
         write(textline, string'(" Fifth Wait"));
         writeline(output, textline);
         cpu_read(RBRADD, INITTHR1);
      end if;

      clkcount := 0; wait_n_cycle(clkcount, 100);

      -- LINE STATUS Register
      cpu_read(LSRADD, "01100000");

      cpu_read(RBRADD, "01001100");
      cpu_read(IIRADD, "11000010");

      clkcount := 0; wait_n_cycle(clkcount, 5);
      -- Transmitter Holding register
      cpu_write(INITTHR0, THRADD);
      clkcount := 0; wait_n_cycle(clkcount, 350);
      cpu_write(INITTHR1, THRADD);
      clkcount := 0; wait_n_cycle(clkcount, 10);
      cpu_write(INITTHR2, THRADD);
      clkcount := 0; wait_n_cycle(clkcount, 1500);

      cpu_read(RBRADD, INITTHR0);
      cpu_read(RBRADD, INITTHR1);
      cpu_read(RBRADD, INITTHR2);

      writeline(output, textline);
      write(textline, errors);
      write(textline, string'(" ERROR(S) "));
      writeline(output, textline);

      test_done <= TRUE;
      wait for PERIOD;
      
      wait;

   end process;

end generate;
end tb;
