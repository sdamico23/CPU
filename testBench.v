`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/31/2019 04:42:10 PM
// Design Name: 
// Module Name: testBench
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


module testBench(    );
    
reg clk;
wire [31:0]currentpc;
wire [31:0]nextpc;
wire [31:0]instruction;
wire [31:0]qa;
wire [31:0]qb; 
wire [31:0]signextendimm;
wire [5:0]op;
wire [4:0]rs;
wire [4:0] rt;
wire [4:0]rd;
wire [4:0]out;
wire [4:0]emux;
wire [4:0]eqa;
wire [4:0]eqb;
wire [4:0]esignextendimm;
wire [15:0]imm;
wire wreg;
wire m2reg;
wire wmem;
wire aluimm;
wire regrt;
wire [3:0] aluc;

initial begin
clock = 0;
end
always 
#5 clk = !clk;
   

PC pc_tb(.clk(clk), .nextpc(nextpc), .currentpc(currentpc));
adder adder_tb(.pc(currentpc), .nextpc(nextpc));
IM im_tb(.pc(currentpc), .instruction(instruction));
IFID ifid_tb(.clk(clk), .instruction(instruction), .opcode(op), .rt(rt), .rs(rs), .rd(rd), .imm(imm));
controlUnit cu_tb(.opcode(op), .wreg(wreg), .m2reg(m2reg), .wmem(wmem), .aluc(aluc), .aluimm(aluimm), .regrt(regrt));
mp mp_tb(.rd(rd), .rt(rt), .regrt(regrt), .out(out));
regMem rm_tb(.rs(rs), .rt(rt), .qa(qa), .qb(qb));
signExtend se_tb(.imm(imm), .signextendimm(signextendimm));
IDEXE idexe_tb(.clk(clk), .wreg(wreg), .m2reg(m2reg), .wmem(wmem), .aluc(aluc), .aluimm(aluimm), .mux(out), .qa(qa), .qb(qb), .signextendimm(signextendimm), .ewreg(ewreg), .em2reg(em2reg), .ewmem(ewmem), .ealuc(ealuc), .ealuimm(ealuimm), .emux(emux), .eqa(eqa), .eqb(eqb), .esignextendimm(esignextendimm));



endmodule
