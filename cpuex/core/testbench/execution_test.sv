module execution_test #(
	parameter INST_MEM_WIDTH = 2
);
 	logic RegWrite;
	logic [1:0] MemtoReg;
	logic [1:0] ALUSrcs;
	logic ALUSrcs2;
	logic [3:0] ALUOp;
	logic [1:0] RegDist;
	logic [1:0] Branch;
	logic MemWrite;
	logic MemRead;
	logic UARTtoReg;
	logic RegtoUART;
	logic [31:0] op1_sub;
	logic [31:0] op2_sub;
	logic [4:0] rt;
	logic [4:0] rd;
	logic [4:0] sa;
	logic [15:0] immediate;
	logic [25:0] inst_index;
	logic [INST_MEM_WIDTH-1:0] pc;
	logic [INST_MEM_WIDTH-1:0] pc1;
 	logic RegWrite_next;
	logic [1:0] MemtoReg_next;
	logic [1:0] Branch_next;
	logic MemWrite_next;
	logic MemRead_next;
	logic UARTtoReg_next;
	logic [31:0] register_data;
	logic [31:0] alu_result;
	logic [4:0] rdist;
	logic [25:0] inst_index_next;
	logic [INST_MEM_WIDTH-1:0] pc_next;
	logic [INST_MEM_WIDTH-1:0] pc1_next;
	logic [INST_MEM_WIDTH-1:0] pc2;

	localparam WAIT = 5000;

	execution #(INST_MEM_WIDTH) execution_test(
 		RegWrite,
		MemtoReg,
		ALUSrcs,
		ALUSrcs2,
		ALUOp,
		RegDist,
		Branch,
		MemWrite,
		MemRead,
		UARTtoReg,
		RegtoUART,
		op1_sub,
		op2_sub,
		rt,
		rd,
		sa,
		immediate,
		inst_index,
		pc,
		pc1,
 		RegWrite_next,
		MemtoReg_next,
		Branch_next,
		MemWrite_next,
		MemRead_next,
		UARTtoReg_next,
		register_data,
		alu_result,
		rdist,
		inst_index_next,
		pc_next,
		pc1_next,
		pc2
	);

	initial begin
		#WAIT;
		RegWrite <= 0;
		MemtoReg <= 2'b00;
		Branch <= 2'b00;
		MemWrite <= 0;
		MemRead <= 0;
		UARTtoReg <= 0;
		RegtoUART <= 0;
		#WAIT;
		//op2 = op2_sub, op1 = op1_sub, Op = +, dist = rd
		ALUSrcs <= 2'b00;
		ALUSrcs2 <= 1;
		ALUOp <= 4'b0011;
		RegDist <= 2'b00;
		op1_sub <= 32'h00001010;
		op2_sub <= 32'h00000101;
		rt <= 5'b00001;
		rd <= 5'b00010;
		sa <= 5'b00100;
		immediate <= 16'h0101;
		inst_index <= 26'h0000001;
		pc <= 1;
		pc1 <= 2;
	end	
endmodule
