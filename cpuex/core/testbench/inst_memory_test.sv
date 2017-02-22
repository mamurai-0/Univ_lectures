module inst_memory_test #(
	parameter INST_MEM_WIDTH = 2
);
	logic CLK;
	logic reset;					
	logic [INST_MEM_WIDTH-1:0] pc;  
	logic [7:0] loader_data;		
	logic loader_enable;				
	logic [31:0] inst;
	logic loader_ready;				

	localparam WAIT = 5000;
	localparam CLK_ = 1;

	inst_memory #(INST_MEM_WIDTH) inst_memory_instance(
			CLK,
			reset,
			pc,
			loader_data,
			loader_enable,
			inst,
			loader_ready
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
		#WAIT;
		pc <= 0;
		loader_enable <= 0;
		#WAIT;
		loader_enable <= 1;
		#WAIT;
		loader_data <= 8'h04;
		loader_ready <= 1;
	    #CLK_;	
		loader_ready <= 0;
		#WAIT;
		loader_data <= 8'h10;
		loader_ready <= 1;
	    #CLK_;	
		loader_ready <= 0;
		#WAIT;
		loader_data <= 8'hc2;
		loader_ready <= 1;
	    #CLK_;	
		loader_ready <= 0;
		#WAIT;
		loader_data <= 8'h00;
		loader_ready <= 1;
	    #CLK_;	
		loader_ready <= 0;
		#WAIT;
		#WAIT;
		loader_data <= 8'h58;
		loader_ready <= 1;
	    #CLK_;	
		loader_ready <= 0;
		#WAIT;
		loader_data <= 8'h04;
		loader_ready <= 1;
	    #CLK_;	
		loader_ready <= 0;
		#WAIT;
		loader_data <= 8'h65;
		loader_ready <= 1;
	    #CLK_;	
		loader_ready <= 0;
		#WAIT;
		loader_data <= 8'h00;
		loader_ready <= 1;
	    #CLK_;	
		loader_ready <= 0;
		#WAIT;
		#WAIT;
		loader_enable <= 0;
	end
endmodule
	
