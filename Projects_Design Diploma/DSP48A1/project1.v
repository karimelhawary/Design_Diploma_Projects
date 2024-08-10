`include "MUX4x1.V"
`include "REG_MUX.v"

module Spartan6_DSP48A1(A,B,D,C,CLK,CARRYIN,OPMODE,BCIN,RSTA,RSTB,RSTM,RSTP,RSTC,RSTD,RSTCARRYIN,RSTOPMODE,
                            CEA,CEB,CEC,CEM,CEP,CED,CECARRYIN,CEOPMODE,PCIN,BCOUT,PCOUT,P,M,CARRYOUT,CARRYOUTF);

//PARAMETERS
parameter A0REG = 1'b0;
parameter A1REG = 1'b1;
parameter B0REG = 1'b0;
parameter B1REG = 1'b1;
parameter CREG = 1'b1;
parameter DREG = 1'b1;
parameter MREG = 1'b1; 
parameter PREG = 1'b1;
parameter CARRYINREG = 1'b1;
parameter CARRYOUTREG = 1'b1;
parameter OPMODEREG = 1'b1;
parameter CARRYINSEL = "OPMODE5";
parameter B_INPUT = "DIRECT";
parameter RSTTYPE = "SYNC";
//Data Ports
input [17:0]A;
input [17:0]B;
input [17:0]BCIN;
input [47:0]C;
input [17:0]D;
input CARRYIN;
output [35:0]M;
output [47:0]P;
output CARRYOUT;
output CARRYOUTF;
//Control Input Ports
input CLK;
input [7:0]OPMODE;
//Clock Enable Input Ports
input CEA,CEB,CEC,CECARRYIN,CED,CEM,CEOPMODE,CEP;
//Reset Input Ports
input RSTA,RSTB,RSTC,RSTCARRYIN,RSTD,RSTM,RSTOPMODE,RSTP;
//Cascade Ports
input [47:0]PCIN;
output [17:0]BCOUT;
output[47:0]PCOUT;

//Wires
wire [17:0]D_WIRE ;
wire [17:0]B0_WIRE ;
wire [17:0]B1_WIRE ;
wire [17:0]B_IN_WIRE;
wire [17:0]D_B0_MUX_WIRE;
wire [17:0]A0_WIRE ;
wire [17:0]A1_WIRE ;
wire [47:0]C_WIRE ;
wire [35:0]A1xB1_OUT_WIRE ;
wire [35:0]M_WIRE ;
wire CARRYIN_WIRE;
wire CARRYOUT_WIRE;
wire CY1_WIRE;
wire CY0_WIRE;
wire [47:0]X_Z_MUX;
wire [47:0]P_WIRE ;
wire [47:0]X_WIRE ;
wire [47:0]D_A_B_CONCAT_WIRE; //D[11:0],A[17:0],B[17:0]
wire [47:0]Z_WIRE ;
wire [17:0]D_B0_PRE_ADD_SUB_WIRE ;
wire [7:0]OPMODE_WIRE;

reg_mux #(.WIDTH(18),.RSTTYPE(RSTTYPE)) D_REG (.CLK(CLK),.RST(RSTD),.EN(CED),.SEL(DREG),.D(D),.out(D_WIRE));
reg_mux #(.WIDTH(18),.RSTTYPE(RSTTYPE)) B0_REG (.CLK(CLK),.RST(RSTB),.EN(CEB),.SEL(B0REG),.D(B_IN_WIRE),.out(B0_WIRE));
reg_mux #(.WIDTH(18),.RSTTYPE(RSTTYPE)) A0_REG (.CLK(CLK),.RST(RSTA),.EN(CEA),.SEL(A0REG),.D(A),.out(A0_WIRE));
reg_mux #(.WIDTH(48),.RSTTYPE(RSTTYPE)) C_REG (.CLK(CLK),.RST(RSTC),.EN(CEC),.SEL(CREG),.D(C),.out(C_WIRE));

reg_mux #(.WIDTH(18),.RSTTYPE(RSTTYPE)) B1_REG (.CLK(CLK),.RST(RSTB),.EN(CEB),.SEL(B1REG),.D(D_B0_MUX_WIRE),.out(B1_WIRE));
reg_mux #(.WIDTH(18),.RSTTYPE(RSTTYPE)) A1_REG (.CLK(CLK),.RST(RSTA),.EN(CEA),.SEL(A1REG),.D(A0_WIRE),.out(A1_WIRE));
reg_mux #(.WIDTH(36),.RSTTYPE(RSTTYPE)) M_REG (.CLK(CLK),.RST(RSTM),.EN(CEM),.SEL(MREG),.D(A1xB1_OUT_WIRE),.out(M_WIRE));

reg_mux #(.WIDTH(1),.RSTTYPE(RSTTYPE)) CY1 (.CLK(CLK),.RST(RSTCARRYIN),.EN(CECARRYIN),.SEL(CARRYINREG),.D(CARRYIN_WIRE),.out(CY1_WIRE));
reg_mux #(.WIDTH(1),.RSTTYPE(RSTTYPE)) CY0 (.CLK(CLK),.RST(RSTCARRYIN),.EN(CECARRYIN),.SEL(CARRYOUTREG),.D(CARRYOUT_WIRE),.out(CY0_WIRE));

reg_mux #(.WIDTH(8),.RSTTYPE(RSTTYPE)) OPMODE_REG (.CLK(CLK),.RST(RSTOPMODE),.EN(CEOPMODE),.SEL(OPMODEREG),.D(OPMODE),.out(OPMODE_WIRE));

reg_mux #(.WIDTH(48),.RSTTYPE(RSTTYPE)) P_REG (.CLK(CLK),.RST(RSTP),.EN(CEP),.SEL(PREG),.D(X_Z_MUX),.out(P_WIRE));

mux4x1 #(.WIDTH(48)) X_MUX (.IN0(48'h000000000000),.IN1({12'h000,M_WIRE}),.IN2(P_WIRE),.IN3(D_A_B_CONCAT_WIRE),.SEL(OPMODE_WIRE[1:0]),.out(X_WIRE));
mux4x1 #(.WIDTH(48)) Z_MUX (.IN0(48'h000000000000),.IN1(PCIN),.IN2(P_WIRE),.IN3(C_WIRE),.SEL(OPMODE_WIRE[3:2]),.out(Z_WIRE));


assign B_IN_WIRE = (B_INPUT == "CASCADE") ? BCIN : (B_INPUT == "DIRECT") ? B : 0;
assign D_B0_PRE_ADD_SUB_WIRE = (OPMODE_WIRE[6]) ? (D_WIRE - B0_WIRE) : (D_WIRE + B0_WIRE);
assign D_B0_MUX_WIRE = (OPMODE_WIRE[4]) ? D_B0_PRE_ADD_SUB_WIRE : B0_WIRE;
assign A1xB1_OUT_WIRE = A1_WIRE * B1_WIRE ;
assign D_A_B_CONCAT_WIRE = {D_WIRE[11:0],A1_WIRE,B1_WIRE};
assign M_WIRE = M;
assign BCOUT = B1_WIRE;
assign CARRYIN_WIRE = (CARRYINSEL == "CARRYIN") ? CARRYIN : (CARRYINSEL == "OPMODE5") ? OPMODE_WIRE[5] : 0;
assign {CARRYOUT_WIRE,X_Z_MUX} = (OPMODE_WIRE[7]) ? (Z_WIRE - (X_WIRE + CY1_WIRE)) : (Z_WIRE + (X_WIRE + CY1_WIRE));
assign P = P_WIRE;
assign PCOUT = P_WIRE;
assign CARRYOUT = CY0_WIRE;
assign CARRYOUTF = CY0_WIRE;

endmodule

