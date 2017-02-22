module receiver #(
	parameter COUNT_WIDTH = 10,//11,//10,//4,//11,
	parameter COUNT_MAX = 10'd995//11'd1298//10'd537//4'd13//11'd1301  // 300000000/115200/2 = 1302.0833333333333
) (
	input logic CLK,
	input logic in,
	output logic[7:0] out,
	output logic valid
);
	logic buffer = 1;
	logic[COUNT_WIDTH-1:0] count_half_period = 0;
	logic receiving = 1'b0;
	logic[3:0] state = 4'b0000;  /* 0001->0010->receiving->0100->1000 */
	logic [7:0] out_sub;

	assign out[0] = out_sub[0];
	assign out[1] = out_sub[1];
	assign out[2] = out_sub[2];
	assign out[3] = out_sub[3];
	assign out[4] = out_sub[4];
	assign out[5] = out_sub[5];
	assign out[6] = out_sub[6];
	assign out[7] = out_sub[7];

	always_comb begin
		if (receiving && state == 4'b1111 && count_half_period == 0) begin
			valid <= 1;
		end else begin
			valid <= 0;
		end
	end

	always_ff @(posedge CLK) begin
		buffer <= in;
		if (!{receiving, state} && !buffer) begin
			state <= 4'b0001;
		end

		if (count_half_period == COUNT_MAX) begin
			count_half_period <= 0;
			if (receiving) begin
				if (state == 4'b1111) begin
					receiving <= 0;
					state <= 4'b0100;
				end else begin
					state <= state + 1;
					if (!state[0]) begin
						out_sub[state[3:1]] <= buffer;
					end
				end
			end else begin
				if (state[1]) begin
					receiving <= 1;
					state <= 4'b0000;
				end else if (state[3]) begin
					state <= 4'b0000;
				end else begin
					state[0] <= state[3];
					state[1] <= state[0];
					state[2] <= state[1];
					state[3] <= state[2];
				end
			end
		end else begin
			if ({receiving, state}) begin
				count_half_period <= count_half_period + 1;
			end
		end
	end
endmodule
