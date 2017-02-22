module alu_test;
	logic [3:0] ALUOp;
	logic [31:0] op1;
	logic [31:0] op2;
	logic [31:0] alu_result;

	localparam WAIT = 5000;

	alu alu_instance(
			ALUOp,
			op1,
			op2,
			alu_result
	);

    initial begin
		#WAIT;// <<
		ALUOp <= 4'b0000;
		op1 <= 32'h00010100;
		op2 <= 32'h00000001;
		#WAIT;// >>
		ALUOp <= 4'b0001;
		op1 <= 32'h80010100;
		op2 <= 32'h00000001;
		#WAIT;// >>>
		ALUOp <= 4'b0010;
		op1 <= 32'h80010100;
		op2 <= 32'h00000001;
		#WAIT;// +
		ALUOp <= 4'b0011;
		op1 <= 32'h00000101;
		op2 <= 32'h00000001;
		#WAIT;// -
		ALUOp <= 4'b0100;
		op1 <= 32'h00000101;
		op2 <= 32'h00000001;
		#WAIT;// &
		ALUOp <= 4'b0101;
		op1 <= 32'h00000101;
		op2 <= 32'h00000001;
		#WAIT;// |
		ALUOp <= 4'b0110;
		op1 <= 32'h00000101;
		op2 <= 32'h11100001;
		#WAIT;// ^
		ALUOp <= 4'b0111;
		op1 <= 32'h00000101;
		op2 <= 32'h00000001;
		#WAIT;// < No
		ALUOp <= 4'b1000;
		op1 <= 32'h00000101;
		op2 <= 32'h00000001;
		#WAIT;// < No
		ALUOp <= 4'b1000;
		op1 <= 32'h00000101;
		op2 <= 32'h81000001;
		#WAIT;// < Yes
		ALUOp <= 4'b1000;
		op1 <= 32'h00000101;
		op2 <= 32'h00110001;
		#WAIT;// == No
		ALUOp <= 4'b1001;
		op1 <= 32'h00000101;
		op2 <= 32'h00000001;
		#WAIT;// == Yes
		ALUOp <= 4'b1001;
		op1 <= 32'h00000101;
		op2 <= 32'h00000101;
		#WAIT;// !=
		ALUOp <= 4'b1010;
		op1 <= 32'h00000101;
		op2 <= 32'h00000001;
		#WAIT;
	end
endmodule
	
