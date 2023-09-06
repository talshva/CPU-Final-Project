-- Tal Shvartzberg - 316581537
-- Oren Schor - 316365352

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;
USE IEEE.STD_LOGIC_SIGNED.ALL;
USE work.aux_package.all;

ENTITY  InterruptController IS
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
			
END InterruptController;

ARCHITECTURE behavior OF InterruptController IS

	SIGNAL irq, clr_irq									: STD_LOGIC_VECTOR( 6 DOWNTO 0 );
	SIGNAL reset_in, reset_out, clr_rst					: STD_LOGIC;
	SIGNAL IE_out										: STD_LOGIC_VECTOR( 6 DOWNTO 0 );
	SIGNAL TYPE_in, TYPE_out							: STD_LOGIC_VECTOR( 7 DOWNTO 0 );
	SIGNAL IFG_in, IFG_out								: STD_LOGIC_VECTOR( 6 DOWNTO 0 );
	SIGNAL CS											: STD_LOGIC_VECTOR( 2 DOWNTO 0 );
	SIGNAL rst											: STD_LOGIC;
	SIGNAL Dout, Din									: STD_LOGIC_VECTOR( 31 DOWNTO 0 );
	SIGNAL en											: STD_LOGIC;

BEGIN

	IC2BUS :BidirPin generic map(width => 32) port map(Dout => Dout, en => en, Din => Din, IOpin => DataBUS);
	
	------------------------------------------------------------------------------------------------------------------------------------------------------
	INTR <= ((IFG_out(0) OR IFG_out(1) OR IFG_out(2) OR IFG_out(3) OR IFG_out(4) OR IFG_out(5) OR IFG_out(6)) AND GIE) OR reset_out;
	
	rst <= Reset; -- local register reset in the start of the system or when key0 is pressed
	
	WITH address SELECT
	CS <= "001" WHEN "111100", -- IE Address
		  "010" WHEN "111101", -- IFG Address
		  "100" WHEN "111110", -- TYPE Address
		  "000" WHEN OTHERS;
		  
	en <= '1' WHEN (INTA = '0' OR (CS(2) = '1' AND MemRead = '1')) OR (CS(1) = '1' AND MemRead = '1') OR (CS(0) = '1' AND MemRead = '1') ELSE '0';
	
	Dout <= X"000000" & TYPE_out WHEN (INTA = '0' OR (CS(2) = '1' AND MemRead = '1')) ELSE -- IntA received or read from TYPE
			X"000000" & "0" & IFG_out WHEN (CS(1) = '1' AND MemRead = '1') ELSE -- read from IFG
			X"000000" & "0" & IE_out WHEN (CS(0) = '1' AND MemRead = '1') ELSE -- read from IE
			(OTHERS => '0');
	
	TYPE_in(7 DOWNTO 5) <= "000";
	TYPE_in(4 DOWNTO 2) <= "000" WHEN reset_out  = '1' ELSE -- KEY0
						   "001" WHEN IFG_out(6) = '1' ELSE -- RX status error
						   "010" WHEN IFG_out(0) = '1' ELSE -- RX
						   "011" WHEN IFG_out(1) = '1' ELSE -- TX
						   "100" WHEN IFG_out(2) = '1' ELSE -- BT 
						   "101" WHEN IFG_out(3) = '1' ELSE -- KEY1
						   "110" WHEN IFG_out(4) = '1' ELSE -- KEY2
						   "111" WHEN IFG_out(5) = '1' ELSE -- KEY3
						   "000";
	TYPE_in(1 DOWNTO 0) <= "00";
	
	clr_rst	   <= '1' WHEN (TYPE_out(4 DOWNTO 2) = "000" AND INTA = '0') ELSE '0';
	clr_irq(6) <= '1' WHEN (TYPE_out(4 DOWNTO 2) = "001" AND INTA = '0') ELSE '0';
	clr_irq(0) <= '1' WHEN (TYPE_out(4 DOWNTO 2) = "010" AND INTA = '0') ELSE '0';
	clr_irq(1) <= '1' WHEN (TYPE_out(4 DOWNTO 2) = "011" AND INTA = '0') ELSE '0';
	clr_irq(2) <= '1' WHEN (TYPE_out(4 DOWNTO 2) = "100" AND INTA = '0') ELSE '0';
	clr_irq(3) <= '1' WHEN (TYPE_out(4 DOWNTO 2) = "101" AND INTA = '0') ELSE '0';
	clr_irq(4) <= '1' WHEN (TYPE_out(4 DOWNTO 2) = "110" AND INTA = '0') ELSE '0';
	clr_irq(5) <= '1' WHEN (TYPE_out(4 DOWNTO 2) = "111" AND INTA = '0') ELSE '0';
	
	IFG_in <= irq AND IE_out;
	------------------------------------------------------------------------------------------------------------------------------------------------------
	
	PROCESS(rst, rst_btn, clr_rst) -- KEY0
		BEGIN
			IF rst = '1' OR clr_rst = '1' THEN
				reset_in <= '0';
			ELSIF (( rst_btn'EVENT ) AND ( rst_btn = '1')) THEN
				reset_in <= '1';
			END IF;
	END PROCESS;
	
	PROCESS(rst, IR(6), clr_irq(6)) -- RX Status Register
	BEGIN
		IF rst = '1' THEN
			irq(6) <= '0';
		ELSIF clr_irq(6) = '1' THEN
			   irq(6) <= '0';
		ELSIF (( IR(6)'EVENT ) AND ( IR(6) = '1')) THEN
			   irq(6) <= '1';
		END IF;
	END PROCESS;
	
	
	PROCESS(rst, IR(0), clr_irq(0)) -- RX
		BEGIN
			IF rst = '1' THEN
				irq(0) <= '0';
			ELSIF clr_irq(0) = '1' THEN
				   irq(0) <= '0';
			ELSIF (( IR(0)'EVENT ) AND ( IR(0) = '1')) THEN
				   irq(0) <= '1';
			END IF;
	END PROCESS;
	
	PROCESS(rst, IR(1), clr_irq(1)) -- TX
		BEGIN
			IF rst = '1' THEN
				irq(1) <= '0';
			ELSIF clr_irq(1) = '1' THEN
				   irq(1) <= '0';
			ELSIF (( IR(1)'EVENT ) AND ( IR(1) = '1')) THEN
				   irq(1) <= '1';
			END IF;
	END PROCESS;
	
	PROCESS(rst, IR(2), clr_irq(2)) -- BT
		BEGIN
			IF rst = '1' THEN
				irq(2) <= '0';
			ELSIF clr_irq(2) = '1' THEN
				   irq(2) <= '0';
			ELSIF (( IR(2)'EVENT ) AND ( IR(2) = '1')) THEN
				   irq(2) <= '1';
			END IF;
	END PROCESS;
	
	PROCESS(rst, IR(3), clr_irq(3)) -- KEY1
		BEGIN
			IF rst = '1' THEN
				irq(3) <= '0';
			ELSIF clr_irq(3) = '1' THEN
				   irq(3) <= '0';
			ELSIF (( IR(3)'EVENT ) AND ( IR(3) = '1')) THEN
				   irq(3) <= '1';
			END IF;
	END PROCESS;
	
	PROCESS(rst, IR(4), clr_irq(4)) -- KEY2
		BEGIN
			IF rst = '1' THEN
				irq(4) <= '0';
			ELSIF clr_irq(4) = '1' THEN
				   irq(4) <= '0';
			ELSIF (( IR(4)'EVENT ) AND ( IR(4) = '1')) THEN
				   irq(4) <= '1';
			END IF;
	END PROCESS;
	
	PROCESS(rst, IR(5), clr_irq(5)) -- KEY3
		BEGIN
			IF rst = '1' THEN
				irq(5) <= '0';
			ELSIF clr_irq(5) = '1' THEN
				   irq(5) <= '0';
			ELSIF (( IR(5)'EVENT ) AND ( IR(5) = '1')) THEN
				   irq(5) <= '1';
			END IF;
	END PROCESS;
-----------------
	
	IE_REG: PROCESS (rst, clock) 
	BEGIN
		IF rst = '1' THEN
			IE_out <= "1111111";
		ELSIF (( clock'EVENT ) AND ( clock = '1')) THEN
			IF (CS(0) = '1' AND MemWrite = '1') THEN
				IE_out <= Din(6 DOWNTO 0);
			END IF;
		END IF;
	END PROCESS;
	
	IFG_REG: PROCESS (clock) 
	BEGIN
		IF (( clock'EVENT ) AND ( clock = '1')) THEN
			reset_out <= reset_in;
			IF rst = '1' THEN
				IFG_out <= "0000000";
			ELSIF (CS(1) = '1' AND MemWrite = '1') THEN 
				IFG_out <= Din(6 DOWNTO 0);
			ELSE 
				IFG_out <= IFG_in;
			END IF;
		END IF;
	END PROCESS;
	
	TYPE_REG: PROCESS (rst, clock) 
	BEGIN
		IF rst = '1' THEN
			TYPE_out <= X"00";
		ELSIF (( clock'EVENT ) AND ( clock = '1')) THEN
				TYPE_out <= TYPE_in;
		END IF;
	END PROCESS;
	
	
END behavior;

