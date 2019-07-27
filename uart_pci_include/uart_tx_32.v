module UART_TX_32 #
(
	parameter CLOCK_FREQUENCY = 25_000_000,
	parameter BAUD_RATE       = 9600
)
(
	input  clockIN,
	input  nTxResetIN,
	input  [31:0] txDataIN,
	input  txLoadIN,
	output wire txIdleOUT,
	output wire txReadyOUT,
	output wire txOUT,
        output wire txReadyOUT_str
);

localparam HALF_BAUD_CLK_REG_VALUE = (CLOCK_FREQUENCY / BAUD_RATE / 2 - 1);
localparam HALF_BAUD_CLK_REG_SIZE  = $clog2(HALF_BAUD_CLK_REG_VALUE);

reg [HALF_BAUD_CLK_REG_SIZE-1:0] txClkCounter = 0;
reg txBaudClk       = 1'b0;
reg [39:0] txReg     = 40'h0000000001;
reg [5:0] txCounter = 6'h0;

reg txReadyOUT_reg0;
reg txReadyOUT_reg1;
reg txReadyOUT_reg2;
reg txReadyOUT_reg3;
reg txReadyOUT_reg4;
reg txReadyOUT_reg5;
reg txReadyOUT_reg6;
//wire txReadyOUT_str;

always @ (posedge clockIN)
begin
  if(!nTxResetIN)
  begin
    txReadyOUT_reg0 <= 1'b0;
    txReadyOUT_reg1 <= 1'b0;
    txReadyOUT_reg2 <= 1'b0;
    txReadyOUT_reg3 <= 1'b0;
    txReadyOUT_reg4 <= 1'b0;
    txReadyOUT_reg5 <= 1'b0;
    txReadyOUT_reg6 <= 1'b0;
  end else 
  begin
    txReadyOUT_reg0 <= txReadyOUT;
    txReadyOUT_reg1 <= txReadyOUT_reg0;
    txReadyOUT_reg2 <= txReadyOUT_reg1;
    txReadyOUT_reg3 <= txReadyOUT_reg2;
    txReadyOUT_reg4 <= txReadyOUT_reg3;
    txReadyOUT_reg5 <= txReadyOUT_reg4;
    txReadyOUT_reg6 <= txReadyOUT_reg5;
  end
end

assign txReadyOUT_str = txReadyOUT && !txReadyOUT_reg2;

assign txReadyOUT = !txCounter[5:1];
assign txIdleOUT  = txReadyOUT & (~txCounter[0]);
assign txOUT      = txReg[0];

always @(posedge clockIN) begin : tx_clock_generate
	if(txIdleOUT & (~txLoadIN)) begin
		txClkCounter <= 0;
		txBaudClk    <= 1'b0;
	end
	else if(txClkCounter == 0) begin
		txClkCounter <= HALF_BAUD_CLK_REG_VALUE;
		txBaudClk    <= ~txBaudClk;
	end
	else begin
		txClkCounter <= txClkCounter - 1'b1;
	end
end

always @(posedge txBaudClk or negedge nTxResetIN) begin : tx_transmit
	if(~nTxResetIN) begin
		txCounter <= 6'h0;
		txReg[0]  <= 1'b1;
	end
	else if(~txReadyOUT) begin
		txReg     <= {1'b0, txReg[39:1]};
		txCounter <= txCounter - 1'b1;
	end
	else if(txLoadIN) begin
		txReg     <= {1'b1, txDataIN[31:24], 1'b0,1'b1, txDataIN[23:16], 1'b0,1'b1, txDataIN[15:8], 1'b0,1'b1, txDataIN[7:0], 1'b0};
		txCounter <= 6'h28;
	end
	else begin
		txCounter <= 6'h0;
	end
end

endmodule