
// 点滅対応の７セグデコーダ

module SEG7DEC(
	input [3:0] DIN,			// 変換前の入力信号
	input EN,					// 点灯信号
	output reg [6:0] HEX		// 変換後の信号
);

// 各セグメントはgfedcbaの並びで0で点灯
always @* begin
	if(EN)
		case(DIN)
			4'd0: HEX = 7'b1000000;
			4'd1: HEX = 7'b1111001;
			4'd2: HEX = 7'b0100100;
			4'd3: HEX = 7'b0110000;
			4'd4: HEX = 7'b0011001;
			4'd5: HEX = 7'b0010010;
			4'd6: HEX = 7'b0000010;
			4'd7: HEX = 7'b1011000;
			4'd8: HEX = 7'b0000000;
			4'd9: HEX = 7'b0010000;
			default:HEX = 7'b0000000;
		endcase
	else
		HEX = 7'b1111111;
end

endmodule