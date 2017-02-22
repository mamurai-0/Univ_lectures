`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/05/2016 04:01:18 AM
// Design Name: 
// Module Name: tb_karen
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

module tb_karen;
    logic clk;
    logic [31:0] a,b,c;
    logic [26:0] a_loser_man; 
	logic [23:0] a_winer_man;
	logic [22:0] a_inf_nan_man;
	logic [7:0]  a_exp;
	logic        a_is_nan, a_is_inf, a_sign, a_op_sub;
	logic [26:0] c_loser_man;
	logic [23:0] c_winer_man;
	logic [22:0] c_inf_nan_man;
	logic [7:0]  c_exp;
	logic c_is_nan, c_is_inf, c_sign, c_op_sub;   
	logic [27:0] c_man;
	logic [27:0] n_man;
	logic [22:0] n_inf_nan_man;
	logic [7:0]  n_exp;
	logic        n_is_nan, n_is_inf, n_sign;    
	logic [4:0] number_of_zero; 

	parameter STEP = 10;
    
    karen karen (clk, a, b, a_loser_man, a_winer_man, a_inf_nan_man, a_exp, a_is_nan, a_is_inf, a_sign, a_op_sub, c_loser_man, c_winer_man, c_inf_nan_man, c_exp, c_is_nan, c_is_inf, c_sign, c_op_sub, c_man, n_man, n_inf_nan_man, n_exp, n_is_nan, n_is_inf, n_sign,number_of_zero, c);
    
    always begin
        clk = 0; #(STEP/2);
        clk = 1; #(STEP/2);
    end
    
    integer fp, out, status,fail,data;
    logic [31:0] r;
    initial begin
        fail = 0;
        data = 0;
        fp = $fopen("/home/tansei/Documents/3s/hardware/4/a.txt", "r");
		out = $fopen("/home/tansei/Documents/3s/hardware/4/b.txt", "w");
        if(fp != 0)begin
            while(!$feof(fp))begin
				@(posedge clk);
                status = $fscanf(fp, "%32b %32b %32b\n", a, b, r);
                @(posedge clk);
                @(posedge clk);
                @(posedge clk);
                @(posedge clk);
               if(c != r)begin
				    $fwrite(out, "arg1 = %32b  arg2 = %32b\nout  = %32b\nans  = %32b\n", a, b, c, r);
				    $fwrite(out, "\nalignment stage\na_loser_man = %27b\na_winer_man = %24b\na_inf_nan_man = %23b\na_exp = %8b\na_is_nan = %1b\na_is_inf = %1b\na_sign = %1b\na_op_sub = %1b\n", a_loser_man, a_winer_man, a_inf_nan_man, a_exp, a_is_nan, a_is_inf, a_sign, a_op_sub);
				    $fwrite(out, "\ncalculation stage\nc_loser_man = %27b\nc_winer_man = %24b\nc_inf_nan_man = %23b\nc_exp = %8b\nc_is_nan = %1b\nc_is_inf = %1b\nc_sign = %1b\nc_op_sub = %1b\nc_man = %28b\n", c_loser_man, c_winer_man, c_inf_nan_man, c_exp, c_is_nan, c_is_inf, c_sign, c_op_sub, c_man);
				    $fwrite(out, "\nnormalozation stage\nn_man = %28b\nn_inf_nan_man = %23b\nn_exp = %8b\nn_is_nan = %1b\nn_is_inf = %1b\nn_sign = %1b\nnumber_of_zero = %5b\n", n_man, n_inf_nan_man, n_exp, n_is_nan, n_is_inf, n_sign, number_of_zero);
				    fail = fail + 1;
				end
				data = data + 1;
            end
            $fwrite(out, "correct %d/%d\n", (data - fail), data);
            $fwrite(out, "\n\nrounding corner case\n");
            @(posedge clk);
            a <= 32'b0_01111111_00000000000000000000000;
            b <= 32'b0_01100111_00000000000000000000001;
            r <= 32'b0_01111111_00000000000000000000001;
            @(posedge clk);
            @(posedge clk);
            @(posedge clk);
            @(posedge clk);                       
            $fwrite(out, "arg1 = %32b\narg2 = %32b\nout  = %32b\nans  = %32b\n", a, b, c, r);
            @(posedge clk);
            a <= 32'b01111111011111111111111111111111;
            b <= 32'b01110011000000000000000000000000;
            r <= 32'b01111111100000000000000000000000;
            @(posedge clk);
            @(posedge clk);
            @(posedge clk);
            @(posedge clk);                       
           $fwrite(out, "arg1 = %32b\narg2 = %32b\nout  = %32b\nans  = %32b\n", a, b, c, r);
            @(posedge clk);
            a <= 32'b00111111100000000000000000000000;
			b <= 32'b10110011000000000000000000000001;
			r <= 32'b00111111011111111111111111111111;
			@(posedge clk);
			@(posedge clk);
			@(posedge clk);
			@(posedge clk);                       
            $fwrite(out, "arg1 = %32b\narg2 = %32b\nout  = %32b\nans  = %32b\n", a, b, c, r);
			@(posedge clk);
			a <= 32'b0_01111111_00000000000000000000001;
			b <= 32'b1_01100110_11111111111111111111111;
			r <= 32'b00111111100000000000000000000001;
			@(posedge clk);
			@(posedge clk);
			@(posedge clk);
			@(posedge clk);                       
			$fwrite(out, "arg1 = %32b\narg2 = %32b\nout  = %32b\nans  = %32b\n", a, b, c, r);
			@(posedge clk);
			a <= 32'b0_00000010_00000000000000000000000;
			b <= 32'b1_00000001_00000000000000000000000;
			r <= 32'b0_00000001_00000000000000000000000;
			@(posedge clk);
			@(posedge clk);
			@(posedge clk);
			@(posedge clk);                       
			$fwrite(out, "arg1 = %32b\narg2 = %32b\nout  = %32b\nans  = %32b\n", a, b, c, r);
			
			$fwrite(out, "\n\nSub + Sub = Norm\n");
			@(posedge clk);
			a <= 32'b10000000011010011001011110110101;
            b <= 32'b10000000001011110001011011010101;
            r <= 32'b10000000100110001010111010001010;
            @(posedge clk);
            @(posedge clk);
            @(posedge clk);
            @(posedge clk);
            $fwrite(out, "arg1 = %32b\narg2 = %32b\nout  = %32b\nans  = %32b\n", a, b, c, r);

			$fflush(out);
        end
    end          
endmodule
