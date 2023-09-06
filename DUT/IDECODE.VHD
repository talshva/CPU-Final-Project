-- Tal Shvartzberg - 316581537
-- Oren Schor - 316365352

--  Idecode module (implements the register file for the MIPS computer)

LIBRARY IEEE; 			
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;

ENTITY Idecode IS
	  PORT(	read_data_1	: 				OUT STD_LOGIC_VECTOR( 31 DOWNTO 0 );
			read_data_2	: 				OUT STD_LOGIC_VECTOR( 31 DOWNTO 0 );
			Opcode :					OUT STD_LOGIC_VECTOR( 5 DOWNTO 0 ); -- opcode for control unit;
			register_rs :			  	OUT STD_LOGIC_VECTOR( 4 DOWNTO 0 ); -- output of inst[21-25] (rs) to Fowarding Unit. 
			register_rt :  				OUT STD_LOGIC_VECTOR( 4 DOWNTO 0 ); -- output of inst[16-20] (rt) to Fowarding Unit / regDst mux 
			register_rd :  				OUT STD_LOGIC_VECTOR( 4 DOWNTO 0 ); -- output of inst[11-15] (rd) to regDst mux 
			Imm_sign_ext :		    	OUT STD_LOGIC_VECTOR( 31 DOWNTO 0 ); -- output of inst[0-15] sign extended.
			jump_address :  			OUT STD_LOGIC_VECTOR( 7 DOWNTO 0 );
			jump_register :				OUT STD_LOGIC_VECTOR( 7 DOWNTO 0 );
			Add_result : 				OUT	STD_LOGIC_VECTOR( 7 DOWNTO 0 ); -- output of branch adder.
			PC_plus_4_out : 			OUT	STD_LOGIC_VECTOR( 9 DOWNTO 0 );
			PCsrc:                      OUT STD_LOGIC;                      -- output for choosing branch eq/neq.
			K0_0:						OUT STD_LOGIC;
			Instruction :				IN 	STD_LOGIC_VECTOR( 31 DOWNTO 0 ); -- Inst. from IF stage.
			PC_plus_4 : 				IN	STD_LOGIC_VECTOR( 9 DOWNTO 0 ); -- PC+4 input to branch Adder.
			write_register_address :    IN  STD_LOGIC_VECTOR( 4 DOWNTO 0 );  -- from MEM stage
			write_data	: 				IN 	STD_LOGIC_VECTOR( 31 DOWNTO 0 );
			RegWrite 	: 				IN 	STD_LOGIC; -- from Control unit
			clock,reset	: 				IN 	STD_LOGIC );
END Idecode;


ARCHITECTURE behavior OF Idecode IS

	TYPE register_file IS ARRAY ( 0 TO 31 ) OF STD_LOGIC_VECTOR( 31 DOWNTO 0 );

	SIGNAL register_array				: register_file;
	SIGNAL read_register_1_address		: STD_LOGIC_VECTOR( 4 DOWNTO 0 );
	SIGNAL read_register_2_address		: STD_LOGIC_VECTOR( 4 DOWNTO 0 );
	SIGNAL read_data_1_signal           : STD_LOGIC_VECTOR( 31 DOWNTO 0 ); 
	SIGNAL read_data_2_signal           : STD_LOGIC_VECTOR( 31 DOWNTO 0 );
	SIGNAL Imm_signal					: STD_LOGIC_VECTOR( 15 DOWNTO 0 );
	SIGNAL Imm_sign_ext_signal			: STD_LOGIC_VECTOR( 31 DOWNTO 0 );
	SIGNAL Add_result_signal 			: STD_LOGIC_VECTOR( 7 DOWNTO 0 );
	SIGNAL Equal						: STD_LOGIC;

BEGIN
	Imm_signal				    <= Instruction( 15 DOWNTO 0 );
	read_register_1_address 	<= Instruction( 25 DOWNTO 21 );
   	read_register_2_address 	<= Instruction( 20 DOWNTO 16 );
	Opcode                      <= Instruction( 31 DOWNTO 26 );
	register_rs					<= Instruction( 25 DOWNTO 21 );
	register_rt			 		<= Instruction( 20 DOWNTO 16 );
   	register_rd					<= Instruction( 15 DOWNTO 11 );
	jump_address				<= Instruction( 7 DOWNTO 0 );
	jump_register               <= read_data_1_signal( 9 DOWNTO 2 );
	PC_plus_4_out               <= PC_plus_4 ( 9 DOWNTO 0 );
	
	-- Read Register 1 Operation
	read_data_1_signal <= register_array( CONV_INTEGER( read_register_1_address ) );
	read_data_1 <= read_data_1_signal;
		
	-- Read Register 2 Operation		 
	read_data_2_signal <= register_array( CONV_INTEGER( read_register_2_address ) );
	read_data_2 <= read_data_2_signal;
	
	-- Update K0_0 SIGNAL
	K0_0		<= register_array(26)(0);
						
	-- Sign Extend 16-bits to 32-bits
	Imm_sign_ext_signal <= X"0000" & Imm_signal  WHEN Imm_signal(15) = '0'
												 ELSE X"FFFF" & Imm_signal;
	Imm_sign_ext <= Imm_sign_ext_signal;
											
	-- Adder to compute Branch Address
	Add_result_signal <= PC_plus_4( 9 DOWNTO 2 ) + Imm_sign_ext_signal( 7 DOWNTO 0 ) ;
	Add_result <= Add_result_signal( 7 DOWNTO 0 );
		
	-- comparator for branch eq/neq -
	--									successful beq												successful bne
	PCsrc <= 	'1' WHEN (((Equal = '1') AND (Instruction(31 DOWNTO 26 ) = X"04")) OR ((Equal = '0') AND (Instruction ( 31 DOWNTO 26 ) = X"05" )))  ELSE  '0';
					 
	PROCESS(read_data_1_signal,read_data_2_signal)
		BEGIN
			if (read_data_1_signal = read_data_2_signal) THEN
				Equal <= '1';
			ELSE 
				Equal <= '0';
			END IF;
		END PROCESS;
	
	PROCESS
		BEGIN
			WAIT UNTIL clock'EVENT AND clock = '0';
			IF reset = '1' THEN
				-- Initial register values on reset are register = reg#
				-- use loop to automatically generate reset logic 
				-- for all registers
				FOR i IN 0 TO 31 LOOP
					register_array(i) <= CONV_STD_LOGIC_VECTOR( i, 32 );
				END LOOP;
			-- Write back to register - don't write to register 0
			ELSIF RegWrite = '1' AND write_register_address /= 0 THEN
				  register_array( CONV_INTEGER( write_register_address)) <= write_data;
			END IF;
		END PROCESS;
END behavior;