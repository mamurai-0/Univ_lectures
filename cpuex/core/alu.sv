module alu (
	input logic [3:0] ALUOp,
	input logic [31:0] op1,
	input logic [31:0] op2,
	output logic [31:0] alu_result
);
	always_comb begin
		case (ALUOp)
			4'b0000 : alu_result <= op1 << op2;
			4'b0001 : alu_result <= op1 >> op2;
			4'b0010 : alu_result <= $signed(op1) >>> $signed(op2);
			4'b0011 : alu_result <= op1 + op2;
			4'b0100 : alu_result <= op1 - op2;
			4'b0101 : alu_result <= op1 & op2;
			4'b0110 : alu_result <= op1 | op2;
			4'b0111 : alu_result <= op1 ^ op2;
			4'b1000 : alu_result <= $signed(op1) < $signed(op2);
			4'b1001 : alu_result <= op1 == op2;
			4'b1010 : alu_result <= op1 != op2;
			default : alu_result <= 0;
		endcase
	end
endmodule
