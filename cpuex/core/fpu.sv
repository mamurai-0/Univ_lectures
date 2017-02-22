module fpu (
//対応するALUOpが存在しない場合は現状維持をしてもらうため、iとfpu_resultのdefaultを消去した。
//各logic coreへの入力valid、出力readyを独立にするためにvalid_a,valid_b,ready_rを長さ7にした。
	input logic CLK,
	input logic reset,
	input logic distinct_,
	input logic AorF,
	input logic [3:0] ALUOp,
	input logic [31:0] op1,
	input logic [31:0] op2,
	output logic AorF_,
	output logic [31:0] fpu_result,
	output logic fpu_valid
);
	logic distinct;
	logic [1:0] state;
	logic [31:0] op1_;
	logic [31:0] op2_;
	logic [31:0] result_0;
	logic [31:0] result_1;
	logic [31:0] result_2;
	logic [31:0] result_3;
	logic [7:0] result_4;
	logic [7:0] result_5;
	logic [7:0] result_6;
	logic [6:0] ready_a;
	logic [6:0] ready_b;
	logic [6:0] ready_r;
	logic [6:0] valid_a;
	logic [6:0] valid_b;
	logic [6:0] valid_r;
	logic [2:0] i;
	logic areset;
	
	fadd fadd_instance(
		.s_axis_a_tdata(op1_),
		.s_axis_a_tready(ready_a[0]),
		.s_axis_a_tvalid(valid_a[0]),
		.s_axis_b_tdata(op2_),
		.s_axis_b_tready(ready_b[0]),
		.s_axis_b_tvalid(valid_b[0]),
		.aclk(CLK),
		.aresetn(areset),
		.m_axis_result_tdata(result_0),
		.m_axis_result_tready(ready_r[0]),
		.m_axis_result_tvalid(valid_r[0])
	);

	fsub fsub_instance(
		.s_axis_a_tdata(op1_),
		.s_axis_a_tready(ready_a[1]),
		.s_axis_a_tvalid(valid_a[1]),
		.s_axis_b_tdata(op2_),
		.s_axis_b_tready(ready_b[1]),
		.s_axis_b_tvalid(valid_b[1]),
		.aclk(CLK),
		.aresetn(areset),
		.m_axis_result_tdata(result_1),
		.m_axis_result_tready(ready_r[1]),
		.m_axis_result_tvalid(valid_r[1])
	);

	fmul fmul_instance(
		.s_axis_a_tdata(op1_),
		.s_axis_a_tready(ready_a[2]),
		.s_axis_a_tvalid(valid_a[2]),
		.s_axis_b_tdata(op2_),
		.s_axis_b_tready(ready_b[2]),
		.s_axis_b_tvalid(valid_b[2]),
		.aclk(CLK),
		.aresetn(areset),
		.m_axis_result_tdata(result_2),
		.m_axis_result_tready(ready_r[2]),
		.m_axis_result_tvalid(valid_r[2])
	);


	fdiv fdiv_instance(
		.s_axis_a_tdata(op1_),
		.s_axis_a_tready(ready_a[3]),
		.s_axis_a_tvalid(valid_a[3]),
		.s_axis_b_tdata(op2_),
		.s_axis_b_tready(ready_b[3]),
		.s_axis_b_tvalid(valid_b[3]),
		.aclk(CLK),
		.aresetn(areset),
		.m_axis_result_tdata(result_3),
		.m_axis_result_tready(ready_r[3]),
		.m_axis_result_tvalid(valid_r[3])
	);

	fceq fceq_instance(
		.s_axis_a_tdata(op1_),
		.s_axis_a_tready(ready_a[4]),
		.s_axis_a_tvalid(valid_a[4]),
		.s_axis_b_tdata(op2_),
		.s_axis_b_tready(ready_b[4]),
		.s_axis_b_tvalid(valid_b[4]),
		.aclk(CLK),
		.aresetn(areset),
		.m_axis_result_tdata(result_4),
		.m_axis_result_tready(ready_r[4]),
		.m_axis_result_tvalid(valid_r[4])
	);

	fcle fcle_instance(
		.s_axis_a_tdata(op1_),
		.s_axis_a_tready(ready_a[5]),
		.s_axis_a_tvalid(valid_a[5]),
		.s_axis_b_tdata(op2_),
		.s_axis_b_tready(ready_b[5]),
		.s_axis_b_tvalid(valid_b[5]),
		.aclk(CLK),
		.aresetn(areset),
		.m_axis_result_tdata(result_5),
		.m_axis_result_tready(ready_r[5]),
		.m_axis_result_tvalid(valid_r[5])
	);

	fclt fclt_instance(
		.s_axis_a_tdata(op1_),
		.s_axis_a_tready(ready_a[6]),
		.s_axis_a_tvalid(valid_a[6]),
		.s_axis_b_tdata(op2_),
		.s_axis_b_tready(ready_b[6]),
		.s_axis_b_tvalid(valid_b[6]),
		.aclk(CLK),
		.aresetn(areset),
		.m_axis_result_tdata(result_6),
		.m_axis_result_tready(ready_r[6]),
		.m_axis_result_tvalid(valid_r[6])
	);

	make_pulse make_pulse(
		.CLK(CLK),
		.reset(reset),
		.x(distinct_),
		.y(distinct)
	);

	always_comb begin
		if (AorF) begin
		case (ALUOp)
			4'b0011 : AorF_ <= 1;
			4'b0100 : AorF_ <= 1;
			4'b1110 : AorF_ <= 1;
			4'b1101 : AorF_ <= 1;
			4'b1100 : AorF_ <= 0;
			4'b1011 : AorF_ <= 0;
			4'b1010 : AorF_ <= 0;
			default : AorF_ <= 1;
		endcase
		end else begin
			AorF_ <= 0;
		end
	end

	always_ff @(posedge CLK) begin
		if (reset) begin
			areset <= 0;
			fpu_result <= 0;
			fpu_valid <= 0;
			state <= 0;
			op1_ <= 0;
			op2_ <= 0;
			ready_r <= 6'b111111;
			valid_a <= 6'b000000;
			valid_b <= 6'b000000;
			i <= 3'b111;
		end else begin
			if (state == 0 && AorF && distinct) begin
				state <= state + 1;
				case (ALUOp)
					4'b0011 : i <= 3'b000;
					4'b0100 : i <= 3'b001;
					4'b1110 : i <= 3'b010;
					4'b1101 : i <= 3'b011;
					4'b1100 : i <= 3'b100;
					4'b1011 : i <= 3'b101;
					4'b1010 : i <= 3'b110;
				endcase
				fpu_result <= 0;
			end else if (state == 1 && ready_a[i]) begin
				state <= state + 1;
				valid_a[i] <= 1;
				op1_ <= op1;
			end else if (state == 2 && ready_b[i]) begin
				valid_b[i] <= 1;
				state <= state + 1;
				op2_ <= op2;
				ready_r[i] <= 1;
			end else if (state == 3 && valid_r[i]) begin
				state <= state + 1;
				case (i)
					3'b000 : fpu_result <= result_0;
					3'b001 : fpu_result <= result_1;
					3'b010 : fpu_result <= result_2;
					3'b011 : fpu_result <= result_3;
					3'b100 : fpu_result <= {24'b000000000000000000000000, result_4};
					3'b101 : fpu_result <= {24'b000000000000000000000000, result_5};
					3'b110 : fpu_result <= {24'b000000000000000000000000, result_6};
					default : fpu_result <= result_0;
				endcase
				fpu_valid <= valid_r[i];
				valid_a[i] <= 0;
				valid_b[i] <= 0;
				ready_r[i] <= 0;
				areset <= 0;
			end else if (state == 4) begin
				areset <= 1;
				state <= 0;
			end else begin
				fpu_valid <= 0;
				areset <= 1;
			end
		end
	end
endmodule
