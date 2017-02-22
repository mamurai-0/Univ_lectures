module d_l(
    input logic CLK_P,
    input logic CLK_N,
	input logic UART_RX,
    output logic UART_TX,
    output logic [7:0] led
);
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
    
    d_l_sub d_l_sub(
        CLK,
        UART_RX,
        UART_TX,
        led
    );
endmodule

