----------------------------------------------------------------------
-- File Downloaded from http://www.nandl	and.com
----------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.ALL;
use ieee.numeric_std.all;
USE work.aux_package.all;
 
entity uart_tb is
end uart_tb;
 
architecture behave of uart_tb is
  -- RUN SIMULATION FOR MINIMUM 50MS
 
  -- Test Bench uses a 50 MHz Clock
  -- Want to interface to 9600 baud UART
-- 50 MHz Clock, 115200 baud UART - (50000000)/(115200) = 434 clocks per bits
-- 50 MHz Clock, 9600 baud UART - (50000000)/(9600) = 5208 clocks per bits
  constant c_CLKS_PER_BIT : integer := 434;
 -- 1/115200 = 8680 ns , 1/9600 = 104167 ns
  constant c_BIT_PERIOD : time := 8680 ns;
   
  signal r_CLOCK     : std_logic                    := '0';
  signal r_TX_DV     : std_logic                    := '0';
  signal r_TX_BYTE   : std_logic_vector(7 downto 0) := (others => '0');
  signal w_TX_SERIAL : std_logic;
  signal w_TX_DONE   : std_logic;
  signal w_RX_DV     : std_logic;
  signal w_RX_BYTE   : std_logic_vector(7 downto 0);
  signal r_RX_SERIAL : std_logic := '1';
 
   
  -- Low-level byte-write
  procedure UART_WRITE_BYTE (
    i_data_in       : in  std_logic_vector(7 downto 0);
    signal o_serial : out std_logic) is
  begin
 
    -- Send Start Bit
    o_serial <= '0';
    wait for c_BIT_PERIOD;
 
    -- Send Data Byte
    for ii in 0 to 7 loop
      o_serial <= i_data_in(ii);
      wait for c_BIT_PERIOD;
    end loop;  -- ii
 
    -- Send Stop Bit
    o_serial <= '1';
    wait for c_BIT_PERIOD;
  end UART_WRITE_BYTE;
 
   
begin
 
  -- Instantiate UART transmitter
  UART_TX_INST : uart_tx
    port map (
	  g_CLKS_PER_BIT => c_CLKS_PER_BIT,
      i_clk       => r_CLOCK,
      i_tx_dv     => r_TX_DV,
      i_tx_byte   => r_TX_BYTE,
      o_tx_serial => w_TX_SERIAL,
      o_tx_done   => w_TX_DONE,
	  PENA		  => '0'	-- without parity bit
      );
 
  -- Instantiate UART Receiver
  UART_RX_INST : uart_rx
    port map (
	  g_CLKS_PER_BIT => c_CLKS_PER_BIT,
      i_clk       => r_CLOCK,
      i_rx_serial => r_RX_SERIAL,
      o_rx_dv     => w_RX_DV,
      o_rx_byte   => w_RX_BYTE,
	  PENA		  => '0' 	-- without parity bit
      );
 
  r_CLOCK <= not r_CLOCK after 10 ns;
   
  process is
  begin
 
    -- Tell the UART to send a command.
    wait until rising_edge(r_CLOCK);
    wait until rising_edge(r_CLOCK);
    r_TX_DV   <= '1';
    r_TX_BYTE <= X"AB";
    wait until rising_edge(r_CLOCK);
    r_TX_DV   <= '0';
    wait until w_TX_DONE = '1';
 
     
    -- Send a command to the UART
    wait until rising_edge(r_CLOCK);
    UART_WRITE_BYTE(X"A5", r_RX_SERIAL);
    wait until rising_edge(r_CLOCK);
 
    -- Check that the correct command was received
    if w_RX_BYTE = X"A5" then
      report "Test Passed - Correct Byte Received" severity note;
    else
      report "Test Failed - Incorrect Byte Received" severity note;
    end if;
 
    assert false report "Tests Complete" severity failure;
     
  end process;
   
end behave;
