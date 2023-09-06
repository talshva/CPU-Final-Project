-- Tal Shvartzberg - 316581537
-- Oren Schor - 316365352

-- Forwarding Unit

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;
USE IEEE.STD_LOGIC_SIGNED.ALL;

ENTITY Forwarding IS
   PORT( 	
	rd_WB 				: IN 	STD_LOGIC_VECTOR( 4 DOWNTO 0 );
	rd_MEM 				: IN 	STD_LOGIC_VECTOR( 4 DOWNTO 0 );
	rt_EX 				: IN 	STD_LOGIC_VECTOR( 4 DOWNTO 0 );
	rs_EX 				: IN 	STD_LOGIC_VECTOR( 4 DOWNTO 0 );
	Regwrite_MEM 		: IN 	STD_LOGIC;
	Regwrite_WB			: IN 	STD_LOGIC;
	Opcode 				: IN 	STD_LOGIC_VECTOR( 5 DOWNTO 0 );
	Function_opcode 	: IN	STD_LOGIC_VECTOR( 5 DOWNTO 0 );
	ALU_A_MUX	 		: OUT 	STD_LOGIC_VECTOR( 1 DOWNTO 0 );
	ALU_B_MUX		 	: OUT 	STD_LOGIC_VECTOR( 1 DOWNTO 0 );
	WD_MUX        		: OUT 	STD_LOGIC_VECTOR( 1 DOWNTO 0 ));		

END Forwarding;

ARCHITECTURE Forward OF Forwarding IS
	SIGNAL f_memA, f_wbA, f_memB, f_wbB, immA, immB : STD_LOGIC;  

	BEGIN           
	-- Code to choose data Forwarding
	f_memA 	<= '1' WHEN (Regwrite_MEM = '1') AND NOT(rd_MEM = 0) AND (rd_MEM = rs_EX) ELSE '0';
	f_wbA 	<=  '1' WHEN (Regwrite_WB = '1')  AND NOT(rd_WB = 0)  AND (rd_WB = rs_EX)  ELSE '0';
	f_memB	<= '1' WHEN (Regwrite_MEM = '1') AND NOT(rd_MEM = 0) AND (rd_MEM = rt_EX) ELSE '0';
	f_wbB 	<=  '1' WHEN (Regwrite_WB = '1')   AND NOT(rd_WB = 0)  AND (rd_WB = rt_EX) ELSE '0';
	immB   <= '1' WHEN (Opcode = "000000" AND (Function_opcode = "000000" OR Function_opcode = "000010")) ELSE '0';
	immA   	<=  '1' WHEN (Opcode = "100011") OR (Opcode = "001000") OR (Opcode = "001100") OR (Opcode = "001101") OR (Opcode = "001110") OR (Opcode = "001111") OR (Opcode = "001010") OR (Opcode = "101011") ELSE '0';
	--                                lw                    addi                   andi                    ori                   xori                    lui                   slti                    sw 
	
	ALU_A_MUX 		<= 	"10" WHEN f_memA='1' ELSE
						"01" WHEN f_wbA='1' AND NOT (f_memA='1') ELSE
						"11" WHEN immB = '1'
							 ELSE "00";
				
	ALU_B_MUX 		<=  "10" WHEN f_memB='1' AND NOT immA = '1' ELSE
					    "01" WHEN f_wbB='1' AND NOT f_memB='1' AND NOT immA = '1' ELSE
					    "11" WHEN immA = '1'
							 ELSE "00";
					  
	WD_MUX 			<=  "10" WHEN f_memB='1' ELSE
						"01" WHEN f_wbB='1' AND NOT f_memB='1'
						--"11" WHEN imm = '1' AND NOT (f_memA='1' OR f_memB='1') -- not really relavent
							 ELSE "00";
			
	END Forward;