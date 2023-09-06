-- Tal Shvartzberg - 316581537
-- Oren Schor - 316365352

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;
USE work.aux_package.all;

ENTITY tb IS

END tb ;


ARCHITECTURE struct OF tb IS

		-- 50 MHz Clock, 115200 baud UART - (50000000)/(115200) = 434 clocks per bits
		-- 50 MHz Clock, 9600 baud UART - (50000000)/(9600) = 5208 clocks per bits
		constant c_CLKS_PER_BIT : integer := 434;
		-- 1/115200 = 8680 ns , 1/9600 = 104167 ns
		constant c_BIT_PERIOD : time := 8680 ns;
  
		SIGNAL mw_U_0disable_clk : boolean := FALSE;
	   
		SIGNAL 	clock       		: STD_LOGIC;
		SIGNAL 	ena         		: STD_LOGIC;
		SIGNAL 	reset       		: STD_LOGIC :='0';
		SIGNAL 	PC					: STD_LOGIC_VECTOR( 9 DOWNTO 0 );
		SIGNAL  Instruction_out     : STD_LOGIC_VECTOR( 31 DOWNTO 0 );
		SIGNAL  LEDR				: STD_LOGIC_VECTOR( 9 DOWNTO 0 );
		SIGNAL  HEX0, HEX1, HEX2, HEX3,HEX4, HEX5 : STD_LOGIC_VECTOR( 6 DOWNTO 0 );
		SIGNAL 	KEY0, KEY1, KEY2, KEY3	         		: STD_LOGIC;
		SIGNAL 	Switches			: STD_LOGIC_VECTOR( 9 DOWNTO 0 );
		signal w_TX_SERIAL : std_logic;
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

		
BEGIN
	

	   
   	L0 : MCU  GENERIC MAP (modelsim => 1) PORT MAP( 	
						reset				=> reset,
						enable 				=> ena,
						clk 				=> clock,
						PC					=> PC,
						Instruction_out		=> Instruction_out,
						RX_bit				=> r_RX_SERIAL,
						TX_bit				=> w_TX_SERIAL,
						LEDR				=> LEDR,
						HEX0				=> HEX0,
						HEX1				=> HEX1,
						HEX2				=> HEX2,
						HEX3				=> HEX3,
						HEX4				=> HEX4,
						HEX5				=> HEX5,
						KEY0				=> KEY0,
						KEY1				=> KEY1,
						KEY2				=> KEY2,
						KEY3				=> KEY3,
						SW					=> Switches
						);

						
    
	--------- start of stimulus section (100000 ns) ------------------	
	Switches <= "1000000010"; -- change from 0000000001 (up counter) to 0000000010 (down counter) for test1 (or (OTHERS => '1') for general purpose)
	ena <= '1';
	
   u_0clk_proc: PROCESS
   BEGIN
      WHILE NOT mw_U_0disable_clk LOOP
         clock <= '0', '1' AFTER 10 ns;
         WAIT FOR 20 ns;
      END LOOP;
      WAIT;
   END PROCESS u_0clk_proc;
   
   
   mw_U_0disable_clk <= False;
   







   u_1pulse_proc: PROCESS
   BEGIN
      reset <= 
         '0',
         '1' AFTER 20 ns,
         '0' AFTER 120 ns;
      WAIT;
    END PROCESS u_1pulse_proc;
	
   KEY_1: PROCESS
   BEGIN
      KEY1 <= 
         '1',
         '0' AFTER 20 us,
         '1' AFTER 21 us;
      WAIT;
    END PROCESS KEY_1;
	
   KEY_2: PROCESS
   BEGIN
      KEY2 <= 
         '1',
         '0' AFTER 30 us,
         '1' AFTER 31 us;
      WAIT;
    END PROCESS KEY_2;
	
   KEY_3: PROCESS
   BEGIN
      KEY3 <= 
         '1',
         '0' AFTER 30 us,
         '1' AFTER 31 us;
      WAIT;
    END PROCESS KEY_3;
	

   RX: PROCESS	
   BEGIN
   WAIT FOR 50 us;
	UART_WRITE_BYTE(X"A5", r_RX_SERIAL);
   WAIT;
   END PROCESS RX;
   
      KEY_0: PROCESS
   BEGIN
      KEY0 <= 
         '1',
         '0' AFTER 250 us,
         '1' AFTER 251 us;
      WAIT;
    END PROCESS KEY_0;
	
	
	

END struct;
