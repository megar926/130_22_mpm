`timescale 1ns/1ns
`include "g_define.vh"

module adr_sel(
clk,
rst_,
ADRESS,
valid_pci,
a_d,
ad_to_tuvv,
devsel_,
tuvv_ready,
dac_ready,
adc_ready,
data_out_sel,
data_wr_adc_sel,
data_in_sel,
sel_reg_sel,
dac_ctrl_sel,
data_in_1_sel,
//active signals
data_in_1_sel_active,
in_1_2_sel_active,
in_1_sel,
in_2_sel,
sens_sel,
c_imsh_sel,
r_err_sel,
r_test_sel,
relay_reg_sel,
conn_4wire_active,
conn_mult_active,
sel_reg_sel_active
);

input clk;
input rst_;
input valid_pci;
input a_d;
input [31:0] ad_to_tuvv;
input devsel_;
input dac_ready;
input adc_ready;
input data_in_1_sel_active;
input in_1_2_sel_active;
input conn_4wire_active;
input conn_mult_active;
input sel_reg_sel_active;
output reg [31:0] ADRESS;
output tuvv_ready;
output data_out_sel;
output data_wr_adc_sel;
output data_in_sel;
output sel_reg_sel;
output dac_ctrl_sel;
output data_in_1_sel;
output in_1_sel;
output in_2_sel;
output sens_sel;
output c_imsh_sel;
output r_err_sel;
output r_test_sel;
output relay_reg_sel;

assign tuvv_ready =      1'b1;
//data_in_out_reg.v
assign data_out_sel =    (ADRESS[19:4] == `DATA_OUT) ? 1'b1 : 1'b0;    //16'hE020 
assign data_wr_adc_sel = (ADRESS[19:4] == `DATA_IN_ADC) ? 1'b1 : 1'b0;	   //16'hE030 wr data to adc and read	
assign data_in_sel =     (ADRESS[19:4] == `DATA_IN) ? 1'b1 : 1'b0;    //16'hE010 //DAC
//sel_reg.v
assign sel_reg_sel =     (ADRESS[19:4] == `SEL_REG) ? 1'b1 : 1'b0;    //16'h1360
//dac_ctrl.v
assign dac_ctrl_sel =    (ADRESS[19:4] == `DAC_CTRL) ? 1'b1 : 1'b0;
//sel_input.v
assign data_in_1_sel =   (ADRESS[19:4] == `DATA_IN_SEL && !in_1_2_sel_active && !conn_4wire_active) ? 1'b1 : 1'b0;
//controller.v
assign in_1_sel =        (ADRESS[19:4] == `IN_1 && !data_in_1_sel_active && !conn_4wire_active) ? 1'b1 : 1'b0;
assign in_2_sel =        (ADRESS[19:4] == `IN_2) ? 1'b1 : 1'b0;
assign sens_sel =        (ADRESS[19:4] == `SENS) ? 1'b1 : 1'b0;
assign c_imsh_sel =      (ADRESS[19:4] == `C_IMSH) ? 1'b1 : 1'b0;	
assign r_err_sel =       (ADRESS[19:4] == `R_ERR) ? 1'b1 : 1'b0;
assign r_test_sel =      (ADRESS[19:4] == `R_TEST) ? 1'b1 : 1'b0;
//relay_reg.v
assign relay_reg_sel =   (!in_1_2_sel_active && !data_in_1_sel_active && !sel_reg_sel_active && ADRESS[19:4] == `RELAY_CTRL) ? 1'b1 : 1'b0;	

always @ (posedge clk)//Формирование адреса
  if(!rst_)
    ADRESS <= 32'b0;
  else if (valid_pci & a_d)
    ADRESS <= ad_to_tuvv;
  else if (devsel_!==0)
    ADRESS <= 32'b0;

endmodule