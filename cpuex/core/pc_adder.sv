module pc_adder #(
	parameter INST_MEM_WIDTH = 2
) (
	input logic [INST_MEM_WIDTH-1:0] in1,
	input logic [INST_MEM_WIDTH-1:0] in2,
	output logic [INST_MEM_WIDTH-1:0] out
);
	always_comb begin
		out <= in1 + in2;
	end
endmodule
