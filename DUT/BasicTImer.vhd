-- Tal Shvartzberg - 316581537
-- Oren Schor - 316365352

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;
USE IEEE.STD_LOGIC_SIGNED.ALL;
USE work.aux_package.all;

ENTITY  BasicTimer IS
	PORT(	clock		 	: IN 	STD_LOGIC;
			Reset		 	: IN 	STD_LOGIC;
			address		 	: IN 	STD_LOGIC_VECTOR( 4 DOWNTO 0 );
			DataBus		 	: INOUT STD_LOGIC_VECTOR( 31 DOWNTO 0 );
			MemRead 		: IN 	STD_LOGIC;
			MemWrite 		: IN 	STD_LOGIC;
			Out_Signal 		: OUT 	STD_LOGIC;
			Set_BTIFG 		: OUT 	STD_LOGIC );
END BasicTimer;

ARCHITECTURE behavior OF BasicTimer IS

	SIGNAL CS			 								: STD_LOGIC_VECTOR( 3 DOWNTO 0 );
	SIGNAL Dout	, Din									: STD_LOGIC_VECTOR( 31 DOWNTO 0 );
	SIGNAL en											: STD_LOGIC;
	SIGNAL Out_s										: STD_LOGIC;
	SIGNAL BTCNT										: STD_LOGIC_VECTOR( 31 DOWNTO 0 );
	SIGNAL BTCCR0										: STD_LOGIC_VECTOR( 31 DOWNTO 0 );
	SIGNAL BTCCR1										: STD_LOGIC_VECTOR( 31 DOWNTO 0 );
	SIGNAL BTCNT_o										: STD_LOGIC_VECTOR( 31 DOWNTO 0 );
	SIGNAL BTCTL										: STD_LOGIC_VECTOR( 7 DOWNTO 0 );
	SIGNAL clock2, clock4, clock8, ChosenClock			: STD_LOGIC;

BEGIN
	
BT2BUS : BidirPin generic map(width => 32) port map(Dout => Dout, en => en, Din => Din, IOpin => DataBUS);
	 -- address(11) & address(5 DOWNTO 2);
	WITH address SELECT
	CS <= "0001" WHEN "10111", -- BTCTL
		  "0010" WHEN "11000", -- BTCNT
		  "0100" WHEN "11001", -- BTCCR0
		  "1000" WHEN "11010", -- BTCCR1
		  "0000" WHEN OTHERS;

	Dout <= X"000000" & BTCTL WHEN (MemRead = '1' AND CS(0) = '1') ELSE
			BTCNT  WHEN (MemRead = '1' AND CS(1) = '1') ELSE
			BTCCR0 WHEN (MemRead = '1' AND CS(2) = '1') ELSE
			BTCCR1 WHEN (MemRead = '1' AND CS(3) = '1') ELSE
			(OTHERS => '0');
	
	en <= '1' WHEN (MemRead = '1' AND CS(0) = '1') OR (MemRead = '1' AND CS(1) = '1') ELSE '0';

	Out_Signal <= Out_s;
	
	ChosenClock <=  clock  WHEN BTCTL(4 DOWNTO 3) = "00"  OR BTCTL(5) = '1' ELSE
					clock2 WHEN BTCTL(4 DOWNTO 3) = "01" ELSE
					clock4 WHEN BTCTL(4 DOWNTO 3) = "10" ELSE
					clock8 WHEN BTCTL(4 DOWNTO 3) = "11" ELSE
					clock;		   			   
	
	WITH BTCTL(2 DOWNTO 0) SELECT
	Set_BTIFG <= BTCNT(0)  WHEN "000",
				 BTCNT(3)  WHEN "001",
				 BTCNT(7)  WHEN "010",
				 BTCNT(11) WHEN "011",
				 BTCNT(15) WHEN "100",
				 BTCNT(19) WHEN "101",
				 BTCNT(23) WHEN "110",
				 BTCNT(25) WHEN "111",
				 '0'       WHEN OTHERS;
	
	
	BTCTL_REG: PROCESS (Reset, clock)
	BEGIN
		IF ( clock'EVENT ) AND ( clock = '1' ) THEN
			IF Reset = '1' THEN
				BTCTL <= "00100000";
			ELSIF (MemWrite = '1' AND CS(0) = '1') THEN
				BTCTL <= Din(7 DOWNTO 0);
			END IF;
		END IF;
	END PROCESS;

		
	BTCNT_REG: PROCESS (Reset, ChosenClock)
	BEGIN
		IF rising_edge(ChosenClock) THEN
			IF Reset = '1' THEN
				BTCNT <= X"00000000";
			END IF;
			IF BTCTL(5) = '0'  THEN
				BTCNT <= BTCNT + 1;
			ELSIF BTCTL(5) = '1' AND (MemWrite = '1' AND CS(1) = '1') THEN
				BTCNT <= Din;
			END IF;
		END IF;
	END PROCESS;
	
BTCNT_o_REG: PROCESS (Reset, ChosenClock)
	BEGIN
		IF rising_edge(ChosenClock) THEN
			IF Reset = '1' THEN
				BTCNT_o <= X"00000000";
			END IF;
			IF BTCTL(5) = '0'  THEN
				IF BTCTL(6) = '1' AND NOT (BTCNT_o = BTCCR0) THEN
					BTCNT_o <= BTCNT_o + 1;
				ELSIF BTCTL(6) = '1' AND BTCNT_o = BTCCR0 THEN
					BTCNT_o <= X"00000000";
				END IF;
			END IF;
		END IF;
	END PROCESS;
	
	OUTPUT_UNIT: PROCESS (Reset, clock)
	BEGIN
		IF rising_edge(clock) THEN
			IF Reset = '1' THEN
				BTCCR0 <= X"00000000";
				BTCCR1 <= X"00000000";
				Out_s  <= '0';
			ELSIF MemWrite = '1' AND CS(2) = '1' THEN
				BTCCR0 <= Din;
			ELSIF MemWrite = '1' AND CS(3) = '1' THEN
				BTCCR1 <= Din;
			END IF;
			
			IF BTCCR0 = BTCNT_o AND BTCTL(6) = '1' THEN
				Out_s <= '1';
			ELSIF BTCCR1 = BTCNT_o OR BTCTL(6) = '0' THEN
				Out_s <= '0';
			END IF;
		END IF;

	END PROCESS;
	
	ClockDivider1: PROCESS (Reset, clock)
	BEGIN
		IF Reset = '1' THEN
			clock2 <= '0';
		ELSIF ( clock'EVENT ) AND ( clock = '1' ) THEN
			clock2 <= NOT clock2;
		END IF;
	END PROCESS;
	
	ClockDivider2: PROCESS (Reset, clock2, clock)
	BEGIN
		IF Reset = '1' THEN
			clock4 <= '0';
		ELSIF ( clock2'EVENT ) AND ( clock2 = '1' ) THEN
			clock4 <= NOT clock4;
		END IF;
	END PROCESS;
	
	ClockDivider3: PROCESS (Reset, clock4, clock)
	BEGIN
		IF Reset = '1' THEN
			clock8 <= '0';
		ELSIF ( clock4'EVENT ) AND ( clock4 = '1' ) THEN
			clock8 <= NOT clock8;
		END IF;
	END PROCESS;
	
END behavior;

