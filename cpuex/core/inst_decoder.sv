module inst_decoder(
	input logic [31:0] inst,
	output logic [5:0] opcode,
	output logic [4:0] rs,
	output logic [4:0] rt,
	output logic [4:0] rd,
	output logic [4:0] sa,
	output logic [5:0] funct,
	output logic [15:0] immediate,
	output logic [25:0] inst_index
);
	always_comb begin
		opcode <= inst[31:26];
		rs <= inst[25:21];
		rt <= inst[20:16];
		rd <= inst[15:11];
		sa <= inst[10:6];
		funct <= inst[5:0];
		immediate <= inst[15:0];
		inst_index <= inst[25:0];
	end
endmodule

