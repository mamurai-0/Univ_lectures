module pc_generator #(
	parameter INST_MEM_WIDTH = 2
)(
	input logic CLK,
	input logic reset,
	input logic [1:0] PCSrcs,
	input logic [INST_MEM_WIDTH-1:0] pc0, //JR
	input logic [INST_MEM_WIDTH-1:0] pc1, //J, JAL
	input logic [INST_MEM_WIDTH-1:0] pc2, //BEQ,BNE,default
	input logic [INST_MEM_WIDTH-1:0] pc3, //BEQ,BNE,default
	input logic enable,
	output logic [INST_MEM_WIDTH-1:0] pc
);
	always_ff @(posedge CLK) begin
		if (reset) begin
			pc <= 0;
		end else if (enable) begin
			case (PCSrcs)
				2'b00 : pc <= pc0;
				2'b01 : pc <= pc1;
				2'b10 : pc <= pc2;
				2'b11 : pc <= pc3;
			endcase
		end
	end
endmodule
	
