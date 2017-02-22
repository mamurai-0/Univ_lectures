module top_sub #(  // todo : reset system
	parameter INST_MEM_WIDTH = 15
) (
	input logic CLK,
	input logic UART_RX,
	input logic sw_n_10,
	input logic sw_c_7,
	input logic sw_s_8,
	output logic UART_TX,
	output logic [7:0] led
);

	//reset
	logic reset;
	assign reset = sw_c_7;

	//receiver and sender
	logic [7:0] receiver_data;
	logic [7:0] sender_data;
	logic receiver_valid;
	logic sender_enable;
	logic sender_ready;

	//receiver buffer
	logic [31:0] input_data;
	logic input_ready;

	//sender_buffer
	logic full;

	//inst_fetch
	logic distinct_before_to_if;
	logic [INST_MEM_WIDTH-1:0] pc_to_if;
	logic [INST_MEM_WIDTH-1:0] pc1_to_if;
	logic input_start_to_if;
	logic input_end_to_if;
	logic distinct_from_if;
	logic [31:0] inst_from_if;
	logic inst_enable_from_if;
	logic [INST_MEM_WIDTH-1:0] pc_next_from_if;
	logic [INST_MEM_WIDTH-1:0] pc1_next_from_if;

	//inst_decode
	logic inst_enable_to_id;
	logic distinct_to_id;
	logic [31:0] inst_to_id;
	logic [INST_MEM_WIDTH-1:0] pc_to_id;
	logic [INST_MEM_WIDTH-1:0] pc1_to_id;
	logic distinct_next_from_id;
	logic AorF_from_id;
 	logic RegWrite_from_id;
	logic [1:0] MemtoReg_from_id;
	logic [1:0] ALUSrcs_from_id;
	logic ALUSrcs2_from_id;
	logic [3:0] ALUOp_from_id;
	logic [1:0] RegDist_from_id;
	logic [1:0] Branch_from_id;
	logic MemWrite_from_id;
	logic MemRead_from_id;
	logic UARTtoReg_from_id;
	logic RegtoUART_from_id;
	logic [4:0] rs_from_id;
	logic [4:0] rt_from_id;
	logic [4:0] rd_from_id;
	logic [4:0] sa_from_id;
	logic [15:0] immediate_from_id;
	logic [25:0] inst_index_from_id;
	logic [INST_MEM_WIDTH-1:0] pc_next_from_id;
	logic [INST_MEM_WIDTH-1:0] pc1_next_from_id;

	//operand_fetch
	logic distinct_to_op;
	logic distinct_before_to_op;
	logic AorF_before_to_op;
	logic RegWrite_before_to_op;
	logic UART_write_enable_to_op;
	logic [4:0] rs_to_op;
	logic [4:0] rt_to_op;
	logic [4:0] rw_to_op;
	logic [31:0] write_data_to_op;
	logic AorF_to_op;
 	logic RegWrite_to_op;
	logic [1:0] MemtoReg_to_op;
	logic [1:0] ALUSrcs_to_op;
	logic ALUSrcs2_to_op;
	logic [3:0] ALUOp_to_op;
	logic [1:0] RegDist_to_op;
	logic [1:0] Branch_to_op;
	logic MemWrite_to_op;
	logic MemRead_to_op;
	logic UARTtoReg_to_op;
	logic RegtoUART_to_op;
	logic [4:0] rd_to_op;
	logic [4:0] sa_to_op;
	logic [15:0] immediate_to_op;
	logic [25:0] inst_index_to_op;
	logic [INST_MEM_WIDTH-1:0] pc_to_op;
	logic [INST_MEM_WIDTH-1:0] pc1_to_op;
	logic distinct_next_from_op;
	logic [31:0] op1_sub_from_op;
	logic [31:0] op2_sub_from_op;
	logic AorF_next_from_op;
	logic RegWrite_next_from_op;
	logic [1:0] MemtoReg_next_from_op;
	logic [1:0] ALUSrcs_next_from_op;
	logic ALUSrcs2_next_from_op;
	logic [3:0] ALUOp_next_from_op;
	logic [1:0] RegDist_next_from_op;
	logic [1:0] Branch_next_from_op;
	logic MemWrite_next_from_op;
	logic MemRead_next_from_op;
	logic UARTtoReg_next_from_op;
	logic RegtoUART_next_from_op;
	logic [4:0] rt_next_from_op;
	logic [4:0] rd_next_from_op;
	logic [4:0] sa_next_from_op;
	logic [15:0] immediate_next_from_op;
	logic [25:0] inst_index_next_from_op;
	logic [INST_MEM_WIDTH-1:0] pc_next_from_op;
	logic [INST_MEM_WIDTH-1:0] pc1_next_from_op;

	//execution
	logic distinct_to_ex;
	logic AorF_to_ex;
	logic RegWrite_to_ex;
	logic [1:0] MemtoReg_to_ex;
	logic [1:0] ALUSrcs_to_ex;
	logic ALUSrcs2_to_ex;
	logic [3:0] ALUOp_to_ex;
	logic [1:0] RegDist_to_ex;
	logic [1:0] Branch_to_ex;
	logic MemWrite_to_ex;
	logic MemRead_to_ex;
	logic UARTtoReg_to_ex;
	logic RegtoUART_to_ex;
	logic [31:0] op1_sub_to_ex;
	logic [31:0] op2_sub_to_ex;
	logic [4:0] rt_to_ex;
	logic [4:0] rd_to_ex;
	logic [4:0] sa_to_ex;
	logic [15:0] immediate_to_ex;
	logic [25:0] inst_index_to_ex;
	logic [INST_MEM_WIDTH-1:0] pc_to_ex;
	logic [INST_MEM_WIDTH-1:0] pc1_to_ex;
	logic distinct_next_from_ex;
	logic AorF_next_from_ex;
	logic AorF_result_from_ex;
 	logic RegWrite_next_from_ex;
	logic [1:0] MemtoReg_next_from_ex;
	logic [1:0] Branch_next_from_ex;
	logic MemWrite_next_from_ex;
	logic MemRead_next_from_ex;
	logic UARTtoReg_next_from_ex;
	logic [31:0] register_data_from_ex;
	logic [31:0] alu_result_from_ex;
	logic [31:0] fpu_result_from_ex;
	logic valid_from_ex;
	logic [4:0] rdist_from_ex;
	logic [25:0] inst_index_next_from_ex;
	logic [INST_MEM_WIDTH-1:0] pc_next_from_ex;
	logic [INST_MEM_WIDTH-1:0] pc1_next_from_ex;
	logic [INST_MEM_WIDTH-1:0] pc2_from_ex;

	//memory_access
	logic distinct_to_mem;
	logic AorF_to_mem;
 	logic RegWrite_to_mem;
	logic [1:0] MemtoReg_to_mem;
	logic [1:0] Branch_to_mem;
	logic MemWrite_to_mem;
	logic MemRead_to_mem;
	logic UARTtoReg_to_mem;
	logic [31:0] register_data_to_mem;
	logic [31:0] alu_result_to_mem;
	logic [31:0] fpu_result_to_mem;
	logic valid_to_mem;
	logic [4:0] rdist_to_mem;
	logic [25:0] inst_index_to_mem;
	logic [INST_MEM_WIDTH-1:0] pc_to_mem;
	logic [INST_MEM_WIDTH-1:0] pc1_to_mem;
	logic [INST_MEM_WIDTH-1:0] pc2_to_mem;
	logic distinct_next_from_mem;
	logic AorF_next_from_mem;
 	logic RegWrite_next_from_mem;
	logic [1:0] MemtoReg_next_from_mem;
	logic [1:0] Branch_next_from_mem;
	logic UARTtoReg_next_from_mem;
	logic [31:0] read_data_from_mem;
	logic [31:0] register_data_next_from_mem;
	logic [31:0] alu_result_next_from_mem;
	logic [4:0] rdist_next_from_mem;
	logic [25:0] inst_index_next_from_mem;
	logic [INST_MEM_WIDTH-1:0] pc_next_from_mem;
	logic [INST_MEM_WIDTH-1:0] pc1_next_from_mem;
	logic [INST_MEM_WIDTH-1:0] pc2_next_from_mem;


	//wriet_buffer_pc_generate
	logic distinct_to_wb;
	logic AorF_to_wb;
	logic RegWrite_to_wb;
	logic [1:0] MemtoReg_to_wb;
	logic [1:0] Branch_to_wb;
	logic UARTtoReg_to_wb;
	logic [31:0] read_data_to_wb;
	logic [31:0] register_data_to_wb;
	logic [31:0] alu_result_to_wb;
	logic [4:0] rd_to_wb;
	logic [25:0] inst_index_to_wb;
	logic [INST_MEM_WIDTH-1:0] pc_to_wb;
	logic [INST_MEM_WIDTH-1:0] pc1_to_wb;
	logic [INST_MEM_WIDTH-1:0] pc2_to_wb;
	logic input_ready_to_wb;
	logic [31:0] input_data_to_wb;
	logic distinct_next_from_wb;
	logic AorF_next_from_wb;
	logic RegWrite_next_from_wb;
	logic UART_write_enable_from_wb;
	logic [31:0] data_from_wb;
	logic [4:0] rd_next_from_wb;
	logic [INST_MEM_WIDTH-1:0] pc_generated_from_wb;
	logic [INST_MEM_WIDTH-1:0] pc1_next_from_wb;

	receiver receiver_instance (
			CLK, 
			UART_RX, 
			receiver_data, 
			receiver_valid
	);
	sender sender_instance (
			CLK, 
			sender_data, 
			sender_enable, 
			UART_TX, 
			sender_ready
	);
	receiver_buffer reveiver_buffer_instance (
			CLK, 
			reset,
			receiver_data, 
			receiver_valid, 
			UARTtoReg_to_wb,
			input_data, 
			input_ready
	);
	logic start_send;
	assign start_send = RegtoUART_to_ex & distinct_to_ex;
	sender_buffer2 sender_buffer_instance (
			CLK, 
			reset, 
			op1_sub_to_ex,
			start_send, 
			sender_ready, 
			sender_data, 
			full,
			sender_enable
	);

	//inst fetch
	inst_fetch #(INST_MEM_WIDTH) inst_fetch_instance(
			CLK, 
			reset, 
			distinct_before_to_if,
			full,
			pc_to_if, 
			pc1_to_if, 
			input_start_to_if, 
			input_end_to_if, 
			distinct_from_if,
			inst_from_if, 
			inst_enable_from_if, 
			pc_next_from_if, 
			pc1_next_from_if
	);
	
	//inst decode
	inst_decode #(INST_MEM_WIDTH) inst_decode_instance(
			CLK,
			reset,
			inst_enable_to_id,
			distinct_to_id,
			inst_to_id, 
			pc_to_id, 
			pc1_to_id, 
			distinct_next_from_id,
			AorF_from_id,
			RegWrite_from_id, 
			MemtoReg_from_id, 
			ALUSrcs_from_id, 
			ALUSrcs2_from_id, 
			ALUOp_from_id, 
			RegDist_from_id, 
			Branch_from_id, 
			MemWrite_from_id, 
			MemRead_from_id, 
			UARTtoReg_from_id, 
			RegtoUART_from_id, 
			rs_from_id,
			rt_from_id, 
			rd_from_id, 
			sa_from_id, 
			immediate_from_id, 
			inst_index_from_id, 
			pc_next_from_id, 
			pc1_next_from_id
	);

	//operand_fetch
	operand_fetch #(INST_MEM_WIDTH) operand_fetch_instance(
			CLK,
			reset,
			distinct_to_op,
			distinct_before_to_op,
			AorF_before_to_op,
			RegWrite_before_to_op,
			UART_write_enable_to_op,
			rs_to_op,
			rt_to_op,
			rw_to_op,
			write_data_to_op,
			AorF_to_op,
 			RegWrite_to_op,
			MemtoReg_to_op,
			ALUSrcs_to_op,
			ALUSrcs2_to_op,
			ALUOp_to_op,
			RegDist_to_op,
			Branch_to_op,
			MemWrite_to_op,
			MemRead_to_op,
			UARTtoReg_to_op,
			RegtoUART_to_op,
			rd_to_op,
			sa_to_op,
			immediate_to_op,
			inst_index_to_op,
			pc_to_op,
			pc1_to_op,
			distinct_next_from_op,
			op1_sub_from_op,
			op2_sub_from_op,
			AorF_next_from_op,
			RegWrite_next_from_op,
			MemtoReg_next_from_op,
			ALUSrcs_next_from_op,
			ALUSrcs2_next_from_op,
			ALUOp_next_from_op,
			RegDist_next_from_op,
			Branch_next_from_op,
			MemWrite_next_from_op,
			MemRead_next_from_op,
			UARTtoReg_next_from_op,
			RegtoUART_next_from_op,
			rt_next_from_op,
			rd_next_from_op,
			sa_next_from_op,
			immediate_next_from_op,
			inst_index_next_from_op,
			pc_next_from_op,
			pc1_next_from_op
	);
			
	//execution
	execution #(INST_MEM_WIDTH) execution_instance(
			CLK,
			reset,
			distinct_to_ex,
			AorF_to_ex,
			RegWrite_to_ex, 
			MemtoReg_to_ex, 
			ALUSrcs_to_ex, 
			ALUSrcs2_to_ex, 
			ALUOp_to_ex, 
			RegDist_to_ex, 
			Branch_to_ex, 
			MemWrite_to_ex, 
			MemRead_to_ex, 
			UARTtoReg_to_ex, 
			RegtoUART_to_ex, 
			op1_sub_to_ex, 
			op2_sub_to_ex, 
			rt_to_ex, 
			rd_to_ex, 
			sa_to_ex, 
			immediate_to_ex, 
			inst_index_to_ex, 
			pc_to_ex, 
			pc1_to_ex, 
			distinct_next_from_ex,
			AorF_next_from_ex,
			AorF_result_from_ex,
			RegWrite_next_from_ex, 
			MemtoReg_next_from_ex, 
			Branch_next_from_ex, 
			MemWrite_next_from_ex, 
			MemRead_next_from_ex, 
			UARTtoReg_next_from_ex, 
			register_data_from_ex, 
			alu_result_from_ex, 
			fpu_result_from_ex,
			valid_from_ex,
			rdist_from_ex, 
			inst_index_next_from_ex, 
			pc_next_from_ex, 
			pc1_next_from_ex, 
			pc2_from_ex
	);

	//memory access
	memory_access2 #(INST_MEM_WIDTH) memory_access_instance(
			CLK, 
			reset, 
			distinct_to_mem,
			AorF_to_mem,
			AorF_result_from_ex,
			RegWrite_to_mem, 
			MemtoReg_to_mem, 
			Branch_to_mem, 
			MemWrite_to_mem, 
			MemRead_to_mem, 
			UARTtoReg_to_mem, 
			register_data_to_mem, 
			alu_result_to_mem,
			fpu_result_to_mem,
			valid_to_mem, 
			rdist_to_mem, 
			inst_index_to_mem, 
			pc_to_mem, 
			pc1_to_mem, 
			pc2_to_mem, 
			distinct_next_from_mem,
			AorF_next_from_mem,
			RegWrite_next_from_mem, 
			MemtoReg_next_from_mem, 
			Branch_next_from_mem, 
			UARTtoReg_next_from_mem, 
			read_data_from_mem, 
			register_data_next_from_mem, 
			alu_result_next_from_mem, 
			rdist_next_from_mem, 
			inst_index_next_from_mem, 
			pc_next_from_mem, 
			pc1_next_from_mem, 
			pc2_next_from_mem
	);

	//write buffer pc generate
	write_buffer_pc_generate #(INST_MEM_WIDTH) write_buffer_pc_generator_instancc(
			CLK,
			reset,
			distinct_to_wb,
			AorF_to_wb,
			RegWrite_to_wb, 
			MemtoReg_to_wb, 
			Branch_to_wb, 
			UARTtoReg_to_wb, 
			read_data_to_wb, 
			register_data_to_wb, 
			alu_result_to_wb, 
			rd_to_wb, 
			inst_index_to_wb, 
			pc_to_wb, 
			pc1_to_wb, 
			pc2_to_wb, 
			input_ready_to_wb, 
			input_data_to_wb, 
			distinct_next_from_wb,
			AorF_next_from_wb,
			RegWrite_next_from_wb, 
			UART_write_enable_from_wb, 
			data_from_wb, 
			rd_next_from_wb, 
			pc_generated_from_wb, 
			pc1_next_from_wb
	);

	assign distinct_before_to_if	= distinct_next_from_wb;
	assign pc_to_if 				= pc_generated_from_wb;
	assign pc1_to_if 				= pc1_next_from_wb;
	assign input_start_to_if 	   	= sw_n_10;
	assign input_end_to_if 		   	= sw_s_8;
	assign inst_enable_to_id		= inst_enable_from_if;
	assign distinct_to_id			= distinct_from_if;
	assign inst_to_id				= inst_from_if;
	assign pc_to_id 				= pc_next_from_if;
	assign pc1_to_id				= pc1_next_from_if;
	assign distinct_to_op 		   	= distinct_next_from_id;
	assign distinct_before_to_op   	= distinct_next_from_wb;
	assign RegWrite_before_to_op   	= RegWrite_next_from_wb;
	assign UART_write_enable_to_op 	= UART_write_enable_from_wb;
	assign rs_to_op 				= rs_from_id;
	assign rt_to_op 				= rt_from_id;
	assign rw_to_op					= rd_next_from_wb;
	assign write_data_to_op 		= data_from_wb;
 	assign RegWrite_to_op 			= RegWrite_from_id;
	assign MemtoReg_to_op 			= MemtoReg_from_id;
	assign ALUSrcs_to_op 			= ALUSrcs_from_id;
	assign ALUSrcs2_to_op 			= ALUSrcs2_from_id;
	assign ALUOp_to_op 				= ALUOp_from_id;
	assign RegDist_to_op 			= RegDist_from_id;
	assign Branch_to_op 			= Branch_from_id;
	assign MemWrite_to_op 			= MemWrite_from_id;
	assign MemRead_to_op	 		= MemRead_from_id;
	assign UARTtoReg_to_op 			= UARTtoReg_from_id;
	assign RegtoUART_to_op 			= RegtoUART_from_id;
	assign rd_to_op 				= rd_from_id;
	assign sa_to_op 				= sa_from_id;
	assign immediate_to_op		 	= immediate_from_id;
	assign inst_index_to_op 		= inst_index_from_id;
	assign pc_to_op 				= pc_next_from_id;
	assign pc1_to_op 				= pc1_next_from_id;
	assign distinct_to_ex 			= distinct_next_from_op;
	assign RegWrite_to_ex 			= RegWrite_next_from_op;
	assign MemtoReg_to_ex			= MemtoReg_next_from_op;
	assign ALUSrcs_to_ex 			= ALUSrcs_next_from_op;
	assign ALUSrcs2_to_ex		 	= ALUSrcs2_next_from_op;
	assign ALUOp_to_ex 				= ALUOp_next_from_op;
	assign RegDist_to_ex 			= RegDist_next_from_op;
	assign Branch_to_ex 			= Branch_next_from_op;
	assign MemWrite_to_ex 			= MemWrite_next_from_op;
	assign MemRead_to_ex 			= MemRead_next_from_op;
	assign UARTtoReg_to_ex 			= UARTtoReg_next_from_op;
	assign RegtoUART_to_ex 			= RegtoUART_next_from_op;
	assign op1_sub_to_ex 			= op1_sub_from_op;
	assign op2_sub_to_ex 			= op2_sub_from_op;
	assign rt_to_ex 				= rt_next_from_op; 
	assign rd_to_ex 				= rd_next_from_op;
	assign sa_to_ex 				= sa_next_from_op;
	assign immediate_to_ex	 		= immediate_next_from_op;
	assign inst_index_to_ex 		= inst_index_next_from_op;
	assign pc_to_ex 				= pc_next_from_op;
	assign pc1_to_ex 				= pc1_next_from_op;
	assign distinct_to_mem			= distinct_next_from_ex;
	assign RegWrite_to_mem 			= RegWrite_next_from_ex;
	assign MemtoReg_to_mem 			= MemtoReg_next_from_ex;
	assign Branch_to_mem 			= Branch_next_from_ex;
	assign MemWrite_to_mem 			= MemWrite_next_from_ex;
	assign MemRead_to_mem 			= MemRead_next_from_ex;
	assign UARTtoReg_to_mem 		= UARTtoReg_next_from_ex;
	assign register_data_to_mem 	= register_data_from_ex;
	assign alu_result_to_mem 		= alu_result_from_ex;
	assign fpu_result_to_mem		= fpu_result_from_ex;
	assign valid_to_mem 			= valid_from_ex;
	assign rdist_to_mem 			= rdist_from_ex;
	assign inst_index_to_mem 		= inst_index_next_from_ex;
	assign pc_to_mem 				= pc_next_from_ex;
	assign pc1_to_mem 				= pc1_next_from_ex;
	assign pc2_to_mem 				= pc2_from_ex;
	assign distinct_to_wb 			= distinct_next_from_mem;
	assign RegWrite_to_wb 			= RegWrite_next_from_mem;
	assign MemtoReg_to_wb 			= MemtoReg_next_from_mem;
	assign Branch_to_wb 			= Branch_next_from_mem;
	assign UARTtoReg_to_wb 			= UARTtoReg_next_from_mem;
	assign read_data_to_wb 			= read_data_from_mem;
	assign register_data_to_wb 		= register_data_next_from_mem;
	assign alu_result_to_wb 		= alu_result_next_from_mem;
	assign rd_to_wb 				= rdist_next_from_mem;
	assign inst_index_to_wb 		= inst_index_next_from_mem;
	assign pc_to_wb 				= pc_next_from_mem;
	assign pc1_to_wb 				= pc1_next_from_mem;
	assign pc2_to_wb 				= pc2_next_from_mem;
	assign input_ready_to_wb 		= input_ready;
	assign input_data_to_wb 		= input_data;
	assign AorF_to_op 				= AorF_from_id;
	assign AorF_before_to_op		= AorF_next_from_wb;
	assign AorF_to_ex 				= AorF_next_from_op;
	assign AorF_to_mem				= AorF_next_from_ex;
	assign AorF_to_wb				= AorF_next_from_mem;

	always_ff @(posedge CLK) begin
		if (reset) begin
			led <= 8'b01010101;
		end else begin
			led[0] <= inst_from_if[31];
			led[1] <= inst_from_if[30];
			led[2] <= inst_from_if[29];
			led[3] <= inst_from_if[28];
			led[4] <= inst_from_if[27];
			led[5] <= inst_from_if[26];
			led[6] <= inst_from_if[25];
			led[7] <= inst_from_if[24];
		end
	end
endmodule
