-- Tal Shvartzberg - 316581537
-- Oren Schor - 316365352

--  Dmemory module (implements the data memory for the MIPS computer)

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;
USE IEEE.STD_LOGIC_SIGNED.ALL;

LIBRARY altera_mf;
USE altera_mf.altera_mf_components.all;

ENTITY dmemory IS
	GENERIC ( modelsim : INTEGER := 0 );
	PORT(	
			DataBUS					: IN 	STD_LOGIC_VECTOR( 31 DOWNTO 0 );
			read_data 				: OUT 	STD_LOGIC_VECTOR( 31 DOWNTO 0 );
			ALU_Result_OUT    		: OUT 	STD_LOGIC_VECTOR( 31 DOWNTO 0 );
        	ALU_Result	 			: IN 	STD_LOGIC_VECTOR( 31 DOWNTO 0 );
			TYPE_addr 				: IN 	STD_LOGIC_VECTOR( 7 DOWNTO 0 );
			TYPE_ctl 				: IN 	STD_LOGIC;	
        	write_data 				: IN 	STD_LOGIC_VECTOR( 31 DOWNTO 0 );
	   		MemRead, MemWrite 		: IN 	STD_LOGIC;
            clock,reset				: IN 	STD_LOGIC );
END dmemory;

ARCHITECTURE behavior OF dmemory IS
SIGNAL write_clock 					: STD_LOGIC;
SIGNAL CS		   					: STD_LOGIC;
SIGNAL address 						: STD_LOGIC_VECTOR(8 DOWNTO 0);
SIGNAL QuartusAddress				: STD_LOGIC_VECTOR(10 DOWNTO 0);
SIGNAL En_BUS2CORE 					: STD_LOGIC;
SIGNAL read_data_mem				: STD_LOGIC_VECTOR( 31 DOWNTO 0 );

BEGIN

-- GPIO DATABUS MUXS:

	En_BUS2CORE <= '1' WHEN MemRead = '1' AND ALU_Result(11) = '1' ELSE '0';
	read_data <=  DataBUS WHEN En_BUS2CORE = '1' ELSE read_data_mem;
	
	ALU_Result_OUT <= DataBUS WHEN En_BUS2CORE = '1' ELSE ALU_Result;



--												Normal						Interrupt
	address <= ALU_Result (10 DOWNTO 2) WHEN TYPE_ctl = '0' ELSE ("000" & TYPE_addr(7 DOWNTO 2));
	QuartusAddress <= address & "00";
	
		
--												not interrupt/GPIO
	CS <= '1' WHEN ALU_Result(31 DOWNTO 11) = "000000000000000000000" AND Memwrite = '1' ELSE '0';
--	CS <= Memwrite;	-- write to memory in addition to GPIO/interrupts...





	Simulation : IF modelsim = 1 GENERATE
		data_memory : altsyncram
		GENERIC MAP  (
			operation_mode => "SINGLE_PORT",
			width_a => 32,
			widthad_a => 9,
			--lpm_hint => "ENABLE_RUNTIME_MOD = YES,INSTANCE_NAME = Dmem",
			lpm_type => "altsyncram",
			outdata_reg_a => "UNREGISTERED",
			init_file => "C:\Users\Tal Shvartzberg\Desktop\Hardware projects\ModelSim\projects\FinalProject\DUT\Data.hex",
			intended_device_family => "Cyclone" 
		)
		PORT MAP (
			wren_a => CS,
			clock0 => write_clock,
			address_a => address,
			data_a => write_data,
			q_a => read_data_mem	);
	-- Load memory address register with write clock
			write_clock <= NOT clock;
	END GENERATE;
		
		
	
	Quartus : IF modelsim = 0 GENERATE
		data_memory : altsyncram
		GENERIC MAP  (
			operation_mode => "SINGLE_PORT",
			width_a => 32,
			widthad_a => 11,
			numwords_a => 2048,
			lpm_hint => "ENABLE_RUNTIME_MOD = YES,INSTANCE_NAME = Dmem",
			lpm_type => "altsyncram",
			outdata_reg_a => "UNREGISTERED",
			init_file => "C:\Users\Tal Shvartzberg\Desktop\Hardware projects\ModelSim\projects\FinalProject\DUT\Data.hex",
			intended_device_family => "Cyclone" 
		)
		PORT MAP (
			wren_a => CS,
			clock0 => write_clock,
			address_a => QuartusAddress,
			data_a => write_data,
			q_a => read_data_mem	);
	-- Load memory address register with write clock
			write_clock <= NOT clock;
	END GENERATE;		
END behavior;

