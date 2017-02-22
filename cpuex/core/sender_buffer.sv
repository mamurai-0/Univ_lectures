module sender_buffer #(
	parameter BUFFER_SIZE = 32
) (
	input logic CLK,
	input logic reset,
	input logic [31:0] data,
	input logic start,
	input logic enable,
	input logic sender_ready,
	output logic [7:0] output_data,
	output logic valid,
	output logic ready
);
	logic [31:0] buffer [BUFFER_SIZE-1:0];
	logic [BUFFER_SIZE-1:0] head;
	logic [BUFFER_SIZE-1:0] tail;
	logic full;
	logic start_buffer;
	logic output_enable;
	integer state;
	integer state2;

	always_ff @(posedge CLK) begin
		if (reset) begin
			buffer <= '{default : 0};
			head <= 0;
			tail <= 0;
			full <= 0;
			start_buffer <= 0;
			output_enable <= 0;
			state <= 0;
			state2 <= 0;
			valid <= 0;
		end else begin
			if (start != start_buffer) begin
				start_buffer <= start;
			end
			if (head == tail && full) begin
				ready <= 0;
			end else begin
				ready <= 1;
			end
			if (enable && state == 0 && start_buffer) begin
				buffer[tail] <= data;
				tail <= tail + 1;
				state <= state + 1;
			end else if (state == 1) begin
				if (head == tail) begin
					full <= 1;
				end else begin
					full <= 0;
				end
				state <= state + 1;
				output_enable <= 1;
			end else if (state <= 10) begin
				state <= state + 1;
				output_enable <= 1;
			end else begin
				output_enable <= 0;
			end	
			if (((head != tail || !full) && state2 == 0) && output_enable) begin
				output_data <= buffer[head][31:24];
				valid <= 1;
				state2 <= state2 + 1;
			end else if (state2 == 1 && sender_ready) begin
				output_data <= buffer[head][23:16];
				state2 <= state2 + 1;
			end else if (state2 == 2 && sender_ready) begin
				output_data <= buffer[head][15:8];
				state2 <= state2 + 1;
			end else if (state2 == 3 && sender_ready) begin
				output_data <= buffer[head][7:0];
				state2 <= state2 + 1;
			end else if (state2 == 4) begin
				state2 <= 0;
				valid <= 0;
				head <= head + 1;
			end
		end
	end
endmodule
