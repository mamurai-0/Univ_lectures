module memory_access_test #(
	parameter INST_MEM_WIDTH = 2,
	parameter DATA_MEM_WIDTH = 3
);

	logic CLK;
	logic reset;
 	logic RegWrite;
	logic [1:0] MemtoReg;
	logic [1:0] Branch;
	logic MemWrite;
	logic MemRead;
	logic UARTtoReg;
	logic [31:0] register_data;
	logic [31:0] alu_result;
	logic [4:0] rdist;
	logic [25:0] inst_index;
	logic [INST_MEM_WIDTH-1:0] pc;
	logic [INST_MEM_WIDTH-1:0] pc1;
	logic [INST_MEM_WIDTH-1:0] pc2;
 	logic RegWrite_next;
	logic [1:0] MemtoReg_next;
	logic [1:0] Branch_next;
	logic UARTtoReg_next;
	logic [31:0] read_data;
	logic [31:0] register_data_next;
	logic [31:0] alu_result_next;
	logic [4:0] rdist_next;
	logic [25:0] inst_index_next;
	logic [INST_MEM_WIDTH-1:0] pc_next;
	logic [INST_MEM_WIDTH-1:0] pc1_next;
	logic [INST_MEM_WIDTH-1:0] pc2_next;

	localparam WAIT = 5000;
	localparam CLK_ = 1;

	memory_access #(INST_MEM_WIDTH, DATA_MEM_WIDTH) memory_access_test(
			CLK,
			reset,
		 	RegWrite,
			MemtoReg,
			Branch,
			MemWrite,
			MemRead,
			UARTtoReg,
			register_data,
			alu_result,
			rdist,
			inst_index,
			pc,
			pc1,
			pc2,
		 	RegWrite_next,
			MemtoReg_next,
			Branch_next,
			UARTtoReg_next,
			read_data,
			register_data_next,
			alu_result_next,
			rdist_next,
			inst_index_next,
			pc_next,
			pc1_next,
			pc2_next
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
		RegWrite <= 0;
		MemtoReg <= 0;
		Branch <= 0;
		MemWrite <= 0; //変化させる必要有り
		MemRead <= 0; //変化させる必要有り
		UARTtoReg <= 0;
		register_data <= 32'h10101010;
		alu_result <= 32'hffffffff;
		rdist <= 5'b01010;
		inst_index <= 26'h1111111;
		pc <= 0;
		pc1 <= 1;
		pc2 <= 2;
		#WAIT;
		RegWrite <= 1;
		MemtoReg <= 1;
		Branch <= 1;
		MemWrite <= 1; //変化させる必要有り
		MemRead <= 0; //変化させる必要有り
		UARTtoReg <= 1;
		register_data <= 32'h11111111;
		alu_result <= 32'h55555555;
		rdist <= 5'b11111;
		inst_index <= 26'h00000000;
		pc <= 1;
		pc1 <= 2;
		pc2 <= 3;
		#WAIT;
		RegWrite <= 1;
		MemtoReg <= 1;
		Branch <= 1;
		MemWrite <= 0; //変化させる必要有り
		MemRead <= 1; //変化させる必要有り
		UARTtoReg <= 1;
		register_data <= 32'h11111111;
		alu_result <= 32'h55555555;
		rdist <= 5'b11111;
		inst_index <= 26'h00000000;
		pc <= 1;
		pc1 <= 2;
		pc2 <= 3;

		#WAIT;
		#WAIT;
	end
endmodule

