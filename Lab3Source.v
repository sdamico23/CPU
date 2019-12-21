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
//need to fix instruction mem, testbench
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
    instructionmemory[100] = 32'h00221820;
    instructionmemory[104] = 32'h01232022; 
    instructionmemory[108] = 32'h00692825;
    instructionmemory[112] = 32'h00693026;  
    instructionmemory[116]= 32'h00693824;   
    end 
     
     always @(pc)
     begin
     do <= instructionmemory[pc];
     end
  
endmodule


module IFID( clk, do, ido
);
input clk;
input [31:0]do;
output reg [31:0]ido;

    always @(posedge clk)
    begin 
    ido<= do;
    end   
endmodule 



module controlUnit( ido, wreg, m2reg, wmem, aluc, aluimm, regrt, mrn, mm2reg, mwreg, ern, em2reg, ewreg, fwda, fwdb);

input [31:0]ido;
input [4:0]mrn, ern;
input mm2reg, mwreg, em2reg,ewreg;
wire [5:0]opcode = {ido[31:26]};
wire [5:0] func = {ido[5:0]};
wire [4:0]rs = {ido[25:21]};
wire [4:0]rt = {ido[20:16]};
output reg [1:0] fwda, fwdb;
output reg wreg;
output reg m2reg;
output reg wmem;
output reg [3:0]aluc;
output reg aluimm;
output reg regrt;

    always @(*)
        if (opcode ==6'b000000) begin
            //add instr
            if (func==6'b100000) begin
            wreg <=1;
            m2reg <= 0;
            wmem <= 0;
            aluimm <= 0;
            regrt <= 0;
            aluc <= 4'b0010;
            end
            //sub instr
            else if (func == 6'b100010) begin
            wreg <=1; 
            m2reg <= 0;
            wmem <= 0;
            aluimm <= 0;
            regrt <= 0;
            aluc <= 4'b0101;
            end
            //and instr
            else if (func == 6'b100100) begin
            wreg <=1;
            m2reg <= 0;
            wmem <= 0;
            aluimm <= 0;
            regrt <= 0;
            aluc <= 4'b0000;
            end
            //or instr
            else if (func == 6'b100101) begin
            wreg <=1;
            m2reg <= 0;
            wmem <= 0;
            aluimm <= 0;
            regrt <= 0;
            aluc <= 4'b0001;
            end
            //xor instr
            else if (func == 6'b100110) begin
            wreg <=1;
            m2reg <= 0;
            wmem <= 0;
            aluimm <= 0;
            regrt <= 0;
            aluc <= 4'b0011;
            end
            end
     always @(*) begin       
     if ( ern == rs)begin
        fwda <= 2'b01;
        end
     else if (mrn == rs) begin 
        fwda <=2'b10;
        end
     else begin
     fwda<=2'b00;
     end 
     end
     
     always @(*) begin
     if (ern == rt) begin
     fwdb <=2'b01;
     end
     else if (mrn ==rt) begin 
     fwdb <= 2'b10;
     end
     else begin 
     fwdb<=2'b00;
     end
    end 
          
endmodule
    


module mp( ido, regrt, out);
input [31:0]ido;
wire [4:0]rd = {ido[15:11]};
wire [4:0]rt = {ido[20:16]};
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
input [4:0]wrn,
input[31:0]ido,
input [31:0]d,
output reg[31:0]qa,
output reg[31:0]qb
);
wire [4:0]rt = {ido[20:16]};
wire [4:0]rs = {ido[25:21]};
reg [31:0]regfile[127:0];


    initial begin 
    regfile[0] = 32'hA00000AA;
    regfile[1] = 32'h10000011; 
    regfile[2] = 32'h20000022;
    regfile[3] = 32'h30000033;
    regfile[4] = 32'h40000044;
    regfile[5] = 32'h50000055;
    regfile[6] = 32'h60000066;
    regfile[7] = 32'h70000077;
    regfile[8] = 32'h80000088;
    regfile[9] = 32'h90000099;
    end 
    
     always @(negedge clk) begin
      if (wwreg)
      regfile[wrn] = d;
      end
      always @(*)begin
       qa <= regfile[rs];
       qb <= regfile[rt];
       end

endmodule


module signExtend( ido, signextendimm
);
input [31:0]ido;
output reg [31:0]signextendimm;
wire [15:0]imm = {ido[15:0]};
//look at 16th bit, extend by that bit
    always @(*)  begin
    signextendimm <= {{16{imm[15]}}, imm[15:0]};
    end 
 

       
endmodule

module IDEXE( clk, wreg, m2reg, wmem, aluc, aluimm, out, fwdaout, fwdbout, signextendimm, ewreg, em2reg, ewmem, ealuc, ealuimm, ern, efwdbout, efwdaout, esignextendimm
);
input clk;
input wreg;
input m2reg;
input wmem;
input [3:0]aluc;
input aluimm;
input [4:0]out;
input [31:0]fwdaout;
input [31:0]fwdbout;
input [31:0]signextendimm; 
output reg ewreg;
output reg em2reg;
output reg ewmem;
output reg [3:0]ealuc;
output reg ealuimm;
output reg[4:0]ern;
output reg[31:0]efwdaout;
output reg[31:0]efwdbout;
output reg[31:0]esignextendimm; 

    always @(posedge clk)
    begin
    ewreg <= wreg;
    em2reg <= m2reg;
    ewmem <= wmem;
    ealuc <= aluc;
    ealuimm <= aluimm;
    ern <= out;
    efwdaout <= fwdaout;
    efwdbout <= fwdbout;
    esignextendimm <= signextendimm;
    end
    
endmodule 

module mux2(ealuimm, efwdbout, esignextendimm, b);

input ealuimm;
input [31:0]efwdbout;
input [31:0]esignextendimm;
output reg [31:0]b;

    always @(*)
    if (ealuimm == 1'b1) begin
    b <= esignextendimm;
    end
    else begin
    b <= efwdbout;
    end
endmodule

module ALU(ealuc, efwdaout, b, r);
input [31:0]efwdaout;
input [31:0] b;
input [3:0]ealuc;
output reg [31:0]r;

    always @(*) begin
    if (ealuc == 4'b0010) begin
        r <= efwdaout+b;
    end
    else if (ealuc == 4'b0000) begin
        r <= efwdaout&b;
    end
    else if (ealuc == 4'b0001) begin
        r <= (efwdaout|b);
    end
    else if (ealuc == 4'b0011) begin
        r <= (efwdaout^b);
    end
    else if (ealuc == 4'b0101) begin
        r <= efwdaout-b;
    end
  end
endmodule


module exemem(clk, ewreg, em2reg, ewmem, ern, r, eqb, mwreg, mm2reg, mwmem, mrn, a, di);
input ewreg, em2reg, ewmem;
input clk;
input [4:0]ern;
input [31:0]r;
input [31:0]eqb;
output reg mwreg, mm2reg, mwmem;
output reg [4:0]mrn;
output reg[31:0]a;
output reg[31:0]di;

    always @(posedge clk)
    begin
    mwreg <= ewreg;
    mm2reg <=em2reg;
    mwmem <= ewmem;
    mrn <= ern;
    a <= r;
    di <= eqb;
    end
    
endmodule

module datamem(a, di, mwmem, do2);

input [31:0]a;
input [31:0]di;
input mwmem;
output reg [31:0]do2;
reg [31:0]datamemory[511:0];


    initial
    begin 
    datamemory[0] = 32'hA00000AA;
    datamemory[1] = 32'h10000011; 
    datamemory[2] = 32'h20000022;
    datamemory[3] = 32'h30000033;
    datamemory[4] = 32'h40000044;
    datamemory[5] = 32'h50000055;
    datamemory[6] = 32'h60000066;
    datamemory[7] = 32'h70000077;
    datamemory[8] = 32'h80000088;
    datamemory[9] = 32'h90000099;
         
    end 
  
     always @(*)
     if (mwmem==1) begin
     do2 <= datamemory[a];
     end
  
endmodule

module memwb(clk, mwreg, mm2reg, a, mrn, do2, wwreg, wm2reg, wa, wrn, wdo);
input clk;
input mwreg, mm2reg; 
input [31:0]a, do2;
input [4:0]mrn;
output reg wwreg, wm2reg;
output reg [31:0]wa, wdo;
output reg [4:0]wrn;

always @(posedge clk) begin
    wwreg <= mwreg;
    wm2reg <=mm2reg;
    wa <=a;
    wdo <= do2;
    wrn <=mrn;
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
 
 
module muxa(fwda, qa, r, a, do2, fwdaout);
input [1:0] fwda;
input [31:0]qa,r,a,do2;
output reg[31:0]fwdaout;

    always @(*) begin
    if (fwda==2'b00) begin
        fwdaout <= qa;
        end
    else if (fwda ==2'b01) begin
        fwdaout <= r;
        end
    else if (fwda ==2'b10) begin
        fwdaout <= a;
        end
   else if (fwda ==2'b11) begin
        fwdaout <= do2;
        end
        end
        
endmodule

module muxb(fwdb, qb, r, a, do2, fwdbout);
input [1:0] fwdb;
input [31:0]qb,r,a,do2;
output reg[31:0]fwdbout;

    always @(*) begin
    if (fwdb==2'b00) begin
        fwdbout <= qb;
        end
    else if (fwdb ==2'b01) begin
        fwdbout <= r;
        end
    else if (fwdb ==2'b10) begin
        fwdbout <= a;
        end
   else if (fwdb ==2'b11) begin
        fwdbout <= do2;
        end
        end
        
endmodule
    
   


