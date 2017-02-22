module data_memory (
	input logic CLK,
	input logic reset,
	input logic distinct,
	input logic [31:0] address,
	input logic [31:0] write_data,
	input logic MemWrite,
	output logic [31:0] read_data,
	input logic MemRead
);
	logic enable;
	logic w_enable;

	data_mem_bl data_mem_bl(
		.addra(address[17:0]),
		.clka(CLK),
		.dina(write_data),
		.douta(read_data),
		.ena(enable),
		.wea(w_enable)
	);

	assign enable = (MemWrite | MemRead);
	assign w_enable = MemWrite & (!MemRead) & distinct;
endmodule

