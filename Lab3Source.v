`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/29/2019 05:17:00 PM
// Design Name: 
// Module Name: Lab3Source
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
module PC(
    input clk, 
    input [31:0]nextpc,
    output reg [31:0]currentpc   
    );
    
    always@(posedge clk)
    begin
    currentpc<=nextpc;
    end
    
    initial begin
    currentpc=100;
    end   
    
endmodule 

module adder( pc, nextpc

    );
input [31:0]pc;
output reg [31:0]nextpc;
     always @(*) begin 
     nextpc <= pc+4;
     end
endmodule


module IM(
    input [31:0] pc,
    output reg[31:0]instruction
    );
reg [31:0]instructionmemory[511:0];


    initial
    begin 
    instructionmemory[100] = 32'h8c220000;
    instructionmemory[104] = 32'h8c230004;      
    end 
     
     always @(pc)
     begin
     instruction <= instructionmemory[pc];
     end
  
endmodule



module IFID( clk, instruction, opcode, rt, rs, rd, imm

);
input clk;
input [31:0]instruction;
output reg [5:0]opcode;
output reg[4:0]rs, rt, rd;
output reg [15:0]imm;

    always @(posedge clk)
    begin
    opcode<=instruction[31:26];
    rs <= instruction[25:21];
    rt <= instruction[20:16];
    rd <= instruction[15:11];
    imm <= instruction[15:0];
    end
endmodule 



module controlUnit( opcode, wreg, m2reg, wmem, aluc, aluimm, regrt);

input [5:0]opcode;
output reg wreg;
output reg m2reg;
output reg wmem;
output reg [3:0]aluc;
output reg aluimm;
output reg regrt;

    always @(opcode) begin
    case (opcode)
    6'b100011:
    begin 
        aluc <=4'b0010;
        wreg=1'b1; 
        m2reg = 1'b1; 
        wmem=1'b0; 
        aluimm=1'b1; 
        regrt=1'b1;
    end
    endcase
    end

endmodule
    


module mp( rd, rt, regrt, out);

input [4:0]rd;
input [4:0]rt;
input regrt;
output reg[4:0]out;

always @ (*)
    if (regrt == 1) begin
        out <= rt;
        end
    else begin
        out <= rd;
        end
endmodule




module regMem(
input [4:0]rs,
input [4:0]rt,
output reg[31:0]qa,
output reg[31:0]qb
    );
reg [31:0]regfile[31:0];

    //always @(negedge clk)
integer i;
    initial begin 
    for (i=0;i<32; i= i+1)
        regfile[i] = 0;
        end
     always @(*) begin
        qa <= regfile[rs];
        qb <= regfile[rt];
     end

endmodule


module signExtend( imm, signextendimm
);
input [15:0]imm;
output reg [31:0]signextendimm;

//look at 16th bit, extend by that bit
    always @(*)  begin
    signextendimm <= {{16{imm[15]}}, imm[15:0]};
    end 
 

       
endmodule

module IDEXE( clk, wreg, m2reg, wmem, aluc, aluimm, mux, qa, qb, signextendimm, ewreg, em2reg, ewmem, ealuc, ealuimm, emux, eqa, eqb, esignextendimm
);
input clk;
input wreg;
input m2reg;
input wmem;
input [3:0]aluc;
input aluimm;
input [4:0]mux;
input [4:0]qa;
input [4:0]qb;
input [31:0]signextendimm; 
output reg ewreg;
output reg em2reg;
output reg ewmem;
output reg [3:0]ealuc;
output reg ealuimm;
output reg[4:0]emux;
output reg[4:0]eqa;
output reg[4:0]eqb;
output reg[31:0]esignextendimm; 

    always @(posedge clk)
    begin
    ewreg <= wreg;
    em2reg <= m2reg;
    ewmem <= wmem;
    ealuc <= aluc;
    ealuimm <= aluimm;
    emux <= mux;
    eqa <= qa;
    eqb <= qb;
    esignextendimm <= signextendimm;
    end
    
endmodule 
