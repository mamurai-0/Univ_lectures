module inst_decoder_test;
	logic [31:0] inst;
	logic [5:0] opcode;
	logic [4:0] rs;
	logic [4:0] rt;
	logic [4:0] rd;
	logic [4:0] sa;
	logic [5:0] funct;
	logic [15:0] immediate;
	logic [25:0] inst_index;

	localparam WAIT = 5000;

	inst_decoder inst_decoder_instance(
			inst,
			opcode,
			rs,
			rt,
			rd,
			sa,
			funct,
			immediate,
			inst_index
	);

    initial begin
		#WAIT;
		inst <= 32'h00c21004;
	end
endmodule
	
