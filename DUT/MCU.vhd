-- Tal Shvartzberg - 316581537
-- Oren Schor 	   - 316365352

-- Top Level Structural Model for mips-core based MCU
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;
USE work.aux_package.all;

ENTITY MCU IS
	GENERIC ( modelsim : INTEGER := 0 );
	PORT( 
			reset								: IN 	STD_LOGIC; 
			enable								: IN 	STD_LOGIC; 	
			clk								    : IN 	STD_LOGIC; 
			KEY0, KEY1, KEY2, KEY3 				: IN 	STD_LOGIC;
			SW 									: IN 	STD_LOGIC_VECTOR( 9 DOWNTO 0 );
			RX_bit								: IN 	STD_LOGIC := '1';
			TX_bit								: OUT 	STD_LOGIC := '1';
			PWM									: OUT   STD_LOGIC;
			PC									: OUT   STD_LOGIC_VECTOR( 9 DOWNTO 0 );
			Instruction_out						: OUT 	STD_LOGIC_VECTOR( 31 DOWNTO 0 );
			LEDR						 		: OUT 	STD_LOGIC_VECTOR( 9 DOWNTO 0 );
			HEX0, HEX1, HEX2, HEX3,HEX4, HEX5 	: OUT 	STD_LOGIC_VECTOR( 6 DOWNTO 0 ));
END MCU;

ARCHITECTURE structure OF MCU IS

-- Signals decleration
	SIGNAL rst									: STD_LOGIC;
	SIGNAL MemWrite								: STD_LOGIC;
	SIGNAL MemRead								: STD_LOGIC;
	SIGNAL INTA									: STD_LOGIC;
	SIGNAL INTR									: STD_LOGIC;
	SIGNAL GIE									: STD_LOGIC;
	SIGNAL DataBUS								: STD_LOGIC_VECTOR( 31 DOWNTO 0 );	-- 32 bits Data bus
	SIGNAL EX_ALU_result						: STD_LOGIC_VECTOR( 31 DOWNTO 0 );	
	SIGNAL MEM_ALU_result						: STD_LOGIC_VECTOR( 31 DOWNTO 0 );	
	
	SIGNAL address								: STD_LOGIC_VECTOR( 11 DOWNTO 0 );	-- 12 bits Address bus
	
	SIGNAL GPIOaddress							: STD_LOGIC_VECTOR( 4 DOWNTO 0 );
	SIGNAL ICaddress							: STD_LOGIC_VECTOR( 5 DOWNTO 0 );
	SIGNAL BTaddress							: STD_LOGIC_VECTOR( 4 DOWNTO 0 );
	SIGNAL UARTaddress							: STD_LOGIC_VECTOR( 6 DOWNTO 0 );
	SIGNAL OutputPortB							: STD_LOGIC_VECTOR( 7 DOWNTO 0 );
	SIGNAL OutputPortC							: STD_LOGIC_VECTOR( 7 DOWNTO 0 );
	SIGNAL OutputPortD							: STD_LOGIC_VECTOR( 7 DOWNTO 0 );
	SIGNAL OutputPortE							: STD_LOGIC_VECTOR( 7 DOWNTO 0 );
	SIGNAL OutputPortF							: STD_LOGIC_VECTOR( 7 DOWNTO 0 );
	SIGNAL OutputPortG							: STD_LOGIC_VECTOR( 7 DOWNTO 0 );
	SIGNAL Set_BTIFG_s							: STD_LOGIC;
	SIGNAL IR	 								: STD_LOGIC_VECTOR(6 DOWNTO 0);
	SIGNAL KEY0_rst								: STD_LOGIC;
	SIGNAL BT_out                               : STD_LOGIC;
	SIGNAL Key_reset_s							: STD_LOGIC;
	SIGNAL Ultimate_reset						: STD_LOGIC;
	SIGNAL RX_IFG								: STD_LOGIC;
	SIGNAL TX_IFG								: STD_LOGIC;
	signal Status_IFG							: STD_LOGIC;

BEGIN
--														A4				A3,A2,A1,A0	
	GPIOaddress	 								<= address(11) & address(5 DOWNTO 2);
	ICaddress									<= address(11) & address(5) & address(3 DOWNTO 0);
	BTaddress                                   <= address(11) & address(5 DOWNTO 2);
	UARTaddress									<= address(11) & address(5 DOWNTO 0);
	rst 										<= reset;
	address  									<= MEM_ALU_result(11 DOWNTO 0); --EX_ALU_result?
	IR(6) 										<= Status_IFG;
	IR(0) 										<= RX_IFG;
	IR(1) 										<= TX_IFG;
	IR(2) 										<= Set_BTIFG_s;
	IR(3)								 		<= NOT(KEY1);
	IR(4)								 		<= NOT(KEY2);
	IR(5) 										<= NOT(KEY3);
	KEY0_rst 									<= NOT(KEY0);
	Ultimate_reset								<= rst OR Key_reset_s;
	PWM											<= BT_out;

	MIPS_Core: PipelinedMIPS 
    GENERIC MAP ( modelsim )
	PORT MAP (
				Reset 							=> rst,
				Enable							=> enable,
				SW								=> SW,
				clock 							=> clk,
				PC	 							=> PC,
				ID_Instruction 					=> Instruction_out,
				MemRead							=> MemRead,
				MemWrite						=> MemWrite,
				DataBUS					    	=> DataBUS,
				EX_ALU_result  					=> EX_ALU_result,	
				MEM_ALU_result  				=> MEM_ALU_result,	
				GIE								=> GIE,
				Key_reset 				        => Key_reset_s,
				INTA							=> INTA,
				INTR							=> INTR
				);
				
	I_O : GPIO
   	PORT MAP (	
				DataBus		 	=> DataBUS,
				clock			=> clk,
				Reset			=> Ultimate_reset,
				address		 	=> GPIOaddress,
				MemRead 		=> MemRead,
				MemWrite 		=> MemWrite,
				A0				=> address(0),
				InputPortA		=> SW,
				OutputPortA		=> LEDR,
				OutputPortB		=> OutputPortB,
				OutputPortC		=> OutputPortC,
				OutputPortD		=> OutputPortD,
				OutputPortE		=> OutputPortE,
				OutputPortF		=> OutputPortF,
				OutputPortG		=> OutputPortG
				);

	IC: InterruptController
	PORT MAP (
			clock	 		=> clk,
			Reset		 	=> Ultimate_reset,
			address		 	=> ICaddress,
			DataBus		 	=> DataBUS,
			MemRead 		=> MemRead,
			MemWrite 		=> MemWrite,
			IR	 			=> IR,
			rst_btn			=> KEY0_rst,
			GIE	 			=> GIE,
			INTA	 		=> INTA,
			INTR		 	=> INTR
			);

	BT: BasicTimer
	PORT MAP (
			clock	 		=> clk,
			Reset		 	=> Ultimate_reset,
			address		 	=> BTaddress,
			DataBus		 	=> DataBUS,
			MemRead 		=> MemRead,
			MemWrite 		=> MemWrite,
			Out_Signal      => BT_out,
			Set_BTIFG       => Set_BTIFG_s
			);
	
	USART: UART
	PORT MAP (
			clock	 		=> clk,
			Reset		 	=> Ultimate_reset,
			address		 	=> UARTaddress,
			DataBus		 	=> DataBUS,
			MemRead 		=> MemRead,
			MemWrite 		=> MemWrite,
			RX_bit      	=> RX_bit,
			TX_bit       	=> TX_bit,
			RX_IFG			=> RX_IFG,
			TX_IFG			=> TX_IFG,
			Status_IFG		=> Status_IFG
			);	
			
		
	g2: Binary2Hex 		PORT MAP ( Binary => OutputPortB(3 DOWNTO 0),  Hex => HEX0);
	g3: Binary2Hex 		PORT MAP ( Binary => OutputPortC(3 DOWNTO 0),  Hex => HEX1);
	g4: Binary2Hex 		PORT MAP ( Binary => OutputPortD(3 DOWNTO 0),  Hex => HEX2);
	g5: Binary2Hex 		PORT MAP ( Binary => OutputPortE(3 DOWNTO 0),  Hex => HEX3);
	g6: Binary2Hex 		PORT MAP ( Binary => OutputPortF(3 DOWNTO 0),  Hex => HEX4);
	g7: Binary2Hex 		PORT MAP ( Binary => OutputPortG(3 DOWNTO 0),  Hex => HEX5);
	
END structure;