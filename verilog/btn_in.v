
// チャタリング除去回路

module BTN_IN(
	input CLK,
	input BIN,
	output reg BOUT
);

/* 50MHzを1250000分周して40Hzを作る */
/* en40hzはシステムクロック1周期分のパルスで */
reg [20:0] cnt;

wire en40hz = (cnt == 1250000 - 1);

always @(posedge CLK) begin
	if(en40hz)
		cnt <= 21'b0;
	else
		cnt <= cnt + 21'b1;
end

/* ボタン入力をFF2個で受ける */
reg ff1, ff2;

always @(posedge CLK) begin
	if(en40hz) begin
		ff2 <= ff1;
		ff1 <= BIN;
	end
end

/* ボタンは押すと0なので、立下りを検出 */
wire temp = ~ff1 & ff2 & en40hz;

/* 念のためFFで受ける */
always @(posedge CLK) begin
	BOUT <= temp;
end

endmodule