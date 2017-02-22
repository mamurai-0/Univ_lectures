module op1_sel (
	input logic ALUSrcs2,
	input logic [31:0] op_rs,
	input logic [31:0] op_rt,
	output logic [31:0] op1
);
	always_comb begin
		if (ALUSrcs2) begin
			op1 <= op_rs;
		end else begin
			op1 <= op_rt;
		end
	end
endmodule

