module sender_buffer2 (
	input logic CLK,
	input logic reset,
	input logic [31:0] data,
	input logic start,
	input logic sender_ready,
	output logic [7:0] output_data,
	output logic full,
	output logic valid
);
	localparam num = 5;

	logic [32:0] buffer [2**num-1:0];
	logic [num-1:0] tail;
	logic [num-1:0] head;
	logic state;
	logic [2:0] state_;
	logic buf_full;
	logic buf_null;
	logic [31:0] register;
	integer i;

	assign buf_full = (tail == head) & buffer[tail][32];
	assign buf_null = (tail == head) & (!buffer[tail][32]);

	always_ff @(posedge CLK) begin
		if (reset) begin
			output_data <= 0;
			full <= 0;
			valid <= 0;
			for (i = 0; i < 2**num; i = i + 1) buffer[i] <= 0;
			tail <= 0;
			head <= 0;
			state <= 0;
			state_ <= 0;
			register <= 0;
		end else begin

			if ((state == 0) && start) begin
				if (!buf_full) begin
					buffer[tail] <= {1'b1, data};
					tail = tail + 1;
				end else begin
					state <= state + 1;
					register <= data;
					full <= 1;
				end
			end else if ((state == 1) && (!buf_full)) begin
				buffer[tail] <= {1'b1, register};
				tail <= tail + 1;
				full <= 0;
				state <= 0;
			end

			if ((state_ == 0) && sender_ready && (!buf_null)) begin
				output_data <= buffer[head][31:24];
				state_ <= state_ + 1;
				valid <= 1;
			end else if ((state_ == 1) && sender_ready) begin
				output_data <= buffer[head][23:16];
				state_ <= state_ + 1;
			end else if ((state_ == 2) && sender_ready) begin
				output_data <= buffer[head][15:8];
				state_ <= state_ + 1;
			end else if ((state_ == 3) && sender_ready) begin
				output_data <= buffer[head][7:0];
				state_ <= state_ + 1;
			end else if ((state_ == 4) && sender_ready) begin
				state_ <= 0;
				buffer[head][32] <= 0;
				valid <= 0;
				head = head + 1;
			end
		end
	end
endmodule

