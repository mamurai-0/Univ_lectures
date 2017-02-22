module top #(  // todo : reset system
	parameter INST_MEM_WIDTH = 15
) (
	input logic CLK_P,
	input logic CLK_N,
	input logic UART_RX,
	input logic sw_n_10,
	input logic sw_c_7,
	input logic sw_s_8,
	output logic UART_TX,
	output logic [7:0] led
);
	//clk generate
	logic CLK_in;
	logic CLK;
	logic locked;
	IBUFGDS IBUBFGDS_instance(.I(CLK_P), .IB(CLK_N), .O(CLK_in));
	
	clk_wiz_0 clk_wiz_0_instance(
		.CLK_in(CLK_in),
		.CLK(CLK),
		.reset(1'b0),
		.locked(locked)
	);
	top_sub #(INST_MEM_WIDTH) top_sub_instance(
			CLK,
			UART_RX,
			sw_n_10,
			sw_c_7,
			sw_s_8,
			UART_TX,
			led
	);
endmodule
