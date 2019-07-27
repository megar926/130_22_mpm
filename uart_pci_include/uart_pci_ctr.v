`timescale 1ns / 1ps
module uart_pci_ctr (
clk,
rst_,
clk_25,
rxIN,
txOUT,
frame_,
irdy_,
trdy_,
cbe,
byte_count,
en3_1,
en3_1_led,
dac1_cs_,
dac1_pd_,
dac1_wr_,
dac1_ldac_,
dac1_clr_,

adc1_convst_,
clk_adc,
cs_buf,
wr_buf,
rd_buf,

a1,
a,
dac2_ldac_,
dac2_wr,
dac2_cs,
dac2_clr,

pot_cs_,
pot_mosi,
pot_miso,
pot_sclk,
pot_wlat_,
pot_shdn_,

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

a3_0,
a3_1,
a3_2,
en3_1,
en3_2,
en3_3,
a6_0,
a6_1,
a6_2,
en_izm
);
input clk;
output clk_25;
input rst_;
input rxIN;
output txOUT;

output frame_;
output irdy_;
output trdy_;
output cbe;
output [3:0] byte_count;
output en3_1_led;
output dac1_cs_;
output dac1_pd_;
output dac1_wr_;
output dac1_ldac_;
output dac1_clr_;

output adc1_convst_;
output clk_adc;
output cs_buf;
output wr_buf;
output rd_buf;

output a1;
output a;
output dac2_ldac_;
output dac2_wr;
output dac2_cs;
output dac2_clr;

output pot_cs_;
output pot_mosi;
input pot_miso;
output pot_sclk;
output pot_wlat_;
output pot_shdn_;

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

output a3_0;
output a3_1;
output a3_2;
output en3_1;
output en3_2;
output en3_3;
output a6_0;
output a6_1;
output a6_2;
output en_izm;

wire devsel_;
wire trdy_;
//wire frame_;
wire irdy_;

  
wire rxReadyOUT_IN;
wire txLoadIN_OUT;
wire [7:0] rxDataIN_OUT;
wire [31:0] txDataIN_OUT;
wire [31:0] adr;
wire [3:0]  cbe;

assign en3_1_led = en3_1;  
UART_RX uart_rx_ (
.clockIN      (clk_25),
.nRxResetIN   (rst_),
.rxIN         (rxIN),
.rxReadyOUT   (rxReadyOUT_IN),
.rxDataOUT    (rxDataIN_OUT)
);

UART_TX_32 uart_tx_32 (
.clockIN      (clk_25),
.nTxResetIN   (rst_),
.txDataIN     (txDataIN_OUT),
.txLoadIN     (txLoadIN_OUT),
.txOUT        (txOUT),
.txReadyOUT_str (txReadyOUT_str)
);

uart_pci uart_pci_(
.clk          (clk),
.clk_25       (clk_25),
.rst_         (rst_),
.rxReadyIN    (rxReadyOUT_IN),
.rxDataIN     (rxDataIN_OUT),
.devsel_      (devsel_),
.trdy_        (trdy_),
.frame_       (frame_),
.irdy_        (irdy_),
.adr          (adr),
.cbe          (cbe),
.byte_count   (byte_count),
.txDataOUT    (txDataIN_OUT),
.txReadyOUT_str (txReadyOUT_str),
.txLoadIN     (txLoadIN_OUT)
);

main main_ (
.clk         (clk_25),
.rst_pci_    (rst_),
.reset_fpga_ (1'b0),
.frame_      (frame_),
.irdy_       (irdy_),
.trdy_       (trdy_),
.ad_bus      (adr),
.c_be_       (cbe),
.dac1_cs_     (dac1_cs_),
.dac1_pd_    (dac1_pd_),
.dac1_wr_    (dac1_wr_),
.dac1_ldac_   (dac1_ldac_),
.dac1_clr_    (dac1_clr_),
.adc1_convst_            (adc1_convst_),
.clk_adc                 (clk_adc),
.rd_buf                  (rd_buf),
.wr_buf                  (wr_buf),
.cs_buf                  (cs_buf),

.a1                       (a1),
.a                        (a),
.dac2_ldac_               (dac2_ldac_),
.dac2_wr                  (dac2_wr),
.dac2_cs                  (dac2_cs),
.dac2_clr                 (dac2_clr),

.pot_cs_ (pot_cs_),
.pot_mosi (pot_mosi),
.pot_miso (pot_miso),
.pot_sclk (pot_sclk),
.pot_wlat_ (pot_wlat_),
.pot_shdn_ (pot_shdn_),

.a2_0       (a2_0),
.a2_1       (a2_1),
.a2_2       (a2_2),
.a2_3       (a2_3),
.en2_1      (en2_1 ),
.en2_2      (en2_2 ),
.en2_3      (en2_3 ),
.en2_4      (en2_4 ),
.en2_5      (en2_5 ),
.en2_6      (en2_6 ),
.en2_7      (en2_7 ),
.en2_8      (en2_8 ),
.en2_9      (en2_9 ),
.en2_10     (en2_10 ),

.a3_0 (a3_0),
.a3_1 (a3_1),
.a3_2 (a3_2),
.en3_1 (en3_1),
.en3_2 (en3_2),
.en3_3 (en3_3),
.a6_0 (a6_0),
.a6_1 (a6_1),
.a6_2 (a6_2),
.en_izm (en_izm)
);

endmodule
