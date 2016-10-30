
// ステートマシン

module STATE(
	input CLK, RST,	// クロック信号とリセット信号
	input SIG2HZ,		// 2Hzの入力信号
	input MODE, SELECT, ADJUST,		// ボタン信号（入力側）
	output SECCLR, MININC, HOURINC,	// ボタン信号（出力側）
	output SECON, MINON, HOURON		// ボタン信号（
);

// ステートマシン関連
reg [1:0] cur, nxt;	// 現在と次のステートレジスタ
parameter NORM = 2'b00, SEC = 2'b01, MIN = 2'b10, HOUR = 2'b11;

// 時刻修正信号
assign SECCLR = (cur == SEC) & ADJUST;
assign MININC = (cur == MIN) & ADJUST;
assign HOURINC = (cur == HOUR) & ADJUST;

// 修正桁点滅信号
assign SECON = ~((cur == SEC) & SIG2HZ);
assign MINON = ~((cur == MIN) & SIG2HZ);
assign HOURON = ~ ((cur == HOUR) & SIG2HZ);

// ステートレジスタ
always @(posedge CLK, posedge RST)begin
	if(RST)
		cur <= NORM;
	else
		cur <= nxt;
end

// 次の状態生成回路
always @* begin
	case(cur)
		NORM:	if(MODE)
					nxt = SEC;
				else
					nxt = NORM;
		SEC:	if(MODE)
					nxt = NORM;
				else if(SELECT)
					nxt = HOUR;
				else
					nxt = SEC;
		MIN:	if(MODE)
					nxt = NORM;
				else if(SELECT)
					nxt = SEC;
				else
					nxt = MIN;
		HOUR:	if(MODE)
					nxt = NORM;
				else if(SELECT)
					nxt = MIN;
				else
					nxt = HOUR;
		default: nxt = 2'bxx;
	endcase
end

endmodule