module memory_access #(
	parameter INST_MEM_WIDTH = 5
) (
	input logic CLK,
	input logic reset,
	input logic distinct,
	input logic AorF,
	input logic AorF_result,
 	input logic RegWrite,
	input logic [1:0] MemtoReg,
	input logic [1:0] Branch,
	input logic MemWrite,
	input logic MemRead,
	input logic UARTtoReg,
	input logic [31:0] register_data,
	input logic [31:0] alu_result,
	input logic [31:0] fpu_result,
	input logic valid,
	input logic [4:0] rdist,
	input logic [25:0] inst_index,
	input logic [INST_MEM_WIDTH-1:0] pc,
	input logic [INST_MEM_WIDTH-1:0] pc1,
	input logic [INST_MEM_WIDTH-1:0] pc2,
	output logic distinct_next,
	output logic AorF_next,
 	output logic RegWrite_next,
	output logic [1:0] MemtoReg_next,
	output logic [1:0] Branch_next,
	output logic UARTtoReg_next,
	output logic [31:0] read_data,
	output logic [31:0] register_data_next,
	output logic [31:0] alu_result_next,
	output logic [4:0] rdist_next,
	output logic [25:0] inst_index_next,
	output logic [INST_MEM_WIDTH-1:0] pc_next,
	output logic [INST_MEM_WIDTH-1:0] pc1_next,
	output logic [INST_MEM_WIDTH-1:0] pc2_next
);
	logic [1:0] state;
	logic distinct_;
	logic AorF_;
	logic RegWrite_;
	logic [1:0] MemtoReg_;
	logic [1:0] Branch_;
	logic UARTtoReg_;
	logic [31:0] register_data_;
	logic [31:0] alu_result_;
	logic [4:0] rdist_;
	logic [25:0] inst_index_;
	logic [INST_MEM_WIDTH-1:0] pc_;
	logic [INST_MEM_WIDTH-1:0] pc1_;
	logic [INST_MEM_WIDTH-1:0] pc2_;
	logic [31:0] read_data_;
	logic [31:0] result;

	data_memory data_memory_instance(
		CLK, 
		reset, 
		distinct, 
		result, 
		register_data, 
		MemWrite, 
		read_data_, 
		MemRead
	);

	always_comb begin
		if (AorF_result) 
			result <= fpu_result;
		else	
			result <= alu_result;
	end

	always_ff @(posedge CLK) begin
		if (reset) begin
			distinct_next <= 0;
			AorF_next <= 0;
			RegWrite_next <= 0;
			MemtoReg_next <= 2'b00;
			Branch_next <= 2'b00;
			UARTtoReg_next <= 0;
			register_data_next <= 0;
			alu_result_next <= 0;
			rdist_next <= 0;
			inst_index_next <= 0;
			pc_next <= 0;
			pc1_next <= 0;
			pc2_next <= 0;
			state <= 0;
			distinct_ <= 0;
			AorF_ <= 0;
			RegWrite_ <= 0;
			MemtoReg_ <= 0;
			Branch_ <= 0;
			UARTtoReg_ <= 0;
			register_data_ <= 0;
			alu_result_ <= 0;
			rdist_ <= 0;
			inst_index_ <= 0;
			pc_ <= 0;
			pc1_ <= 0;
			pc2_ <= 0;
		end else begin
			if (!MemWrite && !MemRead && distinct) begin
				distinct_next <= distinct;
				AorF_next <= AorF;
				RegWrite_next <= RegWrite;
				MemtoReg_next <= MemtoReg;
				Branch_next <= Branch;
				UARTtoReg_next <= UARTtoReg;
				register_data_next <= register_data;
				alu_result_next <= result;
				rdist_next <= rdist;
				inst_index_next <= inst_index;
				pc_next <= pc;
				pc1_next <= pc1;
				pc2_next <= pc2;
			end else if (state == 0 && valid && distinct) begin
				state <= state + 1;
				distinct_ <= distinct;
				AorF_ <= AorF;
				RegWrite_ <= RegWrite;
				MemtoReg_ <= MemtoReg;
				Branch_ <= Branch;
				UARTtoReg_ <= UARTtoReg;
				register_data_ <= register_data;
				alu_result_ <= result;
				rdist_ <= rdist;
				inst_index_ <= inst_index;
				pc_ <= pc;
				pc1_ <= pc1;
				pc2_ <= pc2;
				distinct_next <= 0;
			end else if (state == 1) begin
				state <= state + 1;
			end else if (state == 2) begin
				state <= 0;
				distinct_next <= distinct_;
				AorF_next <= AorF_;
				RegWrite_next <= RegWrite_;
				MemtoReg_next <= MemtoReg_;
				Branch_next <= Branch_;
				UARTtoReg_next <= UARTtoReg_;
				register_data_next <= register_data_;
				alu_result_next <= alu_result_;
				rdist_next <= rdist_;
				inst_index_next <= inst_index_;
				pc_next <= pc_;
				pc1_next <= pc1_;
				pc2_next <= pc2_;
				read_data <= read_data_;
			end else begin
				distinct_next <= 0;
			end
		end
	end
endmodule
