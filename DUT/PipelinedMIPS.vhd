-- Tal Shvartzberg - 316581537
-- Oren Schor 	   - 316365352

-- Top Level Structural Model for MIPS Processor Core

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;
USE work.aux_package.all;

ENTITY PipelinedMIPS IS
	GENERIC ( modelsim : INTEGER := 0 );
	PORT( 
		Reset, clock, Enable	: IN STD_LOGIC; 
		INTR					: IN  STD_LOGIC;
		SW						: IN STD_LOGIC_VECTOR (9 DOWNTO 0);
		
		-- Output important signals to pins for easy display in Simulator
		DataBUS					: INOUT STD_LOGIC_VECTOR( 31 DOWNTO 0 );
		PC						: OUT  STD_LOGIC_VECTOR( 9 DOWNTO 0 );

		ID_Instruction			: OUT STD_LOGIC_VECTOR( 31 DOWNTO 0 );
		ID_read_data_1			: OUT STD_LOGIC_VECTOR( 31 DOWNTO 0 );
		ID_read_data_2			: OUT STD_LOGIC_VECTOR( 31 DOWNTO 0 );
		ID_write_data 			: OUT STD_LOGIC_VECTOR( 31 DOWNTO 0 );
		ID_Regwrite				: OUT STD_LOGIC;
		rs_ID 					: OUT STD_LOGIC_VECTOR( 4 DOWNTO 0 );
		rt_ID 					: OUT STD_LOGIC_VECTOR( 4 DOWNTO 0 );
		rd_ID 					: OUT STD_LOGIC_VECTOR( 4 DOWNTO 0 );
		
		EX_Instruction 			: OUT STD_LOGIC_VECTOR( 31 DOWNTO 0 );
		EX_ALU_result 			: OUT STD_LOGIC_VECTOR( 31 DOWNTO 0 );
		EX_ALU_Ainput			: OUT STD_LOGIC_VECTOR( 31 DOWNTO 0 );
		EX_ALU_Binput			: OUT STD_LOGIC_VECTOR( 31 DOWNTO 0 );
		rs_EX 					: OUT STD_LOGIC_VECTOR( 4 DOWNTO 0 );
		rt_EX 					: OUT STD_LOGIC_VECTOR( 4 DOWNTO 0 );
		rd_EX 					: OUT STD_LOGIC_VECTOR( 4 DOWNTO 0 );
		chosen_rt_rd_EX 		: OUT STD_LOGIC_VECTOR( 4 DOWNTO 0 );
		
		MEM_ALU_result			: OUT STD_LOGIC_VECTOR( 31 DOWNTO 0 );
		MEM_Instruction 		: OUT STD_LOGIC_VECTOR( 31 DOWNTO 0 );
		MEM_MemWrite 			: OUT STD_LOGIC;
		MEM_read_data 			: OUT STD_LOGIC_VECTOR( 31 DOWNTO 0 );
		MEM_write_data  		: OUT STD_LOGIC_VECTOR( 31 DOWNTO 0 ); -- write data
		MEM_Address				: OUT STD_LOGIC_VECTOR( 9 DOWNTO 0 );
		rd_MEM			 		: OUT STD_LOGIC_VECTOR( 4 DOWNTO 0 );
		
		WB_Instruction 			: OUT STD_LOGIC_VECTOR( 31 DOWNTO 0 );
		WB_MemtoReg				: OUT STD_LOGIC_VECTOR( 1 DOWNTO 0 );
		rd_WB			 		: OUT STD_LOGIC_VECTOR( 4 DOWNTO 0 );

		CLKCNT_out				: OUT STD_LOGIC_VECTOR( 15 DOWNTO 0 );
		STCNT_out				: OUT STD_LOGIC_VECTOR( 7 DOWNTO 0 );
		FHCNT_out				: OUT STD_LOGIC_VECTOR( 7 DOWNTO 0 );
		BPADD_out				: OUT STD_LOGIC_VECTOR( 9 DOWNTO 0 );
		IF_ID_Write				: OUT STD_LOGIC;
		ID_write_reg_addr  		: OUT STD_LOGIC_VECTOR( 4 DOWNTO 0 );
		ALU_A_MUX		   		: OUT STD_LOGIC_VECTOR( 1 DOWNTO 0 );
		ALU_B_MUX		   		: OUT STD_LOGIC_VECTOR( 1 DOWNTO 0 );
		WD_MUX        			: OUT STD_LOGIC_VECTOR( 1 DOWNTO 0 );
		Jump					: OUT STD_LOGIC_VECTOR( 1 DOWNTO 0 );
		MemRead					: OUT STD_LOGIC;
		MemWrite				: OUT STD_LOGIC;
		ST_trigger				: OUT STD_LOGIC;
		GIE	 					: OUT STD_LOGIC;
		Key_reset 				: OUT STD_LOGIC;
		INTA					: OUT STD_LOGIC);

END 	PipelinedMIPS;
				
		
ARCHITECTURE structure OF PipelinedMIPS IS	

	-- declare signals used to connect VHDL components
	
	--SIGNAL BreakPoint  				: STD_LOGIC_VECTOR (7 DOWNTO 0);
	
	-- IF IN
	SIGNAL jump_address 			: STD_LOGIC_VECTOR( 7 DOWNTO 0 ); -- from ID
	SIGNAL jump_register 			: STD_LOGIC_VECTOR( 7 DOWNTO 0 ); -- from ID
	SIGNAL Add_result   			: STD_LOGIC_VECTOR( 7 DOWNTO 0 ); -- from ID
	SIGNAL PCWrite					: STD_LOGIC; -- from comparator (ID), Logic and HazardDetection Unit.
	SIGNAL Jump_s					: STD_LOGIC_VECTOR( 1 DOWNTO 0 );
	-- IF OUT
	SIGNAL PC_plus_4_a	 			: STD_LOGIC_VECTOR( 9 DOWNTO 0 ); -- Out to IF/ID reg
	SIGNAL Instruction_a 			: STD_LOGIC_VECTOR( 31 DOWNTO 0 ); -- Out to IF/ID reg
	
	-- ID IN
	SIGNAL PC_plus_4_b	 			: STD_LOGIC_VECTOR( 9 DOWNTO 0 );  -- in from IF/ID reg
	SIGNAL Instruction_b 			: STD_LOGIC_VECTOR( 31 DOWNTO 0 ); -- in from IF/ID reg
	--write_register_address from MEM/WB reg stage write_register_address_c
	SIGNAL write_data	 			: STD_LOGIC_VECTOR( 31 DOWNTO 0 ); -- from WB mux
	SIGNAL RegWrite_d               : STD_LOGIC; -- from Logic Unit, also connects to Forwarding unit
	
	-- ID OUT
	-- jump_address and Add_result defined in IF IN
	-- PCsrc defined in top
	SIGNAL opcode 					: STD_LOGIC_VECTOR( 5 DOWNTO 0 ); -- from ID to Control unit and Forwarding
	SIGNAL PC_plus_4_c	 			: STD_LOGIC_VECTOR( 9 DOWNTO 0 );  -- out to ID/EX reg
	SIGNAL read_data_1_a            : STD_LOGIC_VECTOR( 31 DOWNTO 0 ) := (OTHERS => '0'); -- out to ID/EX reg
	SIGNAL read_data_2_a            : STD_LOGIC_VECTOR( 31 DOWNTO 0 ) := (OTHERS => '0'); -- out to ID/EX reg
	SIGNAL Imm_sign_ext_a           : STD_LOGIC_VECTOR( 31 DOWNTO 0 ); -- out to ID/EX reg
	SIGNAL register_rs_a            : STD_LOGIC_VECTOR( 4 DOWNTO 0 ); -- out to ID/EX reg
	SIGNAL register_rt_a            : STD_LOGIC_VECTOR( 4 DOWNTO 0 ); -- out to ID/EX reg
	SIGNAL register_rd_a            : STD_LOGIC_VECTOR( 4 DOWNTO 0 ); -- out to ID/EX reg
	
	-- EX IN
	SIGNAL Instruction_c 			: STD_LOGIC_VECTOR( 31 DOWNTO 0 );
	SIGNAL PC_plus_4_d	 			: STD_LOGIC_VECTOR( 9 DOWNTO 0 );  -- in from ID/EX reg
	SIGNAL read_data_1_b            : STD_LOGIC_VECTOR( 31 DOWNTO 0 ); -- in from ID/EX reg
	SIGNAL read_data_2_b            : STD_LOGIC_VECTOR( 31 DOWNTO 0 ); -- in from ID/EX reg
	SIGNAL Imm_sign_ext_b           : STD_LOGIC_VECTOR( 31 DOWNTO 0 ); -- in from ID/EX reg
	SIGNAL register_rs_b            : STD_LOGIC_VECTOR( 4 DOWNTO 0 ); -- in from ID/EX reg
	SIGNAL register_rt_b            : STD_LOGIC_VECTOR( 4 DOWNTO 0 ); -- in from ID/EX reg
	SIGNAL register_rd_b            : STD_LOGIC_VECTOR( 4 DOWNTO 0 ); -- 
	-- data_WB defined as write_data in ID IN
	-- data_MEM	ALU data in from MEM stage for data forwarding. ALU_Result_c
	SIGNAL RegDst_b                 : STD_LOGIC_VECTOR( 1 DOWNTO 0 ); -- controls mux to choose write address 
	SIGNAL ALUop_b                  : STD_LOGIC_VECTOR( 5 DOWNTO 0 ); -- opcode for alu from control unit.
	SIGNAL ALU_A_MUX_s              : STD_LOGIC_VECTOR( 1 DOWNTO 0 ); -- controls mux to choose ALU's A input (from data Forwarding)
	SIGNAL ALU_B_MUX_s              : STD_LOGIC_VECTOR( 1 DOWNTO 0 ); -- controls mux to choose ALU's B input (from data Forwarding)
	SIGNAL WD_MUX_s					: STD_LOGIC_VECTOR( 1 DOWNTO 0 ); -- controls mux to choose Write Data output (from data Forwarding)
	SIGNAL Jump_EX_s				: STD_LOGIC_VECTOR( 1 DOWNTO 0 );
	
	-- EX OUT
	SIGNAL rt_EX_s                  : STD_LOGIC_VECTOR( 4 DOWNTO 0 ); -- to HazardDetection unit and Forwarding Unit
	SIGNAL rs_EX_s                  : STD_LOGIC_VECTOR( 4 DOWNTO 0 ); -- to Forwarding Unit
	SIGNAL ALU_Result_a		        : STD_LOGIC_VECTOR( 31 DOWNTO 0 ); -- out to EX/MEM register
	SIGNAL read_data_2_c         	: STD_LOGIC_VECTOR( 31 DOWNTO 0 ); -- out to EX/MEM register
	SIGNAL write_register_address_a : STD_LOGIC_VECTOR( 4 DOWNTO 0 ); -- out to EX/MEM register
	SIGNAL Ainput_o, Binput_o       : STD_LOGIC_VECTOR( 31 DOWNTO 0 ); -- out to tb              
	
	-- MEM IN
	SIGNAL Instruction_d 			: STD_LOGIC_VECTOR( 31 DOWNTO 0 );
	SIGNAL PC_plus_4_e	 			: STD_LOGIC_VECTOR( 9 DOWNTO 0 );  -- in from EX/MEM register
	SIGNAL ALU_Result_b		        : STD_LOGIC_VECTOR( 31 DOWNTO 0 ); -- in from EX/MEM register
	SIGNAL read_data_2_d		    : STD_LOGIC_VECTOR( 31 DOWNTO 0 ); -- in from EX/MEM register (read_data_2_out)
	SIGNAL write_register_address_b : STD_LOGIC_VECTOR( 4 DOWNTO 0 ); -- in from EX/MEM register
	SIGNAL MemRead_c, MemWrite_c    : STD_LOGIC; -- in from EX/MEM register

	-- MEM OUT
	SIGNAL read_data_a		        : STD_LOGIC_VECTOR( 31 DOWNTO 0 ); -- out to MEM/WB register
	SIGNAL ALU_Result_c		        : STD_LOGIC_VECTOR( 31 DOWNTO 0 ); -- out to EX/MEM register need to link to data_mem signal in EX
	
	-- WB
	SIGNAL Instruction_e 			: STD_LOGIC_VECTOR( 31 DOWNTO 0 );
	SIGNAL PC_plus_4_f	 			: STD_LOGIC_VECTOR( 9 DOWNTO 0 ); -- in from MEM/WB register
	SIGNAL read_data_b		        : STD_LOGIC_VECTOR( 31 DOWNTO 0 ); -- in from MEM/WB register
	SIGNAL ALU_Result_d		        : STD_LOGIC_VECTOR( 31 DOWNTO 0 );  -- in from MEM/WB register
	SIGNAL write_register_address_c : STD_LOGIC_VECTOR( 4 DOWNTO 0 ); -- in from EX/MEM register - connects to write_register_address in ID and Forwarding unit
	SIGNAL MemtoReg_d 				: STD_LOGIC_VECTOR( 1 DOWNTO 0 ); -- controls mux to choose write address
	
	-- Top
	SIGNAL RegDst_a                 : STD_LOGIC_VECTOR( 1 DOWNTO 0 ); -- controls mux to choose write address
	SIGNAL RegDst_amux				: STD_LOGIC_VECTOR( 1 DOWNTO 0 );
	SIGNAL MemtoReg_a 				: STD_LOGIC_VECTOR( 1 DOWNTO 0 ); -- controls mux to choose write data source
	SIGNAL MemtoReg_amux 		    : STD_LOGIC_VECTOR( 1 DOWNTO 0 );
	SIGNAL MemtoReg_b 				: STD_LOGIC_VECTOR( 1 DOWNTO 0 ); -- controls mux to choose write data source, also connects HazardDetection unit
	SIGNAL MemtoReg_c 				: STD_LOGIC_VECTOR( 1 DOWNTO 0 ); -- controls mux to choose write data source, also connects Forwarding unit
	SIGNAL ALUop_a                  : STD_LOGIC_VECTOR( 5 DOWNTO 0 ); -- opcode for alu from control unit.
	SIGNAL ALUop_amux               : STD_LOGIC_VECTOR( 5 DOWNTO 0 );
	SIGNAL PCsrc  					: STD_LOGIC;
	SIGNAL RegWrite_a               : STD_LOGIC; -- from Logic Unit
	SIGNAL RegWrite_amux            : STD_LOGIC;
	SIGNAL RegWrite_b               : STD_LOGIC; -- from Logic Unit
	SIGNAL RegWrite_c               : STD_LOGIC; -- from Logic Unit, also connects to Forwarding unit
	SIGNAL MemRead_a, MemWrite_a    : STD_LOGIC; 
	SIGNAL MemRead_amux				: STD_LOGIC;
	SIGNAL MemWrite_amux    		: STD_LOGIC; 
	SIGNAL MemRead_b, MemWrite_b    : STD_LOGIC; -- MemRead_b connects also to HazardDetection Unit
	SIGNAL stall_mux, IF_ID_Write_s : STD_LOGIC; -- PCwrite defined in IF IN
	SIGNAL jr						: STD_LOGIC;
	SIGNAL br						: STD_LOGIC;
	SIGNAL clk, rst, ena			: STD_LOGIC;
	
	-- tb
	SIGNAL PC_tb 					: STD_LOGIC_VECTOR( 9 DOWNTO 0 );
	SIGNAL CLKCNT					: STD_LOGIC_VECTOR( 15 DOWNTO 0 );
	SIGNAL STCNT 					: STD_LOGIC_VECTOR( 7 DOWNTO 0 );
	SIGNAL FHCNT 					: STD_LOGIC_VECTOR( 7 DOWNTO 0 );
	SIGNAL BPADD 					: STD_LOGIC_VECTOR( 9 DOWNTO 0 );
	
	--
	SIGNAL TYPE_ctl_sig 			: STD_LOGIC;
	SIGNAL En_CORE2BUS				: STD_LOGIC;
	SIGNAL Din						: STD_LOGIC_VECTOR( 31 DOWNTO 0 );
	SIGNAL INTA_s					: STD_LOGIC;
	SIGNAL INTR_s					: STD_LOGIC;
	SIGNAL GIE_s					: STD_LOGIC;
	SIGNAL INT_Flush_s             	: STD_LOGIC;
	SIGNAL K0_0_s					: STD_LOGIC;
	SIGNAL epc	 					: STD_LOGIC_VECTOR( 9 DOWNTO 0 );
	SIGNAL EPC_EN_s                 : STD_LOGIC;
	SIGNAL Key_reset_s				: STD_LOGIC;
	
  
BEGIN
	--BreakPoint <= "11111111";	-- CHANGE MANUALLY TO WHENEVER WE WANT TO STOP
	
	En_CORE2BUS	<= '1' WHEN MemWrite_c = '1' AND ALU_Result_b(11) = '1' ELSE '0'; -- was MEMWRITE_B and ALU_RESULT_A (ex stage)
	

	CORE2BUS: 	BidirPin generic map(width => 32) port map(Dout => read_data_2_d, en => En_CORE2BUS, Din => Din, IOpin => DataBUS);
	
	PC				<= PC_tb;		
	ID_Instruction 	<= Instruction_b;
	ID_read_data_1 	<= read_data_1_a;
	ID_read_data_2 	<= read_data_2_a;
	ID_write_data 	<= write_data;
	ID_Regwrite 	<= RegWrite_d;
	rs_ID			<= register_rs_a;
	rt_ID			<= register_rt_a;
	rd_ID			<= register_rd_a;

	EX_Instruction  <= Instruction_c;
	EX_ALU_result	<= ALU_Result_a;
	EX_ALU_Ainput	<= Ainput_o;
	EX_ALU_Binput	<= Binput_o;
	rs_EX			<= rs_EX_s;
	rt_EX			<= rt_EX_s;
	rd_EX			<= register_rd_b;
	chosen_rt_rd_EX	<= write_register_address_a;

	MEM_ALU_result  <= ALU_Result_b;
	MEM_Instruction <= Instruction_d;
	MEM_MemWrite    <= MemWrite_c;
	MEM_read_data   <= read_data_a;
	MEM_write_data  <= read_data_2_d;
	MEM_Address     <= ALU_Result_b(9 DOWNTO 0);
	rd_MEM			<= write_register_address_b;

	WB_Instruction  <= Instruction_e;
	WB_MemtoReg     <= MemtoReg_d;	
	rd_WB			<= write_register_address_c;
	

	rst 			<= Reset;
	ena				<= Enable;	
	IF_ID_Write 	<= IF_ID_Write_s;
	ID_write_reg_addr <= write_register_address_c;
	ALU_A_MUX		<= ALU_A_MUX_s;
	ALU_B_MUX 		<= ALU_B_MUX_s;
	WD_MUX          <= WD_MUX_s;
	Jump			<= Jump_s;
	MemRead			<= MemRead_c;	-- from mem stage ( was b from ex)
	MemWrite		<= MemWrite_c;  -- from mem stage ( was b from ex)
	GIE             <= GIE_s;
	INTA            <= INTA_s;
	INTR_s          <= INTR;
	clk             <= clock;
	Key_reset       <= Key_reset_s;
	
   -- write back mux
   WITH MemtoReg_d SELECT
		write_data <= (31 downto 10 => '0')&PC_plus_4_f WHEN "10",
									  read_data_b WHEN "01",
									  ALU_Result_d WHEN OTHERS;
   
   -- nop mux
   RegDst_amux <= RegDst_a WHEN (stall_mux = '0') ELSE "00";
   MemtoReg_amux <= MemtoReg_a WHEN (stall_mux = '0') ELSE "00";
   RegWrite_amux <= RegWrite_a WHEN (stall_mux = '0') ELSE '0';
   MemRead_amux <= MemRead_a WHEN (stall_mux = '0') ELSE '0';
   MemWrite_amux <= MemWrite_a WHEN (stall_mux = '0') ELSE '0';
   ALUop_amux <= ALUop_a WHEN (stall_mux = '0') ELSE "000000";
      
	-- connect the 5 MIPS components   
  IFE : Ifetch
    GENERIC MAP ( modelsim )
	PORT MAP (	Instruction 	=> Instruction_a,
    	    	PC_plus_4_out 	=> PC_plus_4_a,
				PC_tb			=> PC_tb,
				Add_result 		=> Add_result,
				jump_address	=> jump_address,
				jump_register   => jump_register,
				ISR_address     => read_data_a(9 DOWNTO 2),
				Jump 			=> Jump_s,
				ISR_en        	=> TYPE_ctl_sig,
				clock 			=> clk,  
				reset 			=> rst,
				ena				=> ena,
				PCWrite			=> PCWrite);

  ID : Idecode
	PORT MAP (	
				read_data_1 			=> read_data_1_a,
    	    	read_data_2 			=> read_data_2_a,
				Opcode					=> opcode,
				register_rs 			=> register_rs_a,
				register_rt 			=> register_rt_a,
				register_rd				=> register_rd_a,
				Imm_sign_ext 			=> Imm_sign_ext_a,        		
				jump_address 			=> jump_address,
				jump_register			=> jump_register,			
				Add_result 				=> Add_result,
				PC_plus_4_out			=> PC_plus_4_c,
				PCsrc					=> PCsrc,
				K0_0                    => K0_0_s,
				Instruction				=> Instruction_b,
				PC_plus_4				=> PC_plus_4_b,
				write_register_address	=> write_register_address_c,
				write_data				=> write_data,
				RegWrite				=> RegWrite_d,
				clock					=> clk,
				reset					=> rst);

  CTL : Control
	PORT MAP (	RegDst 			=> RegDst_a,
    	    	MemtoReg 		=> MemtoReg_a,
				RegWrite		=> RegWrite_a,
				MemRead 		=> MemRead_a,
				MemWrite 		=> MemWrite_a,
				jr              => jr,
				br				=> br,
				Jump			=> Jump_s,
				ALUop 			=> ALUop_a,
				GIE             => GIE_s,
				INT_Flush		=> INT_Flush_s,
				EPC_EN          => EPC_EN_s,
				Key_reset       => Key_reset_s,
				INTA            => INTA_s,
				K0_0            => K0_0_s,
				INTR            => INTR_s,
				rs_ID			=> register_rs_a,	
				Opcode 			=> opcode,
				TYPE_addr		=> Din(7 DOWNTO 0),
				PCsrc 			=> PCsrc,
				Function_opcode => Imm_sign_ext_a( 5 DOWNTO 0 ),
				TYPE_ctl 		=> TYPE_ctl_sig,
				clock			=> clk,
				reset			=> rst);



  EXE : Execute
	PORT MAP (	ALU_Result 				=> ALU_Result_a,
    	    	write_register_address 	=> write_register_address_a,
				register_rt_out			=> rt_EX_s,
				register_rs_out 		=> rs_EX_s,
				read_data_2_out 		=> read_data_2_c,
				Ainput 					=> Ainput_o,
				Binput                  => Binput_o,
				read_data_1				=> read_data_1_b,
				read_data_2 			=> read_data_2_b,        		
				Imm_sign_ext 			=> Imm_sign_ext_b,  
				register_rs 			=> register_rs_b,
				register_rt				=> register_rt_b,
				register_rd				=> register_rd_b,
				ALUop					=> ALUop_b,
				data_MEM				=> ALU_Result_c,
				data_WB					=> write_data,
				RegDst					=> RegDst_b,
				ALU_A_MUX				=> ALU_A_MUX_s,
				ALU_B_MUX				=> ALU_B_MUX_s,
				WD_MUX        			=> WD_MUX_s,
				clock					=> clk,
				reset					=> rst);	
				
				
	
  MEM : dmemory
  	GENERIC MAP ( modelsim )
	PORT MAP (	
				DataBUS			=> DataBUS,
				read_data 		=> read_data_a,
				ALU_Result_OUT	=> ALU_Result_c,
				ALU_Result		=> ALU_Result_b,
				TYPE_addr		=> Din(7 DOWNTO 0),
				TYPE_ctl		=> TYPE_ctl_sig,
				write_data		=> read_data_2_d,
				MemRead			=> MemRead_c,
				MemWrite		=> MemWrite_c,
				clock			=> clk,
				reset			=> rst);

  HD : HazardDetection
	PORT MAP (	rd_WB			=> write_register_address_c,
				rt_EX 			=> rt_EX_s,
				rt_ID			=> register_rt_a,
				rs_ID			=> register_rs_a,
				r_dst_EX    	=> write_register_address_a,
				r_dst_MEM   	=> write_register_address_b,
				MemRead_EX		=> MemRead_b,
				jr          	=> jr,
				br  			=> br,
				PCWrite			=> PCWrite,
				IF_ID_Write		=> IF_ID_Write_s,
				stall_mux		=> stall_mux);
	
	
	
	
  FW : Forwarding
	PORT MAP (	rd_WB 			=> write_register_address_c,
				rd_MEM			=> write_register_address_b,
				rt_EX			=> rt_EX_s,
				rs_EX			=> rs_EX_s,
				Regwrite_MEM	=> RegWrite_c,
				Regwrite_WB		=> RegWrite_d,
				Opcode			=> ALUop_b,
				Function_opcode => Imm_sign_ext_b( 5 DOWNTO 0 ),
				ALU_A_MUX		=> ALU_A_MUX_s,
				ALU_B_MUX		=> ALU_B_MUX_s,
				WD_MUX         	=> WD_MUX_s);
	
	
	
	
	
	----------------------------------------------------
	--FOR DEBUGGING ONLY --
	--	print : process (clk) 
    --    begin
	--	 if rising_edge(clk) then
	--	 report "aluop_b = " & to_string(ALUop_b);
	--	 report "aluop_muxa = " & to_string(ALUop_amux);
	--	 report "aluop_a = " & to_string(ALUop_a);
	--	 report "opcode = " & to_string(opcode);
	--	 report "stallmux = " & to_string(stall_mux);
	--	 end if;
	--	end process;		
	----------------------------------------------------

	
	IF_ID_REG: PROCESS (clock) 
	BEGIN
		IF (rising_edge(clock)) THEN
									
			IF (rst = '1' OR INT_Flush_s = '1' OR ( NOT (Jump_s = "00") AND NOT (stall_mux = '1') )) THEN	-- success beq or bne, j, jal and JR, but without data dependence stall
				Instruction_b 	<= (OTHERS => '0');
				PC_plus_4_b 	<= (OTHERS => '0'); 
			ELSIF (IF_ID_Write_s = '1' AND ena = '1') THEN --  AND Jump = "00"
				Instruction_b 	<= Instruction_a;
				PC_plus_4_b 	<= PC_plus_4_a;
																					-- else if stall occurs - Instruction_b is unaffacted
			END IF;
		END IF;
	END PROCESS;
	
	ID_EX_REG: PROCESS (clock) 
	BEGIN
		IF (rising_edge(clock)) THEN
			IF (rst = '1' OR stall_mux = '1') THEN
				read_data_1_b  	<= (OTHERS => '0');
				read_data_2_b  	<= (OTHERS => '0');
				Imm_sign_ext_b 	<= (OTHERS => '0');
				register_rs_b  	<= (OTHERS => '0'); 
				register_rt_b  	<= (OTHERS => '0');
				register_rd_b  	<= (OTHERS => '0');
				PC_plus_4_d    	<= (OTHERS => '0'); 
				RegDst_b 		<= (OTHERS => '0');
				MemtoReg_b 		<= (OTHERS => '0');
				RegWrite_b 		<= '0'; 
				MemRead_b 		<= '0';
				MemWrite_b 		<= '0';
				ALUop_b 		<= (OTHERS => '0');
				Instruction_c   <= (OTHERS => '0');
				Jump_EX_s       <= (OTHERS => '0'); 
			ELSIF (ena = '1') THEN
				read_data_1_b 	<= read_data_1_a;
				read_data_2_b 	<= read_data_2_a;
				Imm_sign_ext_b 	<= Imm_sign_ext_a;
				register_rs_b  	<= register_rs_a; 
				register_rt_b 	<= register_rt_a;
				register_rd_b 	<= register_rd_a;
				PC_plus_4_d     <= PC_plus_4_c;
				RegDst_b 		<= RegDst_amux;
				MemtoReg_b 		<= MemtoReg_amux;
				RegWrite_b 		<= RegWrite_amux; 
				MemRead_b 		<= MemRead_amux;
				MemWrite_b 		<= MemWrite_amux;
				ALUop_b 		<= ALUop_amux;
				Instruction_c   <= Instruction_b;
				Jump_EX_s       <= Jump_s;
			END IF;
		END IF;
	END PROCESS;
	
	EPC_REG: PROCESS (clock) 
	BEGIN
		IF (rising_edge(clock)) THEN				
			IF (rst = '1') THEN	
				epc 			<= (OTHERS => '0');
			ELSIF (PC_plus_4_d /= 0 AND Jump_EX_s = "00" AND EPC_EN_s = '1' AND ena = '1') THEN -- Updates only if no jmp and no flush and GIE = 1
				epc 			<= PC_plus_4_d;												
			END IF;
		END IF;
	END PROCESS;
	
	EX_MEM_REG: PROCESS (clock) 
	BEGIN
		IF (rising_edge(clock)) THEN
			IF (rst = '1') THEN
				PC_plus_4_e  				<= (OTHERS => '0');
				ALU_Result_b				<= (OTHERS => '0');
				read_data_2_d				<= (OTHERS => '0');
				write_register_address_b	<= (OTHERS => '0');
				MemtoReg_c 					<= (OTHERS => '0');
				RegWrite_c 					<= '0'; 
				MemRead_c 					<= '0';
				MemWrite_c					<= '0';
				Instruction_d   			<= (OTHERS => '0');
			ELSIF (ena = '1') THEN
				IF RegDst_b =  "11" THEN
					PC_plus_4_e 			<= epc;
				ELSE
					PC_plus_4_e				<= PC_plus_4_d;
				END IF;	
				ALU_Result_b				<= ALU_Result_a;
				read_data_2_d				<= read_data_2_c;
				write_register_address_b	<= write_register_address_a;
				MemtoReg_c 					<= MemtoReg_b;
				RegWrite_c 					<= RegWrite_b; 
				MemRead_c 					<= MemRead_b;
				MemWrite_c					<= MemWrite_b;
				Instruction_d   			<= Instruction_c;
			END IF;
		END IF;
	END PROCESS;
	
	MEM_WB_REG: PROCESS (clock) 
	BEGIN
		IF (rising_edge(clock)) THEN
			IF (rst = '1') THEN
				PC_plus_4_f  				<= (OTHERS => '0');
				read_data_b					<= (OTHERS => '0');
				ALU_Result_d				<= (OTHERS => '0');
				write_register_address_c	<= (OTHERS => '0');
				MemtoReg_d 					<= (OTHERS => '0');
				RegWrite_d 					<= '0'; 
				Instruction_e   			<= (OTHERS => '0');
			ELSIF (ena = '1') THEN
				PC_plus_4_f					<= PC_plus_4_e;
				read_data_b					<= read_data_a;
				ALU_Result_d				<= ALU_Result_c;
				write_register_address_c	<= write_register_address_b;
				MemtoReg_d 					<= MemtoReg_c;
				RegWrite_d 					<= RegWrite_c;
				Instruction_e   			<= Instruction_d;		
			END IF;
		END IF;
	END PROCESS;
	
	CLKCNT_out <= CLKCNT;
	
	CLOCK_COUNTER: PROCESS (clock, rst) 
	BEGIN
		IF (rising_edge(clock)) THEN
			IF (rst = '1') THEN
				CLKCNT <= (OTHERS => '0');
			ELSE
			CLKCNT <= CLKCNT + 1;
			END IF;
		END IF;
	END PROCESS;
	
	STCNT_out <= STCNT;
	
	STALL_COUNTER: PROCESS (clock, rst) 
	BEGIN
		IF (rising_edge(clock)) THEN
			IF (rst = '1') THEN
				STCNT <= (OTHERS => '0');
			ELSIF ( stall_mux = '1' ) THEN
				STCNT <= STCNT + 1;
			END IF;
		END IF;
	END PROCESS;
	
	FHCNT_out <= FHCNT;
	
	FLUSH_COUNTER: PROCESS (clock, rst) 
	BEGIN
		IF (rising_edge(clock)) THEN
			IF (rst = '1') THEN
				FHCNT <= (OTHERS => '0');
			ELSIF ( NOT (Jump_s = "00") AND NOT (stall_mux = '1') ) THEN
				FHCNT <= FHCNT + 1;
			END IF;
		END IF;
	END PROCESS;
	
	BPADD_out <= BPADD;
	BPADD(1 DOWNTO 0) <= "00";
	
	BPADD_REG: PROCESS (clock, rst) 
	BEGIN
		IF (rising_edge(clock)) THEN
			IF (rst = '1') THEN
				BPADD(9 DOWNTO 2)  <= (OTHERS => '1');
			ELSIF SW(8) = '1' THEN
				BPADD(9 DOWNTO 2) <= SW(7 DOWNTO 0);
			END IF;
		END IF;
	END PROCESS;
  
	ST_trigger <= '1' WHEN (PC_tb = BPADD) ELSE '0';
				
END structure;

