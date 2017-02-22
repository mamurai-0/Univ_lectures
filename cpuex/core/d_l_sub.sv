//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/02/2017 04:23:47 PM
// Design Name: 
// Module Name: d_l_sub
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


module d_l_sub(
    input logic CLK,
    input logic UART_RX,
    output logic UART_TX,
    output logic led
    );
        //receiver and sender
    logic [7:0] receiver_data;
    logic [7:0] sender_data;
    logic receiver_valid;
    logic sender_enable;
    logic sender_ready;
	logic state = 0;

    receiver receiver_instance (
            CLK, 
            UART_RX, 
            receiver_data, 
            receiver_valid
    );
    sender sender_instance (
            CLK, 
            sender_data, 
            sender_enable, 
            UART_TX, 
            sender_ready
    );
 	   
 	assign led = receiver_data;
 	
    always_ff @(posedge CLK) begin
        if (state == 0 && receiver_valid) begin
			state <= 1;
		end else if (state == 1 && sender_ready) begin
            sender_data <= receiver_data;
    		sender_enable <= 1;
			state <= 0;
		end else begin
			sender_enable <= 0;
		end
    end     
endmodule
