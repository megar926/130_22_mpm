`timescale 1ns/1ns
`include "g_define.vh"
`define PAUSE //pause between switches = N
//`define SIM
module sel_input_rom (
//SIGNALS FROM PCI CONTROLLER
clk,
rst_,
valid_pci,
ad_to_tuvv,
ad_from_tuvv,
rd_wr,
//INPUT MUX SIGNALS
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
data_in_1_sel,
data_in_1_sel_active
);

parameter N = 25*(`DELAY_MKS);
parameter C = (`DELAY_MKS_CH);//if 1 - 2 tacts, if 2 - 4 tacts, if 4 -  8 tacts, if 8 - 16 tacts
integer delay = 2;
reg [31:0] DATA_IN_SEL;



input clk;
input rst_;
input valid_pci;
input [31:0] ad_to_tuvv;
input data_in_1_sel;
output [31:0] ad_from_tuvv;
input rd_wr;
output reg a2_0;
output reg a2_1;
output reg a2_2;
output reg a2_3;
output reg en2_1;
output reg en2_2;
output reg en2_3;
output reg en2_4;
output reg en2_5;
output reg en2_6;
output reg en2_7;
output reg en2_8;
output reg en2_9;
output reg en2_10;
output data_in_1_sel_active;
wire [14:0] data_out_rom;
reg [($clog2(C) - 1):0]count_del;
wire  [9:0]en2_reg;
reg  [N-1:0] r_reg;
wire [N-1:0] r_next;
wire s_out;
reg en2_reg_0;
reg en2_reg_1;
wire en2_strobe;
reg a2_sel_flag;
`ifdef PAUSE
reg DATA_IN_SEL_flag;
reg [31:0] DATA_IN_SEL_del;
`endif

`ifdef SIM
reg           [13:0] rom_addr_mux       [0:156];               // address and type of calibr channels
initial
begin
  $readmemb ("C:/Users/TEST/Documents/questa_prj/quartus_13_prj/pci_uart_mb13022/rom/addr.txt",rom_addr_mux);
  //$display("%b", rom_addr_mux[0][4]);
end
`else
sel_input_mux_rom sel_input_mux_rom_(
.clock       (clk),
.address     (DATA_IN_SEL_del`CH_IN_SEL),
.q           (data_out_rom)
);
`endif

`ifdef PAUSE
always @ (posedge clk)
  if (!rst_)
  begin
    DATA_IN_SEL[31:0]     <= 0;
    DATA_IN_SEL_flag      <= 0;
    DATA_IN_SEL_del[31:0] <= {32{1'h0}};
  end
  else if (data_in_1_sel)
  begin
    if (valid_pci)
    begin
      DATA_IN_SEL           <= {32{1'h0}};
      DATA_IN_SEL_del[31:0] <= ad_to_tuvv[31:0];
      DATA_IN_SEL_flag      <= 1'b1;
    end
  end  else if (count_del == 0 || (data_in_1_sel_active == 1'b0))
    begin
      DATA_IN_SEL_flag <= 1'b0;
      DATA_IN_SEL      <= DATA_IN_SEL_del;
		end


always @ (posedge clk)
  begin
    if(!rst_ || !DATA_IN_SEL_flag) 
      begin
        count_del <= {C{1'h1}};
      end else if (DATA_IN_SEL_flag && data_in_1_sel_active == 1'b1)
      begin
        count_del <= count_del - 1'b1;
      end
    end
`else
always @ (posedge clk)
  if (!rst_)
  begin
    DATA_IN_SEL[31:0] <= 0;
  end
  else if (data_in_1_sel)
  begin
    if (valid_pci)
    begin
      DATA_IN_SEL[31:0] <= ad_to_tuvv[31:0];
    end
  end
  `endif

 `ifdef SIM
 always @ (posedge clk) 
  begin
    if(!rst_)
	 begin
	   a2_0 <= 1'b0;
		a2_1 <= 1'b0;
		a2_2 <= 1'b0;
		a2_3 <= 1'b0;
		en2_1 <= 1'b0;
		en2_2 <= 1'b0;
		en2_3 <= 1'b0;
		en2_4 <= 1'b0;
		en2_5 <= 1'b0;
		en2_6 <= 1'b0;
		en2_7 <= 1'b0;
		en2_8 <= 1'b0;
		en2_9 <= 1'b0;
		en2_10 <= 1'b0;
		a2_sel_flag <= 1'b0;
	 end else if (DATA_IN_SEL`En == 1'b0)
	 begin
	   a2_0 <= 1'b0;
		a2_1 <= 1'b0;
		a2_2 <= 1'b0;
		a2_3 <= 1'b0;
		en2_1 <= 1'b0;
		en2_2 <= 1'b0;
		en2_3 <= 1'b0;
		en2_4 <= 1'b0;
		en2_5 <= 1'b0;
		en2_6 <= 1'b0;
		en2_7 <= 1'b0;
		en2_8 <= 1'b0;
		en2_9 <= 1'b0;
		en2_10 <= 1'b0;
		a2_sel_flag <= 1'b0;
	 end else if (DATA_IN_SEL`En == 1'b1 && a2_sel_flag == 0)
	 begin
	  a2_0 <= rom_addr_mux[DATA_IN_SEL`CH_IN_SEL][0];
		a2_1 <= rom_addr_mux[DATA_IN_SEL`CH_IN_SEL][1];
		a2_2 <= rom_addr_mux[DATA_IN_SEL`CH_IN_SEL][2];
		a2_3 <= rom_addr_mux[DATA_IN_SEL`CH_IN_SEL][3];
		a2_sel_flag <= 1'b1;
	 
	 end else if (a2_sel_flag == 1'b1)
	 begin
	    en2_1 <= rom_addr_mux[DATA_IN_SEL`CH_IN_SEL][4];
	    en2_2 <= rom_addr_mux[DATA_IN_SEL`CH_IN_SEL][5];
	    en2_3 <= rom_addr_mux[DATA_IN_SEL`CH_IN_SEL][6];
	    en2_4 <= rom_addr_mux[DATA_IN_SEL`CH_IN_SEL][7];
	    en2_5 <= rom_addr_mux[DATA_IN_SEL`CH_IN_SEL][8];
	    en2_6 <= rom_addr_mux[DATA_IN_SEL`CH_IN_SEL][9];
	    en2_7 <= rom_addr_mux[DATA_IN_SEL`CH_IN_SEL][10];
	    en2_8 <= rom_addr_mux[DATA_IN_SEL`CH_IN_SEL][11];
	    en2_9 <= rom_addr_mux[DATA_IN_SEL`CH_IN_SEL][12];
	    en2_10 <= rom_addr_mux[DATA_IN_SEL`CH_IN_SEL][13];
	  end
  end	
`else
always @ (posedge clk) 
  begin
    if(!rst_)
	 begin
	   a2_0 <= 1'b0;
		a2_1 <= 1'b0;
		a2_2 <= 1'b0;
		a2_3 <= 1'b0;
		en2_1 <= 1'b0;
		en2_2 <= 1'b0;
		en2_3 <= 1'b0;
		en2_4 <= 1'b0;
		en2_5 <= 1'b0;
		en2_6 <= 1'b0;
		en2_7 <= 1'b0;
		en2_8 <= 1'b0;
		en2_9 <= 1'b0;
		en2_10 <= 1'b0;
		a2_sel_flag <= 1'b0;
	 end else if (DATA_IN_SEL`En == 1'b0)
	 begin
	   a2_0 <= 1'b0;
		a2_1 <= 1'b0;
		a2_2 <= 1'b0;
		a2_3 <= 1'b0;
		en2_1 <= 1'b0;
		en2_2 <= 1'b0;
		en2_3 <= 1'b0;
		en2_4 <= 1'b0;
		en2_5 <= 1'b0;
		en2_6 <= 1'b0;
		en2_7 <= 1'b0;
		en2_8 <= 1'b0;
		en2_9 <= 1'b0;
		en2_10 <= 1'b0;
		a2_sel_flag <= 1'b0;
	 end else if (DATA_IN_SEL`En == 1'b1 && a2_sel_flag == 0)
	 begin
	   a2_0 <= data_out_rom[0];
		a2_1 <= data_out_rom[1];
		a2_2 <= data_out_rom[2];
		a2_3 <= data_out_rom[3];
		a2_sel_flag <= 1'b1;
		en2_1 <= data_out_rom[4];
	 
	 end else if (a2_sel_flag == 1'b1)
	 begin
	    //en2_1 <= data_out_rom[4];
	    en2_2 <= data_out_rom[5];
	    en2_3 <= data_out_rom[6];
	    en2_4 <= data_out_rom[7];
	    en2_5 <= data_out_rom[8];
	    en2_6 <= data_out_rom[9];
	    en2_7 <= data_out_rom[10];
	    en2_8 <= data_out_rom[11];
	    en2_9 <= data_out_rom[12];
	    en2_10 <= data_out_rom[13];
	  end
  end	
`endif

assign en2_reg = {en2_1, en2_2, en2_3, en2_4, en2_5, en2_6, en2_7, en2_8, en2_9, en2_10};

assign ad_from_tuvv[31:0] = (!rd_wr & data_in_1_sel) ? {23'b0, data_in_1_sel_active ,DATA_IN_SEL`En ,DATA_IN_SEL`CH_IN_SEL} : 32'bz;

assign data_in_1_sel_active = |en2_reg || !s_out;

always @ (posedge clk) begin
  if (!rst_)
    begin
      en2_reg_0 <= 1'b0;
      en2_reg_1 <= 1'b0;
    end else
    begin
      en2_reg_0 <= |en2_reg;
      en2_reg_1 <= en2_reg_0;
    end
  end
  
assign  en2_strobe =  |en2_reg && !en2_reg_1;

always @(posedge clk)
   begin
      if (!rst_)
        begin 
          r_reg <= {N{1'h1}};
        end else 
      if (en2_strobe)
        begin
          r_reg <= {N{1'h0}};
      end else if(DATA_IN_SEL`En==1'b0) 
      begin      
          r_reg <= r_next;
   	  end
 	  end
 
	assign r_next = {~(|en2_reg), r_reg[N-1:1]};
	assign s_out = r_reg[0];

endmodule