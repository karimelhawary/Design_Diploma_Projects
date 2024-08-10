module Spartan6_DSP48A1_tb();
//Parameters
parameter A0REG=1'b0;
parameter A1REG=1'b1;
parameter B0REG=1'b0;
parameter B1REG=1'b1;
parameter CREG=1'b1;
parameter DREG=1'b1;
parameter MREG=1'b1;
parameter PREG=1'b1;
parameter CARRTINREG=1'b1;
parameter CARRYOUTREG=1'b1;
parameter OPMODEREG=1'b1;
parameter CARRYINSEL="OPMODE5";//or CARRYIN if it is input of user or if it is none the output of mux is 0
parameter B_INPUT="DIRECT";//or CASCADE if it is from BCIN as input or if it is none the output of mux is 0
parameter RSTTYPE="SYNC";//or ASYNE if it is asynchronus
//Data Ports
reg [17:0]A;
reg [17:0]B;
reg [17:0]BCIN;
reg [47:0]C;
reg [17:0]D;
reg CARRYIN;
wire [35:0]M;
wire [47:0]P;
wire CARRYOUT;
wire CARRYOUTF;
//Control Input Ports
reg CLK;
reg [7:0]OPMODE;
//Clock Enable Input Ports
reg CEA,CEB,CEC,CECARRYIN,CED,CEM,CEOPMODE,CEP;
//Reset Input Ports
reg RSTA,RSTB,RSTC,RSTCARRYIN,RSTD,RSTM,RSTOPMODE,RSTP;
//Cascade Ports
reg [47:0]PCIN;
wire [17:0]BCOUT;
wire[47:0]PCOUT;
Spartan6_DSP48A1 #(A0REG,A1REG,B0REG,B1REG,CREG,DREG,MREG,PREG,CARRTINREG,CARRYOUTREG,OPMODEREG,CARRYINSEL,B_INPUT,RSTTYPE) DUT (A,B,D,C,CLK,CARRYIN,OPMODE,BCIN,RSTA,RSTB,RSTM,RSTP,RSTC,RSTD,RSTCARRYIN,RSTOPMODE,CEA,CEB,CEM,CEP,CEC,CED,CECARRYIN,CEOPMODE,PCIN,BCOUT,PCOUT,P,M,CARRYOUT,CARRYOUTF);

//generate CLK
initial begin
	CLK=0;
	forever
	#1 CLK=~CLK;
end

//Testing
initial begin
    RSTA=1'b1;
    RSTB=1'b1;
    RSTC=1'b1;
    RSTCARRYIN=1'b1;
    RSTD=1'b1;
    RSTM=1'b1;
    RSTOPMODE=1'b1;
    RSTP=1'b1;
    A=18'h0;
    D=18'h0;
    C=18'h0;
    B=18'h0;
    OPMODE=8'h0;
    CARRYIN=1'b0;
    BCIN=18'h0;
    CEA=1'b0;
    CEB=1'b0;
    CEM=1'b0;
    CEP=1'b0;
    CEC=1'b0;
    CED=1'b0;
    CECARRYIN=1'b0;
    CEOPMODE=1'b0;
    PCIN=18'h0;
    repeat(50) @(negedge CLK);

    RSTA=1'b0;
    RSTB=1'b0;
    RSTC=1'b0;
    RSTCARRYIN=1'b0;
    RSTD=1'b0;
    RSTM=1'b0;
    RSTOPMODE=1'b0;
    RSTP=1'b0;
    repeat(50) @(negedge CLK);

    A=18'h2;
    D=18'h3;
    C=18'h4;
    B=18'h5;
    OPMODE=8'b00110010;
    CARRYIN=1'b1;
    BCIN=18'h0;
    CEA=1'b1;
    CEB=1'b1;
    CEM=1'b1;
    CEP=1'b1;
    CEC=1'b1;
    CED=1'b1;
    CECARRYIN=1'b1;
    CEOPMODE=1'b1;
    PCIN=18'h0;
    repeat(100) @(negedge CLK);

    A=18'h5;
    D=18'h4;
    C=18'h8;
    B=18'h9;
    OPMODE=8'b00111001;
    CARRYIN=1'b1;
    BCIN=18'h7;
    CEA=1'b1;
    CEB=1'b1;
    CEM=1'b1;
    CEP=1'b1;
    CEC=1'b1;
    CED=1'b1;
    CECARRYIN=1'b1;
    CEOPMODE=1'b1;
    PCIN=18'h3;

#100
$stop;
end
endmodule