module execution #(
	parameter INST_MEM_WIDTH = 5
) (
	input logic CLK,
	input logic reset,
	input logic distinct,
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
	input logic [31:0] op1_sub,
	input logic [31:0] op2_sub,
	input logic [4:0] rt,
	input logic [4:0] rd,
	input logic [4:0] sa,
	input logic [15:0] immediate,
	input logic [25:0] inst_index,
	input logic [INST_MEM_WIDTH-1:0] pc,
	input logic [INST_MEM_WIDTH-1:0] pc1,
	output logic distinct_next,
	output logic AorF_next,
 	output logic RegWrite_next,
	output logic [1:0] MemtoReg_next,
	output logic [1:0] Branch_next,
	output logic MemWrite_next,
	output logic MemRead_next,
	output logic UARTtoReg_next,
	output logic [31:0] register_data,
	output logic [31:0] result,
	output logic valid,
	output logic [4:0] rdist,
	output logic [25:0] inst_index_next,
	output logic [INST_MEM_WIDTH-1:0] pc_next,
	output logic [INST_MEM_WIDTH-1:0] pc1_next,
	output logic [INST_MEM_WIDTH-1:0] pc2
);
	logic [31:0] op1;
	logic [31:0] op2;
	logic AorF_;
	logic [1:0] ALUSrcs_;
	logic ALUSrcs2_;
	logic [3:0] ALUOp_;
	logic [1:0] RegDist_;
	logic [31:0] op1_sub_;
	logic [31:0] op2_sub_;
	logic [4:0] rt_;
	logic [4:0] rd_;
	logic [4:0] sa_;
	logic [4:0] rdist_;
	logic [15:0] immediate_;
	logic [INST_MEM_WIDTH-1:0] pc_;
	logic [INST_MEM_WIDTH-1:0] pc2_;
	logic [31:0] alu_result;
	logic [31:0] fpu_result;
	logic fpu_valid;
	logic [1:0] state;
	logic distinct__;
	logic AorF__;
	logic RegWrite__;
	logic [1:0] MemtoReg__;
	logic [1:0] Branch__;
	logic MemWrite__;
	logic MemRead__;
	logic UARTtoReg__;
	logic [31:0] op2_sub__;
	logic [25:0] inst_index__;
	logic [INST_MEM_WIDTH-1:0] pc__;
	logic [INST_MEM_WIDTH-1:0] pc1__;
	logic AorF___;

	op1_sel op1_sel_instance(
			ALUSrcs2_, 
			op1_sub_, 
			op2_sub_, 
			op1
	);
	op2_sel op2_sel_instance(
			ALUSrcs_, 
			op2_sub_, 
			sa_, 
			immediate_, 
			op2
	);
	dist_sel dist_sel_instance(
			AorF_,
			RegDist_, 
			rd_, 
			rt_, 
			sa_,
			rdist_
	);
	pc_adder #(INST_MEM_WIDTH) pc_adder2_instance(
			pc_, 
			immediate_[INST_MEM_WIDTH-1:0], 
			pc2_
	);
	alu alu_instance(
			ALUOp_, 
			op1, 
			op2, 
			alu_result
	);
	fpu fpu_instance(
			CLK,
			reset,
			distinct__,
			AorF_,
			ALUOp_,
			op1,
			op2,
			AorF___,
			fpu_result,
			fpu_valid
	);
//    assign fpu_result = 0;
//   assign fpu_valid = 0;
	always_ff @(posedge CLK) begin
		if (reset) begin
		distinct_next <= 0;
		AorF_next <= 0;
		RegWrite_next <= 0;
		MemtoReg_next <= 0;
		Branch_next <= 2'b11;
		MemWrite_next <= 0;
		MemRead_next <= 0;
		UARTtoReg_next <= 0;
		register_data <= 0;
		inst_index_next <= 0;
		pc_next <= 0;
		pc1_next <= 0;
		AorF_ <= 0;
		ALUSrcs_ <= 0;
		ALUSrcs2_ <= 0;
		ALUOp_ <= 0;
		RegDist_ <= 0;
		op1_sub_ <= 0;
		op2_sub_ <= 0;
		rt_ <= 0;
		rd_ <= 0;
		sa_ <= 0;
		immediate_ <= 0;
		pc_ <= 0;
		state <= 0;
		result <= 0;
		valid <= 0;
		end else begin
		if ((! AorF || MemWrite || MemRead) && (state ==  0) && distinct) begin
			distinct__ <= distinct;
			AorF__ <= AorF;
			RegWrite__ <= RegWrite;
			MemtoReg__ <= MemtoReg;
			Branch__ <= Branch;
			MemWrite__ <= MemWrite;
			MemRead__ <= MemRead;
			UARTtoReg__ <= UARTtoReg;
			op2_sub__ <= op2_sub;
			inst_index__ <= inst_index;
			pc__ <= pc;
			pc1__ <= pc1;
	
			ALUSrcs_ <= ALUSrcs;
			ALUSrcs2_ <= ALUSrcs2;
			ALUOp_ <= ALUOp;
			RegDist_ <= RegDist;
			op1_sub_ <= op1_sub;
			op2_sub_ <= op2_sub;
			rt_ <= rt;
			rd_ <= rd;
			sa_ <= sa;
			immediate_ <= immediate;
			pc_ <= pc;

			valid <= 0;
			state <= 2;
		end else if ((state == 0) && distinct) begin
			AorF_  <= AorF;
			ALUSrcs_ <= ALUSrcs;
			ALUSrcs2_ <= ALUSrcs2;
			ALUOp_ <= ALUOp;
			RegDist_ <= RegDist;
			op1_sub_ <= op1_sub;
			op2_sub_ <= op2_sub;
			rt_ <= rt;
			rd_ <= rd;
			sa_ <= sa;
			immediate_ <= immediate;
			pc_ <= pc;	
			state <= state + 1;
			valid <= 0;
			distinct__ <= distinct;
			AorF__ <= AorF;
			RegWrite__ <= RegWrite;
			MemtoReg__ <= MemtoReg;
			Branch__ <= Branch;
			MemWrite__ <= MemWrite;
			MemRead__ <= MemRead;
			UARTtoReg__ <= UARTtoReg;
			op2_sub__ <= op2_sub;
			inst_index__ <= inst_index;
			pc__ <= pc;
			pc1__ <= pc1;
		end else if (state == 1 && fpu_valid) begin
			distinct_next <= distinct__;
			AorF_next <= AorF___;
			RegWrite_next <= RegWrite__;
			MemtoReg_next <= MemtoReg__;
			Branch_next <= Branch__;
			MemWrite_next <= MemWrite__;
			MemRead_next <= MemRead__;
			UARTtoReg_next <= UARTtoReg__;
			register_data <= op2_sub__;
			inst_index_next <= inst_index__;
			pc_next <= pc__;
			pc1_next <= pc1__;
			result <= fpu_result;
			rdist <= rdist_;
			pc2 <= pc2_;
			valid <= 1;
			state <= 0;
			AorF_ <= 0;
			distinct__ <= 0;
		end else if (state == 2) begin
			distinct_next <= distinct__;
			AorF_next <= AorF__;
			RegWrite_next <= RegWrite__;
			MemtoReg_next <= MemtoReg__;
			Branch_next <= Branch__;
			MemWrite_next <= MemWrite__;
			MemRead_next <= MemRead__;
			UARTtoReg_next <= UARTtoReg__;
			register_data <= op2_sub__;
			inst_index_next <= inst_index__;
			pc_next <= pc__;
			pc1_next <= pc1__;
			pc2 <= pc2_;
			rdist <= rdist_;
			result <= alu_result;
			valid <= 1;
			state <= 0;
			distinct__ <= 0;
		end else begin
			distinct_next <= 0;
		end
		end
	end
endmodule
		
