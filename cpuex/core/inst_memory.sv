module inst_memory #( //前提：loader_readyは一瞬しか上がらない
	parameter INST_MEM_WIDTH = 15
) (
	input logic CLK,
	input logic reset,
	input logic [INST_MEM_WIDTH-1:0] pc,
	output logic [31:0] inst,
	output logic distinct
);
	logic [INST_MEM_WIDTH-1:0] pc_buffer;
	logic distinct_;
	logic [2:0] state;
	logic rere;

	inst_mem_bl inst_mem_bl(
			.addra(pc),
			.clka(CLK),
			.dina(32'h08000000),
			.douta(inst),
			.ena(1'b1),
			.wea(1'b0)
	);

	always_ff @(posedge CLK) begin
		if (reset) begin
			pc_buffer <= 0;
			distinct_ <= 0;
			distinct <= 0;
			state <= 0;
			rere <= 1;
		end else begin
			rere <= 0;
			if (state == 0 && ((pc != pc_buffer) || rere)) begin
				distinct_ <= 1;
				pc_buffer <= pc;
				state <= state + 1;
			end else if (state == 1) begin
				distinct <= distinct_; 
				state <= 0;
			end else begin
				distinct <= 0;
				distinct_ <= 0;
			end
		end
	end
endmodule
