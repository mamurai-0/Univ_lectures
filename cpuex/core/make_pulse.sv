module make_pulse(
	input logic CLK,
	input logic reset,
	input logic x,
	output logic y
);
	logic [1:0] state;

	always_ff @(posedge CLK) begin
		if (reset) begin
			state <= 0;
			y <= 0;
		end else begin
			if (state == 0 && x == 1) begin
				y <= 1;
				state <= 1;
			end else if (state == 1) begin
				y <= 0;
				state <= 2;
			end else if (state == 2 && x == 0) begin
				state <= 0;
			end
		end
	end
endmodule

