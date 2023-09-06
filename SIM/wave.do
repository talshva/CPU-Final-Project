onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -divider TestBench
add wave -noupdate -radix hexadecimal /tb/clock
add wave -noupdate -radix hexadecimal /tb/ena
add wave -noupdate -radix hexadecimal /tb/reset
add wave -noupdate /tb/L0/Ultimate_reset
add wave -noupdate /tb/L0/MIPS_Core/DataBUS
add wave -noupdate -group Inputs -radix hexadecimal -childformat {{/tb/Switches(9) -radix hexadecimal} {/tb/Switches(8) -radix hexadecimal} {/tb/Switches(7) -radix hexadecimal} {/tb/Switches(6) -radix hexadecimal} {/tb/Switches(5) -radix hexadecimal} {/tb/Switches(4) -radix hexadecimal} {/tb/Switches(3) -radix hexadecimal} {/tb/Switches(2) -radix hexadecimal} {/tb/Switches(1) -radix hexadecimal} {/tb/Switches(0) -radix hexadecimal}} -subitemconfig {/tb/Switches(9) {-height 15 -radix hexadecimal} /tb/Switches(8) {-height 15 -radix hexadecimal} /tb/Switches(7) {-height 15 -radix hexadecimal} /tb/Switches(6) {-height 15 -radix hexadecimal} /tb/Switches(5) {-height 15 -radix hexadecimal} /tb/Switches(4) {-height 15 -radix hexadecimal} /tb/Switches(3) {-height 15 -radix hexadecimal} /tb/Switches(2) {-height 15 -radix hexadecimal} /tb/Switches(1) {-height 15 -radix hexadecimal} /tb/Switches(0) {-height 15 -radix hexadecimal}} /tb/Switches
add wave -noupdate -group Inputs /tb/KEY0
add wave -noupdate -group Inputs /tb/KEY1
add wave -noupdate -group Inputs /tb/KEY2
add wave -noupdate -group Inputs /tb/KEY3
add wave -noupdate -group Outputs -radix unsigned /tb/LEDR
add wave -noupdate -group Outputs /tb/HEX0
add wave -noupdate -group Outputs /tb/HEX1
add wave -noupdate -group Outputs /tb/HEX2
add wave -noupdate -group Outputs /tb/HEX3
add wave -noupdate -group Outputs /tb/HEX4
add wave -noupdate -group Outputs /tb/HEX5
add wave -noupdate -radix hexadecimal -childformat {{/tb/Instruction_out(31) -radix hexadecimal} {/tb/Instruction_out(30) -radix hexadecimal} {/tb/Instruction_out(29) -radix hexadecimal} {/tb/Instruction_out(28) -radix hexadecimal} {/tb/Instruction_out(27) -radix hexadecimal} {/tb/Instruction_out(26) -radix hexadecimal} {/tb/Instruction_out(25) -radix hexadecimal} {/tb/Instruction_out(24) -radix hexadecimal} {/tb/Instruction_out(23) -radix hexadecimal} {/tb/Instruction_out(22) -radix hexadecimal} {/tb/Instruction_out(21) -radix hexadecimal} {/tb/Instruction_out(20) -radix hexadecimal} {/tb/Instruction_out(19) -radix hexadecimal} {/tb/Instruction_out(18) -radix hexadecimal} {/tb/Instruction_out(17) -radix hexadecimal} {/tb/Instruction_out(16) -radix hexadecimal} {/tb/Instruction_out(15) -radix hexadecimal} {/tb/Instruction_out(14) -radix hexadecimal} {/tb/Instruction_out(13) -radix hexadecimal} {/tb/Instruction_out(12) -radix hexadecimal} {/tb/Instruction_out(11) -radix hexadecimal} {/tb/Instruction_out(10) -radix hexadecimal} {/tb/Instruction_out(9) -radix hexadecimal} {/tb/Instruction_out(8) -radix hexadecimal} {/tb/Instruction_out(7) -radix hexadecimal} {/tb/Instruction_out(6) -radix hexadecimal} {/tb/Instruction_out(5) -radix hexadecimal} {/tb/Instruction_out(4) -radix hexadecimal} {/tb/Instruction_out(3) -radix hexadecimal} {/tb/Instruction_out(2) -radix hexadecimal} {/tb/Instruction_out(1) -radix hexadecimal} {/tb/Instruction_out(0) -radix hexadecimal}} -subitemconfig {/tb/Instruction_out(31) {-height 15 -radix hexadecimal} /tb/Instruction_out(30) {-height 15 -radix hexadecimal} /tb/Instruction_out(29) {-height 15 -radix hexadecimal} /tb/Instruction_out(28) {-height 15 -radix hexadecimal} /tb/Instruction_out(27) {-height 15 -radix hexadecimal} /tb/Instruction_out(26) {-height 15 -radix hexadecimal} /tb/Instruction_out(25) {-height 15 -radix hexadecimal} /tb/Instruction_out(24) {-height 15 -radix hexadecimal} /tb/Instruction_out(23) {-height 15 -radix hexadecimal} /tb/Instruction_out(22) {-height 15 -radix hexadecimal} /tb/Instruction_out(21) {-height 15 -radix hexadecimal} /tb/Instruction_out(20) {-height 15 -radix hexadecimal} /tb/Instruction_out(19) {-height 15 -radix hexadecimal} /tb/Instruction_out(18) {-height 15 -radix hexadecimal} /tb/Instruction_out(17) {-height 15 -radix hexadecimal} /tb/Instruction_out(16) {-height 15 -radix hexadecimal} /tb/Instruction_out(15) {-height 15 -radix hexadecimal} /tb/Instruction_out(14) {-height 15 -radix hexadecimal} /tb/Instruction_out(13) {-height 15 -radix hexadecimal} /tb/Instruction_out(12) {-height 15 -radix hexadecimal} /tb/Instruction_out(11) {-height 15 -radix hexadecimal} /tb/Instruction_out(10) {-height 15 -radix hexadecimal} /tb/Instruction_out(9) {-height 15 -radix hexadecimal} /tb/Instruction_out(8) {-height 15 -radix hexadecimal} /tb/Instruction_out(7) {-height 15 -radix hexadecimal} /tb/Instruction_out(6) {-height 15 -radix hexadecimal} /tb/Instruction_out(5) {-height 15 -radix hexadecimal} /tb/Instruction_out(4) {-height 15 -radix hexadecimal} /tb/Instruction_out(3) {-height 15 -radix hexadecimal} /tb/Instruction_out(2) {-height 15 -radix hexadecimal} /tb/Instruction_out(1) {-height 15 -radix hexadecimal} /tb/Instruction_out(0) {-height 15 -radix hexadecimal}} /tb/Instruction_out
add wave -noupdate -radix hexadecimal -childformat {{/tb/PC(9) -radix hexadecimal} {/tb/PC(8) -radix hexadecimal} {/tb/PC(7) -radix hexadecimal} {/tb/PC(6) -radix hexadecimal} {/tb/PC(5) -radix hexadecimal} {/tb/PC(4) -radix hexadecimal} {/tb/PC(3) -radix hexadecimal} {/tb/PC(2) -radix hexadecimal} {/tb/PC(1) -radix hexadecimal} {/tb/PC(0) -radix hexadecimal}} -subitemconfig {/tb/PC(9) {-height 15 -radix hexadecimal} /tb/PC(8) {-height 15 -radix hexadecimal} /tb/PC(7) {-height 15 -radix hexadecimal} /tb/PC(6) {-height 15 -radix hexadecimal} /tb/PC(5) {-height 15 -radix hexadecimal} /tb/PC(4) {-height 15 -radix hexadecimal} /tb/PC(3) {-height 15 -radix hexadecimal} /tb/PC(2) {-height 15 -radix hexadecimal} /tb/PC(1) {-height 15 -radix hexadecimal} /tb/PC(0) {-height 15 -radix hexadecimal}} /tb/PC
add wave -noupdate -divider MIPS-Core
add wave -noupdate -group PipelinedMIPS /tb/L0/MIPS_Core/TYPE_ctl_sig
add wave -noupdate -group PipelinedMIPS /tb/L0/MIPS_Core/epc
add wave -noupdate -group PipelinedMIPS /tb/L0/MIPS_Core/INTA_s
add wave -noupdate -group PipelinedMIPS /tb/L0/MIPS_Core/INTR_s
add wave -noupdate -group PipelinedMIPS /tb/L0/MIPS_Core/GIE_s
add wave -noupdate -group PipelinedMIPS /tb/L0/MIPS_Core/INT_Flush_s
add wave -noupdate -group PipelinedMIPS /tb/L0/MIPS_Core/K0_0_s
add wave -noupdate -group PipelinedMIPS /tb/L0/MIPS_Core/clock
add wave -noupdate -group PipelinedMIPS /tb/L0/MIPS_Core/Enable
add wave -noupdate -group PipelinedMIPS /tb/L0/MIPS_Core/INTR
add wave -noupdate -group PipelinedMIPS /tb/L0/MIPS_Core/modelsim
add wave -noupdate -group PipelinedMIPS /tb/L0/MIPS_Core/Reset
add wave -noupdate -group PipelinedMIPS /tb/L0/MIPS_Core/Key_reset_s
add wave -noupdate -group PipelinedMIPS /tb/L0/MIPS_Core/ALU_A_MUX
add wave -noupdate -group PipelinedMIPS /tb/L0/MIPS_Core/ALU_B_MUX
add wave -noupdate -group PipelinedMIPS /tb/L0/MIPS_Core/BPADD_out
add wave -noupdate -group PipelinedMIPS /tb/L0/MIPS_Core/chosen_rt_rd_EX
add wave -noupdate -group PipelinedMIPS /tb/L0/MIPS_Core/CLKCNT_out
add wave -noupdate -group PipelinedMIPS /tb/L0/MIPS_Core/EX_ALU_Ainput
add wave -noupdate -group PipelinedMIPS /tb/L0/MIPS_Core/EX_ALU_Binput
add wave -noupdate -group PipelinedMIPS /tb/L0/MIPS_Core/EX_ALU_result
add wave -noupdate -group PipelinedMIPS /tb/L0/MIPS_Core/EX_Instruction
add wave -noupdate -group PipelinedMIPS /tb/L0/MIPS_Core/FHCNT_out
add wave -noupdate -group PipelinedMIPS /tb/L0/MIPS_Core/GIE
add wave -noupdate -group PipelinedMIPS /tb/L0/MIPS_Core/ID_Instruction
add wave -noupdate -group PipelinedMIPS /tb/L0/MIPS_Core/ID_read_data_1
add wave -noupdate -group PipelinedMIPS /tb/L0/MIPS_Core/ID_read_data_2
add wave -noupdate -group PipelinedMIPS /tb/L0/MIPS_Core/ID_Regwrite
add wave -noupdate -group PipelinedMIPS /tb/L0/MIPS_Core/ID_write_data
add wave -noupdate -group PipelinedMIPS /tb/L0/MIPS_Core/ID_write_reg_addr
add wave -noupdate -group PipelinedMIPS /tb/L0/MIPS_Core/IF_ID_Write
add wave -noupdate -group PipelinedMIPS /tb/L0/MIPS_Core/INTA
add wave -noupdate -group PipelinedMIPS /tb/L0/MIPS_Core/Jump
add wave -noupdate -group PipelinedMIPS /tb/L0/MIPS_Core/MEM_Address
add wave -noupdate -group PipelinedMIPS /tb/L0/MIPS_Core/MEM_Instruction
add wave -noupdate -group PipelinedMIPS /tb/L0/MIPS_Core/MEM_MemWrite
add wave -noupdate -group PipelinedMIPS /tb/L0/MIPS_Core/MEM_read_data
add wave -noupdate -group PipelinedMIPS /tb/L0/MIPS_Core/MEM_write_data
add wave -noupdate -group PipelinedMIPS /tb/L0/MIPS_Core/MemRead
add wave -noupdate -group PipelinedMIPS /tb/L0/MIPS_Core/PC
add wave -noupdate -group PipelinedMIPS /tb/L0/MIPS_Core/rd_EX
add wave -noupdate -group PipelinedMIPS /tb/L0/MIPS_Core/rd_ID
add wave -noupdate -group PipelinedMIPS /tb/L0/MIPS_Core/rd_MEM
add wave -noupdate -group PipelinedMIPS /tb/L0/MIPS_Core/rd_WB
add wave -noupdate -group PipelinedMIPS /tb/L0/MIPS_Core/rs_EX
add wave -noupdate -group PipelinedMIPS /tb/L0/MIPS_Core/rs_ID
add wave -noupdate -group PipelinedMIPS /tb/L0/MIPS_Core/rt_EX
add wave -noupdate -group PipelinedMIPS /tb/L0/MIPS_Core/rt_ID
add wave -noupdate -group PipelinedMIPS /tb/L0/MIPS_Core/ST_trigger
add wave -noupdate -group PipelinedMIPS /tb/L0/MIPS_Core/STCNT_out
add wave -noupdate -group PipelinedMIPS /tb/L0/MIPS_Core/WB_Instruction
add wave -noupdate -group PipelinedMIPS /tb/L0/MIPS_Core/WB_MemtoReg
add wave -noupdate -group PipelinedMIPS /tb/L0/MIPS_Core/WD_MUX
add wave -noupdate -group PipelinedMIPS /tb/L0/MIPS_Core/DataBUS
add wave -noupdate -group PipelinedMIPS /tb/L0/MIPS_Core/Add_result
add wave -noupdate -group PipelinedMIPS /tb/L0/MIPS_Core/Ainput_o
add wave -noupdate -group PipelinedMIPS /tb/L0/MIPS_Core/ALU_A_MUX_s
add wave -noupdate -group PipelinedMIPS /tb/L0/MIPS_Core/ALU_B_MUX_s
add wave -noupdate -group PipelinedMIPS /tb/L0/MIPS_Core/ALU_Result_a
add wave -noupdate -group PipelinedMIPS /tb/L0/MIPS_Core/ALU_Result_b
add wave -noupdate -group PipelinedMIPS /tb/L0/MIPS_Core/ALU_Result_c
add wave -noupdate -group PipelinedMIPS /tb/L0/MIPS_Core/ALU_Result_d
add wave -noupdate -group PipelinedMIPS /tb/L0/MIPS_Core/ALUop_a
add wave -noupdate -group PipelinedMIPS /tb/L0/MIPS_Core/ALUop_amux
add wave -noupdate -group PipelinedMIPS /tb/L0/MIPS_Core/ALUop_b
add wave -noupdate -group PipelinedMIPS /tb/L0/MIPS_Core/Binput_o
add wave -noupdate -group PipelinedMIPS /tb/L0/MIPS_Core/BPADD
add wave -noupdate -group PipelinedMIPS /tb/L0/MIPS_Core/br
add wave -noupdate -group PipelinedMIPS /tb/L0/MIPS_Core/clk
add wave -noupdate -group PipelinedMIPS /tb/L0/MIPS_Core/CLKCNT
add wave -noupdate -group PipelinedMIPS /tb/L0/MIPS_Core/Din
add wave -noupdate -group PipelinedMIPS /tb/L0/MIPS_Core/En_CORE2BUS
add wave -noupdate -group PipelinedMIPS /tb/L0/MIPS_Core/ena
add wave -noupdate -group PipelinedMIPS /tb/L0/MIPS_Core/FHCNT
add wave -noupdate -group PipelinedMIPS /tb/L0/MIPS_Core/IF_ID_Write_s
add wave -noupdate -group PipelinedMIPS /tb/L0/MIPS_Core/Imm_sign_ext_a
add wave -noupdate -group PipelinedMIPS /tb/L0/MIPS_Core/Imm_sign_ext_b
add wave -noupdate -group PipelinedMIPS /tb/L0/MIPS_Core/Instruction_a
add wave -noupdate -group PipelinedMIPS /tb/L0/MIPS_Core/Instruction_b
add wave -noupdate -group PipelinedMIPS /tb/L0/MIPS_Core/Instruction_c
add wave -noupdate -group PipelinedMIPS /tb/L0/MIPS_Core/Instruction_d
add wave -noupdate -group PipelinedMIPS /tb/L0/MIPS_Core/Instruction_e
add wave -noupdate -group PipelinedMIPS /tb/L0/MIPS_Core/jr
add wave -noupdate -group PipelinedMIPS /tb/L0/MIPS_Core/jump_address
add wave -noupdate -group PipelinedMIPS /tb/L0/MIPS_Core/jump_register
add wave -noupdate -group PipelinedMIPS /tb/L0/MIPS_Core/Jump_s
add wave -noupdate -group PipelinedMIPS /tb/L0/MIPS_Core/MemRead_a
add wave -noupdate -group PipelinedMIPS /tb/L0/MIPS_Core/MemRead_amux
add wave -noupdate -group PipelinedMIPS /tb/L0/MIPS_Core/MemRead_b
add wave -noupdate -group PipelinedMIPS /tb/L0/MIPS_Core/MemRead_c
add wave -noupdate -group PipelinedMIPS /tb/L0/MIPS_Core/MemtoReg_a
add wave -noupdate -group PipelinedMIPS /tb/L0/MIPS_Core/MemtoReg_amux
add wave -noupdate -group PipelinedMIPS /tb/L0/MIPS_Core/MemtoReg_b
add wave -noupdate -group PipelinedMIPS /tb/L0/MIPS_Core/MemtoReg_c
add wave -noupdate -group PipelinedMIPS /tb/L0/MIPS_Core/MemtoReg_d
add wave -noupdate -group PipelinedMIPS /tb/L0/MIPS_Core/MemWrite_a
add wave -noupdate -group PipelinedMIPS /tb/L0/MIPS_Core/MemWrite_amux
add wave -noupdate -group PipelinedMIPS /tb/L0/MIPS_Core/MemWrite_b
add wave -noupdate -group PipelinedMIPS /tb/L0/MIPS_Core/MemWrite_c
add wave -noupdate -group PipelinedMIPS /tb/L0/MIPS_Core/opcode
add wave -noupdate -group PipelinedMIPS /tb/L0/MIPS_Core/PC_plus_4_a
add wave -noupdate -group PipelinedMIPS /tb/L0/MIPS_Core/PC_plus_4_b
add wave -noupdate -group PipelinedMIPS /tb/L0/MIPS_Core/PC_plus_4_c
add wave -noupdate -group PipelinedMIPS /tb/L0/MIPS_Core/PC_plus_4_d
add wave -noupdate -group PipelinedMIPS /tb/L0/MIPS_Core/PC_plus_4_e
add wave -noupdate -group PipelinedMIPS /tb/L0/MIPS_Core/PC_plus_4_f
add wave -noupdate -group PipelinedMIPS /tb/L0/MIPS_Core/PC_tb
add wave -noupdate -group PipelinedMIPS /tb/L0/MIPS_Core/PCsrc
add wave -noupdate -group PipelinedMIPS /tb/L0/MIPS_Core/PCWrite
add wave -noupdate -group PipelinedMIPS /tb/L0/MIPS_Core/read_data_1_a
add wave -noupdate -group PipelinedMIPS /tb/L0/MIPS_Core/read_data_1_b
add wave -noupdate -group PipelinedMIPS /tb/L0/MIPS_Core/read_data_2_a
add wave -noupdate -group PipelinedMIPS /tb/L0/MIPS_Core/read_data_2_b
add wave -noupdate -group PipelinedMIPS /tb/L0/MIPS_Core/read_data_2_c
add wave -noupdate -group PipelinedMIPS /tb/L0/MIPS_Core/read_data_2_d
add wave -noupdate -group PipelinedMIPS /tb/L0/MIPS_Core/read_data_a
add wave -noupdate -group PipelinedMIPS /tb/L0/MIPS_Core/read_data_b
add wave -noupdate -group PipelinedMIPS /tb/L0/MIPS_Core/RegDst_a
add wave -noupdate -group PipelinedMIPS /tb/L0/MIPS_Core/RegDst_amux
add wave -noupdate -group PipelinedMIPS /tb/L0/MIPS_Core/RegDst_b
add wave -noupdate -group PipelinedMIPS /tb/L0/MIPS_Core/register_rd_a
add wave -noupdate -group PipelinedMIPS /tb/L0/MIPS_Core/register_rd_b
add wave -noupdate -group PipelinedMIPS /tb/L0/MIPS_Core/register_rs_a
add wave -noupdate -group PipelinedMIPS /tb/L0/MIPS_Core/register_rs_b
add wave -noupdate -group PipelinedMIPS /tb/L0/MIPS_Core/register_rt_a
add wave -noupdate -group PipelinedMIPS /tb/L0/MIPS_Core/register_rt_b
add wave -noupdate -group PipelinedMIPS /tb/L0/MIPS_Core/RegWrite_a
add wave -noupdate -group PipelinedMIPS /tb/L0/MIPS_Core/RegWrite_amux
add wave -noupdate -group PipelinedMIPS /tb/L0/MIPS_Core/RegWrite_b
add wave -noupdate -group PipelinedMIPS /tb/L0/MIPS_Core/RegWrite_c
add wave -noupdate -group PipelinedMIPS /tb/L0/MIPS_Core/RegWrite_d
add wave -noupdate -group PipelinedMIPS /tb/L0/MIPS_Core/rs_EX_s
add wave -noupdate -group PipelinedMIPS /tb/L0/MIPS_Core/rst
add wave -noupdate -group PipelinedMIPS /tb/L0/MIPS_Core/rt_EX_s
add wave -noupdate -group PipelinedMIPS /tb/L0/MIPS_Core/stall_mux
add wave -noupdate -group PipelinedMIPS /tb/L0/MIPS_Core/STCNT
add wave -noupdate -group PipelinedMIPS /tb/L0/MIPS_Core/WD_MUX_s
add wave -noupdate -group PipelinedMIPS /tb/L0/MIPS_Core/write_data
add wave -noupdate -group PipelinedMIPS /tb/L0/MIPS_Core/write_register_address_a
add wave -noupdate -group PipelinedMIPS /tb/L0/MIPS_Core/write_register_address_b
add wave -noupdate -group PipelinedMIPS /tb/L0/MIPS_Core/write_register_address_c
add wave -noupdate -group PipelinedMIPS /tb/L0/MIPS_Core/En_CORE2BUS
add wave -noupdate -group Fetch /tb/L0/MIPS_Core/IFE/ISR_en
add wave -noupdate -group Fetch /tb/L0/MIPS_Core/IFE/Add_result
add wave -noupdate -group Fetch /tb/L0/MIPS_Core/IFE/clock
add wave -noupdate -group Fetch /tb/L0/MIPS_Core/IFE/ena
add wave -noupdate -group Fetch /tb/L0/MIPS_Core/IFE/Jump
add wave -noupdate -group Fetch /tb/L0/MIPS_Core/IFE/jump_address
add wave -noupdate -group Fetch /tb/L0/MIPS_Core/IFE/jump_register
add wave -noupdate -group Fetch /tb/L0/MIPS_Core/IFE/PCWrite
add wave -noupdate -group Fetch /tb/L0/MIPS_Core/IFE/reset
add wave -noupdate -group Fetch /tb/L0/MIPS_Core/IFE/Instruction
add wave -noupdate -group Fetch /tb/L0/MIPS_Core/IFE/PC_plus_4_out
add wave -noupdate -group Fetch /tb/L0/MIPS_Core/IFE/PC_tb
add wave -noupdate -group Fetch /tb/L0/MIPS_Core/IFE/next_PC
add wave -noupdate -group Fetch /tb/L0/MIPS_Core/IFE/PC
add wave -noupdate -group Fetch /tb/L0/MIPS_Core/IFE/PC_plus_4
add wave -noupdate -group Fetch -radix binary /tb/L0/MIPS_Core/IFE/ISR_address
add wave -noupdate -group Decode -radix hexadecimal /tb/L0/MIPS_Core/ID/clock
add wave -noupdate -group Decode -radix hexadecimal /tb/L0/MIPS_Core/ID/Instruction
add wave -noupdate -group Decode -radix hexadecimal /tb/L0/MIPS_Core/ID/PC_plus_4
add wave -noupdate -group Decode -radix hexadecimal /tb/L0/MIPS_Core/ID/RegWrite
add wave -noupdate -group Decode -radix hexadecimal /tb/L0/MIPS_Core/ID/reset
add wave -noupdate -group Decode /tb/L0/MIPS_Core/ID/K0_0
add wave -noupdate -group Decode -radix hexadecimal /tb/L0/MIPS_Core/ID/write_data
add wave -noupdate -group Decode -radix hexadecimal /tb/L0/MIPS_Core/ID/write_register_address
add wave -noupdate -group Decode -radix hexadecimal /tb/L0/MIPS_Core/ID/Add_result
add wave -noupdate -group Decode -radix hexadecimal /tb/L0/MIPS_Core/ID/Imm_sign_ext
add wave -noupdate -group Decode -radix hexadecimal /tb/L0/MIPS_Core/ID/jump_address
add wave -noupdate -group Decode -radix hexadecimal /tb/L0/MIPS_Core/ID/jump_register
add wave -noupdate -group Decode -radix hexadecimal /tb/L0/MIPS_Core/ID/Opcode
add wave -noupdate -group Decode -radix hexadecimal /tb/L0/MIPS_Core/ID/PC_plus_4_out
add wave -noupdate -group Decode -radix hexadecimal /tb/L0/MIPS_Core/ID/PCsrc
add wave -noupdate -group Decode -radix hexadecimal /tb/L0/MIPS_Core/ID/read_data_1
add wave -noupdate -group Decode -radix hexadecimal /tb/L0/MIPS_Core/ID/read_data_2
add wave -noupdate -group Decode -radix hexadecimal /tb/L0/MIPS_Core/ID/register_rd
add wave -noupdate -group Decode -radix hexadecimal /tb/L0/MIPS_Core/ID/register_rs
add wave -noupdate -group Decode -radix hexadecimal /tb/L0/MIPS_Core/ID/register_rt
add wave -noupdate -group Decode -radix hexadecimal /tb/L0/MIPS_Core/ID/Add_result_signal
add wave -noupdate -group Decode -radix hexadecimal /tb/L0/MIPS_Core/ID/Equal
add wave -noupdate -group Decode -radix hexadecimal /tb/L0/MIPS_Core/ID/Imm_sign_ext_signal
add wave -noupdate -group Decode -radix hexadecimal /tb/L0/MIPS_Core/ID/Imm_signal
add wave -noupdate -group Decode -radix hexadecimal /tb/L0/MIPS_Core/ID/read_data_1_signal
add wave -noupdate -group Decode -radix hexadecimal /tb/L0/MIPS_Core/ID/read_data_2_signal
add wave -noupdate -group Decode -radix hexadecimal /tb/L0/MIPS_Core/ID/read_register_1_address
add wave -noupdate -group Decode -radix hexadecimal /tb/L0/MIPS_Core/ID/read_register_2_address
add wave -noupdate -group Decode -radix hexadecimal -childformat {{/tb/L0/MIPS_Core/ID/register_array(0) -radix hexadecimal} {/tb/L0/MIPS_Core/ID/register_array(1) -radix hexadecimal} {/tb/L0/MIPS_Core/ID/register_array(2) -radix hexadecimal} {/tb/L0/MIPS_Core/ID/register_array(3) -radix hexadecimal} {/tb/L0/MIPS_Core/ID/register_array(4) -radix hexadecimal} {/tb/L0/MIPS_Core/ID/register_array(5) -radix hexadecimal} {/tb/L0/MIPS_Core/ID/register_array(6) -radix hexadecimal} {/tb/L0/MIPS_Core/ID/register_array(7) -radix hexadecimal} {/tb/L0/MIPS_Core/ID/register_array(8) -radix hexadecimal} {/tb/L0/MIPS_Core/ID/register_array(9) -radix hexadecimal} {/tb/L0/MIPS_Core/ID/register_array(10) -radix hexadecimal} {/tb/L0/MIPS_Core/ID/register_array(11) -radix hexadecimal} {/tb/L0/MIPS_Core/ID/register_array(12) -radix hexadecimal} {/tb/L0/MIPS_Core/ID/register_array(13) -radix hexadecimal} {/tb/L0/MIPS_Core/ID/register_array(14) -radix hexadecimal} {/tb/L0/MIPS_Core/ID/register_array(15) -radix hexadecimal} {/tb/L0/MIPS_Core/ID/register_array(16) -radix hexadecimal} {/tb/L0/MIPS_Core/ID/register_array(17) -radix hexadecimal} {/tb/L0/MIPS_Core/ID/register_array(18) -radix hexadecimal} {/tb/L0/MIPS_Core/ID/register_array(19) -radix hexadecimal} {/tb/L0/MIPS_Core/ID/register_array(20) -radix hexadecimal} {/tb/L0/MIPS_Core/ID/register_array(21) -radix hexadecimal} {/tb/L0/MIPS_Core/ID/register_array(22) -radix hexadecimal} {/tb/L0/MIPS_Core/ID/register_array(23) -radix hexadecimal} {/tb/L0/MIPS_Core/ID/register_array(24) -radix hexadecimal} {/tb/L0/MIPS_Core/ID/register_array(25) -radix hexadecimal} {/tb/L0/MIPS_Core/ID/register_array(26) -radix hexadecimal} {/tb/L0/MIPS_Core/ID/register_array(27) -radix hexadecimal} {/tb/L0/MIPS_Core/ID/register_array(28) -radix hexadecimal} {/tb/L0/MIPS_Core/ID/register_array(29) -radix hexadecimal} {/tb/L0/MIPS_Core/ID/register_array(30) -radix hexadecimal} {/tb/L0/MIPS_Core/ID/register_array(31) -radix hexadecimal}} -expand -subitemconfig {/tb/L0/MIPS_Core/ID/register_array(0) {-height 15 -radix hexadecimal} /tb/L0/MIPS_Core/ID/register_array(1) {-height 15 -radix hexadecimal} /tb/L0/MIPS_Core/ID/register_array(2) {-height 15 -radix hexadecimal} /tb/L0/MIPS_Core/ID/register_array(3) {-height 15 -radix hexadecimal} /tb/L0/MIPS_Core/ID/register_array(4) {-height 15 -radix hexadecimal} /tb/L0/MIPS_Core/ID/register_array(5) {-height 15 -radix hexadecimal} /tb/L0/MIPS_Core/ID/register_array(6) {-height 15 -radix hexadecimal} /tb/L0/MIPS_Core/ID/register_array(7) {-height 15 -radix hexadecimal} /tb/L0/MIPS_Core/ID/register_array(8) {-height 15 -radix hexadecimal} /tb/L0/MIPS_Core/ID/register_array(9) {-height 15 -radix hexadecimal} /tb/L0/MIPS_Core/ID/register_array(10) {-height 15 -radix hexadecimal} /tb/L0/MIPS_Core/ID/register_array(11) {-height 15 -radix hexadecimal} /tb/L0/MIPS_Core/ID/register_array(12) {-height 15 -radix hexadecimal} /tb/L0/MIPS_Core/ID/register_array(13) {-height 15 -radix hexadecimal} /tb/L0/MIPS_Core/ID/register_array(14) {-height 15 -radix hexadecimal} /tb/L0/MIPS_Core/ID/register_array(15) {-height 15 -radix hexadecimal} /tb/L0/MIPS_Core/ID/register_array(16) {-height 15 -radix hexadecimal} /tb/L0/MIPS_Core/ID/register_array(17) {-height 15 -radix hexadecimal} /tb/L0/MIPS_Core/ID/register_array(18) {-height 15 -radix hexadecimal} /tb/L0/MIPS_Core/ID/register_array(19) {-height 15 -radix hexadecimal} /tb/L0/MIPS_Core/ID/register_array(20) {-height 15 -radix hexadecimal} /tb/L0/MIPS_Core/ID/register_array(21) {-height 15 -radix hexadecimal} /tb/L0/MIPS_Core/ID/register_array(22) {-height 15 -radix hexadecimal} /tb/L0/MIPS_Core/ID/register_array(23) {-height 15 -radix hexadecimal} /tb/L0/MIPS_Core/ID/register_array(24) {-height 15 -radix hexadecimal} /tb/L0/MIPS_Core/ID/register_array(25) {-height 15 -radix hexadecimal} /tb/L0/MIPS_Core/ID/register_array(26) {-height 15 -radix hexadecimal} /tb/L0/MIPS_Core/ID/register_array(27) {-height 15 -radix hexadecimal} /tb/L0/MIPS_Core/ID/register_array(28) {-height 15 -radix hexadecimal} /tb/L0/MIPS_Core/ID/register_array(29) {-height 15 -radix hexadecimal} /tb/L0/MIPS_Core/ID/register_array(30) {-height 15 -radix hexadecimal} /tb/L0/MIPS_Core/ID/register_array(31) {-height 15 -radix hexadecimal}} /tb/L0/MIPS_Core/ID/register_array
add wave -noupdate -group Execute /tb/L0/MIPS_Core/EXE/clock
add wave -noupdate -group Execute /tb/L0/MIPS_Core/EXE/reset
add wave -noupdate -group Execute -radix hexadecimal /tb/L0/MIPS_Core/EXE/ALU_A_MUX
add wave -noupdate -group Execute -radix hexadecimal /tb/L0/MIPS_Core/EXE/ALU_B_MUX
add wave -noupdate -group Execute -radix hexadecimal /tb/L0/MIPS_Core/EXE/ALUop
add wave -noupdate -group Execute -radix hexadecimal /tb/L0/MIPS_Core/EXE/ALU_ctl
add wave -noupdate -group Execute -radix hexadecimal /tb/L0/MIPS_Core/EXE/Ainput
add wave -noupdate -group Execute -radix hexadecimal /tb/L0/MIPS_Core/EXE/Binput
add wave -noupdate -group Execute -radix hexadecimal /tb/L0/MIPS_Core/EXE/ALU_Result
add wave -noupdate -group Execute -radix hexadecimal /tb/L0/MIPS_Core/EXE/read_data_1
add wave -noupdate -group Execute -radix hexadecimal /tb/L0/MIPS_Core/EXE/read_data_2
add wave -noupdate -group Execute -radix hexadecimal /tb/L0/MIPS_Core/EXE/read_data_2_out
add wave -noupdate -group Execute -radix hexadecimal /tb/L0/MIPS_Core/EXE/Function_opcode
add wave -noupdate -group Execute -radix hexadecimal /tb/L0/MIPS_Core/EXE/Imm_sign_ext
add wave -noupdate -group Execute -radix hexadecimal /tb/L0/MIPS_Core/EXE/data_MEM
add wave -noupdate -group Execute -radix hexadecimal /tb/L0/MIPS_Core/EXE/data_WB
add wave -noupdate -group Execute -radix hexadecimal /tb/L0/MIPS_Core/EXE/RegDst
add wave -noupdate -group Execute -radix hexadecimal /tb/L0/MIPS_Core/EXE/register_rd
add wave -noupdate -group Execute -radix hexadecimal /tb/L0/MIPS_Core/EXE/register_rs
add wave -noupdate -group Execute -radix hexadecimal /tb/L0/MIPS_Core/EXE/register_rt
add wave -noupdate -group Execute -radix hexadecimal /tb/L0/MIPS_Core/EXE/WD_MUX
add wave -noupdate -group Execute -radix hexadecimal /tb/L0/MIPS_Core/EXE/register_rs_out
add wave -noupdate -group Execute -radix hexadecimal /tb/L0/MIPS_Core/EXE/register_rt_out
add wave -noupdate -group Execute -radix hexadecimal /tb/L0/MIPS_Core/EXE/write_register_address
add wave -noupdate -group Execute -radix hexadecimal /tb/L0/MIPS_Core/EXE/shift
add wave -noupdate -group Execute -radix hexadecimal /tb/L0/MIPS_Core/EXE/WD
add wave -noupdate -group Memory -radix hexadecimal /tb/L0/MIPS_Core/MEM/ALU_Result
add wave -noupdate -group Memory -radix hexadecimal /tb/L0/MIPS_Core/MEM/clock
add wave -noupdate -group Memory -radix hexadecimal /tb/L0/MIPS_Core/MEM/MemRead
add wave -noupdate -group Memory -radix hexadecimal /tb/L0/MIPS_Core/MEM/MemWrite
add wave -noupdate -group Memory -radix hexadecimal /tb/L0/MIPS_Core/MEM/modelsim
add wave -noupdate -group Memory -radix hexadecimal /tb/L0/MIPS_Core/MEM/reset
add wave -noupdate -group Memory -radix hexadecimal /tb/L0/MIPS_Core/MEM/TYPE_addr
add wave -noupdate -group Memory -radix hexadecimal /tb/L0/MIPS_Core/MEM/TYPE_ctl
add wave -noupdate -group Memory -radix hexadecimal /tb/L0/MIPS_Core/MEM/write_data
add wave -noupdate -group Memory -radix hexadecimal /tb/L0/MIPS_Core/MEM/ALU_Result_OUT
add wave -noupdate -group Memory -radix hexadecimal /tb/L0/MIPS_Core/MEM/read_data
add wave -noupdate -group Memory -radix hexadecimal /tb/L0/MIPS_Core/MEM/address
add wave -noupdate -group Memory -radix hexadecimal /tb/L0/MIPS_Core/MEM/CS
add wave -noupdate -group Memory -radix hexadecimal -childformat {{/tb/L0/MIPS_Core/MEM/QuartusAddress(10) -radix hexadecimal} {/tb/L0/MIPS_Core/MEM/QuartusAddress(9) -radix hexadecimal} {/tb/L0/MIPS_Core/MEM/QuartusAddress(8) -radix hexadecimal} {/tb/L0/MIPS_Core/MEM/QuartusAddress(7) -radix hexadecimal} {/tb/L0/MIPS_Core/MEM/QuartusAddress(6) -radix hexadecimal} {/tb/L0/MIPS_Core/MEM/QuartusAddress(5) -radix hexadecimal} {/tb/L0/MIPS_Core/MEM/QuartusAddress(4) -radix hexadecimal} {/tb/L0/MIPS_Core/MEM/QuartusAddress(3) -radix hexadecimal} {/tb/L0/MIPS_Core/MEM/QuartusAddress(2) -radix hexadecimal} {/tb/L0/MIPS_Core/MEM/QuartusAddress(1) -radix hexadecimal} {/tb/L0/MIPS_Core/MEM/QuartusAddress(0) -radix hexadecimal}} -subitemconfig {/tb/L0/MIPS_Core/MEM/QuartusAddress(10) {-height 15 -radix hexadecimal} /tb/L0/MIPS_Core/MEM/QuartusAddress(9) {-height 15 -radix hexadecimal} /tb/L0/MIPS_Core/MEM/QuartusAddress(8) {-height 15 -radix hexadecimal} /tb/L0/MIPS_Core/MEM/QuartusAddress(7) {-height 15 -radix hexadecimal} /tb/L0/MIPS_Core/MEM/QuartusAddress(6) {-height 15 -radix hexadecimal} /tb/L0/MIPS_Core/MEM/QuartusAddress(5) {-height 15 -radix hexadecimal} /tb/L0/MIPS_Core/MEM/QuartusAddress(4) {-height 15 -radix hexadecimal} /tb/L0/MIPS_Core/MEM/QuartusAddress(3) {-height 15 -radix hexadecimal} /tb/L0/MIPS_Core/MEM/QuartusAddress(2) {-height 15 -radix hexadecimal} /tb/L0/MIPS_Core/MEM/QuartusAddress(1) {-height 15 -radix hexadecimal} /tb/L0/MIPS_Core/MEM/QuartusAddress(0) {-height 15 -radix hexadecimal}} /tb/L0/MIPS_Core/MEM/QuartusAddress
add wave -noupdate -group Memory -radix hexadecimal /tb/L0/MIPS_Core/MEM/write_clock
add wave -noupdate -group Memory /tb/L0/MIPS_Core/MEM/En_BUS2CORE
add wave -noupdate -group Memory /tb/L0/MIPS_Core/MEM/read_data_mem
add wave -noupdate -group Control /tb/L0/MIPS_Core/CTL/clock
add wave -noupdate -group Control /tb/L0/MIPS_Core/CTL/Function_opcode
add wave -noupdate -group Control /tb/L0/MIPS_Core/CTL/Opcode
add wave -noupdate -group Control /tb/L0/MIPS_Core/CTL/PCsrc
add wave -noupdate -group Control /tb/L0/MIPS_Core/CTL/reset
add wave -noupdate -group Control /tb/L0/MIPS_Core/CTL/Key_reset_s
add wave -noupdate -group Control /tb/L0/MIPS_Core/CTL/INTA
add wave -noupdate -group Control /tb/L0/MIPS_Core/CTL/GIE
add wave -noupdate -group Control /tb/L0/MIPS_Core/CTL/INT_Flush
add wave -noupdate -group Control /tb/L0/MIPS_Core/CTL/K0_0
add wave -noupdate -group Control /tb/L0/MIPS_Core/CTL/INTR
add wave -noupdate -group Control /tb/L0/MIPS_Core/CTL/rs_ID
add wave -noupdate -group Control /tb/L0/MIPS_Core/CTL/TYPE_addr
add wave -noupdate -group Control /tb/L0/MIPS_Core/CTL/ALUop
add wave -noupdate -group Control /tb/L0/MIPS_Core/CTL/br
add wave -noupdate -group Control /tb/L0/MIPS_Core/CTL/jr
add wave -noupdate -group Control /tb/L0/MIPS_Core/CTL/Jump
add wave -noupdate -group Control /tb/L0/MIPS_Core/CTL/MemRead
add wave -noupdate -group Control /tb/L0/MIPS_Core/CTL/MemtoReg
add wave -noupdate -group Control /tb/L0/MIPS_Core/CTL/MemWrite
add wave -noupdate -group Control /tb/L0/MIPS_Core/CTL/RegDst
add wave -noupdate -group Control /tb/L0/MIPS_Core/CTL/RegWrite
add wave -noupdate -group Control /tb/L0/MIPS_Core/CTL/TYPE_ctl
add wave -noupdate -group Control /tb/L0/MIPS_Core/CTL/addi
add wave -noupdate -group Control /tb/L0/MIPS_Core/CTL/andi
add wave -noupdate -group Control /tb/L0/MIPS_Core/CTL/beq
add wave -noupdate -group Control /tb/L0/MIPS_Core/CTL/bne
add wave -noupdate -group Control /tb/L0/MIPS_Core/CTL/j
add wave -noupdate -group Control /tb/L0/MIPS_Core/CTL/jal
add wave -noupdate -group Control /tb/L0/MIPS_Core/CTL/jr_s
add wave -noupdate -group Control /tb/L0/MIPS_Core/CTL/lui
add wave -noupdate -group Control /tb/L0/MIPS_Core/CTL/lw
add wave -noupdate -group Control /tb/L0/MIPS_Core/CTL/mul
add wave -noupdate -group Control /tb/L0/MIPS_Core/CTL/ori
add wave -noupdate -group Control /tb/L0/MIPS_Core/CTL/R_format
add wave -noupdate -group Control /tb/L0/MIPS_Core/CTL/slti
add wave -noupdate -group Control /tb/L0/MIPS_Core/CTL/sw
add wave -noupdate -group Control /tb/L0/MIPS_Core/CTL/xori
add wave -noupdate -group Control /tb/L0/MIPS_Core/CTL/INTA_s
add wave -noupdate -group Control /tb/L0/MIPS_Core/CTL/GIE_s
add wave -noupdate -group Control /tb/L0/MIPS_Core/CTL/pc_k1
add wave -noupdate -group Control /tb/L0/MIPS_Core/CTL/Flush
add wave -noupdate -group Control /tb/L0/MIPS_Core/CTL/INT_process
add wave -noupdate -group {Hazard Detection} /tb/L0/MIPS_Core/HD/br
add wave -noupdate -group {Hazard Detection} /tb/L0/MIPS_Core/HD/jr
add wave -noupdate -group {Hazard Detection} /tb/L0/MIPS_Core/HD/MemRead_EX
add wave -noupdate -group {Hazard Detection} /tb/L0/MIPS_Core/HD/r_dst_EX
add wave -noupdate -group {Hazard Detection} /tb/L0/MIPS_Core/HD/r_dst_MEM
add wave -noupdate -group {Hazard Detection} /tb/L0/MIPS_Core/HD/rd_WB
add wave -noupdate -group {Hazard Detection} /tb/L0/MIPS_Core/HD/rs_ID
add wave -noupdate -group {Hazard Detection} /tb/L0/MIPS_Core/HD/rt_EX
add wave -noupdate -group {Hazard Detection} /tb/L0/MIPS_Core/HD/rt_ID
add wave -noupdate -group {Hazard Detection} /tb/L0/MIPS_Core/HD/IF_ID_Write
add wave -noupdate -group {Hazard Detection} /tb/L0/MIPS_Core/HD/PCWrite
add wave -noupdate -group {Hazard Detection} /tb/L0/MIPS_Core/HD/stall_mux
add wave -noupdate -group {Hazard Detection} /tb/L0/MIPS_Core/HD/branch_stall
add wave -noupdate -group {Hazard Detection} /tb/L0/MIPS_Core/HD/jr_stall
add wave -noupdate -group {Hazard Detection} /tb/L0/MIPS_Core/HD/lw_stall
add wave -noupdate -group {Hazard Detection} /tb/L0/MIPS_Core/HD/stl
add wave -noupdate -group Forwarding /tb/L0/MIPS_Core/FW/Function_opcode
add wave -noupdate -group Forwarding /tb/L0/MIPS_Core/FW/Opcode
add wave -noupdate -group Forwarding /tb/L0/MIPS_Core/FW/rd_MEM
add wave -noupdate -group Forwarding /tb/L0/MIPS_Core/FW/rd_WB
add wave -noupdate -group Forwarding /tb/L0/MIPS_Core/FW/Regwrite_MEM
add wave -noupdate -group Forwarding /tb/L0/MIPS_Core/FW/Regwrite_WB
add wave -noupdate -group Forwarding /tb/L0/MIPS_Core/FW/rs_EX
add wave -noupdate -group Forwarding /tb/L0/MIPS_Core/FW/rt_EX
add wave -noupdate -group Forwarding /tb/L0/MIPS_Core/FW/ALU_A_MUX
add wave -noupdate -group Forwarding /tb/L0/MIPS_Core/FW/ALU_B_MUX
add wave -noupdate -group Forwarding /tb/L0/MIPS_Core/FW/WD_MUX
add wave -noupdate -group Forwarding /tb/L0/MIPS_Core/FW/f_memA
add wave -noupdate -group Forwarding /tb/L0/MIPS_Core/FW/f_memB
add wave -noupdate -group Forwarding /tb/L0/MIPS_Core/FW/f_wbA
add wave -noupdate -group Forwarding /tb/L0/MIPS_Core/FW/f_wbB
add wave -noupdate -group Forwarding /tb/L0/MIPS_Core/FW/immA
add wave -noupdate -group Forwarding /tb/L0/MIPS_Core/FW/immB
add wave -noupdate -group {Bidirectional Bus} /tb/L0/MIPS_Core/CORE2BUS/Dout
add wave -noupdate -group {Bidirectional Bus} /tb/L0/MIPS_Core/CORE2BUS/en
add wave -noupdate -group {Bidirectional Bus} /tb/L0/MIPS_Core/CORE2BUS/width
add wave -noupdate -group {Bidirectional Bus} /tb/L0/MIPS_Core/CORE2BUS/Din
add wave -noupdate -group {Bidirectional Bus} /tb/L0/MIPS_Core/CORE2BUS/IOpin
add wave -noupdate -divider GPIO
add wave -noupdate -group GPIO /tb/L0/I_O/A0
add wave -noupdate -group GPIO /tb/L0/I_O/address
add wave -noupdate -group GPIO /tb/L0/I_O/clock
add wave -noupdate -group GPIO /tb/L0/I_O/InputPortA
add wave -noupdate -group GPIO /tb/L0/I_O/MemRead
add wave -noupdate -group GPIO /tb/L0/I_O/MemWrite
add wave -noupdate -group GPIO /tb/L0/I_O/Reset
add wave -noupdate -group GPIO -radix hexadecimal /tb/L0/I_O/OutputPortA
add wave -noupdate -group GPIO -radix unsigned /tb/L0/I_O/OutputPortB
add wave -noupdate -group GPIO -radix unsigned /tb/L0/I_O/OutputPortC
add wave -noupdate -group GPIO -radix unsigned /tb/L0/I_O/OutputPortD
add wave -noupdate -group GPIO -radix unsigned /tb/L0/I_O/OutputPortE
add wave -noupdate -group GPIO -radix unsigned /tb/L0/I_O/OutputPortF
add wave -noupdate -group GPIO -radix unsigned /tb/L0/I_O/OutputPortG
add wave -noupdate -group GPIO /tb/L0/I_O/DataBus
add wave -noupdate -group GPIO /tb/L0/I_O/CS
add wave -noupdate -group GPIO /tb/L0/I_O/Din
add wave -noupdate -group GPIO /tb/L0/I_O/Dout
add wave -noupdate -group GPIO /tb/L0/I_O/en
add wave -noupdate -group GPIO /tb/L0/I_O/EN_A
add wave -noupdate -group GPIO /tb/L0/I_O/EN_B
add wave -noupdate -group GPIO /tb/L0/I_O/EN_C
add wave -noupdate -group GPIO /tb/L0/I_O/EN_D
add wave -noupdate -group GPIO /tb/L0/I_O/EN_E
add wave -noupdate -group GPIO /tb/L0/I_O/EN_F
add wave -noupdate -group GPIO /tb/L0/I_O/EN_G
add wave -noupdate -divider Interrupts
add wave -noupdate -group IC /tb/L0/IC/clock
add wave -noupdate -group IC /tb/L0/IC/Reset
add wave -noupdate -group IC /tb/L0/IC/address
add wave -noupdate -group IC -radix hexadecimal /tb/L0/IC/DataBus
add wave -noupdate -group IC /tb/L0/IC/MemRead
add wave -noupdate -group IC /tb/L0/IC/MemWrite
add wave -noupdate -group IC -radix binary /tb/L0/IC/IR
add wave -noupdate -group IC /tb/L0/IC/rst_btn
add wave -noupdate -group IC /tb/L0/IC/GIE
add wave -noupdate -group IC /tb/L0/IC/INTA
add wave -noupdate -group IC /tb/L0/IC/INTR
add wave -noupdate -group IC /tb/L0/IC/irq
add wave -noupdate -group IC /tb/L0/IC/clr_irq
add wave -noupdate -group IC /tb/L0/IC/reset_in
add wave -noupdate -group IC /tb/L0/IC/reset_out
add wave -noupdate -group IC /tb/L0/IC/clr_rst
add wave -noupdate -group IC /tb/L0/IC/IE_out
add wave -noupdate -group IC /tb/L0/IC/TYPE_in
add wave -noupdate -group IC /tb/L0/IC/TYPE_out
add wave -noupdate -group IC /tb/L0/IC/IFG_in
add wave -noupdate -group IC /tb/L0/IC/IFG_out
add wave -noupdate -group IC /tb/L0/IC/CS
add wave -noupdate -group IC /tb/L0/IC/rst
add wave -noupdate -group IC /tb/L0/IC/Dout
add wave -noupdate -group IC /tb/L0/IC/Din
add wave -noupdate -group IC /tb/L0/IC/en
add wave -noupdate -divider {Basic Timer}
add wave -noupdate -group BT /tb/L0/BT/clock
add wave -noupdate -group BT /tb/L0/BT/Reset
add wave -noupdate -group BT /tb/L0/BT/address
add wave -noupdate -group BT /tb/L0/BT/DataBus
add wave -noupdate -group BT /tb/L0/BT/MemRead
add wave -noupdate -group BT /tb/L0/BT/MemWrite
add wave -noupdate -group BT /tb/L0/BT/Out_Signal
add wave -noupdate -group BT /tb/L0/BT/Set_BTIFG
add wave -noupdate -group BT /tb/L0/BT/CS
add wave -noupdate -group BT /tb/L0/BT/Dout
add wave -noupdate -group BT /tb/L0/BT/Din
add wave -noupdate -group BT /tb/L0/BT/en
add wave -noupdate -group BT /tb/L0/BT/Out_s
add wave -noupdate -group BT -radix hexadecimal /tb/L0/BT/BTCNT
add wave -noupdate -group BT -radix hexadecimal /tb/L0/BT/BTCCR0
add wave -noupdate -group BT -radix hexadecimal /tb/L0/BT/BTCCR1
add wave -noupdate -group BT /tb/L0/BT/BTCTL
add wave -noupdate -group BT /tb/L0/BT/clock2
add wave -noupdate -group BT /tb/L0/BT/clock4
add wave -noupdate -group BT /tb/L0/BT/clock8
add wave -noupdate -group BT /tb/L0/BT/ChosenClock
add wave -noupdate -divider UART
add wave -noupdate -group UART /tb/L0/USART/Reset
add wave -noupdate -group UART /tb/L0/USART/address
add wave -noupdate -group UART /tb/L0/USART/RX_bit
add wave -noupdate -group UART /tb/L0/USART/MemRead
add wave -noupdate -group UART /tb/L0/USART/MemWrite
add wave -noupdate -group UART /tb/L0/USART/clock
add wave -noupdate -group UART /tb/L0/USART/DataBus
add wave -noupdate -group UART /tb/L0/USART/TX_Done
add wave -noupdate -group UART /tb/L0/USART/TXData_Valid
add wave -noupdate -group UART /tb/L0/USART/RXData_Valid
add wave -noupdate -group UART /tb/L0/USART/RXData
add wave -noupdate -group UART /tb/L0/USART/CS
add wave -noupdate -group UART /tb/L0/USART/Dout
add wave -noupdate -group UART /tb/L0/USART/Din
add wave -noupdate -group UART /tb/L0/USART/en
add wave -noupdate -group UART /tb/L0/USART/UCTL
add wave -noupdate -group UART /tb/L0/USART/RXBUF
add wave -noupdate -group UART /tb/L0/USART/TXBUF
add wave -noupdate -group UART /tb/L0/USART/CLKS_PER_BIT
add wave -noupdate -group UART /tb/L0/USART/FramingError
add wave -noupdate -group UART /tb/L0/USART/ParityError
add wave -noupdate -group UART /tb/L0/USART/OverrunError
add wave -noupdate -group UART /tb/L0/USART/buff_full_flag
add wave -noupdate -group UART /tb/L0/USART/RX_Busy
add wave -noupdate -group UART /tb/L0/USART/TX_Busy
add wave -noupdate -group UART /tb/L0/USART/Busy
add wave -noupdate -group UART /tb/L0/USART/new_RX_flag
add wave -noupdate -group UART /tb/L0/USART/RX_IFG
add wave -noupdate -group UART /tb/L0/USART/TX_bit
add wave -noupdate -group UART /tb/L0/USART/TX_IFG
add wave -noupdate -group UART /tb/L0/USART/Status_IFG
add wave -noupdate -group RX /tb/L0/USART/Receive/i_Clk
add wave -noupdate -group RX /tb/L0/USART/Receive/g_CLKS_PER_BIT
add wave -noupdate -group RX /tb/L0/USART/Receive/PENA
add wave -noupdate -group RX /tb/L0/USART/Receive/PEV
add wave -noupdate -group RX /tb/L0/USART/Receive/SWRST
add wave -noupdate -group RX /tb/L0/USART/Receive/r_RX_DV
add wave -noupdate -group RX /tb/L0/USART/Receive/r_RX_Byte
add wave -noupdate -group RX /tb/L0/USART/Receive/r_Bit_Index
add wave -noupdate -group RX /tb/L0/USART/Receive/r_Clk_Count
add wave -noupdate -group RX /tb/L0/USART/Receive/Parity
add wave -noupdate -group RX /tb/L0/USART/Receive/r_RX_Data
add wave -noupdate -group RX /tb/L0/USART/Receive/r_SM_Main
add wave -noupdate -group RX /tb/L0/USART/Receive/PE
add wave -noupdate -group RX /tb/L0/USART/Receive/FE
add wave -noupdate -group RX /tb/L0/USART/Receive/OE
add wave -noupdate -group RX /tb/L0/USART/Receive/RX_Busy
add wave -noupdate -group TX /tb/L0/USART/Transmit/g_CLKS_PER_BIT
add wave -noupdate -group TX /tb/L0/USART/Transmit/i_Clk
add wave -noupdate -group TX /tb/L0/USART/Transmit/i_TX_DV
add wave -noupdate -group TX /tb/L0/USART/Transmit/TX_Valid
add wave -noupdate -group TX /tb/L0/USART/Transmit/i_TX_Byte
add wave -noupdate -group TX /tb/L0/USART/Transmit/PENA
add wave -noupdate -group TX /tb/L0/USART/Transmit/SWRST
add wave -noupdate -group TX /tb/L0/USART/Transmit/r_TX_Done
add wave -noupdate -group TX /tb/L0/USART/Transmit/Parity
add wave -noupdate -group TX /tb/L0/USART/Transmit/r_TX_Data
add wave -noupdate -group TX /tb/L0/USART/Transmit/r_SM_Main
add wave -noupdate -group TX /tb/L0/USART/Transmit/r_Clk_Count
add wave -noupdate -group TX /tb/L0/USART/Transmit/r_Bit_Index
add wave -noupdate -group TX /tb/L0/USART/Transmit/TX_Busy
add wave -noupdate -group TX /tb/L0/USART/Transmit/o_TX_Serial
add wave -noupdate -group TX /tb/L0/USART/Transmit/o_TX_Done
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {89125961 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 188
configure wave -valuecolwidth 71
configure wave -justifyvalue left
configure wave -signalnamewidth 1
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ps
update
WaveRestoreZoom {0 ps} {439633561 ps}
