module test_top #(
	parameter INST_MEM_WIDTH = 2
);
	logic UART_RX;
	logic sw_n_10;
	logic sw_c_7;
	logic sw_e_9;
	logic sw_s_8;
	logic sw_w_6;
	logic [3:0] sw;
 	logic UART_TX;
	logic [7:0] led;

	logic CLK;
    
    localparam COUNT = 5208;
    localparam START = 50000;

	always begin
	    CLK <= 1;
	    #1;
	    CLK <= 0;
	    #1;
	end
	
	initial begin
		UART_RX <= 1;
	    #START;
		
		sw_n_10 <= 1;
		#START;
		sw_n_10 <= 0;
		#START;

		//IN 00 00 00 ec
	    UART_RX <= 0;
        #COUNT;           //receive start
        UART_RX <= 0;
        #COUNT;
        UART_RX <= 0;	   
	    #COUNT;
        UART_RX <= 0;
        #COUNT;
        UART_RX <= 0;
        #COUNT;
        UART_RX <= 0;
	    #COUNT;
        UART_RX <= 0;
        #COUNT;
        UART_RX <= 0;
        #COUNT;
        UART_RX <= 0;    //receive end
	    #COUNT;
        UART_RX <= 1;
        #COUNT;
 	    UART_RX <= 0;
        #COUNT;           //receive start
        UART_RX <= 0;
        #COUNT;
        UART_RX <= 0;	   
	    #COUNT;
        UART_RX <= 0;
        #COUNT;
        UART_RX <= 0;
        #COUNT;
        UART_RX <= 0;
	    #COUNT;
        UART_RX <= 0;
        #COUNT;
        UART_RX <= 0;
        #COUNT;
        UART_RX <= 0;    //receive end
	    #COUNT;
        UART_RX <= 1;
        #COUNT;
	    UART_RX <= 0;
        #COUNT;           //receive start
        UART_RX <= 0;
        #COUNT;
        UART_RX <= 0;	   
	    #COUNT;
        UART_RX <= 0;
        #COUNT;
        UART_RX <= 0;
        #COUNT;
        UART_RX <= 0;
	    #COUNT;
        UART_RX <= 0;
        #COUNT;
        UART_RX <= 0;
        #COUNT;
        UART_RX <= 0;    //receive end
	    #COUNT;
        UART_RX <= 1;
        #COUNT;
	    UART_RX <= 0;
        #COUNT;           //receive start
        UART_RX <= 1;
        #COUNT;
        UART_RX <= 1;	   
	    #COUNT;
        UART_RX <= 1;
        #COUNT;
        UART_RX <= 0;
        #COUNT;
        UART_RX <= 1;
	    #COUNT;
        UART_RX <= 1;
        #COUNT;
        UART_RX <= 0;
        #COUNT;
        UART_RX <= 0;    //receive end
	    #COUNT;
        UART_RX <= 1;
        #COUNT;

		//OUT 00 00 00 f0
	    UART_RX <= 0;
        #COUNT;           //receive start
        UART_RX <= 0;
        #COUNT;
        UART_RX <= 0;	   
	    #COUNT;
        UART_RX <= 0;
        #COUNT;
        UART_RX <= 0;
        #COUNT;
        UART_RX <= 0;
	    #COUNT;
        UART_RX <= 0;
        #COUNT;
        UART_RX <= 0;
        #COUNT;
        UART_RX <= 0;    //receive end
	    #COUNT;
        UART_RX <= 1;
        #COUNT;
		UART_RX <= 0;
        #COUNT;           //receive start
        UART_RX <= 0;
        #COUNT;
        UART_RX <= 0;	   
	    #COUNT;
        UART_RX <= 0;
        #COUNT;
        UART_RX <= 0;
        #COUNT;
        UART_RX <= 0;
	    #COUNT;
        UART_RX <= 0;
        #COUNT;
        UART_RX <= 0;
        #COUNT;
        UART_RX <= 0;    //receive end
	    #COUNT;
        UART_RX <= 1;
        #COUNT;
	    UART_RX <= 0;
        #COUNT;           //receive start
        UART_RX <= 0;
        #COUNT;
        UART_RX <= 0;	   
	    #COUNT;
        UART_RX <= 0;
        #COUNT;
        UART_RX <= 0;
        #COUNT;
        UART_RX <= 0;
	    #COUNT;
        UART_RX <= 0;
        #COUNT;
        UART_RX <= 0;
        #COUNT;
        UART_RX <= 0;    //receive end
	    #COUNT;
        UART_RX <= 1;
        #COUNT;
	    UART_RX <= 0;
        #COUNT;           //receive start
        UART_RX <= 1;
        #COUNT;
        UART_RX <= 1;	   
	    #COUNT;
        UART_RX <= 1;
        #COUNT;
        UART_RX <= 1;
        #COUNT;
        UART_RX <= 0;
	    #COUNT;
        UART_RX <= 0;
        #COUNT;
        UART_RX <= 0;
        #COUNT;
        UART_RX <= 0;    //receive end
	    #COUNT;
        UART_RX <= 1;
        #COUNT;

		//ADDI 02 00 00 20
	    UART_RX <= 0;
        #COUNT;           //receive start
        UART_RX <= 0;
        #COUNT;
        UART_RX <= 0;	   
	    #COUNT;
        UART_RX <= 0;
        #COUNT;
        UART_RX <= 0;
        #COUNT;
        UART_RX <= 0;
	    #COUNT;
        UART_RX <= 0;
        #COUNT;
        UART_RX <= 1;
        #COUNT;
        UART_RX <= 0;    //receive end
	    #COUNT;
        UART_RX <= 1;
        #COUNT;
		UART_RX <= 0;
        #COUNT;           //receive start
        UART_RX <= 0;
        #COUNT;
        UART_RX <= 0;	   
	    #COUNT;
        UART_RX <= 0;
        #COUNT;
        UART_RX <= 0;
        #COUNT;
        UART_RX <= 0;
	    #COUNT;
        UART_RX <= 0;
        #COUNT;
        UART_RX <= 0;
        #COUNT;
        UART_RX <= 0;    //receive end
	    #COUNT;
        UART_RX <= 1;
        #COUNT;
	    UART_RX <= 0;
        #COUNT;           //receive start
        UART_RX <= 0;
        #COUNT;
        UART_RX <= 0;	   
	    #COUNT;
        UART_RX <= 0;
        #COUNT;
        UART_RX <= 0;
        #COUNT;
        UART_RX <= 0;
	    #COUNT;
        UART_RX <= 0;
        #COUNT;
        UART_RX <= 0;
        #COUNT;
        UART_RX <= 0;    //receive end
	    #COUNT;
        UART_RX <= 1;
        #COUNT;
		UART_RX <= 0;
        #COUNT;           //receive start
        UART_RX <= 0;
        #COUNT;
        UART_RX <= 0;	   
	    #COUNT;
        UART_RX <= 1;
        #COUNT;
        UART_RX <= 0;
        #COUNT;
        UART_RX <= 0;
	    #COUNT;
        UART_RX <= 0;
        #COUNT;
        UART_RX <= 0;
        #COUNT;
        UART_RX <= 0;    //receive end
	    #COUNT;
        UART_RX <= 1;
        #COUNT;
	
		//OUT 00 00 00 f0
	    UART_RX <= 0;
        #COUNT;           //receive start
        UART_RX <= 0;
        #COUNT;
        UART_RX <= 0;	   
	    #COUNT;
        UART_RX <= 0;
        #COUNT;
        UART_RX <= 0;
        #COUNT;
        UART_RX <= 0;
	    #COUNT;
        UART_RX <= 0;
        #COUNT;
        UART_RX <= 0;
        #COUNT;
        UART_RX <= 0;    //receive end
	    #COUNT;
        UART_RX <= 1;
        #COUNT;
 	    UART_RX <= 0;
        #COUNT;           //receive start
        UART_RX <= 0;
        #COUNT;
        UART_RX <= 0;	   
	    #COUNT;
        UART_RX <= 0;
        #COUNT;
        UART_RX <= 0;
        #COUNT;
        UART_RX <= 0;
	    #COUNT;
        UART_RX <= 0;
        #COUNT;
        UART_RX <= 0;
        #COUNT;
        UART_RX <= 0;    //receive end
	    #COUNT;
        UART_RX <= 1;
        #COUNT;
	    UART_RX <= 0;
        #COUNT;           //receive start
        UART_RX <= 0;
        #COUNT;
        UART_RX <= 0;	   
	    #COUNT;
        UART_RX <= 0;
        #COUNT;
        UART_RX <= 0;
        #COUNT;
        UART_RX <= 0;
	    #COUNT;
        UART_RX <= 0;
        #COUNT;
        UART_RX <= 0;
        #COUNT;
        UART_RX <= 0;    //receive end
	    #COUNT;
        UART_RX <= 1;
        #COUNT;
	    UART_RX <= 0;
        #COUNT;           //receive start
        UART_RX <= 1;
        #COUNT;
        UART_RX <= 1;	   
	    #COUNT;
        UART_RX <= 1;
        #COUNT;
        UART_RX <= 1;
        #COUNT;
        UART_RX <= 0;
	    #COUNT;
        UART_RX <= 0;
        #COUNT;
        UART_RX <= 0;
        #COUNT;
        UART_RX <= 0;    //receive end
	    #COUNT;
        UART_RX <= 1;
        #COUNT;

		#START;
		sw_s_8 <= 1;
		#START;
		sw_s_8 <= 0;
	
		//nyuuryoku
	    UART_RX <= 0;
        #COUNT;           //receive start
        UART_RX <= 0;
        #COUNT;
        UART_RX <= 0;	   
	    #COUNT;
        UART_RX <= 0;
        #COUNT;
        UART_RX <= 0;
        #COUNT;
        UART_RX <= 0;
	    #COUNT;
        UART_RX <= 0;
        #COUNT;
        UART_RX <= 0;
        #COUNT;
        UART_RX <= 0;    //receive end
	    #COUNT;
        UART_RX <= 1;
        #START;
 	    UART_RX <= 0;
        #COUNT;           //receive start
        UART_RX <= 0;
        #COUNT;
        UART_RX <= 0;	   
	    #COUNT;
        UART_RX <= 0;
        #COUNT;
        UART_RX <= 0;
        #COUNT;
        UART_RX <= 0;
	    #COUNT;
        UART_RX <= 0;
        #COUNT;
        UART_RX <= 0;
        #COUNT;
        UART_RX <= 0;    //receive end
	    #COUNT;
        UART_RX <= 1;
        #COUNT;
        #START;
        #START;
	    UART_RX <= 0;
        #COUNT;           //receive start
        UART_RX <= 0;
        #COUNT;
        UART_RX <= 0;	   
	    #COUNT;
        UART_RX <= 0;
        #COUNT;
        UART_RX <= 0;
        #COUNT;
        UART_RX <= 0;
	    #COUNT;
        UART_RX <= 0;
        #COUNT;
        UART_RX <= 0;
        #COUNT;
        UART_RX <= 0;    //receive end
	    #COUNT;
        UART_RX <= 1;
        #COUNT;
        #START;
	    UART_RX <= 0;
        #COUNT;           //receive start
        UART_RX <= 1;
        #COUNT;
        UART_RX <= 1;	   
	    #COUNT;
        UART_RX <= 1;
        #COUNT;
        UART_RX <= 1;
        #COUNT;
        UART_RX <= 0;
	    #COUNT;
        UART_RX <= 0;
        #COUNT;
        UART_RX <= 0;
        #COUNT;
        UART_RX <= 0;    //receive end
	    #COUNT;
        UART_RX <= 1;
        #COUNT;


		end

	logic [7:0] receiver_data;
	logic [7:0] sender_data;
	logic receiver_valid;
	logic sender_enable = 0;
	logic sender_ready;
	receiver receiver_instance(CLK, UART_RX, receiver_data, receiver_valid);
	sender sender_instance(CLK, sender_data, sender_enable, UART_TX, sender_ready);
	
	logic [INST_MEM_WIDTH-1:0] pc = 0;
	logic [7:0] loader_data;
	logic loader_enable = 0;
	logic [31:0] inst;
	logic loader_ready = 0;
	inst_memory inst_memory_instance(CLK, pc, loader_data, loader_enable, inst, loader_ready);

	logic [31:0] write_data;
	logic write_enable = 0;
	logic write_ready;
	logic write_index;
	logic [31:0] read_data;
	logic read_enable = 0;
	logic read_index;
	data_memory data_memory_instance(CLK, write_data, write_enable, write_ready,write_index, read_data, read_enable, read_index);

	logic [5:0] funct;
	logic alu_enable = 0;
	logic [4:0] rs;
	logic [4:0] rt;
	logic [4:0] rd;
	logic [4:0] sa;
	logic alu_valid;
	alu alu_instance(CLK, inst[5:0], alu_enable, inst[25:21], inst[20:16], inst[10:6], inst[15:11], alu_valid);
	
	localparam OP_SP   = 6'b000000;
	localparam OP_JP   = 6'b000010;
	localparam OP_JAL  = 6'b000011;
	localparam OP_BEQ  = 6'b000100;
	localparam OP_BNE  = 6'b000101;
	localparam OP_ADDI = 6'b001000;
	localparam OP_ANDI = 6'b001100;
	localparam OP_ORI  = 6'b001101;
	localparam OP_LW   = 6'b100011;
	localparam OP_SW   = 6'b101011;
	localparam OP_IN   = 6'b111011;
	localparam OP_OUT  = 6'b111100;
	localparam OP_LW_I = 6'b111110; 
	
	integer state = 0;
//	integer send_state = 0;
	logic [31:0][31:0] r;
	logic [5:0] before_op = 0;

	always @(posedge CLK) begin
		if (sw_n_10) begin
			loader_enable <= 1;
		end else if (sw_s_8) begin
			loader_enable <= 0;
		end else if (loader_enable) begin
			loader_data <= receiver_data;
			loader_ready <= receiver_valid;
		end
		
		if ((state == 0) && !loader_enable && (before_op != inst[31:26])) begin
			case (inst[31:26])
				OP_SP : begin
						;
						end
				OP_JP : begin
							pc <= inst[INST_MEM_WIDTH-1:0];
							before_op <= inst[31:26];
						end
				OP_JAL : begin
							r[31] <= pc + 1;
							state <= state + 1;
						end
				OP_BEQ : begin
							if (r[inst[25:21]] == r[inst[20:16]]) begin
								pc <= pc + inst[15:0];											//INST_MEM_WIDTHの値により編集の必要あり？
							end else begin
								pc <= pc + 1;
							end
							before_op <= inst[31:26];
						end
				OP_BNE : begin
							if (r[inst[25:21]] != r[inst[20:16]]) begin
								pc <= pc + inst[15:0];											//INST_MEM_WIDTHの値により編集の必要あり？
							end else begin
								pc <= pc + 1;
							end
							before_op <= inst[31:26];
						end
				OP_ADDI : begin
							r[inst[20:16]] <= r[inst[25:21]] + {{16{inst[15]}}, inst[15:0]};
							pc <= pc + 1;
							before_op <= inst[31:26];
						end
				OP_ANDI : begin
							r[inst[20:16]] <= r[inst[25:21]] & {{16{inst[15]}}, inst[15:0]};
							pc <= pc + 1;
							before_op <= inst[31:26];
						end
				OP_ORI : begin
							r[inst[20:16]] <= r[inst[25:21]] | {{16{inst[15]}}, inst[15:0]};
							pc <= pc + 1;
							before_op <= inst[31:26];
						end
				OP_LW : begin
							read_enable <= 1;
							read_index <= r[inst[25:21] + {{16{inst[15]}}, inst[15:0]};	
							state <= state + 1;		
						end
				OP_SW : begin
							write_enable <= 1;
							write_index <= r[inst[25:21]] + {{16{inst[15]}}, inst[15:0]};
							write_data <= r[inst[20:16]];
							state <= state + 1;
						end
				OP_IN : begin
							if (receiver_valid) begin
								r[inst[15:11]][31:24] <= receiver_data;
								state <= state + 1;
							end
						end
				OP_OUT : begin
								sender_data <= r[inst[25:21]][31:24];
								state <= state + 1;
								sender_enable <= 1;
						end
				OP_LW_I : begin
							;
						end	
			endcase
		end else if (state == 1) begin
			case (inst[31:26])
				OP_JAL : begin
							pc <= inst[INST_MEM_WIDTH-1:0];
							bafore_op <= inst[31:26];
							state <= 0;
						end
				OP_LW : begin
							read_enable <= 0;
							r[inst[20:16]] <= read_data;
							before_op <= inst[31:26];
							state <= 0;
						end
				OP_SW : begin
							if (write_ready) begin
								write_enable <= 0;
								before_op <= inst[31:26];
								state <= 0;
							end
				OP_IN : begin
							if (receiver_valid) begin
								r[inst[15:11]][23:16] <= receiver_data;
								state <= state + 1;
							end
						end
				OP_OUT : begin
							if (sender_ready) begin
								sender_data <= r[inst[25:21]][23:16];
								state <= state + 1;
							end
						end
				default : state <= 0;
			endcase
		end else if (state == 2) begin
			case (inst[31:26])
				OP_IN : begin
							if (receiver_valid) begin
								r[inst[15:11]][15:8] <= receiver_data;
								state <= state + 1;
							end
						end
				OP_OUT : begin
							if (sender_ready) begin
								sender_data <= r[inst[25:21]][15:8];
								state <= state + 1;
//								send_state <= send_state + 1;
							end
						end
				default : state <= 0;
			endcase
		end else if (state == 3) begin
			case (inst[31:26])
				OP_IN : begin
							if (receiver_valid) begin
								r[inst[15:11]][7:0] <= receiver_data;
								state <= state + 1;
							end 
						end
				OP_OUT : begin
							if (sender_ready) begin
								sender_data <= r[inst[25:21]][7:0];
								state <= state + 1;
//								send_state <= send_state + 1;
							end	
						end
				default : state <= 0;
			endcase
		end else if (state == 4) begin
			case (inst[31:26])
				OP_IN : begin
								state <= 0;
								pc <= pc + 1;
								before_op <= inst[31:26];
						end
				OP_OUT : begin
							if (sender_ready) begin
//								state <= state + 1;
								sender_enable <= 0;
								state <= 0;
								pc <= pc + 1;
								before_op <= inst[31:26];
//								send_state <= send_state + 1;
							end
						end
				default : state <= 0;
			endcase
//		end else if (state == 5) begin
//			case (inst[31:26])
//				OP_OUT : begin
//							if (sender_ready) begin
//								send_state <= send_state + 1;
//							end
//							if (send_state == 4) begin
//								state <= 0;
//								pc <= pc + 1;
//								send_state <= 0;
//								before_op <= inst[31:26];
//							end
//						end
//				default : state <= 0;
//			endcase
		end
	end
endmodule
