-- Tal Shvartzberg - 316581537
-- Oren Schor - 316365352


-- Hazard Detection module.


LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;
USE IEEE.STD_LOGIC_SIGNED.ALL;

ENTITY HazardDetection IS
   PORT( 	
   	rd_WB 			: IN 	STD_LOGIC_VECTOR( 4 DOWNTO 0 );
	rt_EX		 	: IN 	STD_LOGIC_VECTOR( 4 DOWNTO 0 );
	rt_ID 			: IN 	STD_LOGIC_VECTOR( 4 DOWNTO 0 );
	rs_ID           : IN 	STD_LOGIC_VECTOR( 4 DOWNTO 0 );
	r_dst_EX		: IN 	STD_LOGIC_VECTOR( 4 DOWNTO 0 );
	r_dst_MEM		: IN 	STD_LOGIC_VECTOR( 4 DOWNTO 0 );
	MemRead_EX 		: IN 	STD_LOGIC;
	jr              : IN    STD_LOGIC;
	br  			: IN    STD_LOGIC;
	PCWrite 		: OUT 	STD_LOGIC;
	IF_ID_Write 	: OUT 	STD_LOGIC;
	stall_mux 		: OUT 	STD_LOGIC );
	
END HazardDetection;

ARCHITECTURE stall OF HazardDetection IS

SIGNAL stl,lw_stall, jr_stall, branch_stall : STD_LOGIC;
BEGIN           
	lw_stall <= '1' WHEN ((rt_ID = rt_EX OR rs_ID = rt_EX) AND MemRead_EX = '1') ELSE '0'; -- read from register while previous instruction is lw.
	jr_stall <= '1' WHEN ((rs_ID = r_dst_EX OR rs_ID = r_dst_MEM) AND jr = '1')  ELSE '0'; -- jump to register content while previous instruction modifying it.
	branch_stall <= '1' WHEN (br = '1' AND (((rs_ID = r_dst_EX OR rs_ID = r_dst_MEM) AND rs_ID /= 0 ) OR (((rt_ID = r_dst_EX OR rt_ID = r_dst_MEM))  AND rt_ID /= 0 ))) ELSE '0'; -- OR (rt_ID = rd_WB OR rt_ID = rd_WB)

	-- Code to generate stall signals
	stl 			<=  '1'  WHEN lw_stall = '1' OR jr_stall = '1' OR branch_stall = '1' ELSE '0';
	IF_ID_Write 	<=  '0' WHEN stl = '1' ELSE '1';
	PCWrite 		<=  '0' WHEN stl = '1' ELSE '1';
	stall_mux 		<= stl;
	
   END stall;