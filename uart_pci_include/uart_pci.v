`timescale 1ns / 1ps
module uart_pci #
(
parameter CLOCK_FREQUENCY = 25_000_000,
parameter BAUD_RATE       = 9600
)
(
//UART SIGNALS
clk, //25 Mhz
rst_,
rxReadyIN,
rxDataIN,
txDataOUT,
txLoadIN,
txReadyOUT_str,
devsel_,
trdy_,
irdy_,
frame_,
clk_25,
adr,
cbe,
byte_count,
frame_,
trdy_str
);

input clk;
input rst_;
input rxReadyIN;
input [7:0] rxDataIN;
input txReadyOUT_str;
output reg [31:0] txDataOUT;
output reg txLoadIN;
input devsel_;
input trdy_;

inout [31:0] adr;
output [3:0] cbe;
output frame_;
output irdy_;
output trdy_str;

output byte_count;
//output frame_;

output clk_25;

reg [3:0] byte_count = 4'b0000;
reg [31:0] adr_pci;
reg [31:0] dat_pci;

reg [31:0] dan;
reg [3:0] cbe;
reg frame_;
reg irdy_;

reg [3:0] pci_shift;
reg clk_50=1'b1;
reg clk_25=1'b1;
reg frame_reg_0;
reg frame_reg_1;
wire frame_str;

reg trdy_reg_0;
reg trdy_reg_1;
wire trdy_str;

reg devsel_reg_0;
reg devsel_reg_1;
wire devsel_str;

reg rxReadyIN_reg0;
reg rxReadyIN_reg1;
reg rxReadyIN_reg2;
reg rxReadyIN_reg3;
reg rxReadyIN_reg4;
reg rxReadyIN_reg5;

always @ (posedge clk)
begin
  clk_50 <= ~clk_50;
end


always @ (posedge clk_50)
begin
  clk_25 <= ~clk_25;
end

always @ (negedge clk_25)
begin
  if (!rst_)
    begin
      txDataOUT <= 31'h0000;
      txLoadIN  <= 1'b0;
    end else if(txReadyOUT_str == 1'b1)
    begin
      txDataOUT <= 31'h0000;
      txLoadIN  <= 1'b0;
    end else if (trdy_ == 1'b0 && cbe == 4'h6)
    begin
      txDataOUT <= adr;
      txLoadIN  <= 1'b1;
    end
end

always @ (posedge clk_25) 
begin
  if (!rst_) 
  begin
    rxReadyIN_reg0 <= 1'b0;
    rxReadyIN_reg1 <= 1'b0;
    rxReadyIN_reg2 <= 1'b0;
    rxReadyIN_reg3 <= 1'b0;
    rxReadyIN_reg4 <= 1'b0;
    rxReadyIN_reg5 <= 1'b0;
  end else begin
    rxReadyIN_reg0 <= rxReadyIN;
    rxReadyIN_reg1 <= rxReadyIN_reg0;
    rxReadyIN_reg2 <= rxReadyIN_reg1;
    rxReadyIN_reg3 <= rxReadyIN_reg2;
    rxReadyIN_reg4 <= rxReadyIN_reg3;
    rxReadyIN_reg5 <= rxReadyIN_reg4;
  end
end

assign rxReady_str = rxReadyIN_reg4 && !rxReadyIN_reg5;


//Word counter
always @ (posedge clk_25) 
begin
  if (!rst_)
  begin
    byte_count <= 4'b0000;
  end else if (rxReady_str)
  begin
    byte_count <= byte_count + 1'b1;
  end else if (frame_str)
  begin
    byte_count <= 4'b0000;
  end
end

always @ (posedge clk_25)
begin
  if (!rst_)
  begin
    adr_pci <= 32'b0;
    dat_pci <= 32'b0;
  end else
  begin
    if (rxReady_str) begin
    case(byte_count)
      4'd0: adr_pci[7:0]   <= rxDataIN;
      4'd1: adr_pci[15:8]  <= rxDataIN;
      4'd2: adr_pci[23:16] <= rxDataIN;
      4'd3: adr_pci[31:24] <= rxDataIN;
      4'd4: dat_pci[7:0]   <= rxDataIN;
      4'd5: dat_pci[15:8]  <= rxDataIN;
      4'd6: dat_pci[24:16] <= rxDataIN;
      4'd7: dat_pci[31:24] <= rxDataIN;
      4'd8: cbe [3:0] <= rxDataIN[3:0];
     endcase
   end
   end
end

//PCI master block
always @ (negedge clk_25 or posedge trdy_str or negedge rst_)
begin
  if (!rst_)
  begin
    frame_ <= 1'b1;
  end else if (trdy_str)
  begin
    frame_ <= 1'b1;
  end else if (byte_count == 4'd9 && irdy_ == 1'b1 && (cbe == 4'h7 || cbe == 4'h6))
  begin
     frame_ <= 1'b0;
  end
end

assign adr = ((byte_count == 4'd9 && irdy_ == 1'b1 && cbe == 4'h7) || (byte_count == 4'd9 && irdy_ == 1'b1 && cbe == 4'h6))?adr_pci:(byte_count == 4'd9 && irdy_ == 1'b0 && cbe == 4'h7)?dat_pci:32'bz;

always @ (posedge clk_25 or posedge trdy_str or negedge rst_)
begin
  if (!rst_)
    begin
      irdy_ <= 1'b1;
    end else if (trdy_str)
    begin
      irdy_ <= 1'b1;
    end else if (frame_==1'b0)
    begin
      irdy_ <= 1'b0;
  end
end 

always @ (posedge clk_25)
begin
  if (!rst_)
  begin
    frame_reg_0 <= 1'b0;
	  frame_reg_1 <= 1'b0;
  end else begin
    frame_reg_0 <= frame_;
	  frame_reg_1 <= frame_reg_0;
  end
end

assign frame_str = frame_ && ~frame_reg_1;//pos frame strobe

always @ (negedge clk_25)
begin
  if (!rst_)
  begin
    trdy_reg_0 <= 1'b0;
	  trdy_reg_1 <= 1'b0;
  end else begin
    trdy_reg_0 <= trdy_;
	  trdy_reg_1 <= trdy_reg_0;
  end
end

assign trdy_str = trdy_ && ~trdy_reg_1;//pos frame strobe

//assign irdy_ = (devsel_==1'b0 || frame_==1'b0)?1'b0:1'b1;
//assign irdy_ = devsel_ || frame_;

always @ (posedge clk_25)
begin
  if (!rst_)
  begin
    devsel_reg_0 <= 1'b0;
	  devsel_reg_1 <= 1'b0;
  end else 
  begin
    devsel_reg_0 <= devsel_;
	  devsel_reg_1 <= devsel_reg_0;
  end
end

assign devsel_str = devsel_ && ~devsel_reg_1;//pos devsel strobe

              
endmodule