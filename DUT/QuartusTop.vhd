-- Tal Shvartzberg - 316581537
-- Oren Schor - 316365352

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;
USE work.aux_package.all;

ENTITY QuartusTop IS
		   
  PORT (  Switches: 							IN  STD_LOGIC_VECTOR (9 DOWNTO 0);
		  KEY0, KEY1, KEY2, KEY3, clk: 			IN  STD_LOGIC;
		  RX_bit: 								IN 	STD_LOGIC := '1';
		  TX_bit: 								OUT STD_LOGIC := '1';
		  Hex0, Hex1, Hex2, Hex3, Hex4, Hex5: 	OUT STD_LOGIC_VECTOR(6 downto 0);
		  LEDR:									OUT STD_LOGIC_VECTOR(9 downto 0);
		  PWM_out:								OUT STD_LOGIC
		  ); 
		  
END QuartusTop;


ARCHITECTURE struct OF QuartusTop IS

		SIGNAL 	ena         		: STD_LOGIC;
		SIGNAL 	reset       		: STD_LOGIC :='0';
		SIGNAL 	clock				: STD_LOGIC;
		SIGNAL  rst_flag			: STD_LOGIC := '0';

BEGIN
	
	clock <= clk;
	ena   <= Switches(9);
	
   	MCU_top : MCU  GENERIC MAP (modelsim => 0) PORT MAP( 	
						clk 				=> clock,		-- PLLOut
						reset				=> reset,
						enable 				=> ena,
						RX_bit				=> RX_bit,
						TX_bit				=> TX_bit,
						LEDR				=> LEDR,
						HEX0				=> Hex0,
						HEX1				=> Hex1,
						HEX2				=> Hex2,
						HEX3				=> Hex3,
						HEX4				=> Hex4,
						HEX5				=> Hex5,
						KEY0				=> KEY0,
						KEY1				=> KEY1,
						KEY2				=> KEY2,
						KEY3				=> KEY3,
						SW					=> Switches,
						PWM					=> PWM_out
						);

-------- Synchronous Part ----------------------------------------------------------------	

init_reset: PROCESS (clock) 
	BEGIN
		IF clock'EVENT AND clock = '1' AND NOT (rst_flag = '1') THEN
			reset <= '1';
			rst_flag <= '1';
		ELSIF clock'EVENT AND clock = '1' AND rst_flag = '1' THEN
			reset <= '0';
		END IF;
	END PROCESS;
	
END struct;