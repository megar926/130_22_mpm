`timescale 1ns/1ns

module por (
clk,
por_rst_
);//power on reset module

input clk;
output por_rst_;

reg clk_reg_0=1'b0;
reg clk_reg_1=1'b0;
reg clk_reg_2=1'b0;

always @ (posedge clk) begin
  clk_reg_0 <= 1'b1;
  clk_reg_1 <= clk_reg_0;
  clk_reg_2 <= clk_reg_1;
end

assign por_rst_ = (clk_reg_0 == 1'b1 && clk_reg_1 == 1'b1 && clk_reg_2 == 1'b0)?1'b0:1'b1;
endmodule