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
wire [31:0]do, do2,ido;
wire [31:0]qa;
wire [31:0]qb; 
wire [31:0]signextendimm;
wire [4:0]out;
wire [31:0]esignextendimm, b,r, a, di, wa, wdo,d;
wire [15:0]imm;
wire wreg, ewreg;
wire m2reg, em2reg, mwreg, mm2reg, mwmem, wwreg, wm2reg;
wire wmem, ewmem;
wire aluimm, ealuimm;
wire regrt;
wire [3:0] aluc, ealuc;
wire [1:0] fwda, fwdb;
wire [4:0] mrn,ern,wrn;
wire [31:0]fwdaout, fwdbout, efwdaout,efwdbout;
initial begin
clk = 0;
end
always 
#5 clk = !clk;
   

PC pc_tb(.clk(clk), .nextpc(nextpc), .currentpc(currentpc));
adder adder_tb(.pc(currentpc), .nextpc(nextpc));
IM im_tb(.pc(currentpc), .do(do));
IFID ifid_tb(.clk(clk), .do(do), .ido(ido));
controlUnit cu_tb(.ido(ido), .mrn(mrn), .ern(ern), .mm2reg(mm2reg), .mwreg(mwreg), .em2reg(em2reg), .ewreg(ewreg), .fwda(fwda), .fwdb(fwdb), .wreg(wreg), .m2reg(m2reg), .wmem(wmem), .aluc(aluc), .aluimm(aluimm), .regrt(regrt));
mp mp_tb(.ido(ido), .regrt(regrt), .out(out));
regMem rm_tb(.ido(ido),.clk(clk), .wwreg(wwreg), .wrn(wrn), .d(d), .qa(qa), .qb(qb));
signExtend se_tb(.ido(ido), .signextendimm(signextendimm));
IDEXE idexe_tb(.clk(clk), .ern(ern), .fwdaout(fwdaout), .fwdbout(fwdbout),.efwdaout(efwdaout), .efwdbout(efwdbout), .wreg(wreg), .m2reg(m2reg), .wmem(wmem), .aluc(aluc), .aluimm(aluimm), .out(out), .signextendimm(signextendimm), .ewreg(ewreg), .em2reg(em2reg), .ewmem(ewmem), .ealuc(ealuc), .ealuimm(ealuimm),  .esignextendimm(esignextendimm));
mux2 mux2_tb(.ealuimm(ealuimm), .efwdbout(efwdbout), .esignextendimm(esignextendimm), .b(b));
ALU alu_tb(.ealuc(ealuc), .efwdaout(efwdaout), .b(b), .r(r));
exemem exemem_tb(.clk(clk), .ewreg(ewreg), .em2reg(em2reg), .ewmem(ewmem), .ern(ern), .r(r), .eqb(eqb), .mwreg(mwreg), .mm2reg(mm2reg), .mwmem(mwmem), .mrn(mrn), .a(a), .di(di));
datamem datamem_tb(.a(a), .di(di), .mwmem(mwmem), .do2(do2));
memwb memwb_tb(.clk(clk), .mwreg(mwreg), .mm2reg(mm2reg), .a(a), .mrn(mrn), .do2(do2), .wm2reg(wm2reg), .wa(wa), .wrn(wrn),.wwreg(wwreg), .wdo(wdo));
mux3 mux3_tb(.wm2reg(wm2reg), .wdo(wdo), .wa(wa), .d(d));
muxa muxa_tb(.fwda(fwda), .qa(qa), .r(r), .a(a), .do2(do2), .fwdaout(fwdaout));
muxb muxb_tb(.fwdb(fwdb), .qb(qb), .r(r), .a(a), .do2(do2), .fwdbout(fwdbout));
endmodule
