-- Tal Shvartzberg - 316581537
-- Oren Schor - 316365352

-- Ifetch module (provides the PC and instruction memory for the MIPS computer)

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;
LIBRARY altera_mf;
USE altera_mf.altera_mf_components.all;

ENTITY Ifetch IS
	GENERIC ( modelsim : INTEGER := 0 );
	PORT(	Instruction 				: OUT	STD_LOGIC_VECTOR( 31 DOWNTO 0 );
        	PC_plus_4_out 				: OUT	STD_LOGIC_VECTOR( 9 DOWNTO 0 );
			PC_tb 						: OUT	STD_LOGIC_VECTOR( 9 DOWNTO 0 );
        	Add_result 					: IN 	STD_LOGIC_VECTOR( 7 DOWNTO 0 );
			jump_address    			: IN 	STD_LOGIC_VECTOR( 7 DOWNTO 0 );
			jump_register				: IN 	STD_LOGIC_VECTOR( 7 DOWNTO 0 );
			ISR_address					: IN 	STD_LOGIC_VECTOR( 7 DOWNTO 0 );
			Jump                        : IN 	STD_LOGIC_VECTOR( 1 DOWNTO 0 );
			ISR_en                      : IN    STD_LOGIC;
        	clock, reset, PCWrite, ena 	: IN 	STD_LOGIC);
			
END Ifetch;

ARCHITECTURE behavior OF Ifetch IS
	SIGNAL PC, PC_plus_4		 	 : STD_LOGIC_VECTOR( 9 DOWNTO 0 );
	SIGNAL next_PC					 : STD_LOGIC_VECTOR( 7 DOWNTO 0 );
	SIGNAL read_clock : STD_LOGIC;
BEGIN

--ROM for Instruction Memory

	Simulation : IF modelsim = 1 GENERATE
	inst_memory : altsyncram
	GENERIC MAP  (
		operation_mode => "ROM",
		width_a => 32,
		widthad_a => 8,
		--lpm_hint => "ENABLE_RUNTIME_MOD = YES,INSTANCE_NAME = Dmem",
		lpm_type => "altsyncram",
		outdata_reg_a => "UNREGISTERED",
		init_file => "C:\Users\Tal Shvartzberg\Desktop\Hardware projects\ModelSim\projects\FinalProject\DUT\Program.hex",
		intended_device_family => "Cyclone" 
	)
	PORT MAP (
		clock0 => read_clock,
		address_a => PC( 9 DOWNTO 2 ),
		q_a => Instruction	);
	END GENERATE;
		
		
	
	Quartus : IF modelsim = 0 GENERATE
		inst_memory : altsyncram
		GENERIC MAP  (
			operation_mode => "ROM",
			width_a => 32,
			widthad_a => 10,
			numwords_a => 1024,
			lpm_hint => "ENABLE_RUNTIME_MOD = YES,INSTANCE_NAME = Pmem",
			lpm_type => "altsyncram",
			outdata_reg_a => "UNREGISTERED",
			init_file => "C:\Users\Tal Shvartzberg\Desktop\Hardware projects\ModelSim\projects\FinalProject\DUT\Program.hex",
			intended_device_family => "Cyclone" 
		)
		PORT MAP (
			clock0 => read_clock,
			address_a => PC,
			q_a => Instruction);
		END GENERATE;	
	
		read_clock <= NOT(clock); -- check
		
		-- Instructions always start on word address - not byte
		PC(1 DOWNTO 0) <= "00";
		
	    -- copy output signals - allows read inside module when using tb
		PC_tb <= PC;
		
		-- send PC + 4 value to ID stage
		PC_plus_4_out 	<= PC_plus_4;
		
		-- Adder to increment PC by 4        
      	PC_plus_4( 9 DOWNTO 2 )  <= PC( 9 DOWNTO 2 ) + 1;
       	PC_plus_4( 1 DOWNTO 0 )  <= "00";
		
		-- Mux to select Reset or Branch or jump/jal or jr       
		Next_PC <=  X"00" 	      WHEN 	 reset = '1' 				  					ELSE
					ISR_address   WHEN ( ISR_en = '1' AND reset = '0')				   	ELSE
					Add_result    WHEN ( Jump = "01"  AND reset = '0' AND ISR_en = '0') ELSE	-- successful beq OR Successful bne
					jump_address  WHEN ( Jump = "10"  AND reset = '0' AND ISR_en = '0')	ELSE	-- j, jal
					jump_register WHEN ( Jump = "11"  AND reset = '0' AND ISR_en = '0') ELSE	-- jr
					PC_plus_4( 9 DOWNTO 2 );
			
	PROCESS
		BEGIN
			WAIT UNTIL ( clock'EVENT ) AND ( clock = '1' );
			IF reset = '1' THEN
				   PC( 9 DOWNTO 2) <= "00000000" ; 
			ELSIF (PCWrite = '1' AND ena = '1') THEN
				   PC( 9 DOWNTO 2 ) <= next_PC;
			END IF;
	END PROCESS;
END behavior;


