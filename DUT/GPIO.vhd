-- Tal Shvartzberg - 316581537
-- Oren Schor 	   - 316365352

-- Top Level Structural Model for GPIO Module

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;
USE IEEE.STD_LOGIC_SIGNED.ALL;
USE work.aux_package.all;

ENTITY GPIO IS
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
END GPIO;

ARCHITECTURE behavior OF GPIO IS

			SIGNAL en						: STD_LOGIC;	-- SW input tristate enable
			SIGNAL EN_A, EN_B, EN_C			: STD_LOGIC;	-- LED/HEX output enable
			SIGNAL EN_D, EN_E, EN_F, EN_G	: STD_LOGIC;	-- LED/HEX output enable
			SIGNAL CS			 			: STD_LOGIC_VECTOR( 6 DOWNTO 0 );
			SIGNAL Dout, Din				: STD_LOGIC_VECTOR( 31 DOWNTO 0 );
			SIGNAL O_PortA_sig				: STD_LOGIC_VECTOR( 9 DOWNTO 0 );
			SIGNAL O_PortB_sig				: STD_LOGIC_VECTOR( 7 DOWNTO 0 );
			SIGNAL O_PortC_sig				: STD_LOGIC_VECTOR( 7 DOWNTO 0 );
			SIGNAL O_PortD_sig				: STD_LOGIC_VECTOR( 7 DOWNTO 0 );
			SIGNAL O_PortE_sig				: STD_LOGIC_VECTOR( 7 DOWNTO 0 );
			SIGNAL O_PortF_sig				: STD_LOGIC_VECTOR( 7 DOWNTO 0 );
			SIGNAL O_PortG_sig				: STD_LOGIC_VECTOR( 7 DOWNTO 0 );


BEGIN


--				       A5				A3, A2,A1,A0		
--		address  is address(11) & address(5 DOWNTO 2) 
	WITH address SELECT
	CS <= "0000001" WHEN "10000",	-- 0x800				- LEDR		- CS(0)
		  "0000010" WHEN "10001",	-- 0x804 or 0x805		- HEX0/1	- CS(1)	
		  "0000100" WHEN "10010",	-- 0x808 or 0x809		- HEX2/3	- CS(2)
		  "0001000" WHEN "10011",	-- 0x80C or 0x80D		- HEX4/5	- CS(3) 
		  "0010000" WHEN "10100",	-- 0x810				- SW		- CS(4) 
		  "0100000" WHEN "10101",	-- available slot						
		  "1000000" WHEN "10110",	-- available slot
		  "0000000" WHEN OTHERS;

	Dout(31 DOWNTO 10) <= (OTHERS => '0');
	Dout(9 DOWNTO 0)   <= InputPortA;		-- Only switches defined as Input to the bus.
	
	
	en <= '1' WHEN (MemRead = '1' AND CS(4) = '1') ELSE '0';	-- SW input tristate enable

	GPIO2BUS: BidirPin generic map(width => 32) port map(Dout => Dout, en => en, Din => Din, IOpin => DataBUS);

	EN_A <= '1' WHEN MemWrite = '1' AND CS(0) = '1' ELSE '0';				-- Enable LEDR 
	EN_B <= '1' WHEN MemWrite = '1' AND CS(1) = '1' AND A0 = '0' ELSE '0';	-- Enable HEX0 
	EN_C <= '1' WHEN MemWrite = '1' AND CS(1) = '1' AND A0 = '1' ELSE '0';	-- Enable HEX1 
	EN_D <= '1' WHEN MemWrite = '1' AND CS(2) = '1' AND A0 = '0' ELSE '0';	-- Enable HEX2 
	EN_E <= '1' WHEN MemWrite = '1' AND CS(2) = '1' AND A0 = '1' ELSE '0';	-- Enable HEX3 
	EN_F <= '1' WHEN MemWrite = '1' AND CS(3) = '1' AND A0 = '0' ELSE '0';	-- Enable HEX4 
	EN_G <= '1' WHEN MemWrite = '1' AND CS(3) = '1' AND A0 = '1' ELSE '0';	-- Enable HEX5 

	
	PROCESS(Reset, clock)
	BEGIN
		IF Reset = '1' THEN
			O_PortA_sig <= "0000000000";
			O_PortB_sig <= X"00";
			O_PortC_sig <= X"00";
			O_PortD_sig <= X"00";
			O_PortE_sig <= X"00";
			O_PortF_sig <= X"00";
			O_PortG_sig <= X"00";
		ELSIF ( clock'EVENT ) AND ( clock = '0' ) THEN 	-- why Falling edge?
			IF    (EN_A = '1') THEN
				O_PortA_sig <= Din(9 DOWNTO 0);
			ELSIF (EN_B = '1') THEN
				O_PortB_sig <= Din(7 DOWNTO 0);
			ELSIF (EN_C = '1') THEN
				O_PortC_sig <= Din(7 DOWNTO 0);
			ELSIF (EN_D = '1') THEN
				O_PortD_sig <= Din(7 DOWNTO 0);
			ELSIF (EN_E = '1') THEN
				O_PortE_sig <= Din(7 DOWNTO 0);
			ELSIF (EN_F = '1') THEN
				O_PortF_sig <= Din(7 DOWNTO 0);
			ELSIF (EN_G = '1') THEN
				O_PortG_sig <= Din(7 DOWNTO 0);
			END IF;
		END IF;
	END PROCESS;
	
	OutputPortA <= O_PortA_sig;
	OutputPortB <= O_PortB_sig;
	OutputPortC	<= O_PortC_sig;
	OutputPortD <= O_PortD_sig;
	OutputPortE <= O_PortE_sig;
	OutputPortF <= O_PortF_sig;
	OutputPortG <= O_PortG_sig;
	
END behavior;

