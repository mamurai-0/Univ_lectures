module register_test;
	logic RegWrite;
	logic UART_write_enable;
	logic [4:0] rs;
	logic [4:0] rt;
	logic [4:0] rw;
	logic [31:0] write_data;
	logic reset;
	logic [31:0] op1_sub;
	logic [31:0] op2_sub;

	localparam WAIT = 5000;

	register register_instance(
			RegWrite,
			UART_write_enable,
			rs,
			rt,
			rw,
			write_data,
			reset,
			op1_sub,
			op2_sub
	);

	initial begin
		#WAIT;
		reset <= 1;
		RegWrite <= 0;
		UART_write_enable <= 0;
		#WAIT;
		rw <= 5'b00001;
		write_data <= 32'h10101010;
		#WAIT;
		RegWrite <= 1;
		#WAIT;
		rs <= 5'b00001;
		rw <= 5'b00010;
		#WAIT;
		rt <= 5'b00010;
		#WAIT;
		RegWrite <= 0;
		rw <=5'b00011;
		#WAIT;
		UART_write_enable <= 1;
	end
endmodule
