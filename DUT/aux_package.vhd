-- Tal Shvartzberg - 316581537
-- Oren Schor - 316365352 

LIBRARY ieee;
USE ieee.std_logic_1164.all;

PACKAGE aux_package is

----------------------------------------------------------------------------------------------------
	COMPONENT MCU IS
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
				LEDR						 	    : OUT 	STD_LOGIC_VECTOR( 9 DOWNTO 0 );
				HEX0, HEX1, HEX2, HEX3,HEX4, HEX5 	: OUT 	STD_LOGIC_VECTOR( 6 DOWNTO 0 ));
	END COMPONENT;
----------------------------------------------------------------------------------------------------
	COMPONENT  GPIO IS
		PORT(				
				DataBus		 					: INOUT STD_LOGIC_VECTOR( 31 DOWNTO 0 );
				clock		 					: IN 	STD_LOGIC;
				Reset		 					: IN 	STD_LOGIC;
				address		 					: IN 	STD_LOGIC_VECTOR( 4 DOWNTO 0 );	-- (A4,A3,A2,A1,A0)
				MemRead 						: IN 	STD_LOGIC;
				MemWrite 						: IN 	STD_LOGIC;
				A0              				: IN 	STD_LOGIC;
				InputPortA						: IN 	STD_LOGIC_VECTOR( 9 DOWNTO 0 );	 -- SW
				OutputPortA						: OUT 	STD_LOGIC_VECTOR( 9 DOWNTO 0 );	 -- LEDR
				OutputPortB						: OUT 	STD_LOGIC_VECTOR( 7 DOWNTO 0 );  -- HEX0
				OutputPortC						: OUT 	STD_LOGIC_VECTOR( 7 DOWNTO 0 );  -- HEX1
				OutputPortD						: OUT 	STD_LOGIC_VECTOR( 7 DOWNTO 0 );  -- HEX2
				OutputPortE						: OUT 	STD_LOGIC_VECTOR( 7 DOWNTO 0 );  -- HEX3
				OutputPortF						: OUT 	STD_LOGIC_VECTOR( 7 DOWNTO 0 );  -- HEX4
				OutputPortG 					: OUT 	STD_LOGIC_VECTOR( 7 DOWNTO 0 ));  -- HEX5
	END COMPONENT;
----------------------------------------------------------------------------------------------------
	COMPONENT PipelinedMIPS IS
		GENERIC ( modelsim : INTEGER := 0 );
		PORT(   
				Reset, clock, Enable				: IN STD_LOGIC; 
				INTR								: IN  STD_LOGIC;
				SW									: IN STD_LOGIC_VECTOR (9 DOWNTO 0);

				DataBUS								: INOUT STD_LOGIC_VECTOR( 31 DOWNTO 0 );

				PC									: OUT  STD_LOGIC_VECTOR( 9 DOWNTO 0 );
				
				ID_Instruction						: OUT STD_LOGIC_VECTOR( 31 DOWNTO 0 );
				ID_read_data_1						: OUT STD_LOGIC_VECTOR( 31 DOWNTO 0 );
				ID_read_data_2						: OUT STD_LOGIC_VECTOR( 31 DOWNTO 0 );
				ID_write_data 						: OUT STD_LOGIC_VECTOR( 31 DOWNTO 0 );
				ID_Regwrite							: OUT STD_LOGIC;
				rs_ID 								: OUT STD_LOGIC_VECTOR( 4 DOWNTO 0 );
				rt_ID 								: OUT STD_LOGIC_VECTOR( 4 DOWNTO 0 );
				rd_ID 								: OUT STD_LOGIC_VECTOR( 4 DOWNTO 0 );
		
				EX_Instruction 						: OUT STD_LOGIC_VECTOR( 31 DOWNTO 0 );
				EX_ALU_result 						: OUT STD_LOGIC_VECTOR( 31 DOWNTO 0 );
				EX_ALU_Ainput						: OUT STD_LOGIC_VECTOR( 31 DOWNTO 0 );
				EX_ALU_Binput						: OUT STD_LOGIC_VECTOR( 31 DOWNTO 0 );
				rs_EX 								: OUT STD_LOGIC_VECTOR( 4 DOWNTO 0 );
				rt_EX 								: OUT STD_LOGIC_VECTOR( 4 DOWNTO 0 );
				rd_EX 								: OUT STD_LOGIC_VECTOR( 4 DOWNTO 0 );
				chosen_rt_rd_EX 					: OUT STD_LOGIC_VECTOR( 4 DOWNTO 0 );
				
				MEM_ALU_result						: OUT STD_LOGIC_VECTOR( 31 DOWNTO 0 );
				MEM_Instruction 					: OUT STD_LOGIC_VECTOR( 31 DOWNTO 0 );
				MEM_MemWrite 						: OUT STD_LOGIC;
				MEM_read_data 						: OUT STD_LOGIC_VECTOR( 31 DOWNTO 0 );
				MEM_write_data  					: OUT STD_LOGIC_VECTOR( 31 DOWNTO 0 ); -- write data
				MEM_Address							: OUT STD_LOGIC_VECTOR( 9 DOWNTO 0 );
				rd_MEM			 					: OUT STD_LOGIC_VECTOR( 4 DOWNTO 0 );
				
				WB_Instruction 						: OUT STD_LOGIC_VECTOR( 31 DOWNTO 0 );
				WB_MemtoReg							: OUT STD_LOGIC_VECTOR( 1 DOWNTO 0 );
				rd_WB			 					: OUT STD_LOGIC_VECTOR( 4 DOWNTO 0 );

				CLKCNT_out							: OUT STD_LOGIC_VECTOR( 15 DOWNTO 0 );
				STCNT_out							: OUT STD_LOGIC_VECTOR( 7 DOWNTO 0 );
				FHCNT_out							: OUT STD_LOGIC_VECTOR( 7 DOWNTO 0 );
				BPADD_out							: OUT STD_LOGIC_VECTOR( 9 DOWNTO 0 );
				IF_ID_Write							: OUT STD_LOGIC;
				ID_write_reg_addr   				: OUT STD_LOGIC_VECTOR( 4 DOWNTO 0 );
				ALU_A_MUX		   					: OUT STD_LOGIC_VECTOR( 1 DOWNTO 0 );
				ALU_B_MUX		   					: OUT STD_LOGIC_VECTOR( 1 DOWNTO 0 );
				WD_MUX        						: OUT STD_LOGIC_VECTOR( 1 DOWNTO 0 );
				Jump								: OUT STD_LOGIC_VECTOR( 1 DOWNTO 0 );
				MemRead								: OUT STD_LOGIC;
				MemWrite							: OUT STD_LOGIC;
				ST_trigger							: OUT STD_LOGIC;
				GIE	 								: OUT STD_LOGIC;
				Key_reset 							: OUT STD_LOGIC;
				INTA								: OUT STD_LOGIC);
	END COMPONENT;
----------------------------------------------------------------------------------------------------	
	COMPONENT Ifetch IS
		GENERIC ( modelsim : INTEGER := 0 );
		PORT(	
				Instruction 						: OUT	STD_LOGIC_VECTOR( 31 DOWNTO 0 );
				PC_plus_4_out 						: OUT	STD_LOGIC_VECTOR( 9 DOWNTO 0 );
				PC_tb 								: OUT	STD_LOGIC_VECTOR( 9 DOWNTO 0 );
				Add_result 							: IN 	STD_LOGIC_VECTOR( 7 DOWNTO 0 );
				jump_address    					: IN 	STD_LOGIC_VECTOR( 7 DOWNTO 0 );
				jump_register						: IN 	STD_LOGIC_VECTOR( 7 DOWNTO 0 );
				ISR_address							: IN 	STD_LOGIC_VECTOR( 7 DOWNTO 0 );
				Jump                        		: IN 	STD_LOGIC_VECTOR( 1 DOWNTO 0 );
				ISR_en                      		: IN    STD_LOGIC;
				clock, reset, PCWrite, ena 			: IN 	STD_LOGIC);
	END COMPONENT;
----------------------------------------------------------------------------------------------------  
	COMPONENT Idecode IS
		PORT(	
				read_data_1							: OUT STD_LOGIC_VECTOR( 31 DOWNTO 0 );
				read_data_2							: OUT STD_LOGIC_VECTOR( 31 DOWNTO 0 );
				Opcode 								: OUT STD_LOGIC_VECTOR( 5 DOWNTO 0 ); -- opcode for control unit;
				register_rs 						: OUT STD_LOGIC_VECTOR( 4 DOWNTO 0 ); -- output of inst[21-25] (rs) to Fowarding Unit. 
				register_rt 						: OUT STD_LOGIC_VECTOR( 4 DOWNTO 0 ); -- output of inst[16-20] (rt) to Fowarding Unit / regDst mux 
				register_rd 						: OUT STD_LOGIC_VECTOR( 4 DOWNTO 0 ); -- output of inst[11-15] (rd) to regDst mux 
				Imm_sign_ext 						: OUT STD_LOGIC_VECTOR( 31 DOWNTO 0 ); -- output of inst[0-15] sign extended.
				jump_address 						: OUT STD_LOGIC_VECTOR( 7 DOWNTO 0 );
				jump_register 						: OUT STD_LOGIC_VECTOR( 7 DOWNTO 0 );
				Add_result 							: OUT	STD_LOGIC_VECTOR( 7 DOWNTO 0 ); -- output of branch adder.
				PC_plus_4_out 						: OUT	STD_LOGIC_VECTOR( 9 DOWNTO 0 );
				PCsrc								: OUT STD_LOGIC;                      -- output for choosing branch eq/neq.
				K0_0								: OUT STD_LOGIC;
				Instruction 						: IN 	STD_LOGIC_VECTOR( 31 DOWNTO 0 ); -- Inst. from IF stage.
				PC_plus_4 							: IN	STD_LOGIC_VECTOR( 9 DOWNTO 0 ); -- PC+4 input to branch Adder.
				write_register_address 				: IN  STD_LOGIC_VECTOR( 4 DOWNTO 0 );  -- from MEM stage
				write_data							: IN 	STD_LOGIC_VECTOR( 31 DOWNTO 0 );
				RegWrite 							: IN 	STD_LOGIC; -- from Control unit
				clock,reset							: IN 	STD_LOGIC );
	END COMPONENT;
----------------------------------------------------------------------------------------------------
	COMPONENT  Execute IS
		PORT(	
				ALU_Result 							: OUT	STD_LOGIC_VECTOR( 31 DOWNTO 0 );
				write_register_address  			: OUT   STD_LOGIC_VECTOR( 4 DOWNTO 0 ); -- regDst mux output
				register_rt_out						: OUT   STD_LOGIC_VECTOR( 4 DOWNTO 0 ); -- for hazard detection unit
				register_rs_out						: OUT   STD_LOGIC_VECTOR( 4 DOWNTO 0 ); -- for Forwarding unit
				read_data_2_out 					: OUT 	STD_LOGIC_VECTOR( 31 DOWNTO 0 );
				Ainput			 					: OUT 	STD_LOGIC_VECTOR( 31 DOWNTO 0 );
				Binput			 					: OUT 	STD_LOGIC_VECTOR( 31 DOWNTO 0 );
				read_data_1 						: IN 	STD_LOGIC_VECTOR( 31 DOWNTO 0 );
				read_data_2 						: IN 	STD_LOGIC_VECTOR( 31 DOWNTO 0 );
				Imm_sign_ext 						: IN 	STD_LOGIC_VECTOR( 31 DOWNTO 0 );
				register_rs 						: IN    STD_LOGIC_VECTOR( 4 DOWNTO 0 ); -- input of inst[21-25] (rs) to Fowarding Unit. 
				register_rt     					: IN 	STD_LOGIC_VECTOR( 4 DOWNTO 0 ); -- input of inst[16-20] (rt) to Fowarding Unit / regDst mux 
				register_rd     					: IN 	STD_LOGIC_VECTOR( 4 DOWNTO 0 ); -- input of inst[11-15] (rd) to regDst mux 			
				ALUop 								: IN 	STD_LOGIC_VECTOR( 5 DOWNTO 0 );
				data_MEM 							: IN    STD_LOGIC_VECTOR( 31 DOWNTO 0 );  -- from MEM stage to alu's input mux's
				data_WB	        					: IN 	STD_LOGIC_VECTOR( 31 DOWNTO 0 );  -- from WB stage to alu's input mux's
				RegDst 		   						: IN 	STD_LOGIC_VECTOR( 1 DOWNTO 0 ); -- choose write Address
				ALU_A_MUX 							: IN 	STD_LOGIC_VECTOR( 1 DOWNTO 0 );
				ALU_B_MUX 							: IN 	STD_LOGIC_VECTOR( 1 DOWNTO 0 );
				WD_MUX        						: IN 	STD_LOGIC_VECTOR( 1 DOWNTO 0 );
				clock, reset						: IN 	STD_LOGIC );
	END COMPONENT;
----------------------------------------------------------------------------------------------------
	COMPONENT dmemory IS
		GENERIC ( modelsim : INTEGER := 0 );
		PORT(	
				DataBUS								: IN 	STD_LOGIC_VECTOR( 31 DOWNTO 0 );
				read_data 							: OUT 	STD_LOGIC_VECTOR( 31 DOWNTO 0 );
				ALU_Result_OUT    					: OUT 	STD_LOGIC_VECTOR( 31 DOWNTO 0 );
				ALU_Result	 						: IN 	STD_LOGIC_VECTOR( 31 DOWNTO 0 );
				TYPE_addr 							: IN 	STD_LOGIC_VECTOR( 7 DOWNTO 0 );
				TYPE_ctl 							: IN 	STD_LOGIC;	
				write_data 							: IN 	STD_LOGIC_VECTOR( 31 DOWNTO 0 );
				MemRead, MemWrite 					: IN 	STD_LOGIC;
				clock,reset							: IN 	STD_LOGIC );
	END COMPONENT;
----------------------------------------------------------------------------------------------------	
	COMPONENT control IS
	   PORT( 	
		RegDst 										: OUT 	STD_LOGIC_VECTOR( 1 DOWNTO 0 );
		MemtoReg 									: OUT 	STD_LOGIC_VECTOR( 1 DOWNTO 0 );
		RegWrite 									: OUT 	STD_LOGIC;
		MemRead 									: OUT 	STD_LOGIC;
		MemWrite 									: OUT 	STD_LOGIC;
		jr             								: OUT   STD_LOGIC;
		br 											: OUT   STD_LOGIC;
		Jump           								: OUT   STD_LOGIC_VECTOR( 1 DOWNTO 0 );
		ALUop 										: OUT 	STD_LOGIC_VECTOR( 5 DOWNTO 0 );
		TYPE_ctl									: OUT	STD_LOGIC;
		INTA	 									: OUT 	STD_LOGIC;
		GIE	 										: OUT 	STD_LOGIC;
		INT_Flush									: OUT 	STD_LOGIC;
		EPC_EN										: OUT 	STD_LOGIC;
		Key_reset									: OUT 	STD_LOGIC;
		K0_0										: IN    STD_LOGIC;
		INTR									 	: IN 	STD_LOGIC;
		rs_ID           							: IN 	STD_LOGIC_VECTOR( 4 DOWNTO 0 );
		Opcode 										: IN 	STD_LOGIC_VECTOR( 5 DOWNTO 0 );
		TYPE_addr 									: IN 	STD_LOGIC_VECTOR( 7 DOWNTO 0 );
		PCsrc 										: IN 	STD_LOGIC;
		Function_opcode 							: IN	STD_LOGIC_VECTOR( 5 DOWNTO 0 );
		clock, reset								: IN 	STD_LOGIC );

	END COMPONENT;
----------------------------------------------------------------------------------------------------
	COMPONENT Forwarding IS
		PORT( 	
				rd_WB 								: IN 	STD_LOGIC_VECTOR( 4 DOWNTO 0 );
				rd_MEM 								: IN 	STD_LOGIC_VECTOR( 4 DOWNTO 0 );
				rt_EX 								: IN 	STD_LOGIC_VECTOR( 4 DOWNTO 0 );
				rs_EX 								: IN 	STD_LOGIC_VECTOR( 4 DOWNTO 0 );
				Regwrite_MEM 						: IN 	STD_LOGIC;
				Regwrite_WB							: IN 	STD_LOGIC;
				Opcode 								: IN 	STD_LOGIC_VECTOR( 5 DOWNTO 0 );
				Function_opcode 					: IN	STD_LOGIC_VECTOR( 5 DOWNTO 0 );
				ALU_A_MUX	 						: OUT 	STD_LOGIC_VECTOR( 1 DOWNTO 0 );
				ALU_B_MUX		 					: OUT 	STD_LOGIC_VECTOR( 1 DOWNTO 0 );
				WD_MUX        						: OUT 	STD_LOGIC_VECTOR( 1 DOWNTO 0 ));		
	END COMPONENT;
----------------------------------------------------------------------------------------------------	
	COMPONENT HazardDetection IS
		PORT( 	
				rd_WB 								: IN 	STD_LOGIC_VECTOR( 4 DOWNTO 0 );
				rt_EX		 						: IN 	STD_LOGIC_VECTOR( 4 DOWNTO 0 );
				rt_ID 								: IN 	STD_LOGIC_VECTOR( 4 DOWNTO 0 );
				rs_ID           					: IN 	STD_LOGIC_VECTOR( 4 DOWNTO 0 );
				r_dst_EX							: IN 	STD_LOGIC_VECTOR( 4 DOWNTO 0 );
				r_dst_MEM							: IN 	STD_LOGIC_VECTOR( 4 DOWNTO 0 );
				MemRead_EX 							: IN 	STD_LOGIC;
				jr              					: IN    STD_LOGIC;
				br  								: IN    STD_LOGIC;
				PCWrite 							: OUT 	STD_LOGIC;
				IF_ID_Write 						: OUT 	STD_LOGIC;
				stall_mux 							: OUT 	STD_LOGIC);
	END COMPONENT;
----------------------------------------------------------------------------------------------------
	COMPONENT Binary2Hex IS
		PORT(      
				Binary								: IN STD_LOGIC_VECTOR (3 DOWNTO 0);
				Hex									: OUT STD_LOGIC_VECTOR(6 DOWNTO 0));
	END COMPONENT;
----------------------------------------------------------------------------------------------------
	COMPONENT Hex2Binary IS
		PORT(    
				Hex									: IN STD_LOGIC_VECTOR (6 DOWNTO 0);
				Binary								: OUT STD_LOGIC_VECTOR(3 DOWNTO 0));
	END COMPONENT;
----------------------------------------------------------------------------------------------------	
	COMPONENT BidirPin IS
		GENERIC( width: integer:=16 );
		PORT(   
				Dout								: IN STD_LOGIC_VECTOR(width-1 DOWNTO 0);
				en									: IN STD_LOGIC;
				Din									: OUT STD_LOGIC_VECTOR(width-1 DOWNTO 0);
				IOpin								: INOUT STD_LOGIC_VECTOR(width-1 DOWNTO 0));
	END COMPONENT;
----------------------------------------------------------------------------------------------------	
	COMPONENT  InterruptController IS
		PORT(	clock	 		: IN 	STD_LOGIC;
				Reset		 	: IN 	STD_LOGIC; -- reset from tb
				address		 	: IN 	STD_LOGIC_VECTOR( 5 DOWNTO 0 ); -- a11,a5,a3-a0
				DataBus		 	: INOUT STD_LOGIC_VECTOR( 31 DOWNTO 0 );
				MemRead	 		: IN 	STD_LOGIC;
				MemWrite	 	: IN 	STD_LOGIC;
				IR	 			: IN 	STD_LOGIC_VECTOR(6 DOWNTO 0);
				rst_btn			: IN 	STD_LOGIC;
				GIE	 			: IN 	STD_LOGIC;
				INTA	 		: IN 	STD_LOGIC;
				INTR		 	: OUT 	STD_LOGIC );
				
	END COMPONENT;
----------------------------------------------------------------------------------------------------
	COMPONENT  BasicTimer IS
		PORT(	clock		 	: IN 	STD_LOGIC;
				Reset		 	: IN 	STD_LOGIC;
				address		 	: IN 	STD_LOGIC_VECTOR( 4 DOWNTO 0 );
				DataBus		 	: INOUT STD_LOGIC_VECTOR( 31 DOWNTO 0 );
				MemRead 		: IN 	STD_LOGIC;
				MemWrite 		: IN 	STD_LOGIC;
				Out_Signal 		: OUT 	STD_LOGIC;
				Set_BTIFG 		: OUT 	STD_LOGIC );
	END COMPONENT;
----------------------------------------------------------------------------------------------------	
	COMPONENT UART is
	  port (
		clock      	: in  	std_logic;
		Reset		: in  	std_logic;
		address		: in 	std_logic_vector( 6 downto 0 );	-- a11,a5-a0
		DataBus		: inout std_logic_vector( 31 downto 0 );
		MemRead     : in 	std_logic;
		MemWrite 	: in 	std_logic;
		RX_bit		: in	std_logic:= '1';
		TX_bit     	: out 	std_logic;
		RX_IFG 		: out  	std_logic;
		TX_IFG		: out	std_logic;
		Status_IFG	: out 	std_logic
		);
	end COMPONENT;
----------------------------------------------------------------------------------------------------	
	COMPONENT UART_RX is
	  port (
		SWRST			: in  std_logic := '0';	
		g_CLKS_PER_BIT 	: in integer := 434;
		i_Clk       	: in  std_logic;
		i_RX_Serial 	: in  std_logic;
		PENA			: in  std_logic := '0';
		PEV				: in  std_logic := '0';
		o_RX_DV     	: out std_logic;
		o_RX_Byte   	: out std_logic_vector(7 downto 0);
		FE     			: out std_logic;
		PE     			: out std_logic;
		OE     			: out std_logic;
		RX_Busy     	: out std_logic
		);
	end COMPONENT;
----------------------------------------------------------------------------------------------------	
	COMPONENT UART_TX is
	  port (
		SWRST			: in  std_logic := '0';
		g_CLKS_PER_BIT 	: in integer := 434;
		i_Clk       	: in  std_logic;
		i_TX_DV     	: in  std_logic;
		i_TX_Byte   	: in  std_logic_vector(7 downto 0);
		PENA			: in  std_logic := '0';
		TX_Busy 		: out std_logic;
		o_TX_Serial 	: out std_logic;
		o_TX_Done   	: out std_logic
		);
	end COMPONENT;
----------------------------------------------------------------------------------------------------	




end aux_package;

