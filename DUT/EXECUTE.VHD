-- Tal Shvartzberg - 316581537
-- Oren Schor - 316365352

--  Execute module (implements the data ALU and Branch Address Adder for the MIPS computer)

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
--USE IEEE.STD_LOGIC_ARITH.ALL; -- deprecated LIBRARY!!!!!!!!!!
USE IEEE.STD_LOGIC_SIGNED.ALL;
USE IEEE.NUMERIC_STD.ALL; -- SHIFTS

ENTITY  Execute IS
	PORT(	ALU_Result 				: OUT	STD_LOGIC_VECTOR( 31 DOWNTO 0 );
			write_register_address  : OUT   STD_LOGIC_VECTOR( 4 DOWNTO 0 ); -- regDst mux output
			register_rt_out			: OUT   STD_LOGIC_VECTOR( 4 DOWNTO 0 ); -- for hazard detection unit
			register_rs_out			: OUT   STD_LOGIC_VECTOR( 4 DOWNTO 0 ); -- for Forwarding unit
			read_data_2_out 		: OUT 	STD_LOGIC_VECTOR( 31 DOWNTO 0 );
			Ainput			 		: OUT 	STD_LOGIC_VECTOR( 31 DOWNTO 0 );
			Binput			 		: OUT 	STD_LOGIC_VECTOR( 31 DOWNTO 0 );
			read_data_1 			: IN 	STD_LOGIC_VECTOR( 31 DOWNTO 0 );
			read_data_2 			: IN 	STD_LOGIC_VECTOR( 31 DOWNTO 0 );
			Imm_sign_ext 			: IN 	STD_LOGIC_VECTOR( 31 DOWNTO 0 );
			register_rs 			: IN    STD_LOGIC_VECTOR( 4 DOWNTO 0 ); -- input of inst[21-25] (rs) to Fowarding Unit. 
			register_rt     		: IN 	STD_LOGIC_VECTOR( 4 DOWNTO 0 ); -- input of inst[16-20] (rt) to Fowarding Unit / regDst mux 
			register_rd     		: IN 	STD_LOGIC_VECTOR( 4 DOWNTO 0 ); -- input of inst[11-15] (rd) to regDst mux 			
			ALUop 					: IN 	STD_LOGIC_VECTOR( 5 DOWNTO 0 );
			data_MEM 				: IN    STD_LOGIC_VECTOR( 31 DOWNTO 0 );  -- from MEM stage to alu's input mux's
			data_WB	        		: IN 	STD_LOGIC_VECTOR( 31 DOWNTO 0 );  -- from WB stage to alu's input mux's
			RegDst 		   			: IN 	STD_LOGIC_VECTOR( 1 DOWNTO 0 ); -- choose write Address
			ALU_A_MUX 				: IN 	STD_LOGIC_VECTOR( 1 DOWNTO 0 );
			ALU_B_MUX 				: IN 	STD_LOGIC_VECTOR( 1 DOWNTO 0 );
			WD_MUX        			: IN 	STD_LOGIC_VECTOR( 1 DOWNTO 0 );
			clock, reset			: IN 	STD_LOGIC );

END Execute;

ARCHITECTURE behavior OF Execute IS
SIGNAL Ainput_s, Binput_s 	: STD_LOGIC_VECTOR( 31 DOWNTO 0 );
SIGNAL Function_opcode      : STD_LOGIC_VECTOR( 5 DOWNTO 0 );
SIGNAL ALU_ctl				: STD_LOGIC_VECTOR( 3 DOWNTO 0 );
SIGNAL WD		            : STD_LOGIC_VECTOR( 31 DOWNTO 0 );
SIGNAL shift                : unsigned( 31 DOWNTO 0 ) := (OTHERS => '0');

BEGIN
	
	-- Straight Forward connections
	
	register_rt_out <= register_rt;
	register_rs_out <= register_rs;
	Function_opcode <= Imm_sign_ext( 5 DOWNTO 0 );
	Ainput 			<= Ainput_s;
	Binput 			<= Binput_s;
	read_data_2_out <= WD;
	
	-- ALU input mux's
	Ainput_s <= read_data_1 WHEN (ALU_A_MUX = "00") ELSE
				  data_WB WHEN (ALU_A_MUX = "01") ELSE
				 data_MEM WHEN (ALU_A_MUX = "10") 
					      ELSE Imm_sign_ext;
	
	Binput_s <= read_data_2 WHEN (ALU_B_MUX = "00") ELSE
				  data_WB WHEN (ALU_B_MUX = "01") ELSE
				 data_MEM WHEN (ALU_B_MUX = "10")
					      ELSE Imm_sign_ext;
						  
	WD       <= read_data_2 WHEN (WD_MUX = "00") ELSE
				  data_WB WHEN (WD_MUX = "01") ELSE
				 data_MEM WHEN (WD_MUX = "10")
					      ELSE Imm_sign_ext;
						  
		 
	-- Generate ALU control bits
		-- add   	    - 0000
		-- sub 		  	- 0001
		-- and  		- 0010 
		-- OR  		    - 0011 
		-- xor  	    - 0100 
		-- mul 		    - 0101 
		-- shift left   - 0110
		-- shift right  - 0111
		-- lui 		    - 1000
		-- set 			- 1001
		-- ori			- 1010
		
	ALU_ctl <= "0000" WHEN ALUop = "100011" OR ALUop = "101011" OR ALUop = "001000" OR (ALUop = "000000" AND ( Function_opcode = "100000" OR Function_opcode = "001000" OR Function_opcode = "100001"))  ELSE -- add
			   "0001" WHEN ALUop = "000000" AND Function_opcode = "100010" ELSE -- sub
			   "0010" WHEN ALUop = "000000" AND Function_opcode = "100100" ELSE -- and
			   "0011" WHEN ALUop = "000000" AND Function_opcode = "100101" ELSE -- or
			   "0100" WHEN ALUop = "000000" AND Function_opcode = "100110" ELSE -- xor
			   "0101" WHEN ALUop = "011100" ELSE -- mul
			   "0110" WHEN ALUop = "000000" AND Function_opcode = "000000" ELSE -- shift left
			   "0111" WHEN ALUop = "000000" AND Function_opcode = "000010" ELSE -- shift right
			   "1000" WHEN ALUop = "001111" ELSE -- lui 
			   "1001" WHEN ALUop = "001010" OR (ALUop = "000000" AND Function_opcode = "101010") ELSE -- slti or slt
			   "1010" WHEN ALUop = "001101" ELSE -- ori 
			   "1011" WHEN ALUop = "001100" ELSE -- andi 
			   "1100" WHEN ALUop = "001110" -- xori 
					  ELSE  "1111";
	
	-- Mux for Register Write Address
    write_register_address <= register_rt WHEN (RegDst = "00") ELSE
							  register_rd WHEN (RegDst = "01") ELSE
						  (others => '1') WHEN (RegDst = "10") ELSE
							  "11011"; -- reg k1

PROCESS ( ALU_ctl, Ainput_s, Binput_s )
	BEGIN
	-- Select ALU operation
 	CASE ALU_ctl IS
		-- ALU performs ALUresult = A_input + B_input
		WHEN "0000" =>	ALU_Result 	<= Ainput_s + Binput_s; 
		
		-- ALU performs ALUresult = A_input - B_input
		WHEN "0001" =>	ALU_Result 	<= Ainput_s - Binput_s;
		
		-- ALU performs ALUresult = A_input AND B_input
		WHEN "0010" =>	ALU_Result 	<= Ainput_s AND Binput_s;
		
		-- ALU performs ALUresult = A_input OR B_input
		WHEN "0011" =>	ALU_Result 	<= Ainput_s OR Binput_s;
		
		-- ALU performs ALUresult = A_input XOR B_input
		WHEN "0100" =>	ALU_Result 	<= Ainput_s XOR Binput_s;
		
		-- ALU performs ALUresult = A_input MUL B_input
		WHEN "0101" =>	ALU_Result 	<= Ainput_s(15 DOWNTO 0) * Binput_s (15 DOWNTO 0);
		
		-- ALU performs ALUresult = A_input << B_input
		WHEN "0110" =>	ALU_result <= std_logic_vector(shift_left(unsigned(Binput_s), to_integer(unsigned(Ainput_s(10 DOWNTO 6))))); 
						
		-- ALU performs ALUresult = A_input >> B_input
		WHEN "0111" =>	ALU_result <= std_logic_vector(shift_right(unsigned(Binput_s), to_integer(unsigned(Ainput_s(10 DOWNTO 6))))); 
		
		-- ALU performs ALUresult = {Binput,16'b0}  -- (Lui)
		WHEN "1000" =>	ALU_Result 	<= Binput_s(15 DOWNTO 0) & X"0000" ;
		
		-- ALU performs ALUresult = '1' if A_input < B_input else '0'  (slt)
		WHEN "1001" =>	
		   if(Ainput_s<Binput_s) then
		   ALU_Result <= X"00000001" ;
		   else
		   ALU_Result <= X"00000000" ;
		   end if; 

		WHEN "1010" =>	ALU_Result 	<= Ainput_s OR (X"0000" & Binput_s(15 DOWNTO 0)); -- ori

		WHEN "1011" =>	ALU_Result 	<= Ainput_s AND (X"0000" & Binput_s(15 DOWNTO 0)); -- andi
		
		WHEN "1100" =>	ALU_Result 	<= Ainput_s XOR (X"0000" & Binput_s(15 DOWNTO 0)); -- xori
		
 	 	WHEN OTHERS	=>	ALU_Result 	<= X"00000000" ;
  	END CASE;
  END PROCESS;
END behavior;