module write_buffer_pc_generate_test #(
	parameter INST_MEM_WIDTH = 2
);
	logic reset;
	logic RegWrite;
	logic [1:0] MemtoReg;
	logic [1:0] Branch;
	logic UARTtoReg;
	logic [31:0] read_data;
	logic [31:0] register_data;
	logic [31:0] alu_result;
	logic [4:0] rd;
	logic [25:0] inst_index;
	logic [INST_MEM_WIDTH-1:0] pc;
	logic [INST_MEM_WIDTH-1:0] pc1;
	logic [INST_MEM_WIDTH-1:0] pc2;
	logic input_ready;
	logic [31:0] input_data;
	logic RegWrite_next;
	logic UART_write_enable;
	logic [31:0] data;
	logic [4:0] rd_next;
	logic [INST_MEM_WIDTH-1:0] pc_generated;
	logic [INST_MEM_WIDTH-1:0] pc1_next;
	
	localparam WAIT = 5000;
	write_buffer_pc_generate #(INST_MEM_WIDTH) write_buffer_pc_generate_instance(
			reset,
			RegWrite,
			MemtoReg,
			Branch,
			UARTtoReg,
			read_data,
			register_data,
			alu_result,
			rd,
			inst_index,
			pc,
			pc1,
			pc2,
			input_ready,
			input_data,
			RegWrite_next,
			UART_write_enable,
			data,
			rd_next,
			pc_generated,
			pc1_next
	);

	initial begin
		#WAIT;
		reset <= 1;
		#WAIT;
		reset <= 0;
		//register_write_test
		RegWrite <= 0;
		MemtoReg <= 2'b01;
		UARTtoReg <= 0;
		read_data <= 32'hffffffff;
		register_data <= 32'haaaaaaaa;
		alu_result <= 32'h11111111;
		rd <= 5'b11100;
		inst_index <= 26'h1bbbbbb; 
        pc <= 2'b10;
		pc1 <= 2'b01;
		pc2 <= 2'b11;
		input_data <= 32'h55555555;
		input_ready <= 0;
		#WAIT;
		MemtoReg <= 2'b10;
		#WAIT;
		MemtoReg <= 2'b11;
		#WAIT;
		UARTtoReg <= 1;
		#WAIT;
		UARTtoReg <= 0;
		input_ready <= 1;
		#WAIT;
		//branch_test
		Branch <= 2'b00;
		input_ready <= 0;
		#WAIT;
		Branch <= 2'b10;
		alu_result <= 0;
		#WAIT;
		//���Ȥϼ�����
		#WAIT;
		#WAIT;
		#WAIT;
		#WAIT;
		#WAIT;
	end
endmodule
