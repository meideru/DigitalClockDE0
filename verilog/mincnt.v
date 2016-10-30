
// 分カウンタ

module MINCNT(
	input CLK, RST,		// クロック信号とリセット信号
	input EN, INC,			// イネーブル信号と+1分信号
	output reg [2:0] QH,	// 10の位の桁の信号
	output reg [3:0] QL,	// 1の位の桁の信号
	output CA				// 桁上がり信号
);

// 1分桁
always @(posedge CLK, posedge RST)begin
	if(RST)
		QL <= 4'd0;
	else if(EN == 1'b1 || INC == 1'b1)begin
		if(QL == 4'd9)
			QL <= 4'd0;
		else
			QL <= QL + 1'b1;
	end
end

// 10分桁
always @(posedge CLK, posedge RST)begin
	if(RST)
		QH <= 3'd0;
	else if((EN == 1'b1 || INC == 1'b1) && QL == 4'd9)begin
		if(QH == 3'd5)
			QH <= 3'd0;
		else
			QH <= QH + 1'b1;
	end
end

// 桁上がり信号
assign CA = (QH == 3'd5 && QL == 4'd9 && EN == 1'b1);

endmodule