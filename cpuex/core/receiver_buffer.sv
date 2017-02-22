module receiver_buffer(
	//little endian
	input logic CLK,
	input logic reset,
	input logic [7:0] data,
	input logic valid,
	input logic UARTtoReg,
	output logic [31:0] input_data,
	output logic ready
);
	localparam num = 10;
	logic [2:0] state;
	logic [1:0] state_;
	logic [31:0] buffer [2**num-1:0];
	logic [31:0] buffer_buf;
	integer i;
	integer head;
	integer tail;
	logic buffer_null;
	logic UARTtoReg_p;

	make_pulse make_pulse(
			.CLK(CLK),
			.reset(reset),
			.x(UARTtoReg),
			.y(UARTtoReg_p)
	);

	assign buffer_null = (tail == head);
	always_ff @(posedge CLK) begin
		if (reset) begin
			state <= 0;
			state_ <= 0;
			for (i=0; i<2**num; i=i+1) buffer[i] <= 0;
			buffer_buf <= 0;
			input_data <= 0;
			ready <= 0;
			head <= 0;
			tail <= 0;
		end else begin
		case (state)
			0 : begin
					if (valid) begin
						buffer_buf[31:24] <= data;
						state <= state + 1;
				    end
				end
			1 : begin
					if (valid) begin
						buffer_buf[23:16] <= data;
						state <= state + 1;
					end
				end
			2 : begin
					if (valid) begin
						buffer_buf[15:8] <= data;
						state <= state + 1;
					end
				end
			3 : begin
					if (valid) begin
						buffer_buf[7:0] <= data;
						state <= state + 1;
					end
				end
			4 : begin
					buffer[head] <= buffer_buf;
					state <= state + 1;
				end
			5 : begin
					head <= head + 1;
					state <= 0;
				end
		endcase

		if (state_ == 0 && UARTtoReg_p && !buffer_null) begin
			input_data <= buffer[tail];
			state_ <= 2;
		end else if (state_ == 0 && UARTtoReg_p && buffer_null) begin
			state_ <= 1; 
		end else if (state_ == 1 && !buffer_null) begin
			input_data <= buffer[tail];
			state_ <= 2;
		end else if(state_ == 2) begin
			tail <= tail + 1;
			ready <= 1;
			state_ <= 0;
		end else begin
			ready <= 0;
		end
		end
	end
endmodule
