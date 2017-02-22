module loopback (
	input logic CLK_P,
	input logic CLK_N,
	input logic UART_RX,
//	input logic sw_n_10,
//	input logic sw_c_7,
//	input logic sw_e_9,
//	input logic sw_s_8,
//	input logic sw_w_6,
//	input logic [3:0] sw,
	output logic UART_TX
//	output logic [7:0] led
);

	logic CLK;
	IBUFGDS IBUBFGDS_instance(.I(CLK_P), .IB(CLK_N), .O(CLK));
	
	logic [7:0] receiver_data;
	logic [7:0] sender_data;
	logic receiver_valid;
	logic sender_enable = 1;
	logic sender_ready;
	receiver receiver_instance(CLK, UART_RX, receiver_data, receiver_valid);
	sender sender_instance(CLK, sender_data, sender_enable, UART_TX, sender_ready);
	
	assign sender_data = receiver_data;
endmodule
