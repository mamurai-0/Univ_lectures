module register_write #(
	parameter INST_MEM_WIDTH = 2
) (
	input logic CLK,
	input logic reset,
	input logic distinct,
	input logic [1:0] MemtoReg,
	input logic UARTtoReg,
	input logic [31:0] read_data,
	input logic [31:0] alu_result,
	input logic [INST_MEM_WIDTH-1:0] pc,
	input logic [31:0] input_data,
	input logic input_ready,
	output logic UART_write_enable,
	output logic pc_enable,
	output logic [31:0] data
);
	logic UARTtoReg_buf;
	logic [1:0] state;

	always_ff @(posedge CLK) begin
		if (reset) begin
			UART_write_enable <= 0;
			pc_enable <= 1;
			data <= 0;
			UARTtoReg_buf <= 0;
			state <= 0;
		end else begin
			if ((state == 0) && (MemtoReg == 2'b01)) begin
				if (!UARTtoReg) data <= read_data;
			end else if ((state == 0) && (MemtoReg == 2'b10)) begin
				if (!UARTtoReg) data <= alu_result;
			end else if ((state == 0) && (MemtoReg == 2'b11)) begin 
				if (!UARTtoReg) data <= pc + 1;//dataとpcの長さが違うが大丈夫か？
			end else if ((state == 0) && (UARTtoReg != UARTtoReg_buf) && UARTtoReg && !input_ready) begin
				state <= state + 1;
				UARTtoReg_buf <= UARTtoReg;
				UART_write_enable <= 0;
				pc_enable <= 0;
			end else if ((state == 0) && (UARTtoReg != UARTtoReg_buf) && !UARTtoReg) begin
				UARTtoReg_buf <= UARTtoReg;
			end else if ((state == 1) && UARTtoReg_buf && input_ready) begin
				data <= input_data;
				UART_write_enable <= 1;
				UARTtoReg_buf <= 0;
				pc_enable <= 1;
				state <= state + 1;
			end else if ((state == 1) && UARTtoReg_buf && !input_ready) begin
				UART_write_enable <= 0;
				pc_enable <= 0;
			end else if ((state == 2) && distinct) begin
				state <= 0;
				UART_write_enable <= 0;
			end
		end	
	end
endmodule
