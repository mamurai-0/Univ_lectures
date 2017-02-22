module op2_sel(
	input logic [1:0] ALUSrcs,
	input logic [31:0] op2_sub,
	input logic [4:0] sa,
	input logic [15:0] immediate,
	output logic [31:0] op2
);
	always_comb begin
		case (ALUSrcs)
			2'b00 : op2 <= op2_sub;
			2'b01 : op2 <= {27'b000000000000000000000000000, sa};
			2'b10 : op2 <= {{16{immediate[15]}}, immediate};
//			2'b11 : op2 <= {16'h0000, immediate};
			2'b11 : op2 <= {{16{immediate[15]}}, immediate};
			default : op2 <= 0;
		endcase
	end
endmodule

