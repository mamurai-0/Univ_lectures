//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/02/2017 04:16:17 PM
// Design Name: 
// Module Name: d_l_test
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

module d_l_test;
    logic CLK;
	logic UART_RX;
	logic UART_TX;

	d_l_sub d_l_sub(
	   CLK,
	   UART_RX,
	   UART_TX
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
		#7000;
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

		end
		end	
endmodule
