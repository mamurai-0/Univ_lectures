module test_top #(
	parameter INST_MEM_WIDTH = 14
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
	localparam WAIT = 271.3;
	localparam CLK_ = 1;
	always begin
		CLK <= 1;
		#0.5;
		CLK <= 0;
		#0.5;
	end

	integer i;
	logic buffer;
	initial begin
		#1;
		UART_RX <= 1;
		sw_n_10 <= 0;
		sw_s_8 <= 0;
		#7000;
		sw_c_7 <= 1;
		#WAIT;
		sw_c_7 <= 0;
		#WAIT;
		
		for (i=0; i<100; i=i+1) begin
		UART_RX <= 0;
		#WAIT;		
		UART_RX <= 1;
		#WAIT;
		UART_RX <= 0;
		#WAIT;
		UART_RX <= 1;
		#WAIT;
		UART_RX <= 0;
		#WAIT;
		UART_RX <= 1;
		#WAIT;
		UART_RX <= 0;
		#WAIT;
		UART_RX <= 1;
		#WAIT;
		UART_RX <= 0;
		#WAIT;
		UART_RX <= 1;
		#WAIT;
		#WAIT;
		UART_RX <= 0;
        #WAIT;
        UART_RX <= 1;
        #WAIT;
        UART_RX <= 1;
        #WAIT;
        UART_RX <= 1;
        #WAIT;
        UART_RX <= 1;
        #WAIT;
        UART_RX <= 1;
        #WAIT;
        UART_RX <= 1;
        #WAIT;
        UART_RX <= 1;
        #WAIT;
        UART_RX <= 1;
        #WAIT;
        UART_RX <= 1;																				
		#WAIT;
		#WAIT;
		UART_RX <= 0;
        #WAIT;
        UART_RX <= 0;
        #WAIT;
        UART_RX <= 0;
        #WAIT;
        UART_RX <= 0;
        #WAIT;
        UART_RX <= 0;
        #WAIT;
        UART_RX <= 0;
        #WAIT;
        UART_RX <= 0;
        #WAIT;
        UART_RX <= 0;
        #WAIT;
        UART_RX <= 0;
        #WAIT;
        UART_RX <= 1;
        #WAIT;
		#WAIT;
		UART_RX <= 0;
        #WAIT;
		UART_RX <= 0;
		#WAIT;
        UART_RX <= 1;
        #WAIT;
        UART_RX <= 0;
        #WAIT;
        UART_RX <= 1;
        #WAIT;
        UART_RX <= 0;
        #WAIT;
        UART_RX <= 1;
        #WAIT;
        UART_RX <= 0;
        #WAIT;
        UART_RX <= 1;
        #WAIT;
        UART_RX <= 1;        		
		#WAIT;
		end
		end	
endmodule
