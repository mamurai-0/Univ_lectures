module inst_fetch_test #(
	parameter INST_MEM_WIDTH = 2
);
	logic CLK;
	logic reset;
	logic [INST_MEM_WIDTH-1:0] pc;
	logic [INST_MEM_WIDTH-1:0] pc1;
	logic [7:0] input_data; //program loader
	logic input_start; //program loader
	logic input_end; //program loader
	logic input_valid;//prorgram loader
	logic [31:0] inst;
	logic inst_enable;
	logic [INST_MEM_WIDTH-1:0] pc_next;
	logic [INST_MEM_WIDTH-1:0] pc1_next;

	logic [7:0] loader_data;
	logic loader_enable;
	logic loader_ready;
	
	localparam WAIT = 5000;
	localparam CLK_ = 1;

	inst_fetch #(INST_MEM_WIDTH) inst_fetch_instance(
		CLK,
		reset,
		pc,
		pc1,
		input_data,
		input_start,
		input_end,
		input_valid,
		inst,
		inst_enable,
		pc_next,
		pc1_next
	);

	always begin
		CLK <= 1;
		#0.5;
		CLK <= 0;
		#0.5;
	end
	
	initial begin
		#WAIT;
		reset <= 1;
		#WAIT;
		reset <= 0;
		pc <= 0;
		pc1 <= 1;
		#WAIT;
		input_start <= 1;
		#WAIT;
		input_start <= 0; 
		input_data <= 8'h04;
		input_valid <= 1;
		#CLK_;
		input_valid <= 0;
		#WAIT;	
		input_data <= 8'h10;
		input_valid <= 1;
		#CLK_;
		input_valid <= 0;
		#WAIT;
		input_data <= 8'hc2;
        input_valid <= 1;
        #CLK_;
        input_valid <= 0;
        #WAIT;
        input_data <= 8'h00;
        input_valid <= 1;
        #CLK_;
        input_valid <= 0;
		#WAIT;
		input_end <= 1;
		#WAIT;
		input_end <= 0;
    end
endmodule
