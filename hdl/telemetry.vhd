--------------------------------------------------------------------------------
-- HERMESS Project
-- 
-- @author: Robin Grimsmann
-- @brief: telemetry component 
-- @date: 17.01.2022
--------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity telemetry is
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
end telemetry ;

architecture arch of telemetry is
  signal tx_reg           : std_logic_vector(7 downto 0);
  signal rx_reg           : std_logic_vector(7 downto 0);

  signal transmit_counter : std_logic_vector(31 downto 0);
  signal config_reg       : std_logic_vector(31 downto 0);
  signal status_reg       : std_logic_vector(31 downto 0);
  signal config_baud_reg  : std_logic_vector(31 downto 0);
  signal config_gap_reg   : std_logic_vector(31 downto 0);
  signal receive_reg      : std_logic_vector(31 downto 0); 
  --
  signal ShadowLoadReg    : std_logic_vector(31 downto 0);
  -- DEbug GAP Reg
  signal gap_reg          : std_logic_vector(31 downto 0);
  -- Define the APB 3 statemachine
  type APBStateType is (APBWaiting, APBReading, APBWriting);
  signal APBState         : APBStateType;
  -- define the uart transmit state machine
  type UART_TX_StateType is (Blocked, Prepare, Load8Bit, StartTransmission, ResetStartBit, GAP);
  signal UART_TX_State : UART_TX_StateType;
  -- define uart receive state machine
  type UART_RX_StateType is (Start, SelectReg, Update, InterruptState);
  signal UART_RX_State : UART_RX_StateType;
  -- GAP State
  type GAPStateType is (InnerFrame, FrameEnd);
  signal GAPState   : GAPStateType;
  -- Create memory block
  type speicherType is array(0 to 23) of STD_LOGIC_VECTOR(31 downto 0); 
  signal memory : speicherType;
  -- 
  type rxMemoryType is array(0 to 5) of std_logic_vector(31 downto 0);
  signal rxMemory : rxMemoryType;
  -- needed signals for the uart component
  signal tx_start       : std_logic;
  signal TX_finish      : std_logic;
  signal TX_busy        : std_logic;
  signal RX_finish      : std_logic;

  component UART_TX
	port(	clk : in std_logic;
			nRst : in std_logic;
			TX_start : in std_logic;
			baud_config_reg : in std_logic_vector;
			TX_data_in : in std_logic_vector(7 downto 0);
			TX_data_out : out std_logic;
			TX_busy : out std_logic;
			TX_finish : out std_logic );
	end component;


	component UART_RX
	port(   clk : in std_logic;
			nRst : in std_logic;
			baud_config_reg : in std_logic_vector;
	    RX_data_in : in std_logic;
	    RX_data_out : out std_logic_vector(7 downto 0);
			RX_finish : out std_logic );
	end component;

  -- Procedures

  procedure Transmit8bit(signal outputsignal : out std_logic_vector(7 downto 0);
                        signal inputRegister: in std_logic_vector(31 downto 0);
                        variable pos: in integer range 0 to 3) is 
  begin 
    case pos is 
      when 0 => 
        outputsignal <= inputRegister(7 downto 0);
      when 1 =>
        outputsignal <= inputRegister(15 downto 8);
      when 2 => 
        outputsignal <= inputRegister(23 downto 16);
      when 3 => 
        outputsignal <= inputRegister(31 downto 24);
    end case;
  end procedure;

  procedure Transmit8bitRAM(signal outputsignal : out std_logic_vector(7 downto 0);
                        signal inputSignal: in std_logic_vector(31 downto 0);
                        variable pos: in integer range 0 to 3) is 
  begin 
    case pos is 
      when 0 => 
        outputsignal <= inputSignal(7 downto 0);
      when 1 =>
        outputsignal <= inputSignal(15 downto 8);
      when 2 => 
        outputsignal <= inputSignal(23 downto 16);
      when 3 => 
        outputsignal <= inputSignal(31 downto 24);
    end case;
  end procedure;

  procedure LoadRXByteToMemory( signal inputSignal : in std_logic_vector(7 downto 0);
                                signal outPutSignal : out std_logic_vector(31 downto 0);
                                variable pos : integer range 0 to 3) is 
  begin
    case pos is 
      when 0 => 
        outputSignal(7 downto 0)  <= inputSignal;
      when 1 =>
        outputsignal(15 downto 8) <= inputSignal;
      when 2 => 
        outputsignal(23 downto 16) <= inputSignal;
      when 3 => 
        outputsignal(31 downto 24) <= inputsignal;
    end case;
  end procedure;

  begin
  
  c_TX : UART_TX port map (clk => PCLK,
    nRst => PRESETN,
    TX_start => tx_start,
    baud_config_reg => config_baud_reg,
    TX_data_in => tx_reg,
    TX_data_out => TX,
    TX_busy => TX_busy,
    TX_finish => TX_finish);

  c_RX : UART_RX port map (clk => PCLK,
     nRst => PRESETN,
     baud_config_reg => config_baud_reg,
     RX_data_in => RX,		-- replace last RX_data_in with TX_out for testbench_UART
     RX_data_out => rx_reg,
     RX_finish => RX_finish); 
  
  -- TODO: Find fix for the missing byte
  -- Better: implement sending with preloading 3 frames (one measrument frame + frame counter and 8 byte of bullshut)
  PROCESS (PCLK, PRESETN) is 
    variable pos                    : integer range 0 to 3;
    variable row                    : integer range 0 to 32 - 1;
    variable rxPos                  : integer range 0 to 3;
    variable rxRow                  : integer range 0 to 7;
    variable byte_counter           : integer range 0 to 31;  
    variable gap_counter            : integer;
    variable apb_memory_tx_address  : integer range 0 to 24;
    variable apb_memory_rx_address  : integer range 0 to 7;
    variable rx_counter             : integer range 0 to 24;
  begin 
    if (PRESETN = '0') then 
      tx_reg                      <= (others => '0');
      transmit_counter            <= (others => '0');
      config_reg                  <= (others => '0');
      status_reg                  <= (others => '0');
      config_baud_reg             <= (others => '0');
      config_gap_reg              <= (others => '0');
      receive_reg                 <= (others => '0');
      PRDATA                      <= (others => '0');
      --          
      ShadowLoadReg               <= (others => '0');
      --
      memory                      <= (others => (others => '0'));
      rxMemory                    <= (others => (others => '0'));
      --          
      gap_reg                     <= (others => '0');
      --
      PREADY                      <= '0';
      PSLVERR                     <= '0';
      Interrupt                   <= '0';
      TX_start                    <= '0';
      APBState                    <= APBWaiting;
      UART_TX_State               <= Blocked;
      GAPState                    <= InnerFrame;
      UART_RX_State               <= Start;
      -- Init process variables
      gap_counter                 := 0;
      byte_counter                := 0;
      pos                         := 0;
      row                         := 0;
      apb_memory_tx_address       := 0;
      rxPos                       := 0;
      rxRow                       := 0;
    elsif (rising_edge(PCLK)) then
      -- Reset of the complete TX buffer
      if (config_reg(31) = '1') then 
        ShadowLoadReg  <= (others => '0');
        --
        memory         <= (others => (others => '0'));
        --
        status_reg(8 downto 1) <= (others => '0');
        config_reg(31) <= '0';
        GAPState  <= InnerFrame;
        -- init row and pos
        pos := 0;
        row := 0;
        -- 
        status_reg(31) <= '0';
      end if;
      if (config_reg(30)  = '1') then 
        rxMemory  <= (others => (others => '0'));
        receive_reg <= (others => '0');
        UART_RX_State <= Start;
        rxPos     := 0;
        rxRow     := 0;
        config_reg(30) <= '0';
        status_reg(30) <= '0';
      end if;
      -- Enable interrupt
      if (config_reg(0) = '1') then 
        INTERRUPT <= status_reg(31) or status_reg(30);
      else 
        INTERRUPT <= '0';
      end if;
      -- RX finish signal
      case UART_RX_State is 
        when Start => 
          if (rx_finish = '1') then 
            UART_RX_State <= SelectReg;
          else 
            if (rxPos = 0) then
              receive_reg <= (others => '0');
            end if;
          end if;
        when SelectReg => 
          LoadRXByteToMemory(rx_reg, receive_reg, rxPos);
          UART_RX_State <= Update;
        when Update => 
          if (rxPos = 3) then 
            rxMemory(rxRow) <= receive_reg; 
            rxRow := rxRow + 1;
            rxPos := 0;
          else 
            rxPos := rxPos + 1;
          end if;
          UART_RX_State <= InterruptState;
        when InterruptState =>
          if (rxRow = 6 and rxPos = 0) then
            status_reg(30) <= '1';
            rxRow := 0;
            rxPos := 0;
          end if;
          UART_RX_State <= Start;
        when others => 
          UART_RX_State <= Start;
      end case;
      -- Update pos and row in status reg 
      status_reg(2 downto 1) <= std_logic_vector(to_unsigned(pos, 2));
      status_reg(8 downto 4) <= std_logic_vector(to_unsigned(row, 5));

      -- Transmit state maschine 
      case UART_TX_State is 
        when Blocked => 
          if (config_reg(2) = '1' and config_reg(1) = '1' and pos = 0 and row = 0) then -- config_reg(2) := global enable
            UART_TX_State <= Prepare;
            -- reset start bit to avoid loops
            byte_counter := 0;
          end if;
          -- 
          tx_start <= '0';
        when GAP => 
          tx_start <= '0';
          if (tx_busy = '0') then -- wait until the last transmission is done
            if (gap_counter < to_integer(unsigned(config_gap_reg))) then
              gap_reg     <= std_logic_vector(to_unsigned(gap_counter, gap_reg'length));
              gap_counter := gap_counter + 1;
            else 
              gap_counter := 0;
              byte_counter  := 0;
              -- Change the state
              case GAPState is 
                when InnerFrame =>
                  UART_TX_State <= Prepare;
                when FrameEnd =>
                  UART_TX_State <= Blocked;
              end case;
            end if;
          end if;
        when Prepare => 
          ShadowLoadReg <= memory(row);
          UART_TX_State <= Load8Bit;
          config_reg(1) <= '0';
        when Load8Bit => 
            --Anpassung für dem RAM betrieb
            Transmit8bitRAM(tx_reg, ShadowLoadReg, pos);
            -- end of RAM Betrieb
          -- change state to Start transmission (benefit: write to bus after updating the transmit register)
          UART_TX_State <= StartTransmission;
        when StartTransmission  => 
            tx_start <= '1';
            if (pos < 3) then 
              pos := pos + 1;
            else 
              pos := 0;
              row := row + 1;
            end if;
            if (row > 23) then 
              -- set the interrupt flag
              status_reg(31) <= '1';
              -- reset position
              row := 0;
              pos := 0;
              -- change state
              GAPState      <= FrameEnd;
              UART_TX_State <= GAP;
            else
              UART_TX_State <= ResetStartBit;
              byte_counter := byte_counter + 1;
            end if;
        when ResetStartBit => 
          tx_start <= '0';
          if (tx_finish = '1') then 
            if (byte_counter <= 23) then
              UART_TX_State <= Prepare;
            else
              GAPState <= InnerFrame;
              UART_TX_State <= GAP;
            end if;
          end if;
        when others => 
          tx_start <= '0';
          UART_TX_State <= Blocked;
      end case;
      -- APB state maschine
      case APBState is  
        when APBWaiting => 
          if ((PENABLE = '1') AND (PWRITE = '1') AND (PSEL = '1')) then 
              APBState <= APBWriting;
            elsif ((PWRITE = '0' AND PSEL = '1')) then
              APBState <= APBReading;
          end if;
          PREADY <= '0';
        when APBReading =>
          if (PADDR(8) = '1' and PADDR(9) = '0') then -- Address modifiyer: Read form memory
              apb_memory_tx_address := to_integer(shift_right(unsigned(PADDR(7 downto 0)), 2));
               -- shift addr right by 2 to get the normal numbering for memory access.
              PRDATA <= memory(apb_memory_tx_address);
          elsif (PADDR(8)  = '0' and PADDR(9) = '1') then 
              apb_memory_rx_address := to_integer(shift_right(unsigned(PADDR(7 downto 0)), 2));
              PRDATA <= rxMemory(apb_memory_rx_address);
          else 
              -- normal register access
              case PADDR is
                when X"000" => 
                    PRDATA <= transmit_counter; 
                when X"004" =>
                    PRDATA <= config_reg;     
                when X"008" => 
                    PRDATA <= status_reg;     
                when X"00C" => 
                    PRDATA <= config_baud_reg;
                when X"010" => 
                    PRDATA <= config_gap_reg; 
                when X"014" => 
                    PRDATA <= receive_reg;
                when others => 
                PRDATA <= (others => '0');
              end case;
          end if;
          PREADY <= '1';
          APBState <= APBWaiting;
        when APBWriting => 
          if (PADDR(8) = '1' and PADDR(9) = '0') then 
                apb_memory_tx_address := to_integer(shift_right(unsigned(PADDR(7 downto 0)), 2));
                memory(apb_memory_tx_address) <= PWDATA;
          elsif (PADDR(8) = '0' and PADDR(9) = '1') then 
                apb_memory_rx_address := to_integer(shift_right(unsigned(PADDR(7 downto 0)), 2));
                rxMemory(apb_memory_rx_address) <= PWDATA;
          else 
                case PADDR is 
                  when X"000" => 
                      transmit_counter <= PWDATA; 
                  when X"004" =>
                      config_reg <= PWDATA;
                      if (PWDATA(1) = '0') then 
                        UART_TX_State <= Blocked;
                      end if; 
                  when X"008" => 
                      status_reg <= PWDATA;     
                      if (status_reg(31) = '0' or status_reg(30) = '0') then
                        INTERRUPT <= '0';
                      end if;
                  when X"00C" => 
                      config_baud_reg <= PWDATA;
                  when X"010" => 
                      config_gap_reg <= PWDATA; 
                  when X"014" => 
                      receive_reg <= PWDATA;
                  when others => 
                      -- ignore it
                end case;
          end if;
          PREADY <= '1';
          APBState <= APBWaiting;
        when others => 
          APBState <= APBWaiting;    
      end case;
    end if;
  END PROCESS;
  
end architecture ; -- arch