module inst_fetch_and_decode #(
	parameter INST_MEM_WIDTH
) (
	input logic CLK, 
	input logic reset,
	input logic distinct_before,
	input logic full,
	input logic [INST_MEM_WIDTH-1:0] pc,
	input logic [INST_MEM_WIDTH-1:0] pc1,
	input logic input_start,
	input logic input_end,
	output logic distinct,
	output logic AorF,
 	output logic RegWrite,
	output logic [1:0] MemtoReg,
	output logic [1:0] ALUSrcs,
	output logic ALUSrcs2,
	output logic [3:0] ALUOp,
	output logic [1:0] RegDist,
	output logic [1:0] Branch,
	output logic MemWrite,
	output logic MemRead,
	output logic UARTtoReg,
	output logic RegtoUART,
	output logic [4:0] rs,
	output logic [4:0] rt,
	output logic [4:0] rd,
	output logic [4:0] sa,
	output logic [15:0] immediate,
	output logic [25:0] inst_index,
	output logic [INST_MEM_WIDTH-1:0] pc_next,
	output logic [INST_MEM_WIDTH-1:0] pc1_next
);
	logic [31:0] inst_;
    logic distinct_;
    logic [INST_MEM_WIDTH-1:0] pc_;
    logic [INST_MEM_WIDTH-1:0] pc1_;
    logic [2:0] state;
	logic [31:0] inst__;
	logic distinct__;

	inst_memory #(INST_MEM_WIDTH) inst_memory_instance(
	       CLK, 
	       reset, 
	       pc, 
	       inst_, 
		   distinct_
	);
	
	logic [5:0] opcode;
	logic [5:0] funct;
	logic [31:0] inst_;
	logic distinct_;
	logic [INST_MEM_WIDTH-1:0] pc_;
	logic [INST_MEM_WIDTH-1:0] pc1_;
	logic state;
	inst_decoder inst_decoder_instance(
			inst, 
			opcode, 
			rs, 
			rt, 
			rd, 
			sa,
			funct, 
			immediate, 
			inst_index
	);
	operator operator_instamce(
			opcode, 
			funct, 
			AorF,
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
			RegtoUART
	);
	
	always_ff @(posedge CLK) begin
		if (reset) begin //initialize
			pc_next <= 0;
			pc1_next <= 0;
			inst_enable <= 1;
			pc_ <= 0;
			pc1_ <= 1;
			inst <= 0;
			distinct <= 0;
			state <= 1;
			inst__ <= 0;
			distinct__ <= 0;
		end else begin
			if (state == 0 && distinct_before) begin
				pc <= pc;
				pc1_ <= pc1;
				state <= state + 1;
				distinct <= 0;
			end else if (state == 1) begin
				state <= 3;
//				state <= state + 1;
//			end else if (state == 2) begin
//				state <= state + 1;
			end else if (state == 3 && (!full)) begin
				inst <= inst_;
				distinct <= distinct_;
				pc_next <= pc_;
				pc1_next <= pc1_;
				state <= 0;
			end else if (state == 3 && full) begin
				inst__ <= inst_;
				distinct__ <= distinct_;
				state <= state + 1;
			end else if (state == 4 && (!full)) begin
				inst <= inst__;
				distinct <= distinct__;
				pc_next <= pc_;
				pc1_next <= pc1_;
				state <= 0;
			end else begin
				distinct <= 0;
			end
		end
	end
endmodule

