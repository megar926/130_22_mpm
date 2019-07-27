`timescale 1ns/1ns
`include "g_define.vh"

module dac_ctrl (
//SIGNALS FROM PCI CONTROLLER
clk,
rst_,
valid_pci,
ad_to_tuvv,
ad_from_tuvv,
rd_wr,
//DAC AD5331 SIGNALS
dac1_d,
dac1_cs_,
dac1_wr_,
dac1_clr_,
dac1_ldac_,
dac1_pd_,
dac1_busy,
//SEL SIGNAL FOR REGISTER
dac_ctrl_sel
);

input clk;
input rst_;
input valid_pci;
input [31:0] ad_to_tuvv;
input rd_wr;
input dac_ctrl_sel;
output [31:0] ad_from_tuvv;
output [9:0] dac1_d;
output dac1_cs_;
output dac1_wr_;
output dac1_clr_;
output dac1_ldac_;
output dac1_pd_;
output dac1_busy;

integer delay = 2;
reg [31:0] DAC_CTRL;
reg dac_wr_request;
wire dac_wr_end_cicle;
wire dac_ctrl_sel;
reg st_0, st_1, st_2, st_3;
reg power_on;
reg [4:0] pause_pd;
wire clr_reg;
wire pd_reg;
assign ad_from_tuvv[31:0] = (!rd_wr & dac_ctrl_sel) ? {19'b0, dac1_busy ,DAC_CTRL [11:0]} : 32'bz;
//assign dac_ctrl_sel = (ADRESS[19:4] == 16'h1350) ? 1'b1 : 1'b0;
assign dac1_busy = (dac_wr_request || st_0 || st_1 || st_2 || st_3)?1'b1:1'b0;//|| (dac_wr_en && !power_on)

always @ (posedge clk) 
  begin////////////////////////////dooooooooooooooooooo
  if(!rst_) begin
    power_on <= 1'b0;
    pause_pd <= 8'd0;
  end  else if (!pd_reg) begin
    power_on <= 1'b0;
    pause_pd <= 8'd0;
  end else if (pause_pd == 8'd31 && power_on == 1'b0 && pd_reg)
  begin
    power_on <= 1'b1;
    pause_pd <= 8'd0;
  end else if (pd_reg && power_on == 1'b0) begin
    pause_pd <= pause_pd + 1'b1;
  end
end

always @ (posedge clk)
  if (!rst_)
  begin
    DAC_CTRL [31:0] <= 0;
    dac_wr_request       <= 1'b0;
  end
  else if (dac_ctrl_sel)
  begin
    if (valid_pci)
  begin
    DAC_CTRL [31:0] <= ad_to_tuvv[31:0];
    dac_wr_request <= 1'b1;
  end
  end
  else if (dac_wr_end_cicle || !dac1_pd_)
  begin
    dac_wr_request <= 1'b0;
  end
assign clr_reg = (dac_wr_request && DAC_CTRL`CLR_DAC_1);
assign pd_reg  = (DAC_CTRL`PD_DAC);
assign dac1_pd_ = pd_reg;
always @ (posedge clk) begin
  if (!rst_) begin
    st_0 <= 1'b0;
    st_1 <= 1'b0;
    st_2 <= 1'b0;
    st_3 <= 1'b0;
  end else if (rst_ && power_on && pd_reg) begin 
    st_0 <= (dac_wr_request || clr_reg);
    st_1 <= st_0;
    st_2 <= st_1;
    st_3 <= st_2;
  end
end

assign dac1_clr_ = (DAC_CTRL`CLR_DAC_1 && st_0 && ~st_1)?1'b0:1'b1;
assign dac1_wr_ = (st_1 && st_0 && ~DAC_CTRL`CLR_DAC_1)?1'b0:1'b1;
assign dac1_cs_ = ((st_1 || st_0) && ~DAC_CTRL`CLR_DAC_1)?1'b0:1'b1;
assign dac1_ldac_ = (((st_1 && st_2) || st_3) && ~DAC_CTRL`CLR_DAC_1)?1'b0:1'b1;
assign dac1_d = DAC_CTRL`DAN_DAC_1;
assign dac_wr_end_cicle = st_3;
endmodule
