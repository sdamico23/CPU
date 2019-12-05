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
wire [31:0]do, do2;
wire [31:0]qa;
wire [31:0]qb; 
wire [31:0]signextendimm;
wire [5:0]op, funcode;
wire [4:0]rs;
wire [4:0]rt;
wire [4:0]rd;
wire [4:0]out;
wire [4:0]emux, mmux, wmux;
wire [31:0]eqa;
wire [31:0]eqb;
wire [31:0]esignextendimm, b,r, a, di, wa, wdo,d;
wire [15:0]imm;
wire wreg, ewreg;
wire m2reg, em2reg, mwreg, mm2reg, mwmem, wwreg, wm2reg;
wire wmem, ewmem;
wire aluimm, ealuimm;
wire regrt;
wire [3:0] aluc, ealuc;

initial begin
clk = 0;
end
always 
#5 clk = !clk;
   

PC pc_tb(.clk(clk), .nextpc(nextpc), .currentpc(currentpc));
adder adder_tb(.pc(currentpc), .nextpc(nextpc));
IM im_tb(.pc(currentpc), .do(do));
IFID ifid_tb(.clk(clk), .do(do), .opcode(op), .rt(rt), .rs(rs), .rd(rd),.funcode(funcode), .imm(imm));
controlUnit cu_tb(.opcode(op), .wreg(wreg), .m2reg(m2reg), .wmem(wmem), .aluc(aluc), .aluimm(aluimm), .regrt(regrt));
mp mp_tb(.rd(rd), .rt(rt), .regrt(regrt), .out(out));
regMem rm_tb(.rs(rs), .rt(rt),.clk(clk), .wwreg(wwreg), .wmux(wmux), .d(d), .qa(qa), .qb(qb));
signExtend se_tb(.imm(imm), .signextendimm(signextendimm));
IDEXE idexe_tb(.clk(clk), .wreg(wreg), .m2reg(m2reg), .wmem(wmem), .aluc(aluc), .aluimm(aluimm), .mux(out), .qa(qa), .qb(qb), .signextendimm(signextendimm), .ewreg(ewreg), .em2reg(em2reg), .ewmem(ewmem), .ealuc(ealuc), .ealuimm(ealuimm), .emux(emux), .eqa(eqa), .eqb(eqb), .esignextendimm(esignextendimm));
mux2 mux2_tb(.ealuimm(ealuimm), .eqb(eqb), .esignextendimm(esignextendimm), .b(b));
ALU alu_tb(.ealuc(ealuc), .a(eqa), .b(b), .r(r));
exemem exemem_tb(.clk(clk), .ewreg(ewreg), .em2reg(em2reg), .ewmem(ewmem), .emux(emux), .r(r), .eqb(eqb), .mwreg(mwreg), .mm2reg(mm2reg), .mwmem(mwmem), .mmux(mmux), .a(a), .di(di));
datamem datamem_tb(.a(a), .di(di), .we(mwmem), .do2(do2));
memwb memwb_tb(.clk(clk), .mwreg(mwreg), .mm2reg(mm2reg), .a(a), .mmux(mmux), .do2(do2), .wm2reg(wm2reg), .wa(wa), .wmux(wmux),.wwreg(wwreg), .wdo(wdo));
mux3 mux3_tb(.wm2reg(wm2reg), .wdo(wdo), .wa(wa), .d(d));

endmodule
