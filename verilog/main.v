
// 最上位部

/*
	【ルール】
	・MODEはBTN0, SELECTはBNT1, RESETはBTN2
	・リセットはSW[0]で行う
*/

module MAIN(
	input CLOCK_50,		// クロック信号
	input [2:0] BUTTON,	// ボタン
	input [9:0] SW,		// スイッチ
	output [9:0] LEDG,	// 秒
	output [7:0] HEX0_D, HEX1_D, HEX2_D, HEX3_D	// 時・分
);

// クロック信号
wire CLK;
assign CLK = CLOCK_50;
// リセット信号
wire RST;
assign RST = SW[0];

// 桁上がり信号
wire CASEC, CAMIC;
// ボタン信号
wire MODE, SELECT, ADJUST;
// 操作信号
wire SECCLR, MININC, HOURINC;
// 点滅信号
wire SECON, MINON, HOURON;
// イネーブル信号
wire EN1HZ, SIG2HZ;
// ボタン信号
wire [2:0] btn;
// 1の桁の信号
wire [3:0] SECL, MINL, HOURL;
// 10の桁の信号
wire [2:0] SECH, MINH;
// 10の桁の信号
wire [1:0] HOURH;

// 各ブロックの接続
CNT1SEC CNT1SEC(.CLK(CLK), .RST(RST), .EN1HZ(EN1HZ), .SIG2HZ(SIG2HZ));
BTN_IN BTN_IN0(.CLK(CLK), .BIN(BUTTON[0]), .BOUT(MODE));
BTN_IN BTN_IN1(.CLK(CLK), .BIN(BUTTON[1]), .BOUT(SELECT));
BTN_IN BTN_IN2(.CLK(CLK), .BIN(BUTTON[2]), .BOUT(ADJUST));
SECCNT SEC(.CLK(CLK), .RST(RST), .EN(EN1HZ), .CLR(SECCLR),
				.QH(SECH), .QL(SECL), .CA(CASEC));
MINCNT MIN(.CLK(CLK), .RST(RST), .EN(CASEC), .INC(MININC),
				.QH(MINH), .QL(MINL), .CA(CAMIN));
HOURCNT HOUR(.CLK(CLK), .RST(RST), .EN(CAMIN), .INC(HOURINC),
					.QH(HOURH), .QL(HOURL));
STATE STATE(.CLK(CLK), .RST(RST), .SIG2HZ(SIG2HZ),
					.MODE(MODE), .SELECT(SELECT), .ADJUST(ADJUST),
					.SECCLR(SECCLR), .MININC(MININC), .HOURINC(HOURINC),
					.SECON(SECON), .MINON(MINON), .HOURON(HOURON));

SEG7DEC ML(.DIN(MINL), .EN(MINON), .HEX(HEX0_D[6:0]));
SEG7DEC MH(.DIN({1'b0, MINH}), .EN(MINON), .HEX(HEX1_D[6:0]));
SEG7DEC HL(.DIN(HOURL), .EN(HOURON), .HEX(HEX2_D[6:0]));
SEG7DEC HH(.DIN({2'b00, HOURH}), .EN(HOURON), .HEX(HEX3_D[6:0]));

// 秒桁の点滅制御
assign LEDG[3:0] = (SECON == 1'b1) ? SECL : 4'd0;
assign LEDG[6:4] = (SECON == 1'b1) ? SECH : 3'h0;
assign LEDG[9:7] = 3'h0;

assign HEX0_D[7] = 1'b1;
assign HEX1_D[7] = 1'b1;
assign HEX2_D[7] = 1'b0;
assign HEX3_D[7] = 1'b1;

endmodule