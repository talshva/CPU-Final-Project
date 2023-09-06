----------------------------------------------------------------------
-- File Downloaded from http://www.nandland.com
----------------------------------------------------------------------
-- This file contains the UART Receiver.  This receiver is able to
-- receive 8 bits of serial data, one start bit, one stop bit,
-- and no parity bit.  When receive is complete o_rx_dv will be
-- driven high for one clock cycle.
-- 
-- Set Generic g_CLKS_PER_BIT as follows:
-- g_CLKS_PER_BIT = (Frequency of i_Clk)/(Frequency of UART)
-- 50 MHz Clock, 115200 baud UART - (50000000)/(115200) = 434
-- 50 MHz Clock, 9600 baud UART - (50000000)/(9600) = 5208
--
library ieee;
use ieee.std_logic_1164.ALL;
use ieee.numeric_std.all;
USE work.aux_package.all;
 
entity UART_RX is
  port (
	SWRST			: in  std_logic := '0';	
	g_CLKS_PER_BIT 	: in integer := 434;
    i_Clk       	: in  std_logic;
    i_RX_Serial 	: in  std_logic := '1';
	PENA			: in  std_logic := '0';
	PEV				: in  std_logic := '0';
    o_RX_DV     	: out std_logic;
    o_RX_Byte   	: out std_logic_vector(7 downto 0);
	FE     			: out std_logic := '0';
	PE     			: out std_logic := '0';
	OE     			: out std_logic := '0';
	RX_Busy     	: out std_logic := '0'
    );
end UART_RX;

architecture rtl of UART_RX is
 
  type t_SM_Main is (s_Idle, s_RX_Start_Bit, s_RX_Data_Bits, s_RX_Check_Parity,
                     s_RX_Stop_Bit, s_Cleanup);
  signal r_SM_Main : t_SM_Main := s_Idle;
 
  signal r_RX_Data_R : std_logic := '1';
  signal r_RX_Data   : std_logic := '1';
   
  signal r_Clk_Count : integer := 0;
  signal r_Bit_Index : integer range 0 to 7 := 0;
  signal r_RX_Byte   : std_logic_vector(7 downto 0) := (others => '0');
  signal r_RX_DV     : std_logic := '0';
  signal Parity      : std_logic := '0';

   
begin
 
  Parity <= (r_RX_Byte(0) xor r_RX_Byte(1) xor r_RX_Byte(2) xor r_RX_Byte(3) xor
			r_RX_Byte(4) xor r_RX_Byte(5) xor r_RX_Byte(6) xor r_RX_Byte(7));
  o_RX_DV   <= r_RX_DV;
  o_RX_Byte <= r_RX_Byte;
  
  
  -- Purpose: Double-register the incoming data.
  -- This allows it to be used in the UART RX Clock Domain.
  -- (It removes problems caused by metastabiliy)
  p_SAMPLE : process (i_Clk)
  begin
    if rising_edge(i_Clk) then
      r_RX_Data_R <= i_RX_Serial;
      r_RX_Data   <= r_RX_Data_R;
    end if;
  end process p_SAMPLE;
   
 
  -- Purpose: Control RX state machine
  p_UART_RX : process (i_Clk)
  begin
    if rising_edge(i_Clk) then	 
	
		if SWRST = '1' then
			r_SM_Main <= s_Idle;
		end if;
		
		if r_RX_DV = '1' and i_RX_Serial = '0' then
			OE <= '1';
		else
			OE <= '0';
		end if;
		
      case r_SM_Main is
 
        when s_Idle =>
		  RX_Busy	  <= '0';	
          r_RX_DV     <= '0';
          r_Clk_Count <= 0;
          r_Bit_Index <= 0;

          if r_RX_Data = '0' and SWRST = '0' then       -- Start bit detected	
            r_SM_Main <= s_RX_Start_Bit;
          else
            r_SM_Main <= s_Idle;
          end if;
 
           
        -- Check middle of start bit to make sure it's still low
        when s_RX_Start_Bit =>
		  RX_Busy	 	 <= '1';
          if r_Clk_Count = (g_CLKS_PER_BIT-1)/2 then
            if r_RX_Data = '0' then
              r_Clk_Count <= 0;  -- reset counter since we found the middle
              r_SM_Main   <= s_RX_Data_Bits;
            else
              r_SM_Main   <= s_Idle;
            end if;
          else
            r_Clk_Count <= r_Clk_Count + 1;
            r_SM_Main   <= s_RX_Start_Bit;
          end if;
 
           
        -- Wait g_CLKS_PER_BIT-1 clock cycles to sample serial data
        when s_RX_Data_Bits =>
          if r_Clk_Count < g_CLKS_PER_BIT-1 then
            r_Clk_Count <= r_Clk_Count + 1;
            r_SM_Main   <= s_RX_Data_Bits;
          else
            r_Clk_Count            <= 0;
            r_RX_Byte(r_Bit_Index) <= r_RX_Data;
             
            -- Check if we have sent out all bits
            if r_Bit_Index < 7 then	
              r_Bit_Index <= r_Bit_Index + 1;
              r_SM_Main   <= s_RX_Data_Bits;
            else
			  if PENA = '1' then
				r_SM_Main   <= s_RX_Check_Parity;
			  else
              r_Bit_Index <= 0;
              r_SM_Main   <= s_RX_Stop_Bit;
			  end if;
            end if;
          end if;
 
		when s_RX_Check_Parity =>
		  if r_Clk_Count < g_CLKS_PER_BIT-1 then
            r_Clk_Count <= r_Clk_Count + 1;
            r_SM_Main   <= s_RX_Check_Parity;
          else
			PE <= Parity xor r_RX_Data xor PEV;
			r_Bit_Index <= 0;
			r_SM_Main   <= s_RX_Stop_Bit;	
		  end if;
		
        when s_RX_Stop_Bit => -- Receive Stop bit.  Stop bit = 1
          -- Wait g_CLKS_PER_BIT-1 clock cycles for Stop bit to finish
          if r_Clk_Count < g_CLKS_PER_BIT-1 then
            r_Clk_Count <= r_Clk_Count + 1;
            r_SM_Main   <= s_RX_Stop_Bit;
          else
		  
			if r_RX_Data = '0' then	-- If stop bit = 0
			FE 			<= '1';
			end if;	
			
            r_RX_DV     <= '1';
            r_Clk_Count <= 0;
            r_SM_Main   <= s_Cleanup;
          end if;
 
                   
        -- Stay here 1 clock
        when s_Cleanup =>
	--	  if r_Clk_Count < g_CLKS_PER_BIT-1 then
    --       r_Clk_Count <= r_Clk_Count + 1;
    --       r_SM_Main   <= s_Cleanup;
    --      else
	--		r_Clk_Count <= 0;
			RX_Busy	    <= '0';	
			r_SM_Main <= s_Idle;
			r_RX_DV   <= '0';
	--	  end if;		
             
        when others =>
          r_SM_Main <= s_Idle;
 
      end case;
    end if;
  end process p_UART_RX;
 

   
end rtl;
