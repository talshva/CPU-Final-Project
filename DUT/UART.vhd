
-- Set Generic g_CLKS_PER_BIT as follows:
-- g_CLKS_PER_BIT = (Frequency of i_Clk)/(Frequency of UART)
-- 50 MHz Clock, 115200 baud UART - (50000000)/(115200) = 434
-- 50 MHz Clock, 9600 baud UART - (50000000)/(9600) = 5208
--
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
USE work.aux_package.all;
 
entity UART is
  port (
    clock      	: in  	std_logic;
	Reset		: in  	std_logic := '0';
	address		: in 	std_logic_vector( 6 downto 0 ) := "0000000";	-- a11,a5-a0
	DataBus		: inout std_logic_vector( 31 downto 0 );
	MemRead     : in 	std_logic:= '0';
	MemWrite 	: in 	std_logic:= '0';
	RX_bit		: in	std_logic := '1';
	TX_bit     	: out 	std_logic := '1';
	RX_IFG 		: out  	std_logic := '0';
	TX_IFG		: out	std_logic := '0';
	Status_IFG	: out 	std_logic
    );
end UART;
 
 
architecture RTL of UART is
	SIGNAL CS			 								: STD_LOGIC_VECTOR( 3 DOWNTO 0 );
	SIGNAL Dout	, Din									: STD_LOGIC_VECTOR( 31 DOWNTO 0 );
	SIGNAL en											: STD_LOGIC;
	SIGNAL UCTL											: STD_LOGIC_VECTOR( 7 DOWNTO 0 ) := "00001001";
	SIGNAL RXBUF										: STD_LOGIC_VECTOR( 7 DOWNTO 0 ) := "00000000";
	SIGNAL TXBUF										: STD_LOGIC_VECTOR( 7 DOWNTO 0 ) := "00000000";
	SIGNAL CLKS_PER_BIT									: integer;
	SIGNAL FramingError									: STD_LOGIC;
	SIGNAL ParityError									: STD_LOGIC;
	SIGNAL OverrunError									: STD_LOGIC;
	SIGNAL buff_full_flag								: STD_LOGIC := '0';
	SIGNAL RX_Busy										: STD_LOGIC := '0';
	SIGNAL TX_Busy										: STD_LOGIC := '0';
	SIGNAL Busy											: STD_LOGIC := '0';
	SIGNAL RXData										: STD_LOGIC_VECTOR( 7 DOWNTO 0 );
	SIGNAL RXData_Valid									: STD_LOGIC;	
	SIGNAL TXData_Valid									: STD_LOGIC;
	SIGNAL TX_Done										: STD_LOGIC;
		
 
begin

	UART2BUS : BidirPin generic map(width => 32) port map(Dout => Dout, en => en, Din => Din, IOpin => DataBUS);	
	
	-- 50 MHz Clock, 115200 baud UART - (50000000)/(115200) = 434
	-- 50 MHz Clock, 9600 baud UART - (50000000)/(9600) = 5208
	CLKS_PER_BIT <= 434 WHEN UCTL(3) = '1' ELSE 5208;
	-- Error handling
	Status_IFG <= '1' WHEN FramingError = '1' OR ParityError = '1' OR OverrunError = '1' ELSE '0';
	Busy	   <= '1' WHEN RX_Busy = '1' OR TX_Busy = '1' ELSE '0';
	

	
	
	--OverrunError <= '1' WHEN buff_full_flag = '1' AND new_RX_flag = '1' ELSE '0'; --receiving start bit while buffer still full			
	
	
	
	
	-- Interrupts:
	RX_IFG <= '1' WHEN buff_full_flag = '1' 			ELSE '0';			 -- full byte received
			--  '0' WHEN (MemRead = '1' AND CS(1) = '1')  ELSE unaffected; -- also reset if the pending interrupt is served
	TX_IFG <= '1' WHEN TX_Done = '1'					ELSE '0';			 -- writing to TX buffer
			--  '0' WHEN (MemRead = '1' AND CS(2) = '1')  ELSE '0'; -- also reset if the interrupt request is serviced
  
	
	
	
	--address(11) & address(5 DOWNTO 0);
	WITH address SELECT
	CS <= "0001" WHEN "1011000", -- UCTL
		  "0010" WHEN "1011001", -- RXBUF
		  "0100" WHEN "1011010", -- TXBUF
		  "0000" WHEN OTHERS;
 
	-- Reading from registers
	Dout <= X"000000" & UCTL  WHEN (MemRead = '1' AND CS(0) = '1') 	ELSE
			X"000000" & RXBUF WHEN (MemRead = '1' AND CS(1) = '1')  ELSE
			X"000000" & TXBUF WHEN (MemRead = '1' AND CS(2) = '1') 	ELSE
			(OTHERS => '0');
 
	en <= '1' WHEN MemRead = '1' AND (CS(0) = '1' OR CS(1) = '1' OR CS(2) = '1') ELSE '0';





	UCTL_REG: PROCESS (Reset, clock)
	BEGIN
		IF ( clock'EVENT ) AND ( clock = '1' ) THEN
			IF Reset = '1' THEN 
				UCTL <= "00001001";	--SWRST enabled, Baudrate = 115200
			ELSIF (MemWrite = '1' AND CS(0) = '1') THEN
				UCTL <= Din(7 DOWNTO 0);
			ELSIF UCTL(0) = '1' THEN	-- SWRST on
				UCTL(7 DOWNTO 4) <= "0000"; 
				UCTL(3) <= '1';
				UCTL(2 DOWNTO 1) <= "00";			
			ELSE
				UCTL(4) 	  <= FramingError;
				UCTL(5) 	  <= ParityError;
				UCTL(6) 	  <= OverrunError;
				UCTL(7)		  <= Busy;
			END IF;
		END IF;
	END PROCESS;
	
	
	RX_REG: PROCESS (Reset, clock)
	BEGIN
		IF ( clock'EVENT ) AND ( clock = '1' ) THEN
			IF Reset = '1' THEN 
				RXBUF <= "00000000";
			ELSIF (RXData_Valid = '1') AND NOT (MemRead = '1' AND CS(1) = '1') THEN	 -- full byte received and ready to enter buffer
				buff_full_flag <= '1';
				RXBUF <= RXData;
			ELSIF (MemRead = '1' AND CS(1) = '1') AND NOT (RXData_Valid = '1')  THEN -- reading from RXBUF
				buff_full_flag <= '0';
				RXBUF <= "00000000";
			END IF;
		END IF;
	END PROCESS;
	
	
	TX_REG: PROCESS (Reset, clock)
	BEGIN
		IF ( clock'EVENT ) AND ( clock = '1' ) THEN
			IF Reset = '1' THEN
				TXBUF <= "00000000";	
			ELSIF (MemWrite = '1' AND CS(2) = '1') THEN
				TXData_Valid <= '1';
				TXBUF <= Din(7 DOWNTO 0);
			ELSE
				TXData_Valid <= '0';
			END IF;
		END IF;
	END PROCESS;
	
	
    Receive : UART_RX
	PORT MAP (	
				--Inputs:
				SWRST			=> UCTL(0),
				g_CLKS_PER_BIT	=> CLKS_PER_BIT,
				i_Clk 			=> clock,
				i_RX_Serial		=> RX_bit,	
				PENA			=> UCTL(1),
				PEV				=> UCTL(2),
				--Outputs:
				o_RX_DV			=> RXData_Valid,	-- Byte is valid for reading
				o_RX_Byte		=> RXData,			-- Byte Data
				FE				=> FramingError,
				PE				=> ParityError,
				OE				=> OverrunError,
				RX_Busy			=> RX_Busy
				);


    Transmit : UART_TX
	PORT MAP (	
				--Inputs:
				SWRST			=> UCTL(0),
				g_CLKS_PER_BIT	=> CLKS_PER_BIT,
				i_Clk 			=> clock,
				i_TX_DV			=> TXData_Valid,
				i_TX_Byte		=> TXBUF,
				PENA			=> UCTL(1),
				--Outputs:
				o_TX_Serial		=> TX_bit,
				TX_Busy			=> TX_Busy,
				o_TX_Done		=> TX_Done
				);
   
end RTL;
