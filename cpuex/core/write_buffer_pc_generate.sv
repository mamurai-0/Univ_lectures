module write_buffer_pc_generate #(
	parameter INST_MEM_WIDTH = 5
) (
	input logic CLK,
	input logic reset,
	input logic distinct,
	input logic AorF,
	input logic RegWrite,
	input logic [1:0] MemtoReg,
	input logic [1:0] Branch,
	input logic UARTtoReg,
	input logic [31:0] read_data,
	input logic [31:0] register_data,
	input logic [31:0] alu_result,
	input logic [4:0] rd,
	input logic [25:0] inst_index,
	input logic [INST_MEM_WIDTH-1:0] pc,
	input logic [INST_MEM_WIDTH-1:0] pc1,
	input logic [INST_MEM_WIDTH-1:0] pc2,
	input logic input_ready,
	input logic [31:0] input_data,
	output logic distinct_next,
	output logic AorF_next,
	output logic RegWrite_next,
	output logic UART_write_enable,
	output logic [31:0] data,
	output logic [4:0] rd_next,
	output logic [INST_MEM_WIDTH-1:0] pc_generated,
	output logic [INST_MEM_WIDTH-1:0] pc1_next
);
	logic pc_enable;
	logic [1:0] PCSrcs;
	logic [1:0] Branch_buf;
	logic [31:0] register_data_buf;
	logic [31:0] alu_result_buf;
	logic [25:0] inst_index_buf;
	logic [INST_MEM_WIDTH-1:0] pc1_buf;
	logic [INST_MEM_WIDTH-1:0] pc2_buf;
	logic distinct_;
	logic AorF_;
	logic RegWrite_;
	logic [4:0] rd_;
	logic state;
	logic UARTtoReg_;

	branch branch_instance(
		Branch_buf, 
		alu_result_buf, 
		PCSrcs
	);
	register_write #(INST_MEM_WIDTH) register_write_instance(
		CLK, 
		reset, 
		distinct, 
		MemtoReg, 
		UARTtoReg,
		read_data, 
		alu_result, 
		pc, 
		input_data, 
		input_ready, 
		UART_write_enable, 
		pc_enable, 
		data
	);
	pc_generator #(INST_MEM_WIDTH) pc_generator_instance(
		CLK, 
		reset, 
		PCSrcs, 
		register_data_buf[INST_MEM_WIDTH-1:0], 
		inst_index_buf[INST_MEM_WIDTH-1:0], 
		pc2_buf, 
		pc1_buf, 
		pc_enable, 
		pc_generated
	);
	pc_adder #(INST_MEM_WIDTH) pc_adder_instance(
		pc_generated, 
		1, 
		pc1_next
	);

	always_ff @(posedge CLK) begin
		if (reset) begin
			distinct_next <= 1;
			AorF_next <= 0;
			RegWrite_next <= 0;
			Branch_buf <= 2'b11;
			register_data_buf <= 0;
			alu_result_buf <= 0;
			rd_next <= 0;
			inst_index_buf <= 0;
			pc1_buf <= 0;
			pc2_buf <= 0;
			state <= 0;
			distinct_ <= 0;
			AorF_ <= 0;
			RegWrite_ <= 0;
		end else begin
			if (state == 0 && distinct) begin
				distinct_ <= distinct;
				AorF_ <= AorF;
				RegWrite_ <= RegWrite;
				Branch_buf <= Branch;
				rd_ <= rd;
				register_data_buf <= register_data;
				alu_result_buf <= alu_result;
				inst_index_buf <= inst_index;
				pc1_buf <= pc1;
				pc2_buf <= pc2;
				state <= state + 1;
				distinct_next <= 0;
				UARTtoReg_ <= UARTtoReg;
			end else if (state == 1 && !UARTtoReg_)  begin
				rd_next <= rd_;
				distinct_next <= distinct_;
				AorF_next <= AorF_;
				RegWrite_next <= RegWrite_;
				state <= 0;
			end else if ((state == 1 && UARTtoReg_) && UART_write_enable) begin
				rd_next <= rd_;
                distinct_next <= distinct_;
                AorF_next <= AorF_;
                RegWrite_next <= RegWrite_;
                state <= 0;			     
			end else begin
				distinct_next <= 0;
			end
		end
	end
endmodule
	
