module top #(
	parameter INST_MEM_WIDTH = 1,  //TODO too large? For OP_JP, must be smaller than 26 bit. If smaller than 16, we must change BEQ and BNE.
	parameter DATA_MEM_WIDTH = 7   //TODO too large? if greater than 15, error.
) (
	input logic CLK_P,
	input logic CLK_N,
	input logic UART_RX,
	output logic UART_TX,
	output logic [7:0] led,
	input logic sw_n_10,
	input logic sw_c_7,
	input logic sw_e_9,
	input logic sw_s_8,
	input logic sw_w_6,
	input logic [3:0] sw
);
	logic CLK;
	IBUFGDS IBUFGDS_instance(.I(CLK_P), .IB(CLK_N), .O(CLK));

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
	localparam OP_LW_I = 6'b111110; //デバッグ用に追加した。
	
	localparam FUNCT_SLL = 6'b000000;
	localparam FUNCT_SRL = 6'b000010;
	localparam FUNCT_SRA = 6'b000011;
	localparam FUNCT_JR  = 6'b001000;
	localparam FUNCT_ADD = 6'b100000;
	localparam FUNCT_SUB = 6'b100010;
	localparam FUNCT_AND = 6'b100100;
	localparam FUNCT_OR  = 6'b100101;
	localparam FUNCT_XOR = 6'b100110;
	localparam FUNCT_SLT = 6'b101010;
								
	localparam CLEAR	 = 32'b0;
		
	logic[31:0] inst_mem [2**INST_MEM_WIDTH-1:0] = '{
	       default : CLEAR
	};
	logic[2**DATA_MEM_WIDTH-1:0][31:0] data_mem;
	logic[31:0][31:0] r;									//General Purpose Register 32bit * 32 
	logic[INST_MEM_WIDTH-1:0] pc = 0;
	logic[31:0] inst;
	integer state = 1;
	logic sender_enable = 0;
	integer loader_state = 0;
	logic[2**INST_MEM_WIDTH-1:0] loader_counter = 0;
	logic[31:0] buff;
	logic[7:0] buf_sub;

	assign inst = inst_mem[pc];;

	always @(posedge CLK) begin
 		if (sw_n_10 && (loader_state == 0)) begin
			loader_state <= loader_state + 1;
			led[0] <= 1;
		end else if (receiver_valid && (loader_state == 1)) begin
			buff[7:0] <= receiver_data;
			loader_state <= loader_state + 1;
		end else if (receiver_valid && (loader_state == 2)) begin
			buff[15:8] <= receiver_data;
			loader_state <= loader_state + 1;		
		end else if (receiver_valid && (loader_state == 3)) begin
			buff[23:16] <= receiver_data;
			loader_state <= loader_state + 1;
		end else if (receiver_valid && (loader_state == 4)) begin
			buff[31:24] <= receiver_data;
			loader_state <= loader_state + 1;	
		end else if (loader_state == 5) begin
			inst_mem[loader_counter] <= buff;
			loader_state <= 1;
			loader_counter <= loader_counter + 1;
		end else if (sw_s_8) begin
			loader_state <= 0;
			led[1] <= 1;
		end else if (inst == CLEAR) begin
			state <= 1;
			led <= 0;
		end else if (state == 1) begin
			led[2] <= 1;
			case (inst[31:26])
				OP_SP  : begin 
						 case (inst[5:0])
							FUNCT_SLL: ;
							FUNCT_SRL: ;
							FUNCT_SRA: ;
							FUNCT_JR : ; 
							FUNCT_ADD: ;
							FUNCT_SUB: ;
							FUNCT_AND: ;
							FUNCT_OR : ;
							FUNCT_XOR: ;
							FUNCT_SLT: ;     
						 endcase
						 end
				OP_JP  : pc <= inst[INST_MEM_WIDTH-1:0];
				OP_JAL : begin
						 r[31] <= pc + 1;
						 pc <= inst[INST_MEM_WIDTH-1:0];         //douji ni pc henkou site daijoubu???
						 end
				OP_BEQ : if (inst[25:21] == inst[20:16]) begin
						 	pc <= pc + inst[13:0];
						 end else begin
						 	pc <= pc + 1;
						 end
				OP_BNE : if (inst[25:21] != inst[20:16]) begin
							pc <= pc + inst[13:0];
						 end else begin
						 	pc <= pc + 1;
						 end
				OP_ADDI: begin
				         r[inst[20:16]] <= r[inst[25:21]] + {{16{inst[15]}}, inst[15:0]};
						 pc <= pc + 1;
						 end
				OP_ANDI: begin
				         r[inst[20:16]] <= r[inst[25:21]] & {{16{1'b0}}, inst[15:0]};
						 pc <= pc + 1;
						 end
				OP_ORI : begin
				         r[inst[20:16]] <= r[inst[25:21]] | {{16{1'b0}}, inst[15:0]};
						 pc <= pc + 1;
						 end
				OP_LW  : begin
				         r[inst[20:16]] <= data_mem[{{16{inst[15]}}, inst[15:0]} + r[inst[25:21]]];
						 pc <= pc + 1;
						 end
				OP_SW  : begin
				         data_mem[{{16{inst[15]}}, inst[15:0]} + r[inst[25:21]]] <= r[inst[20:16]];
						 pc <= pc + 1;
						 end
                OP_IN  : if (receiver_valid) begin
                          		r[inst[15:11]][31:24] <= receiver_data;
                          		state <= state + 1;
                          end
                OP_OUT : if (sender_ready) begin
                          		sender_data <= r[inst[25:21]][31:24];
                          		state <= state + 1;
								sender_enable <= (inst[31:26]==OP_OUT);
                          end
				OP_LW_I : begin//デバッグ用に追加した命令。rs番めのレジスタにinst_memのrt番めを代入する。
							r[inst[25:21]] <= inst_mem[inst[20:16]];
							pc <= pc + 1;
						  end
			endcase
		end else if (state == 2) begin
			case (inst[31:26])
	             OP_IN  : 
                          if (receiver_valid) begin
								r[inst[15:11]][23:16] <= receiver_data;
                          		state <= state + 1;
                          end
                 OP_OUT : 
                          if (sender_ready) begin
								sender_data <= r[inst[25:21]][23:16];
                          		state <= state + 1;
                          end
			endcase
		end else if (state == 3) begin
			case (inst[31:26])
                 OP_IN  : 
                          if (receiver_valid) begin
								r[inst[15:11]][15:8] <= receiver_data;
                          		state <= state + 1;
                          end
                 OP_OUT : 
                          if (sender_ready) begin
								sender_data <= r[inst[25:21]][15:8];
                          		state <= state + 1;
                          end
			endcase
		end else if (state == 4) begin
			case (inst[31:26])
                 OP_IN  : 
                          if (receiver_valid) begin
								r[inst[15:11]][7:0] <= receiver_data;
                          		state <= state + 1;
                          end
                 OP_OUT : 
                          if (sender_ready) begin
								sender_data <= r[inst[25:21]][7:0];
                          		state <= state + 1;
                          end
             endcase
		end	 else if (state == 5) begin
			case (inst[31:26])
				OP_IN  : begin					
                                pc <= pc +1;
                                state <= 1;
					     end
				OP_OUT : if (!sender_ready) state <= state + 1;
			endcase
		end else if (state == 6) begin
			case (inst[31:26])
				OP_OUT : if (sender_ready) begin 
							state <= 1;
							sender_enable <= 0;
							pc <= pc + 1;
						 end
			endcase
		end 
	end

	logic [7:0] receiver_data;
	logic [7:0] sender_data;
	logic receiver_valid;
	logic sender_ready;

	receiver receiver_instance(CLK, UART_RX, receiver_data, receiver_valid);
	sender sender_instance(CLK, sender_data, sender_enable, UART_TX, sender_ready);
endmodule
