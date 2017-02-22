module register (
	input logic CLK,
	input logic reset,
	input logic distinct,
	input logic AorF,
	input logic AorF_before,
	input logic RegWrite,
	input logic UART_write_enable,
	input logic MemWrite,
	input logic MemRead,
	input logic [4:0] rs,
	input logic [4:0] rt,
	input logic [4:0] rd,
	input logic [4:0] rw,
	input logic [31:0] write_data,
	output logic [31:0] op1_sub,
	output logic [31:0] op2_sub
);
	logic [31:0] r [31:0];
	logic [31:0] f [31:0];
	logic buffer;
    integer i;
    
	always_ff @(posedge CLK) begin
		if (reset) begin
			op1_sub <= 0;
			op2_sub <= 0;
			buffer <= 0;
			for (i = 0; i < 32; i = i + 1) begin
				r[i] <= 0;
				f[i] <= 0;
			end
		end else begin
			if (AorF && (MemWrite || MemRead)) begin
				op1_sub <= r[rs];
				op2_sub <= f[rt];
			end else if (AorF) begin
				op1_sub <= f[rd];
				op2_sub <= f[rt];
			end else begin
				op1_sub <= r[rs];
				op2_sub <= r[rt];
			end
			if ((RegWrite && (distinct != buffer)) || (UART_write_enable && distinct)) begin
				if (AorF_before) begin
					f[rw] <= write_data;
				end else begin
					r[rw] <= write_data;
				end
				buffer <= distinct;
			end
		end
	end
endmodule
