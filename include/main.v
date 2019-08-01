	//GLAVNIY MODUL'
//`define IF_INPUT_CASE
//`define SEL_INPUT_NOT_DEL
module main(
//PCI bus signals
clk,
ad_bus,
frame_,
c_be_,
irdy_,
trdy_,
devsel_,
serr_,	
rst_pci_,

pci_stop,
pci_idsel,

dip_a,

reset_fpga_,
			
set1_check_a,
set2_check_a,
set3_check_a,
set4_check_a,
	
set1_check_b,
set2_check_b,
set3_check_b,
set4_check_b,
	
set1_check_c,
set2_check_c,
set3_check_c,
set4_check_c,

set_check_d, 	
set_v_d, 	
set_r_d, 	
set_gnd_d, 	

set1_v,  	   //analogoviy
set2_v,
set3_v,
set4_v,
	
set1_r,       //parametricheskiy
set2_r,
set3_r,
set4_r,
	
set1_gnd,       //diskretniy
set2_gnd,
set3_gnd,
set4_gnd,

adc_test,
a5_0,
a5_1,
						
set_a,
set_b,
set_c,
a4_0,
a4_1,
a4_2,
a4_3,
en_prb,
				
a_sel,
b_sel,
c_sel,
d_sel,
cntrl_e,
			
a_sus,
b_sus,
c_sus,
d_sus,
				
co_a,
co_b,
co_c,
co_d,
co_en,
			
//DAC 5725 SIGNALS (FOR OLD SCHEMATIC)
DAC2_D,
a1,
a,
en_rb,
dac2_ldac_,
dac2_wr,
dac2_cs,
dac2_clr,
		
//ADC AD7938 SIGNALS
adc1_convst_,
clk_adc,
rd_buf,
wr_buf,
cs_buf,
d_buf,
adc1_wb,
adc_busy,

//ADC AD5331 SIGNALS dac_ctrl.v
dac1_d,
dac1_cs_,
dac1_wr_,
dac1_clr_,
dac1_ldac_,
dac1_pd_,
//INPUT MUX SIGNALS (DA20-DA29) sel_input.v
a2_0,
a2_1,
a2_2,
a2_3,
en2_1,
en2_2,
en2_3,
en2_4,
en2_5,
en2_6,
en2_7,
en2_8,
en2_9,
en2_10,
//MUX D30, D31, D32 SIGNALS SEL_REG.V
a3_0,
a3_1,
a3_2,
en3_1,
en3_2,
en3_3,
//DA37 MUX36S08
a6_0,
a6_1,
a6_2,
en_izm,
//POT MCP41HVX1 (D17) SIGNALS spi_ctrl.v
pot_cs_,
pot_mosi,
pot_miso,
pot_sclk,
pot_wlat_,
pot_shdn_,
//relay
conn_mult,
conn_4wire,
//TEST PINS
fpga_test2,
fpga_test5,
fpga_test6,
fpga_test7,
fpga_test8,
fpga_test9,
fpga_test10,
fpga_test11,
fpga_test12,
fpga_test13
);
//PCI BUS SIGNALS	
input clk;
inout [31:0] ad_bus;	
input frame_;
input [3:0] c_be_;
input irdy_;
output trdy_;
output devsel_;
output serr_;

input pci_stop;
input pci_idsel;

input rst_pci_;
input reset_fpga_;

//controler.v
output set1_check_a;
output set2_check_a;
output set3_check_a;
output set4_check_a;
	
output set1_check_b;
output set2_check_b;
output set3_check_b;
output set4_check_b;
	
output set1_check_c;
output set2_check_c;
output set3_check_c;
output set4_check_c;

output set_check_d; 	
output set_v_d; 	
output set_r_d; 	
output set_gnd_d; 	

output set1_v;  	   //analogoviy
output set2_v;
output set3_v;
output set4_v;
	
output set1_r;       //parametricheskiy
output set2_r;
output set3_r;
output set4_r;
	
output set1_gnd;       //diskretniy
output set2_gnd;
output set3_gnd;
output set4_gnd;

output adc_test;
output a5_0;
output a5_1;
						
output set_a;
output set_b;
output set_c;
output a4_0;
output a4_1;
output a4_2;
output a4_3;
output en_prb;
				
output [32:1] a_sel;
output [32:1] b_sel;
output [32:1] c_sel;
output [56:1] d_sel;
output [4:1]  cntrl_e;
			
output [32:1] a_sus;
output [32:1] b_sus;
output [32:1] c_sus;
output [56:1] d_sus;
				
input [3:0] dip_a;
	
output [1:0] co_a;
output [1:0] co_b;
output [1:0] co_c;
output [1:0] co_d;
output co_en;

//ADC AD7938 SIGNALS
output adc1_convst_;
output clk_adc;
output rd_buf;
output wr_buf;
output cs_buf;
inout [11:0] d_buf;
output adc1_wb;
input adc_busy;
//DAC 5725 SIGNALS (FOR OLD SCHEMATIC)
output [11:0] DAC2_D;
output [8:0] a1;
output [1:0] a;
output dac2_wr;
output dac2_cs;
output en_rb;
output dac2_ldac_;
output dac2_clr;
//INPUT MUX SIGNALS (DA20-DA29) sel_input.v
output a2_0;
output a2_1;
output a2_2;
output a2_3;
output en2_1;
output en2_2;
output en2_3;
output en2_4;
output en2_5;
output en2_6;
output en2_7;
output en2_8;
output en2_9;
output en2_10;
//MUX D30, D31, D32 SIGNALS
output a3_0;
output a3_1;
output a3_2;
output en3_1;
output en3_2;
output en3_3;
//DA37 MUX36S08
output a6_0;
output a6_1;
output a6_2;
output en_izm;
//POT MCP41HVX1 (D17) SIGNALS spi_ctrl.v
output pot_cs_;
output pot_mosi;
input pot_miso;
output pot_sclk;
output pot_wlat_;
output pot_shdn_;
//ADC AD5331 SIGNALS dac_ctrl.v
output [9:0] dac1_d;
output dac1_cs_;
output dac1_wr_;
output dac1_clr_;
output dac1_ldac_;
output dac1_pd_;
//RELAY
output conn_4wire;
output conn_mult;
//FPGA TEST PINS
output fpga_test2;
output fpga_test5;
output fpga_test6;
output fpga_test7;
output fpga_test8;
output fpga_test9;
output fpga_test10;
output fpga_test11;
output fpga_test12;
output fpga_test13;
	
wire [1:0] dev_adr;
wire valid_pci;
wire a_d;
wire [31:0] ad_from_tuvv;
wire [31:0] ad_to_tuvv;
wire [31:0] ADRESS;
wire tuvv_ready;
wire adc_ready;
wire dac1_busy;
wire valid_tuvv;
wire pci_busy;
wire transaction;
wire rd_wr;
wire [8:0] dat_spi_out;
wire send_data_spi;
wire send_ok_strobe;
wire data_out_sel;
wire data_wr_adc_sel;
wire data_in_sel;
wire sel_reg_sel;
wire dac_ctrl_sel;
wire data_in_1_sel;
wire in_1_sel;
wire in_2_sel;
wire sens_sel;
wire c_imsh_sel;
wire r_err_sel;
wire r_test_sel;
wire in_1_2_sel_active;
wire data_in_1_sel_active;
wire pot_busy;
wire a3_0;
wire a3_1;
wire a3_2;
wire en3_1;
wire en3_2;
wire en3_3;
wire a6_0;
wire a6_1;
wire a6_2;
wire en_izm;
wire pot_cs_;
wire pot_mosi;
wire pot_miso;
wire pot_sclk;
wire pot_wlat_;
wire a2_0;
wire a2_1;
wire a2_2;
wire a2_3;
wire en2_1;
wire en2_2;
wire en2_3;
wire en2_4;
wire en2_5;
wire en2_6;
wire en2_7;
wire en2_8;
wire en2_9;
wire en2_10;
wire relay_reg_sel;
wire conn_4wire_active;
wire set_abc;
wire conn_mult_active;
wire por_rst_;
assign adc1_wb = 1'b1;
assign set_a = set_abc;
assign set_b = set_abc;
assign set_c = set_abc;
assign a5_0  = a[0];
assign a5_1  = a[1];


assign rst_ = (rst_pci_ == 1'b0 || reset_fpga_ == 1'b1 || por_rst_ == 1'b0)?1'b0:1'b1;
	
pci_t32 pci_t32_inst1 	(
.pci_io            (ad_bus),
.frame_            (frame_),
.c_be_             (c_be_),
.irdy_             (irdy_),
.trdy_             (trdy_),								
.devsel_           (devsel_),
.serr_             (serr_),
.rst_              (rst_),
.valid_pci         (valid_pci), 
.a_d               (a_d),
.ad_from_tuvv      (ad_from_tuvv),
.ad_to_tuvv        (ad_to_tuvv),
.tuvv_ready        (tuvv_ready),
.valid_tuvv        (valid_tuvv),
.pci_busy          (pci_busy),
.rd_wr             (rd_wr),
.clk               (clk),
.dip_a             (dip_a)
);
	
controller controller_inst1(
.clk                (clk),
.ADRESS             (ADRESS),
.valid_pci          (valid_pci),
.a_d                (a_d),
.ad_from_tuvv       (ad_from_tuvv),
.ad_to_tuvv         (ad_to_tuvv),
.valid_tuvv         (valid_tuvv),
.pci_busy           (pci_busy),
.rd_wr              (rd_wr),
.trdy_              (trdy_),
.devsel_            (devsel_),
.rst_               (rst_),
								
.set1_check_a        (set1_check_a),
.set1_check_b        (set1_check_b),
.set1_check_c        (set1_check_c),

.set2_check_a        (set2_check_a),
.set2_check_b        (set2_check_b),
.set2_check_c        (set2_check_c),

.set3_check_a        (set3_check_a),
.set3_check_b        (set3_check_b),
.set3_check_c        (set3_check_c),

.set4_check_a        (set4_check_a),
.set4_check_b        (set4_check_b),
.set4_check_c        (set4_check_c),

.set_check_d         (set_check_d),
.set_v_d             (set_v_d),
.set_r_d             (set_r_d),
.set_gnd_d           (set_gnd_d),

.set1_gnd            (set1_gnd),
.set1_r              (set1_r),
.set1_v              (set1_v),

.set2_gnd            (set2_gnd),
.set2_r              (set2_r),
.set2_v              (set2_v),

.set3_gnd            (set3_gnd),
.set3_r              (set3_r),
.set3_v              (set3_v),

.set4_gnd            (set4_gnd),
.set4_r              (set4_r),
.set4_v              (set4_v),
								
.set_abc            (set_abc),
								
.a_sel              (a_sel),
.b_sel              (b_sel),
.c_sel              (c_sel),
.d_sel              (d_sel),
.cntrl_e            (cntrl_e),
			
.a_sus              (a_sus),
.b_sus              (b_sus),
.c_sus              (c_sus),
.d_sus              (d_sus),

.co_a               (co_a),
.co_b               (co_b),
.co_c               (co_c),
.co_d               (co_d),
.co_en              (co_en),
.in_1_sel           (in_1_sel),
.in_2_sel           (in_2_sel),
.sens_sel           (sens_sel),
.c_imsh_sel         (c_imsh_sel),
.r_err_sel          (r_err_sel),
.r_test_sel         (r_test_sel),
.in_1_2_sel_active  (in_1_2_sel_active),
.adc_test           (adc_test),
.en_prb             (en_prb)
);

adr_sel adr_sel_inst_1 (
.clk                    (clk),
.rst_                   (rst_),
.ADRESS                 (ADRESS),
.valid_pci              (valid_pci),
.a_d                    (a_d),
.ad_to_tuvv             (ad_to_tuvv),
.devsel_                (devsel_),
.dac_ready              (dac_ready),
.adc_ready              (adc_ready),
.tuvv_ready             (tuvv_ready),
.data_out_sel           (data_out_sel),
.data_wr_adc_sel        (data_wr_adc_sel),
.data_in_sel            (data_in_sel),
.sel_reg_sel            (sel_reg_sel),
.dac_ctrl_sel           (dac_ctrl_sel),
.data_in_1_sel         (data_in_1_sel),
.in_1_sel               (in_1_sel),
.in_2_sel               (in_2_sel),
.sens_sel               (sens_sel),
.c_imsh_sel             (c_imsh_sel),
.r_err_sel              (r_err_sel),
.r_test_sel             (r_test_sel),
.in_1_2_sel_active      (in_1_2_sel_active),
.data_in_1_sel_active   (data_in_1_sel_active),
.relay_reg_sel          (relay_reg_sel),
.conn_4wire_active      (conn_4wire_active),
.conn_mult_active      (conn_mult_active)
);

//data_in_out_1 data_in_out_inst_1(
data_in data_in_out_inst_1(
//SIGNALS FROM PCI CONTROLLER
.clk                     (clk),
.rst_                    (rst_),
.valid_pci               (valid_pci),
.ad_to_tuvv              (ad_to_tuvv),
.ad_from_tuvv            (ad_from_tuvv),
.rd_wr                   (rd_wr),
//ADC AD7938 SIGNALS
.adc1_convst_            (adc1_convst_),
.clk_adc                 (clk_adc),
.rd_buf                  (rd_buf),
.wr_buf                  (wr_buf),
.cs_buf                  (cs_buf),
.d_buf                   (d_buf),
//SEL REG SIGNAL
.data_wr_adc_sel         (data_wr_adc_sel),
//DAC 5725 SIGNALS (FOR OLD SCHEMATIC)
.DAC2_D                  (DAC2_D),
.a1                      (a1),
.a                       (a),
.dac2_ldac_              (dac2_ldac_),
.dac2_wr                 (dac2_wr),
.dac2_cs                 (dac2_cs),
.dac2_clr                (dac2_clr),
.en_rb                   (en_rb),
.adc_ready               (adc_ready),
.data_in_sel             (data_in_sel),
.data_out_sel            (data_out_sel)
);

`ifdef IF_INPUT_CASE
sel_input sel_input_inst_1(
//SIGNALS FROM PCI CONTROLLER
.clk                     (clk),
.rst_                    (rst_),
.valid_pci               (valid_pci),
.ad_to_tuvv              (ad_to_tuvv),
.ad_from_tuvv            (ad_from_tuvv),
.rd_wr                   (rd_wr),
//BUSY AND ACTIVE SIGNALS
.data_in_1_sel          (data_in_1_sel),
.data_in_1_sel_active   (data_in_1_sel_active),
//INPUT MUX SIGNALS
.a2_0                     (a2_0),
.a2_1                     (a2_1),
.a2_2                     (a2_2),
.a2_3                     (a2_3),
.en2_1                    (en2_1),
.en2_2                    (en2_2),
.en2_3                    (en2_3),
.en2_4                    (en2_4),
.en2_5                    (en2_5),
.en2_6                    (en2_6),
.en2_7                    (en2_7),
.en2_8                    (en2_8),
.en2_9                    (en2_9),
.en2_10                   (en2_10)
);
`else
sel_input_rom sel_input_inst_1(
//SIGNALS FROM PCI CONTROLLER
.clk                     (clk),
.rst_                    (rst_),
.valid_pci               (valid_pci),
.ad_to_tuvv              (ad_to_tuvv),
.ad_from_tuvv            (ad_from_tuvv),
.rd_wr                   (rd_wr),
//BUSY AND ACTIVE SIGNALS
.data_in_1_sel          (data_in_1_sel),
.data_in_1_sel_active   (data_in_1_sel_active),
//INPUT MUX SIGNALS
.a2_0                     (a2_0),
.a2_1                     (a2_1),
.a2_2                     (a2_2),
.a2_3                     (a2_3),
.en2_1                    (en2_1),
.en2_2                    (en2_2),
.en2_3                    (en2_3),
.en2_4                    (en2_4),
.en2_5                    (en2_5),
.en2_6                    (en2_6),
.en2_7                    (en2_7),
.en2_8                    (en2_8),
.en2_9                    (en2_9),
.en2_10                   (en2_10)
);
`endif

dac_ctrl dac_ctrl_inst_1 (
//SIGNALS FROM PCI CONTROLLER
.clk             (clk),
.rst_            (rst_),
.valid_pci       (valid_pci),
.ad_to_tuvv      (ad_to_tuvv),
.ad_from_tuvv    (ad_from_tuvv),
.rd_wr           (rd_wr),
//ADC AD5331 SIGNALS
.dac1_d          (dac1_d),
.dac1_cs_        (dac1_cs_),
.dac1_wr_        (dac1_wr_),
.dac1_clr_       (dac1_clr_),
.dac1_ldac_      (dac1_ldac_),
.dac1_pd_        (dac1_pd_),
.dac1_busy       (dac1_busy),
.dac_ctrl_sel    (dac_ctrl_sel)
);
`ifdef SEL_INPUT_NOT_DEL
sel_reg sel_reg_inst_1(
//SIGNALS FROM PCI CONTROLLER
.clk               (clk),
.rst_              (rst_),
.valid_pci         (valid_pci),
.ad_to_tuvv        (ad_to_tuvv),
.ad_from_tuvv      (ad_from_tuvv),
.rd_wr             (rd_wr),
.dat_spi_out       (dat_spi_out),
.send_data_spi     (send_data_spi),
.send_ok_strobe    (send_ok_strobe),
//MUX D19, D20, D21, D121 SIGNALS
.a3_0              (a3_0),
.a3_1              (a3_1),
.a3_2              (a3_2),
.en3_1             (en3_1),
.en3_2             (en3_2),
.en3_3             (en3_3),
//DA37
.a6_0              (a6_0),
.a6_1              (a6_1),
.a6_2              (a6_2),
.en_izm            (en_izm),
//SEL REGISTER
.sel_reg_sel       (sel_reg_sel),
//BUSY POTENTIOMETER SIGNAL
.pot_busy          (pot_busy)
);
`else
sel_reg_del sel_reg_del_inst_1(
//SIGNALS FROM PCI CONTROLLER
.clk               (clk),
.rst_              (rst_),
.valid_pci         (valid_pci),
.ad_to_tuvv        (ad_to_tuvv),
.ad_from_tuvv      (ad_from_tuvv),
.rd_wr             (rd_wr),
.dat_spi_out       (dat_spi_out),
.send_data_spi     (send_data_spi),
.send_ok_strobe    (send_ok_strobe),
//MUX D19, D20, D21, D121 SIGNALS
.a3_0              (a3_0),
.a3_1              (a3_1),
.a3_2              (a3_2),
.en3_1             (en3_1),
.en3_2             (en3_2),
.en3_3             (en3_3),
//DA37
.a6_0              (a6_0),
.a6_1              (a6_1),
.a6_2              (a6_2),
.en_izm            (en_izm),
//SEL REGISTER
.sel_reg_sel       (sel_reg_sel),
//BUSY POTENTIOMETER SIGNAL
.pot_busy          (pot_busy)
);
`endif

spi_ctrl spi_ctrl_inst_1 (
//SIGNALS FROM PCI CONTROLLER
.clk               (clk),
.rst_              (rst_),
.dat_spi_in        (dat_spi_out),
.send_data         (send_data_spi),
.send_ok_strobe    (send_ok_strobe),
.pot_busy          (pot_busy),
//POT MCP41HVX1 (D17) SIGNALS
.pot_cs_           (pot_cs_),
.pot_mosi          (pot_mosi),
.pot_miso          (pot_miso),
.pot_sclk          (pot_sclk),
.pot_wlat_         (pot_wlat_),
.pot_shdn_         (pot_shdn_)
);

relay_reg relay_reg_ (
//SIGNALS FROM PCI CONTROLLER
.clk                 (clk),
.rst_                (rst_),
.valid_pci           (valid_pci),
.ad_to_tuvv          (ad_to_tuvv),
.ad_from_tuvv        (ad_from_tuvv),
.rd_wr               (rd_wr),
.relay_reg_sel       (relay_reg_sel),
.conn_mult           (conn_mult),
.conn_4wire          (conn_4wire),
.conn_4wire_active   (conn_4wire_active),
.conn_mult_active    (conn_mult_active)
);

por por_ (
.clk                 (clk),
.por_rst_            (por_rst_)
);	           

endmodule


