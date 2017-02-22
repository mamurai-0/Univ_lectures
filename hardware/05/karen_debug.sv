`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: UT
// Engineer: Hideaki Imamura
// 
// Create Date: 06/02/2016 01:22:46 PM
// Design Name: 
// Module Name: karen
// Project Name: HW_4
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


module karen(
    input logic clk,
    input logic [31:0] a,
    input logic [31:0] b,
    output logic [26:0] a_loser_man,
    output logic [23:0] a_winer_man,
    output logic [22:0] a_inf_nan_man,
    output logic [7:0]  a_exp,
    output logic        a_is_nan, a_is_inf, a_sign, a_op_sub,
    output logic [26:0] c_loser_man,
    output logic [23:0] c_winer_man,
    output logic [22:0] c_inf_nan_man,
    output logic [7:0]  c_exp,
    output logic c_is_nan, c_is_inf, c_sign, c_op_sub,   
    output logic [27:0] c_man,
    output logic [27:0] n_man,
    output logic [22:0] n_inf_nan_man,
    output logic [7:0]  n_exp,
    output logic        n_is_nan, n_is_inf, n_sign,  
    output logic [4:0] number_of_zero,
    output logic [31:0] c
    );
    
//    logic [26:0] a_loser_man; 
//    logic [23:0] a_winer_man;
//    logic [22:0] a_inf_nan_man;
//    logic [7:0]  a_exp;
//    logic        a_is_nan, a_is_inf, a_sign, a_op_sub;
    //alignment stage
    karen_align alignment (a, b, a_is_nan, a_is_inf, a_inf_nan_man, a_sign, a_exp, a_op_sub, a_winer_man, a_loser_man);
    
//    logic [26:0] c_loser_man;
//    logic [23:0] c_winer_man;
//    logic [22:0] c_inf_nan_man;
//    logic [7:0]  c_exp;
//    logic c_is_nan, c_is_inf, c_sign, c_op_sub;
    //pipelined register between alignment step and calculation step
    always @ (posedge clk) begin
            c_is_nan <= a_is_nan;
            c_is_inf <= a_is_inf;
            c_inf_nan_man <= a_inf_nan_man;
            c_sign <= a_sign;
            c_exp <= a_exp;
            c_op_sub <= a_op_sub;
            c_winer_man <= a_winer_man;
            c_loser_man <= a_loser_man;
    end
//    logic [27:0] c_man;
    //calculation stage
    karen_calcu calculation (c_op_sub, c_winer_man, c_loser_man, c_man);
//    logic [27:0] n_man;
//    logic [22:0] n_inf_nan_man;
//    logic [7:0]  n_exp;
//    logic        n_is_nan, n_is_inf, n_sign;
    //pipelined register between calculation step and normalization step
    always @ (posedge clk) begin
            n_is_nan <= c_is_nan;
            n_is_inf <= c_is_inf;
            n_inf_nan_man <= c_inf_nan_man;
            n_sign <= c_sign;
            n_exp <= c_exp;
            n_man <= c_man;
    end
    //normalization stage
    logic [31:0] ans;
    logic [4:0] num;
    karen_norm normalization (n_is_nan, n_is_inf, n_inf_nan_man, n_sign, n_exp, n_man, ans, num);
    always @(posedge clk) begin
        number_of_zero <= num;
        c <= ans;
    end
endmodule

module karen_align (
    input logic [31:0] a,
    input logic [31:0] b,
    output logic is_nan,
    output logic is_inf,
    output logic [22:0] inf_nan_man,
    output logic sign,
    output logic [7:0] exp,
    output logic op_sub,
    output logic [23:0] winer_man24,
    output logic [26:0] loser_man27
    );
    
    logic win_or_lose;
    logic [31:0] winer;
    logic [31:0] loser;    
	logic [23:0] loser_man24;   
	logic winer_is_inf; 
	logic loser_is_inf;
	logic winer_is_nan; 
	logic loser_is_nan;
	logic [22:0] nan_man;
	logic [7:0] shift_amount;
	logic [49:0] loser_man50;   
    
	always_comb begin
    	if ({1'b0, b[30:0]} > {1'b0, a[30:0]}) begin
    	   winer <= b;
    	   loser <= a;
    	   win_or_lose <= 1'b1;
    	end else begin
    	   winer <= a;
    	   loser <= b;
    	   win_or_lose <= 1'b0;
    	end
    end
    assign winer_man24 = {|winer[30:23], winer[22:0]};
    assign exp = winer[30:23];
    assign sign = win_or_lose? b[31] : a[31];
    assign op_sub = winer[31] ^ loser[31];
    always_comb begin
    	loser_man24 <= {|loser[30:23], loser[22:0]};
    	winer_is_inf <= &winer[30:23] & ~|winer[22:0];
    	loser_is_inf <= &loser[30:23] & ~|loser[22:0];
    	winer_is_nan <= &winer[30:23] & |winer[22:0];
    	loser_is_nan <= &loser[30:23] & |loser[22:0];
    	nan_man <= ({1'b0, a[22:0]} > {1'b0, b[22:0]})? {1'b0, a[21:0]} : {1'b0, b[21:0]};
    end
    assign is_inf = winer_is_inf | loser_is_inf;
    assign is_nan = winer_is_nan | loser_is_nan | (winer[31] ^ loser[31]) & winer_is_inf & loser_is_inf;
    assign inf_nan_man = is_nan? nan_man : 23'h0;
    always_comb begin	
    	if ((winer[30:23] != 0) & (loser[30:23] == 0)) begin
    	    shift_amount <= (winer[30:23] - loser[30:23]) - 8'h1;
    	end else begin
    	    shift_amount <= winer[30:23] - loser[30:23];
    	end
    end
    always_comb begin
        if (shift_amount >= 26) begin
    	    loser_man50 <= {26'h0, loser_man24};
    	end else begin
    	    loser_man50 <= ({loser_man24, 26'h0} >> shift_amount);
    	end
    end
    assign loser_man27 = {loser_man50[49:24], |loser_man50[23:0]};
endmodule

module karen_calcu (
    input logic op_sub,
    input logic [23:0] winer_man24,
    input logic [26:0] loser_man27,
    output logic [27:0] man28
	);
	
	logic [27:0] aligned_winer_man;
	logic [27:0] aligned_loser_man;
    
	always_comb begin
		aligned_winer_man <= {1'b0, winer_man24, 3'b000};
    	aligned_loser_man <= {1'b0, loser_man27};
    end
    assign man28 = op_sub? (aligned_winer_man - aligned_loser_man) : (aligned_winer_man + aligned_loser_man);
endmodule

module karen_norm (
    input logic is_nan,
    input logic is_inf,
    input logic [22:0] inf_nan_man,
    input logic sign,
    input logic [7:0] exp,
    input logic [27:0] man,
    output logic [31:0] ans,
    output logic [4:0] number_of_zero
//    output logic man_sub,
//    output logic man_after_round
	);

    logic [26:0] sub_man0, sub_man1, sub_man2, sub_man3, sub_man4;
    logic [4:0] number_of_zero;
    logic [7:0] exp_sub;
    logic [26:0] man_sub;
    logic man_plus;
    logic [24:0] man_after_round;
    logic [7:0] exp_sub_sub;
    logic overflow;
 
    assign number_of_zero[4] = ~|man[26:11];
    assign sub_man4 = number_of_zero[4]? {man[10:0], 16'b0} : man[26:0];
    assign number_of_zero[3] = ~|sub_man4[26:19];
    assign sub_man3 = number_of_zero[3]? {sub_man4[18:0], 8'b0} : sub_man4;
    assign number_of_zero[2] = ~|sub_man3[26:23];
    assign sub_man2 = number_of_zero[2]? {sub_man3[22:0], 4'b0} : sub_man3;
    assign number_of_zero[1] = ~|sub_man2[26:25];
    assign sub_man1 = number_of_zero[1]? {sub_man2[24:0], 2'b0} : sub_man2;
    assign number_of_zero[0] = ~sub_man1[26];
    assign sub_man0 = number_of_zero[0]? {sub_man1[25:0], 1'b0} : sub_man1;
	always_comb begin
        if (man[27]) begin
            man_sub <= man[27:1];
            exp_sub <= exp + 8'h1;
        end else begin
            if ((exp > number_of_zero) && (sub_man0[26])) begin
                exp_sub <= exp - number_of_zero;
                man_sub <= sub_man0;
            end else begin
				if((exp == 0) && man[26])
					exp_sub <= 8'h1;
				else
                	exp_sub <= 0;
                if(exp != 0)
                    man_sub <= man[26:0] << (exp - 8'h1);
                else man_sub <= man[26:0];
            end
        end
    end
    always_comb begin
		if (man[27]) begin
				man_plus <= man_sub[2] &  (man_sub[3] | man_sub[1] | man_sub[0] | man[0]);
		end else begin
    			man_plus <= man_sub[2] & (man_sub[3] | man_sub[1] | man_sub[0]);
		end
    end
    always_comb begin
    	man_after_round <= {1'b0, man_sub[26:3]} + man_plus;
    end
    always_comb begin
    	exp_sub_sub <= man_after_round[24]? exp_sub + 8'h1 : exp_sub;
    end	
    always_comb begin
    	overflow <= &exp_sub | &exp_sub_sub;
	end
    assign ans =  result (overflow, sign, is_nan, is_inf, inf_nan_man, exp_sub_sub, man_after_round[22:0]);
    function [31:0] result;
        input logic overflow;
        input logic sign;
        input logic is_nan;
        input logic is_inf;
        input logic [22:0] inf_nan_man;
        input logic [7:0] exponent;
        input logic [22:0] mantissa;
        casex ({overflow, is_nan, is_inf})
            3'b1_0_0 : result = {sign, 8'hff, 23'h000000};
            3'b0_0_0 : result = {sign, exponent, mantissa};
            3'bx_1_x : result = {1'b1, 8'hff, inf_nan_man};
            3'bx_0_1 : result = {sign, 8'hff, inf_nan_man};
            default  : result = {sign, 8'h00, 23'h000000};
        endcase
    endfunction
endmodule
