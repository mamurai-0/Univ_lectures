module test_minrt #(
	parameter INST_MEM_WIDTH = 15
);
    logic CLK;
	logic UART_RX;
	logic sw_n_10;
	logic sw_c_7;
//	logic sw_e_9;
	logic sw_s_8;
//	logic sw_w_6;
//	logic [3:0] sw;
	logic UART_TX;
	logic [7:0] led;

	top_sub #(INST_MEM_WIDTH) top_sub_instance(
			CLK,
			UART_RX,
			sw_n_10,
			sw_c_7,
//			sw_e_9,
			sw_s_8,
//			sw_w_6,
//			sw,
			UART_TX,
			led
	);
	localparam WAIT = 1992;
//	localparam LONG_WAIT = 100000;
	localparam CLK_ = 1;
	always begin
		CLK <= 1;
		#0.5;
		CLK <= 0;
		#0.5;
	end

	integer i, fp, status;
	logic [7:0] buffer;
	initial begin
		fp = $fopen("/home/tansei/Documents/3a/cpuEX/cpuEX/srcs/s_and_coe/contest.txt", "r");
		#1;
		UART_RX <= 1;
		sw_n_10 <= 0;
		sw_s_8 <= 0;
		#7000;
		sw_c_7 <= 1;
		#WAIT;
		sw_c_7 <= 0;
		#WAIT;
		if (fp != 0) begin
			while (!$feof(fp)) begin
				#1;
				status = $fscanf(fp, "%8b\n", buffer);
 				#WAIT;
				UART_RX <= 0;
 				#WAIT;
				UART_RX <= buffer[7];
 				#WAIT;
				UART_RX <= buffer[6];
 				#WAIT;
				UART_RX <= buffer[5];
 				#WAIT;
				UART_RX <= buffer[4];
 				#WAIT;
				UART_RX <= buffer[3];
 				#WAIT;
				UART_RX <= buffer[2];
 				#WAIT;
				UART_RX <= buffer[1];
 				#WAIT;
				UART_RX <= buffer[0];
				#WAIT;
				UART_RX <= 1;
			end
		end
	end
endmodule
