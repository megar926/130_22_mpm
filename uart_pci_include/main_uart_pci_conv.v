`timescale 1ns / 1ps
module uart_pci_ctr (
clk,
rst_,
rxIN
);
input clk;
input rst_;
input rxIN;

wire devsel_;
wire trdy_;
wire frame_;
wire irdy_;
  
wire rxReadyOUT_IN;
wire [7:0] rxDataIN_OUT;
wire [31:0] adr;
wire [3:0]  cbe;
  
UART_RX uart_rx_ (
.clockIN      (clk),
.nRxResetIN   (rst_),
.rxIN         (rxIN),
.rxReadyOUT   (rxReadyOUT_IN),
.rxDataOUT    (rxDataIN_OUT)
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
.cbe          (cbe)
);

main main_ (
.clk         (clk_25),
.rst_pci_    (rst_),
.reset_fpga_ (1'b0),
.frame_      (frame_),
.irdy_       (irdy_),
.trdy_       (trdy_),
.ad_bus      (adr),
.c_be_       (cbe)
);

endmodule
