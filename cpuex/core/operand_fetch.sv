module operand_fetch #(
	parameter INST_MEM_WIDTH = 2
) (
	input logic CLK,
	input logic reset,
	input logic distinct,
	input logic distinct_before,
	input logic AorF_before,
	input logic RegWrite_before,
	input logic UART_write_enable,
	input logic [4:0] rs,
	input logic [4:0] rt,
	input logic [4:0] rw,
	input logic [31:0] write_data,
	input logic AorF,
 	input logic RegWrite,
	input logic [1:0] MemtoReg,
	input logic [1:0] ALUSrcs,
	input logic ALUSrcs2,
	input logic [3:0] ALUOp,
	input logic [1:0] RegDist,
	input logic [1:0] Branch,
	input logic MemWrite,
	input logic MemRead,
	input logic UARTtoReg,
	input logic RegtoUART,
	input logic [4:0] rd,
	input logic [4:0] sa,
	input logic [15:0] immediate,
	input logic [25:0] inst_index,
	input logic [INST_MEM_WIDTH-1:0] pc,
	input logic [INST_MEM_WIDTH-1:0] pc1,
	output logic distinct_next,
	output logic [31:0] op1_sub,
	output logic [31:0] op2_sub,
	output logic AorF_next,
	output logic RegWrite_next,
	output logic [1:0] MemtoReg_next,
	output logic [1:0] ALUSrcs_next,
	output logic ALUSrcs2_next,
	output logic [3:0] ALUOp_next,
	output logic [1:0] RegDist_next,
	output logic [1:0] Branch_next,
	output logic MemWrite_next,
	output logic MemRead_next,
	output logic UARTtoReg_next,
	output logic RegtoUART_next,
	output logic [4:0] rt_next,
	output logic [4:0] rd_next,
	output logic [4:0] sa_next,
	output logic [15:0] immediate_next,
	output logic [25:0] inst_index_next,
	output logic [INST_MEM_WIDTH-1:0] pc_next,
	output logic [INST_MEM_WIDTH-1:0] pc1_next
);

	register register_instance(
			CLK,
			reset,
			distinct_before,
			AorF,
			AorF_before,
			RegWrite_before,
			UART_write_enable,
			MemWrite,
			MemRead,
			rs,
			rt,
			rd,
			rw,
			write_data,
			op1_sub,
			op2_sub
	);

	always_ff @(posedge CLK) begin
		distinct_next <= distinct;
		AorF_next <= AorF;
		RegWrite_next <= RegWrite;
	 	MemtoReg_next <= MemtoReg;
	 	ALUSrcs_next <= ALUSrcs;
		ALUSrcs2_next <= ALUSrcs2;
	 	ALUOp_next <= ALUOp;
	 	RegDist_next <= RegDist;
	 	Branch_next <= Branch;
	 	MemWrite_next <= MemWrite;
	 	MemRead_next <= MemRead;
	 	UARTtoReg_next <= UARTtoReg;
	 	RegtoUART_next <= RegtoUART;
		rt_next <= rt;
	 	rd_next <= rd;
	 	sa_next <= sa;
	 	immediate_next <= immediate;
	 	inst_index_next <= inst_index;
	 	pc_next <= pc;
	 	pc1_next <= pc1;
	end
endmodule
