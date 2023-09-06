LIBRARY ieee;
USE ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
	--------------------------------------------
ENTITY Binary2Hex IS
  PORT (  Binary		: IN STD_LOGIC_VECTOR (3 DOWNTO 0);
		  Hex			: OUT STD_LOGIC_VECTOR(6 downto 0) );
END Binary2Hex;

ARCHITECTURE struct OF Binary2Hex IS 
BEGIN	
	------------7-Segment implementation-------------------
	Hex <=  "1000000" when Binary = "0000" else
			"1111001" when Binary = "0001" else
			"0100100" when Binary = "0010" else
			"0110000" when Binary = "0011" else
			"0011001" when Binary = "0100" else
			"0010010" when Binary = "0101" else
			"0000010" when Binary = "0110" else
			"1111000" when Binary = "0111" else
			"0000000" when Binary = "1000" else
			"0010000" when Binary = "1001" else
			"0001000" when Binary = "1010" else
			"0000011" when Binary = "1011" else
			"1000110" when Binary = "1100" else
			"0100001" when Binary = "1101" else
			"0000110" when Binary = "1110" else
			"0001110" when Binary = "1111" else
			"1111111";
			
END struct;