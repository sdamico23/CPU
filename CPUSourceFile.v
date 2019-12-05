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
    output reg[31:0]do
    );
reg [31:0]instructionmemory[0:511];


    initial
    begin 
    instructionmemory[100] = 32'h8c220000;
    instructionmemory[104] = 32'h8c230004; 
    instructionmemory[108] = 32'h8c240008;
    instructionmemory[112] = 32'h8c25000c;  
    instructionmemory[116]= 32'h004a3020;   
    end 
     
     always @(pc)
     begin
     do <= instructionmemory[pc];
     end
  
endmodule



module IFID( clk, do, opcode, rt, rs, rd, imm, shift,funcode
);
input clk;
input [31:0]do;
output reg [5:0]opcode, funcode;
output reg[4:0]rs, rt, rd, shift;
output reg [15:0]imm;

    always @(posedge clk)
    begin
    if (do[31:26]== 6'b100011) begin
    opcode<=do[31:26];
    rs <= do[25:21];
    rt <= do[20:16];
    imm <= do[15:0];
    end
    
    else begin
    opcode<=do[31:26];
    rs <= do[25:21];
    rt <= do[20:16];
    rd <= do[15:11]; 
    funcode <= do[5:0];
    end
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
        wreg<=1'b1; 
        m2reg <= 1'b1; 
        wmem<=1'b1; 
        aluimm<=1'b1; 
        regrt<=1'b1;
    end
    6'b000000:
    begin
        aluc <=4'b0010;
        wreg<=1'b1; 
        m2reg <= 1'b0; 
        wmem<=1'b0; 
        aluimm<=1'b0; 
        regrt<=1'b0; 
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
input clk,
input wwreg,
input [4:0]wmux,
input [31:0]d,
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
     always @(negedge clk) begin
      if (wwreg)
      regfile[wmux] = d;
      end
      always @(*)begin
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
input [31:0]qa;
input [31:0]qb;
input [31:0]signextendimm; 
output reg ewreg;
output reg em2reg;
output reg ewmem;
output reg [3:0]ealuc;
output reg ealuimm;
output reg[4:0]emux;
output reg[31:0]eqa;
output reg[31:0]eqb;
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

module mux2(ealuimm, eqb, esignextendimm, b);

input ealuimm;
input [31:0]eqb;
input [31:0]esignextendimm;
output reg [31:0]b;

    always @(*)
    if (ealuimm == 1'b1) begin
    b <= esignextendimm;
    end
    else begin
    b <= eqb;
    end
endmodule

module ALU(ealuc, a, b, r);
input [31:0]a;
input [31:0] b;
input [3:0]ealuc;
output reg [31:0]r;

always @(*) begin
if (ealuc == 4'b0010) begin
    r <= a+b;
    end
  end
endmodule


module exemem(clk, ewreg, em2reg, ewmem, emux, r, eqb, mwreg, mm2reg, mwmem, mmux, a, di);
input ewreg, em2reg, ewmem;
input clk;
input [4:0]emux;
input [31:0]r;
input [31:0]eqb;
output reg mwreg, mm2reg, mwmem;
output reg [4:0]mmux;
output reg[31:0]a;
output reg[31:0]di;

    always @(posedge clk)
    begin
    mwreg <= ewreg;
    mm2reg <=em2reg;
    mwmem <= ewmem;
    mmux <= emux;
    a <= r;
    di <= eqb;
    end
    
endmodule

module datamem(a, di, we, do2);

input [31:0]a;
input [31:0]di;
input we;
output reg [31:0]do2;
reg [31:0]datamemory[511:0];


    initial
    begin 
    datamemory[0] = 32'hA00000AA;
    datamemory[4] = 32'h10000011; 
    datamemory[8] = 32'h20000022;
    datamemory[12] = 32'h30000033;
    datamemory[16] = 32'h40000044;
    datamemory[20] = 32'h50000055;
    datamemory[24] = 32'h60000066;
    datamemory[28] = 32'h70000077;
    datamemory[32] = 32'h80000088;
    datamemory[36] = 32'h90000099;
         
    end 
  
     always @(*)
     if (we==1) begin
     do2 <= datamemory[a];
     end
  
endmodule

module memwb(clk, mwreg, mm2reg, a, mmux, do2, wwreg, wm2reg, wa, wmux, wdo);
input clk;
input mwreg, mm2reg; 
input [31:0]a, do2;
input [4:0]mmux;
output reg wwreg, wm2reg;
output reg [31:0]wa, wdo;
output reg [4:0]wmux;

always @(posedge clk) begin
    wwreg <= mwreg;
    wm2reg <=mm2reg;
    wa <=a;
    wdo <= do2;
    wmux <=mmux;
    end
endmodule

module mux3(wm2reg, wdo, wa, d);
input wm2reg;
input [31:0] wa,wdo;
output reg[31:0] d;

    always @(*)
    if (wm2reg == 1'b1) begin
    d <= wdo;
    end
    else begin
    d <= wa;
    end
endmodule
    


