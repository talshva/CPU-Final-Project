-- Tal Shvartzberg - 316581537
-- Oren Schor - 316365352
		
-- control module (implements MIPS control unit)

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;
USE IEEE.STD_LOGIC_SIGNED.ALL;

ENTITY control IS
   PORT( 	
	RegDst 			: OUT 	STD_LOGIC_VECTOR( 1 DOWNTO 0 );
	MemtoReg 		: OUT 	STD_LOGIC_VECTOR( 1 DOWNTO 0 );
	RegWrite 		: OUT 	STD_LOGIC;
	MemRead 		: OUT 	STD_LOGIC;
	MemWrite 		: OUT 	STD_LOGIC;
	jr              : OUT   STD_LOGIC;
	br 				: OUT   STD_LOGIC;
	Jump            : OUT   STD_LOGIC_VECTOR( 1 DOWNTO 0 );
	ALUop 			: OUT 	STD_LOGIC_VECTOR( 5 DOWNTO 0 );
	TYPE_ctl		: OUT	STD_LOGIC;
	INTA	 		: OUT 	STD_LOGIC;
	GIE	 			: OUT 	STD_LOGIC;
	INT_Flush		: OUT 	STD_LOGIC;
	EPC_EN			: OUT 	STD_LOGIC;
	Key_reset		: OUT 	STD_LOGIC;
	K0_0			: IN    STD_LOGIC;
	INTR		 	: IN 	STD_LOGIC;
	rs_ID           : IN 	STD_LOGIC_VECTOR( 4 DOWNTO 0 );
	Opcode 			: IN 	STD_LOGIC_VECTOR( 5 DOWNTO 0 );
	TYPE_addr 		: IN 	STD_LOGIC_VECTOR( 7 DOWNTO 0 );
	PCsrc 			: IN 	STD_LOGIC;
	Function_opcode : IN	STD_LOGIC_VECTOR( 5 DOWNTO 0 );
	clock, reset	: IN 	STD_LOGIC );

END control;

ARCHITECTURE behavior OF control IS

	SIGNAL  R_format, lw, sw, beq, bne, addi, andi, ori, xori, mul, lui, slti, j, jal, jr_s, INTA_s, GIE_s, pc_k1, Flush, Key_reset_s: STD_LOGIC;
	SIGNAL  INT_process : STD_LOGIC_VECTOR(2 DOWNTO 0); -- (stage3,stage2,stage1)

BEGIN           
	-- Code to generate control signals using opcode bits
	R_format 	<=  '1'  WHEN  Opcode = "000000"  ELSE '0'; -- add20/sub22/and24/or25/xor26/shift left00/shift right02/addu(move)21/slt2a/jr08 - alu function code decision - 0001
	lw          <=  '1'  WHEN  Opcode = "100011"  ELSE '0'; -- alu add - 0000
 	sw          <=  '1'  WHEN  Opcode = "101011"  ELSE '0'; -- alu add - 0000
   	beq         <=  '1'  WHEN  Opcode = "000100"  ELSE '0'; -- alu dont care - 1111
	bne         <=  '1'  WHEN  Opcode = "000101"  ELSE '0'; -- alu dont care - 1111
	addi        <=  '1'  WHEN  Opcode = "001000"  ELSE '0'; -- alu add - 0000
	andi		<=  '1'  WHEN  Opcode = "001100"  ELSE '0'; -- alu andi - 1011
	xori		<=  '1'  WHEN  Opcode = "001110"  ELSE '0'; -- alu xori - 1100
	mul			<=  '1'  WHEN  Opcode = "011100"  ELSE '0'; -- alu mul- 0101
	lui         <=  '1'  WHEN  Opcode = "001111"  ELSE '0'; -- alu lui - 1000
	slti        <=  '1'  WHEN  Opcode = "001010"  ELSE '0'; -- alu set - 1001
	ori         <=  '1'  WHEN  Opcode = "001101"  ELSE '0'; -- alu ori - 1010
	j           <=  '1'  WHEN  Opcode = "000010"  ELSE '0'; -- alu dont care - 1111
	jal         <=  '1'  WHEN  Opcode = "000011"  ELSE '0'; -- alu dont care - 1111
	jr_s        <=  '1'  WHEN  Opcode = "000000" AND Function_opcode ="001000" ELSE '0'; 
		
  	RegDst(0)   <=  '1' WHEN (R_format = '1') OR (mul = '1') OR (pc_k1 = '1') 				ELSE '0';
	RegDst(1)   <=  '1' WHEN (jal = '1') OR (pc_k1 = '1') 									ELSE '0';
	MemtoReg(0) <=  '1' WHEN (lw = '1') AND (pc_k1 = '0') 									ELSE '0';
	MemtoReg(1) <=  '1' WHEN (jal = '1') OR (pc_k1 = '1') 									ELSE '0';
  	RegWrite 	<=  '1' WHEN ((R_format = '1') OR (lw = '1') OR (addi = '1') OR (andi = '1') OR (ori = '1') OR (xori = '1') OR (mul = '1') OR (lui = '1') OR (slti = '1') OR (jal = '1') OR (pc_k1 = '1')) ELSE '0';
  	MemRead 	<=  '1' WHEN (lw = '1') AND (pc_k1 = '0')									ELSE '0';
   	MemWrite 	<=  '1' WHEN (sw = '1') AND (pc_k1 = '0') 									ELSE '0'; 
	Jump(0)     <=  '1' WHEN ((PCsrc = '1') OR (jr_s = '1')) AND (pc_k1 = '0')  			ELSE '0';				--(successful beq OR Successful bne) OR JR instruction
	Jump(1)     <=  '1' WHEN ((j = '1') OR (jal = '1') OR (jr_s = '1')) AND (pc_k1 = '0') 	ELSE '0';   --			J OR JAL 				 OR JR instruction
	ALUop 		<= Opcode;
	jr          <= '1' when jr_s = '1' AND pc_k1 = '0' ELSE '0';
	br			<= '1' WHEN ((beq='1') OR (bne='1')) AND (pc_k1 = '0') ELSE '0';
	GIE         <= GIE_s AND K0_0;
	EPC_EN      <= GIE_s;
	INTA        <= INTA_s;
	INT_Flush   <= Flush;
	
	Key_reset 	<= Key_reset_s;
	
	PROCESS (clock, reset) 
		BEGIN
			IF (rising_edge(clock)) THEN
				IF reset = '1' THEN
					GIE_s 		<= '1';
					INTA_s		<= '1';
					TYPE_ctl 	<= '0';
					pc_k1     	<= '0';
					Flush     	<= '0';
					INT_process <= (OTHERS => '0');
					Key_reset_s <= '0';
				ELSIF INTR = '1' AND INT_process = "000" THEN
					pc_k1     		<= '1';
					Flush     		<= '1';
					INT_process(0) 	<= '1';
				ELSIF INT_process = "001" THEN
					GIE_s 			<= '0';
					pc_k1     		<= '0';
					INT_process(1) 	<= '1';
				ELSIF INT_process = "011" THEN -- The Cmd that was in EX stage at the time INTR arrived needs to get to WB stage before granting IC to transmit on the bus.
					INTA_s			<= '0';
					TYPE_ctl 		<= '1';
					INT_process(2) 	<= '1';
				ELSIF INT_process = "111" THEN
					IF TYPE_addr = X"00" THEN
						GIE_s 		<= '1';
						Key_reset_s <= '1';
					END IF;
					INTA_s			<= '1';
					Flush     		<= '0';
					TYPE_ctl 		<= '0';
					INT_process 	<= (OTHERS => '0');
				ELSIF Key_reset_s = '1' THEN
					Key_reset_s <= '0';
				ELSIF jr_s = '1' AND rs_ID = "11011" THEN -- reti
					GIE_s 			<= '1';
				END IF;
			END IF;
	END PROCESS;
	
	
   END behavior;



