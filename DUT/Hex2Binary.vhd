LIBRARY ieee;
USE ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
	--------------------------------------------
ENTITY Hex2Binary IS
  PORT (  Hex				: IN STD_LOGIC_VECTOR (6 DOWNTO 0);
		  Binary			: OUT STD_LOGIC_VECTOR(3 downto 0) );
END Hex2Binary;

ARCHITECTURE struct OF Hex2Binary IS 
BEGIN	
	------------7-Segment implementation-------------------
	Binary <=   "0000" when Hex = "1000000" else
				"0001" when Hex = "1111001" else
				"0010" when Hex = "0100100" else
				"0011" when Hex = "0110000" else
				"0100" when Hex = "0011001" else
				"0101" when Hex = "0010010" else
				"0110" when Hex = "0000010" else
				"0111" when Hex = "1111000" else
				"1000" when Hex = "0000000" else
				"1001" when Hex = "0010000" else
				"1010" when Hex = "0001000" else
				"1011" when Hex = "0000011" else
				"1100" when Hex = "1000110" else
				"1101" when Hex = "0100001" else
				"1110" when Hex = "0000110" else
				"1111" when Hex = "0001110";
			
END struct;