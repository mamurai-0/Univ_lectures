module inst_decode_test #(
	parameter INST_MEM_WIDTH = 2
);
	logic reset;
	logic [31:0] inst;
	logic [INST_MEM_WIDTH-1:0] pc;
	logic [INST_MEM_WIDTH-1:0] pc1;
	logic RegWrite_before;
	logic UART_write_enable;
	logic [31:0] data;
	logic [4:0] address;
 	logic RegWrite;
	logic [1:0] MemtoReg;
	logic [1:0] ALUSrcs;
	logic ALUSrcs2;
	logic [3:0] ALUOp;
	logic [1:0] RegDist;
	logic [1:0] Branch;
	logic MemWrite;
	logic MemRead;
	logic UARTtoReg;
	logic RegtoUART;
	logic [31:0] op1;
	logic [31:0] op2;
	logic [4:0] rt;
	logic [4:0] rd;
	logic [4:0] sa;
	logic [15:0] immediate;
	logic [25:0] inst_index;
	logic [INST_MEM_WIDTH-1:0] pc_next;
	logic [INST_MEM_WIDTH-1:0] pc1_next;

	localparam WAIT = 5000;
	inst_decode #(INST_MEM_WIDTH) inst_decode_instance(
		reset,
	 	inst,
		pc,
		pc1,
		RegWrite_before,
		UART_write_enable,
		data,
		address,
 		RegWrite,
		MemtoReg,
		ALUSrcs,
		ALUSrcs2,
		ALUOp,
		RegDist,
		Branch,
		MemWrite,
		MemRead,
		UARTtoReg,
		RegtoUART,
		op1,
		op2,
		rt,
		rd,
		sa,
		immediate,
		inst_index,
		pc_next,
		pc1_next
	);

	initial begin
		#WAIT;
		reset <= 1;
		#WAIT;
		reset <= 0;
		#WAIT;
		inst <= 32'h00430820; //ADD %r1,%r2,%r3
		pc <= 1;
		pc1 <= 1;
		RegWrite_before <= 0;
		UART_write_enable <= 0;
		data <= 32'h1010101010;
		address <= 5'b00001;
		#WAIT;
		inst <= 32'h00a62022; //SUB %r4,%r5,%r6
		pc <= 1;
		pc1 <= 1;
		RegWrite_before <= 1;
		UART_write_enable <= 0;
		data <= 32'h1010101010;
		address <= 5'b00001;
		#WAIT;
	end
endmodule
