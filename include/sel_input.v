`timescale 1ns/1ns
`include "g_define.vh"
module sel_input (
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
integer delay = 2;
reg [31:0] DATA_IN_SEL;

input clk;
input rst_;
input valid_pci;
input [31:0] ad_to_tuvv;
input data_in_1_sel;
output [31:0] ad_from_tuvv;
input rd_wr;
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
output data_in_1_sel_active;
reg  [3:0] a2_reg;
reg  [9:0]en2_reg;
reg  [N-1:0] r_reg;
wire [N-1:0] r_next;
reg en2_reg_0;
reg en2_reg_1;
wire en2_strobe;
wire s_out;
reg           [13:0] rom_addr_mux       [0:156];               // address and type of calibr channels
initial
begin
  $readmemb ("rom/addr.txt",rom_addr_mux);
  $display("%b", rom_addr_mux[0][4]);
end


assign a2_0 = a2_reg[0];
assign a2_1 = a2_reg[1];
assign a2_2 = a2_reg[2];
assign a2_3 = a2_reg[3];
assign en2_1 = en2_reg[0];
assign en2_2 = en2_reg[1];
assign en2_3 = en2_reg[2];
assign en2_4 = en2_reg[3];
assign en2_5 = en2_reg[4];
assign en2_6 = en2_reg[5];
assign en2_7 = en2_reg[6];
assign en2_8 = en2_reg[7];
assign en2_9 = en2_reg[8];
assign en2_10 = en2_reg[9];

assign ad_from_tuvv[31:0] = (!rd_wr & data_in_1_sel) ? {23'b0, data_in_1_sel_active ,DATA_IN_SEL`En ,DATA_IN_SEL`CH_IN_SEL} : 32'bz;

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

always @ (posedge clk) 
  begin
    if (!rst_) begin
      a2_reg <= 4'b0;
      en2_reg <= 10'b0;
    end else if (DATA_IN_SEL`En==1'b1)
	begin
      case(DATA_IN_SEL`CH_IN_SEL)
        8'd0: begin      //A3/A2/A1/A0
                a2_reg    <= {1'b0, 1'b0, 1'b0, 1'b0};     //ch_a1   //chanel 1
                en2_reg   <= {1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b1};
              end
        8'd1: begin
                a2_reg    <= {1'b0, 1'b0, 1'b0, 1'b1};     //ch_b1   //chanel 2
                en2_reg   <= {1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b1};
              end
        8'd2: begin
                a2_reg    <= {1'b0, 1'b0, 1'b0, 1'b1};     //ch_c1   //chanel 3
                en2_reg   <= {1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b1};
              end
        8'd3: begin
                a2_reg    <= {1'b0, 1'b0, 1'b1, 1'b1};     //ch_a2   //chanel 4
                en2_reg   <= {1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b1};
              end
        8'd4: begin
                a2_reg    <= {1'b0, 1'b1, 1'b0, 1'b0};     //ch_b2   //chanel 5
                en2_reg   <= {1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b1};
              end
        8'd5: begin
                a2_reg    <= {1'b0, 1'b1, 1'b0, 1'b1};     //ch_c2   //chanel 6
                en2_reg   <= {1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b1};
              end
        8'd6: begin
                a2_reg    <= {1'b0, 1'b1, 1'b1, 1'b0};     //ch_a3   //chanel 7
                en2_reg   <= {1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b1};
              end
        8'd7: begin
                a2_reg    <= {1'b0, 1'b1, 1'b1, 1'b1};     //ch_b3   //chanel 8
                en2_reg   <= {1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b1};
              end
        8'd8: begin
                a2_reg    <= {1'b1, 1'b0, 1'b0, 1'b0};     //ch_c3   //chanel 9
                en2_reg   <= {1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b1};
              end
        8'd9: begin
                a2_reg    <= {1'b1, 1'b0, 1'b0, 1'b1};     //ch_a4   //chanel 10
                en2_reg   <= {1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b1};
              end
        8'd10: begin
                a2_reg    <= {1'b1, 1'b0, 1'b1, 1'b0};     //ch_b4   //chanel 11
                en2_reg   <= {1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b1};
               end
        8'd11: begin
                a2_reg    <= {1'b1, 1'b0, 1'b1, 1'b1};     //ch_c4   //chanel 12
                en2_reg   <= {1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b1};
               end
        8'd12: begin
                 a2_reg    <= {1'b1, 1'b1, 1'b0, 1'b0};     //ch_a5   //chanel 13
                 en2_reg   <= {1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b1};
               end
        8'd13: begin
                 a2_reg    <= {1'b1, 1'b1, 1'b0, 1'b1};     //ch_b5   //chanel 14
                 en2_reg   <= {1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b1};
               end
        8'd14: begin
                 a2_reg    <= {1'b1, 1'b1, 1'b1, 1'b0};     //ch_c5   //chanel 15
                 en2_reg   <= {1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b1};
               end
        8'd15: begin
                 a2_reg    <= {1'b1, 1'b1, 1'b1, 1'b1};     //ch_a6   //chanel 16
                 en2_reg   <= {1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b1};
               end
//////////////////////////////////////////////////////////////////////////////////////
        8'd16: begin      //A3/A2/A1/A0
                 a2_reg    <= {1'b0, 1'b0, 1'b0, 1'b0};     //ch_b6   //chanel 1
                 en2_reg   <= {1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b1, 1'b0};
               end
        8'd17: begin
                 a2_reg    <= {1'b0, 1'b0, 1'b0, 1'b1};     //ch_c6   //chanel 2
                 en2_reg   <= {1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b1, 1'b0};
               end
        8'd18: begin
                 a2_reg    <= {1'b0, 1'b0, 1'b0, 1'b1};     //ch_a7   //chanel 3
                 en2_reg   <= {1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b1, 1'b0};
               end
        8'd19: begin
                 a2_reg    <= {1'b0, 1'b0, 1'b1, 1'b1};     //ch_b7   //chanel 4
                 en2_reg   <= {1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b1, 1'b0};
               end
        8'd20: begin
                 a2_reg    <= {1'b0, 1'b1, 1'b0, 1'b0};     //ch_c7   //chanel 5
                 en2_reg   <= {1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b1, 1'b0};
               end
        8'd21: begin
                 a2_reg    <= {1'b0, 1'b1, 1'b0, 1'b1};     //ch_a8   //chanel 6
                 en2_reg   <= {1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b1, 1'b0};
               end
        8'd22: begin
                 a2_reg    <= {1'b0, 1'b1, 1'b1, 1'b0};     //ch_b8   //chanel 7
                 en2_reg   <= {1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b1, 1'b0};
               end
        8'd23: begin
                 a2_reg    <= {1'b0, 1'b1, 1'b1, 1'b1};     //ch_c8   //chanel 8
                 en2_reg   <= {1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b1, 1'b0};
               end
        8'd24: begin
                 a2_reg    <= {1'b1, 1'b0, 1'b0, 1'b0};     //ch_a9   //chanel 9
                 en2_reg   <= {1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b1, 1'b0};
               end
        8'd25: begin
                 a2_reg    <= {1'b1, 1'b0, 1'b0, 1'b1};     //ch_b9   //chanel 10
                 en2_reg   <= {1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b1, 1'b0};
               end
        8'd26: begin
                 a2_reg    <= {1'b1, 1'b0, 1'b1, 1'b0};     //ch_c9   //chanel 11
                 en2_reg   <= {1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b1, 1'b0};
               end
        8'd27: begin
                 a2_reg    <= {1'b1, 1'b0, 1'b1, 1'b1};     //ch_a10   //chanel 12
                 en2_reg   <= {1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b1, 1'b0};
               end
        8'd28: begin
                 a2_reg    <= {1'b1, 1'b1, 1'b0, 1'b0};     //ch_b10   //chanel 13
                 en2_reg   <= {1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b1, 1'b0};
               end
        8'd29: begin
                 a2_reg    <= {1'b1, 1'b1, 1'b0, 1'b1};     //ch_c10   //chanel 14
                 en2_reg   <= {1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b1, 1'b0};
               end
        8'd30: begin
                 a2_reg    <= {1'b1, 1'b1, 1'b1, 1'b0};     //ch_a11   //chanel 15
                 en2_reg   <= {1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b1, 1'b0};
               end
        8'd31: begin
                 a2_reg    <= {1'b1, 1'b1, 1'b1, 1'b1};     //ch_b11   //chanel 16
                 en2_reg   <= {1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b1, 1'b0};
               end
/////////////////////////////////////////////////////////////////////////////////////
        8'd32: begin      //A3/A2/A1/A0
                 a2_reg    <= {1'b0, 1'b0, 1'b0, 1'b0};     //ch_c11   //chanel 1
                 en2_reg   <= {1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b1, 1'b0, 1'b0};
               end
        8'd33: begin
                 a2_reg    <= {1'b0, 1'b0, 1'b0, 1'b1};     //ch_a12   //chanel 2
                 en2_reg   <= {1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b1, 1'b0, 1'b0};
               end
        8'd34: begin
                 a2_reg    <= {1'b0, 1'b0, 1'b0, 1'b1};     //ch_b12   //chanel 3
                 en2_reg   <= {1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b1, 1'b0, 1'b0};
               end
        8'd35: begin
                 a2_reg    <= {1'b0, 1'b0, 1'b1, 1'b1};     //ch_c12   //chanel 4
                 en2_reg   <= {1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b1, 1'b0, 1'b0};
               end
        8'd36: begin
                 a2_reg    <= {1'b0, 1'b1, 1'b0, 1'b0};     //ch_a13   //chanel 5
                 en2_reg   <= {1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b1, 1'b0, 1'b0};
               end
        8'd37: begin
                 a2_reg    <= {1'b0, 1'b1, 1'b0, 1'b1};     //ch_b13   //chanel 6
                 en2_reg   <= {1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b1, 1'b0, 1'b0};
               end
        8'd38: begin
                 a2_reg    <= {1'b0, 1'b1, 1'b1, 1'b0};     //ch_c13   //chanel 7
                 en2_reg   <= {1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b1, 1'b0, 1'b0};
               end
        8'd39: begin
                 a2_reg    <= {1'b0, 1'b1, 1'b1, 1'b1};     //ch_a14   //chanel 8
                 en2_reg   <= {1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b1, 1'b0, 1'b0};
               end
        8'd40: begin
                 a2_reg    <= {1'b1, 1'b0, 1'b0, 1'b0};     //ch_b14   //chanel 9
                 en2_reg   <= {1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b1, 1'b0, 1'b0};
               end
        8'd41: begin
                 a2_reg    <= {1'b1, 1'b0, 1'b0, 1'b1};     //ch_c14   //chanel 10
                 en2_reg   <= {1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b1, 1'b0, 1'b0};
               end
        8'd42: begin
                 a2_reg    <= {1'b1, 1'b0, 1'b1, 1'b0};     //ch_a15   //chanel 11
                 en2_reg   <= {1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b1, 1'b0, 1'b0};
               end
        8'd43: begin
                 a2_reg    <= {1'b1, 1'b0, 1'b1, 1'b1};     //ch_b15   //chanel 12
                 en2_reg   <= {1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b1, 1'b0, 1'b0};
               end
        8'd44: begin
                 a2_reg    <= {1'b1, 1'b1, 1'b0, 1'b0};     //ch_c15   //chanel 13
                 en2_reg   <= {1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b1, 1'b0, 1'b0};
               end
        8'd45: begin
                 a2_reg    <= {1'b1, 1'b1, 1'b0, 1'b1};     //ch_a16   //chanel 14
                 en2_reg   <= {1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b1, 1'b0, 1'b0};
               end
        8'd46: begin
                 a2_reg    <= {1'b1, 1'b1, 1'b1, 1'b0};     //ch_b16   //chanel 15
                 en2_reg   <= {1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b1, 1'b0, 1'b0};
               end
        8'd47: begin
                 a2_reg    <= {1'b1, 1'b1, 1'b1, 1'b1};     //ch_c16   //chanel 16
                 en2_reg   <= {1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b1, 1'b0, 1'b0};
               end
//////////////////////////////////////////////////////////////////////////////////
        8'd48: begin      //A3/A2/A1/A0
                 a2_reg    <= {1'b0, 1'b0, 1'b0, 1'b0};     //ch_a17   //chanel 1
                 en2_reg   <= {1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b1, 1'b0, 1'b0, 1'b0};
               end
        8'd49: begin
                 a2_reg    <= {1'b0, 1'b0, 1'b0, 1'b1};     //ch_b17   //chanel 2
                 en2_reg   <= {1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b1, 1'b0, 1'b0, 1'b0};
               end
        8'd50: begin
                 a2_reg    <= {1'b0, 1'b0, 1'b0, 1'b1};     //ch_c17   //chanel 3
                 en2_reg   <= {1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b1, 1'b0, 1'b0, 1'b0};
               end
        8'd51: begin
                 a2_reg    <= {1'b0, 1'b0, 1'b1, 1'b1};     //ch_a18   //chanel 4
                 en2_reg   <= {1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b1, 1'b0, 1'b0, 1'b0};
               end
        8'd52: begin
                 a2_reg    <= {1'b0, 1'b1, 1'b0, 1'b0};     //ch_b18   //chanel 5
                 en2_reg   <= {1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b1, 1'b0, 1'b0, 1'b0};
               end
        8'd53: begin
                 a2_reg    <= {1'b0, 1'b1, 1'b0, 1'b1};     //ch_c18   //chanel 6
                 en2_reg   <= {1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b1, 1'b0, 1'b0, 1'b0};
               end
        8'd54: begin
                 a2_reg    <= {1'b0, 1'b1, 1'b1, 1'b0};     //ch_a19   //chanel 7
                 en2_reg   <= {1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b1, 1'b0, 1'b0, 1'b0};
               end
        8'd55: begin
                 a2_reg    <= {1'b0, 1'b1, 1'b1, 1'b1};     //ch_b19   //chanel 8
                 en2_reg   <= {1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b1, 1'b0, 1'b0, 1'b0};
               end
        8'd56: begin
                 a2_reg    <= {1'b1, 1'b0, 1'b0, 1'b0};     //ch_c19   //chanel 9
                 en2_reg   <= {1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b1, 1'b0, 1'b0, 1'b0};
               end
        8'd57: begin
                 a2_reg    <= {1'b1, 1'b0, 1'b0, 1'b1};     //ch_a20   //chanel 10
                 en2_reg   <= {1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b1, 1'b0, 1'b0, 1'b0};
               end
        8'd58: begin
                 a2_reg    <= {1'b1, 1'b0, 1'b1, 1'b0};     //ch_b20   //chanel 11
                 en2_reg   <= {1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b1, 1'b0, 1'b0, 1'b0};
               end
        8'd59: begin
                 a2_reg    <= {1'b1, 1'b0, 1'b1, 1'b1};     //ch_c20   //chanel 12
                 en2_reg   <= {1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b1, 1'b0, 1'b0, 1'b0};
               end
        8'd60: begin
                 a2_reg    <= {1'b1, 1'b1, 1'b0, 1'b0};     //ch_a21   //chanel 13
                 en2_reg   <= {1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b1, 1'b0, 1'b0, 1'b0};
               end
        8'd61: begin
                 a2_reg    <= {1'b1, 1'b1, 1'b0, 1'b1};     //ch_b21   //chanel 14
                 en2_reg   <= {1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b1, 1'b0, 1'b0, 1'b0};
               end
        8'd62: begin
                 a2_reg    <= {1'b1, 1'b1, 1'b1, 1'b0};     //ch_c21   //chanel 15
                 en2_reg   <= {1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b1, 1'b0, 1'b0, 1'b0};
               end
        8'd63: begin
                 a2_reg    <= {1'b1, 1'b1, 1'b1, 1'b1};     //ch_a22   //chanel 16
                 en2_reg   <= {1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b1, 1'b0, 1'b0, 1'b0};
               end
/////////////////////////////////////////////////////////////////////////////////////
        8'd64: begin      //A3/A2/A1/A0
                 a2_reg    <= {1'b0, 1'b0, 1'b0, 1'b0};     //ch_b22   //chanel 1
                 en2_reg   <= {1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b1, 1'b0, 1'b0, 1'b0, 1'b0};
               end
        8'd65: begin
                 a2_reg    <= {1'b0, 1'b0, 1'b0, 1'b1};     //ch_c22   //chanel 2
                 en2_reg   <= {1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b1, 1'b0, 1'b0, 1'b0, 1'b0};
               end
        8'd66: begin
                 a2_reg    <= {1'b0, 1'b0, 1'b0, 1'b1};     //ch_a23   //chanel 3
                 en2_reg   <= {1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b1, 1'b0, 1'b0, 1'b0, 1'b0};
               end
        8'd67: begin
                 a2_reg    <= {1'b0, 1'b0, 1'b1, 1'b1};     //ch_b23   //chanel 4
                 en2_reg   <= {1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b1, 1'b0, 1'b0, 1'b0, 1'b0};
               end
        8'd68: begin
                 a2_reg    <= {1'b0, 1'b1, 1'b0, 1'b0};     //ch_c23   //chanel 5
                 en2_reg   <= {1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b1, 1'b0, 1'b0, 1'b0, 1'b0};
               end
        8'd69: begin
                 a2_reg    <= {1'b0, 1'b1, 1'b0, 1'b1};     //ch_a24   //chanel 6
                 en2_reg   <= {1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b1, 1'b0, 1'b0, 1'b0, 1'b0};
               end
        8'd70: begin
                 a2_reg    <= {1'b0, 1'b1, 1'b1, 1'b0};     //ch_b24   //chanel 7
                 en2_reg   <= {1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b1, 1'b0, 1'b0, 1'b0, 1'b0};
               end
        8'd71: begin
                 a2_reg    <= {1'b0, 1'b1, 1'b1, 1'b1};     //ch_c24   //chanel 8
                 en2_reg   <= {1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b1, 1'b0, 1'b0, 1'b0, 1'b0};
               end
        8'd72: begin
                 a2_reg    <= {1'b1, 1'b0, 1'b0, 1'b0};     //ch_a25   //chanel 9
                 en2_reg   <= {1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b1, 1'b0, 1'b0, 1'b0, 1'b0};
               end
        8'd73: begin
                 a2_reg    <= {1'b1, 1'b0, 1'b0, 1'b1};     //ch_b25   //chanel 10
                 en2_reg   <= {1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b1, 1'b0, 1'b0, 1'b0, 1'b0};
               end
        8'd74: begin
                 a2_reg    <= {1'b1, 1'b0, 1'b1, 1'b0};     //ch_c25   //chanel 11
                 en2_reg   <= {1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b1, 1'b0, 1'b0, 1'b0, 1'b0};
               end
        8'd75: begin
                 a2_reg    <= {1'b1, 1'b0, 1'b1, 1'b1};     //ch_a26   //chanel 12
                 en2_reg   <= {1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b1, 1'b0, 1'b0, 1'b0, 1'b0};
               end
        8'd76: begin
                 a2_reg    <= {1'b1, 1'b1, 1'b0, 1'b0};     //ch_b26   //chanel 13
                 en2_reg   <= {1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b1, 1'b0, 1'b0, 1'b0, 1'b0};
               end
        8'd77: begin
                 a2_reg    <= {1'b1, 1'b1, 1'b0, 1'b1};     //ch_c26   //chanel 14
                 en2_reg   <= {1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b1, 1'b0, 1'b0, 1'b0, 1'b0};
               end
        8'd78: begin
                 a2_reg    <= {1'b1, 1'b1, 1'b1, 1'b0};     //ch_a27   //chanel 15
                 en2_reg   <= {1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b1, 1'b0, 1'b0, 1'b0, 1'b0};
               end
        8'd79: begin
                 a2_reg    <= {1'b1, 1'b1, 1'b1, 1'b1};     //ch_b27   //chanel 16
                 en2_reg   <= {1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b1, 1'b0, 1'b0, 1'b0, 1'b0};
               end
/////////////////////////////////////////////////////////////////////////////////
        8'd80: begin      //A3/A2/A1/A0
                 a2_reg    <= {1'b0, 1'b0, 1'b0, 1'b0};     //ch_c27   //chanel 1
                 en2_reg   <= {1'b0, 1'b0, 1'b0, 1'b0, 1'b1, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0};
               end
        8'd81: begin
                 a2_reg    <= {1'b0, 1'b0, 1'b0, 1'b1};     //ch_a28   //chanel 2
                 en2_reg   <= {1'b0, 1'b0, 1'b0, 1'b0, 1'b1, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0};
               end
        8'd82: begin
                 a2_reg    <= {1'b0, 1'b0, 1'b0, 1'b1};     //ch_b28   //chanel 3
                 en2_reg   <= {1'b0, 1'b0, 1'b0, 1'b0, 1'b1, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0};
               end
        8'd83: begin
                 a2_reg    <= {1'b0, 1'b0, 1'b1, 1'b1};     //ch_c28   //chanel 4
                 en2_reg   <= {1'b0, 1'b0, 1'b0, 1'b0, 1'b1, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0};
               end
        8'd84: begin
                 a2_reg    <= {1'b0, 1'b1, 1'b0, 1'b0};     //ch_a29   //chanel 5
                 en2_reg   <= {1'b0, 1'b0, 1'b0, 1'b0, 1'b1, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0};
               end
        8'd85: begin
                 a2_reg    <= {1'b0, 1'b1, 1'b0, 1'b1};     //ch_b29   //chanel 6
                 en2_reg   <= {1'b0, 1'b0, 1'b0, 1'b0, 1'b1, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0};
               end
        8'd86: begin
                 a2_reg    <= {1'b0, 1'b1, 1'b1, 1'b0};     //ch_c29   //chanel 7
                 en2_reg   <= {1'b0, 1'b0, 1'b0, 1'b0, 1'b1, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0};
               end
        8'd87: begin
                 a2_reg    <= {1'b0, 1'b1, 1'b1, 1'b1};     //ch_a30   //chanel 8
                 en2_reg   <= {1'b0, 1'b0, 1'b0, 1'b0, 1'b1, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0};
               end
        8'd88: begin
                 a2_reg    <= {1'b1, 1'b0, 1'b0, 1'b0};     //ch_b30   //chanel 9
                 en2_reg   <= {1'b0, 1'b0, 1'b0, 1'b0, 1'b1, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0};
               end
        8'd89: begin
                 a2_reg    <= {1'b1, 1'b0, 1'b0, 1'b1};     //ch_c30   //chanel 10
                 en2_reg   <= {1'b0, 1'b0, 1'b0, 1'b0, 1'b1, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0};
               end
        8'd90: begin
                 a2_reg    <= {1'b1, 1'b0, 1'b1, 1'b0};     //ch_a31   //chanel 11
                 en2_reg   <= {1'b0, 1'b0, 1'b0, 1'b0, 1'b1, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0};
               end
        8'd91: begin
                 a2_reg    <= {1'b1, 1'b0, 1'b1, 1'b1};     //ch_b31   //chanel 12
                 en2_reg   <= {1'b0, 1'b0, 1'b0, 1'b0, 1'b1, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0};
               end
        8'd92: begin
                 a2_reg    <= {1'b1, 1'b1, 1'b0, 1'b0};     //ch_c31   //chanel 13
                 en2_reg   <= {1'b0, 1'b0, 1'b0, 1'b0, 1'b1, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0};
               end
        8'd93: begin
                 a2_reg    <= {1'b1, 1'b1, 1'b0, 1'b1};     //ch_a32   //chanel 14
                 en2_reg   <= {1'b0, 1'b0, 1'b0, 1'b0, 1'b1, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0};
               end
        8'd94: begin
                 a2_reg    <= {1'b1, 1'b1, 1'b1, 1'b0};     //ch_b32   //chanel 15
                 en2_reg   <= {1'b0, 1'b0, 1'b0, 1'b0, 1'b1, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0};
               end
        8'd95: begin
                 a2_reg    <= {1'b1, 1'b1, 1'b1, 1'b1};     //ch_c32   //chanel 16
                 en2_reg   <= {1'b0, 1'b0, 1'b0, 1'b0, 1'b1, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0};
               end
/////////////////////////////////////////////////////////////////////////////////////
        8'd96: begin      //A3/A2/A1/A0
                 a2_reg    <= {1'b0, 1'b0, 1'b0, 1'b0};     //ch_d1   //chanel 1
                 en2_reg   <= {1'b0, 1'b0, 1'b0, 1'b1, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0};
               end
        8'd97: begin
                 a2_reg    <= {1'b0, 1'b0, 1'b0, 1'b1};     //ch_d2   //chanel 2
                 en2_reg   <= {1'b0, 1'b0, 1'b0, 1'b1, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0};
               end
        8'd98: begin
                 a2_reg    <= {1'b0, 1'b0, 1'b0, 1'b1};     //ch_d3   //chanel 3
                 en2_reg   <= {1'b0, 1'b0, 1'b0, 1'b1, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0};
               end
        8'd99: begin
                 a2_reg    <= {1'b0, 1'b0, 1'b1, 1'b1};     //ch_d4   //chanel 4
                 en2_reg   <= {1'b0, 1'b0, 1'b0, 1'b1, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0};
               end
        8'd100: begin
                  a2_reg    <= {1'b0, 1'b1, 1'b0, 1'b0};     //ch_d5   //chanel 5
                  en2_reg   <= {1'b0, 1'b0, 1'b0, 1'b1, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0};
                end
        8'd101: begin
                  a2_reg    <= {1'b0, 1'b1, 1'b0, 1'b1};     //ch_d6   //chanel 6
                  en2_reg   <= {1'b0, 1'b0, 1'b0, 1'b1, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0};
                end
        8'd102: begin
                  a2_reg    <= {1'b0, 1'b1, 1'b1, 1'b0};     //ch_d7   //chanel 7
                  en2_reg   <= {1'b0, 1'b0, 1'b0, 1'b1, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0};
                end
        8'd103: begin
                  a2_reg    <= {1'b0, 1'b1, 1'b1, 1'b1};     //ch_d8   //chanel 8
                  en2_reg   <= {1'b0, 1'b0, 1'b0, 1'b1, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0};
                end
        8'd104: begin
                  a2_reg    <= {1'b1, 1'b0, 1'b0, 1'b0};     //ch_d9   //chanel 9
                  en2_reg   <= {1'b0, 1'b0, 1'b0, 1'b1, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0};
                end
        8'd105: begin
                  a2_reg    <= {1'b1, 1'b0, 1'b0, 1'b1};     //ch_d10   //chanel 10
                  en2_reg   <= {1'b0, 1'b0, 1'b0, 1'b1, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0};
                end
        8'd106: begin
                  a2_reg    <= {1'b1, 1'b0, 1'b1, 1'b0};     //ch_d11   //chanel 11
                  en2_reg   <= {1'b0, 1'b0, 1'b0, 1'b1, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0};
                end
        8'd107: begin
                  a2_reg    <= {1'b1, 1'b0, 1'b1, 1'b1};     //ch_d12   //chanel 12
                  en2_reg   <= {1'b0, 1'b0, 1'b0, 1'b1, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0};
                end
        8'd108: begin
                  a2_reg    <= {1'b1, 1'b1, 1'b0, 1'b0};     //ch_d13   //chanel 13
                  en2_reg   <= {1'b0, 1'b0, 1'b0, 1'b1, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0};
                end
        8'd109: begin
                  a2_reg    <= {1'b1, 1'b1, 1'b0, 1'b1};     //ch_d14   //chanel 14
                  en2_reg   <= {1'b0, 1'b0, 1'b0, 1'b1, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0};
                end
        8'd110: begin
                  a2_reg    <= {1'b1, 1'b1, 1'b1, 1'b0};     //ch_d15   //chanel 15
                  en2_reg   <= {1'b0, 1'b0, 1'b0, 1'b1, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0};
                end
        8'd111: begin
                  a2_reg    <= {1'b1, 1'b1, 1'b1, 1'b1};     //ch_d16   //chanel 16
                  en2_reg   <= {1'b0, 1'b0, 1'b0, 1'b1, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0};
                end
//////////////////////////////////////////////////////////////////////////////////
        8'd112: begin      //A3/A2/A1/A0
                  a2_reg    <= {1'b0, 1'b0, 1'b0, 1'b0};     //ch_d17   //chanel 1
                  en2_reg   <= {1'b0, 1'b0, 1'b1, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0};
                end
        8'd113: begin
                  a2_reg    <= {1'b0, 1'b0, 1'b0, 1'b1};     //ch_d18   //chanel 2
                  en2_reg   <= {1'b0, 1'b0, 1'b1, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0};
                end
        8'd114: begin
                  a2_reg    <= {1'b0, 1'b0, 1'b0, 1'b1};     //ch_d19   //chanel 3
                  en2_reg   <= {1'b0, 1'b0, 1'b1, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0};
                end
        8'd115: begin
                  a2_reg    <= {1'b0, 1'b0, 1'b1, 1'b1};     //ch_d20   //chanel 4
                  en2_reg   <= {1'b0, 1'b0, 1'b1, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0};
                end
        8'd116: begin
                  a2_reg    <= {1'b0, 1'b1, 1'b0, 1'b0};     //ch_d21   //chanel 5
                  en2_reg   <= {1'b0, 1'b0, 1'b1, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0};
                end
        8'd117: begin
                  a2_reg    <= {1'b0, 1'b1, 1'b0, 1'b1};     //ch_d22   //chanel 6
                  en2_reg   <= {1'b0, 1'b0, 1'b1, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0};
                end
        8'd118: begin
                  a2_reg    <= {1'b0, 1'b1, 1'b1, 1'b0};     //ch_d23   //chanel 7
                  en2_reg   <= {1'b0, 1'b0, 1'b1, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0};
                end
        8'd119: begin
                  a2_reg    <= {1'b0, 1'b1, 1'b1, 1'b1};     //ch_d24   //chanel 8
                  en2_reg   <= {1'b0, 1'b0, 1'b1, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0};
                end
        8'd120: begin
                  a2_reg    <= {1'b1, 1'b0, 1'b0, 1'b0};     //ch_d25   //chanel 9
                  en2_reg   <= {1'b0, 1'b0, 1'b1, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0};
                end
        8'd121: begin
                  a2_reg    <= {1'b1, 1'b0, 1'b0, 1'b1};     //ch_d26   //chanel 10
                  en2_reg   <= {1'b0, 1'b0, 1'b1, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0};
                end
        8'd122: begin
                  a2_reg    <= {1'b1, 1'b0, 1'b1, 1'b0};     //ch_d27   //chanel 11
                  en2_reg   <= {1'b0, 1'b0, 1'b1, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0};
                end
        8'd123: begin
                  a2_reg    <= {1'b1, 1'b0, 1'b1, 1'b1};     //ch_d28   //chanel 12
                  en2_reg   <= {1'b0, 1'b0, 1'b1, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0};
                end
        8'd124: begin
                  a2_reg    <= {1'b1, 1'b1, 1'b0, 1'b0};     //ch_d29   //chanel 13
                  en2_reg   <= {1'b0, 1'b0, 1'b1, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0};
                end
        8'd125: begin
                  a2_reg    <= {1'b1, 1'b1, 1'b0, 1'b1};     //ch_d30   //chanel 14
                  en2_reg   <= {1'b0, 1'b0, 1'b1, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0};
                end
        8'd126: begin
                  a2_reg    <= {1'b1, 1'b1, 1'b1, 1'b0};     //ch_d31   //chanel 15
                  en2_reg   <= {1'b0, 1'b0, 1'b1, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0};
                end
        8'd127: begin
                  a2_reg    <= {1'b1, 1'b1, 1'b1, 1'b1};     //ch_d32   //chanel 16
                  en2_reg   <= {1'b0, 1'b0, 1'b1, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0};
                end
//////////////////////////////////////////////////////////////////////////////////////
        8'd128: begin      //A3/A2/A1/A0
                  a2_reg    <= {1'b0, 1'b0, 1'b0, 1'b0};     //ch_d33   //chanel 1
                  en2_reg   <= {1'b0, 1'b1, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0};
                end
        8'd129: begin
                  a2_reg    <= {1'b0, 1'b0, 1'b0, 1'b1};     //ch_d34   //chanel 2
                  en2_reg   <= {1'b0, 1'b1, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0};
                end
        8'd130: begin
                  a2_reg    <= {1'b0, 1'b0, 1'b0, 1'b1};     //ch_d35   //chanel 3
                  en2_reg   <= {1'b0, 1'b1, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0};
                end
        8'd131: begin
                  a2_reg    <= {1'b0, 1'b0, 1'b1, 1'b1};     //ch_d36   //chanel 4
                  en2_reg   <= {1'b0, 1'b1, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0};
                end
        8'd132: begin
                  a2_reg    <= {1'b0, 1'b1, 1'b0, 1'b0};     //ch_d37   //chanel 5
                  en2_reg   <= {1'b0, 1'b1, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0};
                end
        8'd133: begin
                  a2_reg    <= {1'b0, 1'b1, 1'b0, 1'b1};     //ch_d38   //chanel 6
                  en2_reg   <= {1'b0, 1'b1, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0};
                end
        8'd134: begin
                  a2_reg    <= {1'b0, 1'b1, 1'b1, 1'b0};     //ch_d39   //chanel 7
                  en2_reg   <= {1'b0, 1'b1, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0};
                end
        8'd135: begin
                  a2_reg    <= {1'b0, 1'b1, 1'b1, 1'b1};     //ch_d40   //chanel 8
                  en2_reg   <= {1'b0, 1'b1, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0};
                end
        8'd136: begin
                  a2_reg    <= {1'b1, 1'b0, 1'b0, 1'b0};     //ch_d41   //chanel 9
                  en2_reg   <= {1'b0, 1'b1, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0};
                end
        8'd137: begin
                  a2_reg    <= {1'b1, 1'b0, 1'b0, 1'b1};     //ch_d42   //chanel 10
                  en2_reg   <= {1'b0, 1'b1, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0};
                end
        8'd138: begin
                  a2_reg    <= {1'b1, 1'b0, 1'b1, 1'b0};     //ch_d43   //chanel 11
                  en2_reg   <= {1'b0, 1'b1, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0};
                end
        8'd139: begin
                  a2_reg    <= {1'b1, 1'b0, 1'b1, 1'b1};     //ch_d44   //chanel 12
                  en2_reg   <= {1'b0, 1'b1, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0};
                end
        8'd140: begin
                  a2_reg    <= {1'b1, 1'b1, 1'b0, 1'b0};     //ch_d45   //chanel 13
                  en2_reg   <= {1'b0, 1'b1, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0};
                end
        8'd141: begin
                  a2_reg    <= {1'b1, 1'b1, 1'b0, 1'b1};     //ch_d46   //chanel 14
                  en2_reg   <= {1'b0, 1'b1, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0};
                end
        8'd142: begin
                  a2_reg    <= {1'b1, 1'b1, 1'b1, 1'b0};     //ch_d47   //chanel 15
                  en2_reg   <= {1'b0, 1'b1, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0};
                end
        8'd143: begin
                  a2_reg    <= {1'b1, 1'b1, 1'b1, 1'b1};     //ch_d48   //chanel 16
                  en2_reg   <= {1'b0, 1'b1, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0};
                end
//////////////////////////////////////////////////////////////////////////////
        8'd144: begin      //A3/A2/A1/A0
                  a2_reg    <= {1'b0, 1'b0, 1'b0, 1'b0};     //ch_d49   //chanel 1
                  en2_reg   <= {1'b1, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0};
                end
        8'd145: begin
                  a2_reg    <= {1'b0, 1'b0, 1'b0, 1'b1};     //ch_d50   //chanel 2
                  en2_reg   <= {1'b1, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0};
                end
        8'd146: begin
                  a2_reg    <= {1'b0, 1'b0, 1'b0, 1'b1};     //ch_d51   //chanel 3
                  en2_reg   <= {1'b1, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0};
                end
        8'd147: begin
                  a2_reg    <= {1'b0, 1'b0, 1'b1, 1'b1};     //ch_d52   //chanel 4
                  en2_reg   <= {1'b1, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0};
                end
        8'd148: begin
                  a2_reg    <= {1'b0, 1'b1, 1'b0, 1'b0};     //ch_d53   //chanel 5
                  en2_reg   <= {1'b1, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0};
                end
        8'd149: begin
                  a2_reg    <= {1'b0, 1'b1, 1'b0, 1'b1};     //ch_d54   //chanel 6
                  en2_reg   <= {1'b1, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0};
                end
        8'd150: begin
                  a2_reg    <= {1'b0, 1'b1, 1'b1, 1'b0};     //ch_d55   //chanel 7
                  en2_reg   <= {1'b1, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0};
                end
        8'd151: begin
                  a2_reg    <= {1'b0, 1'b1, 1'b1, 1'b1};     //ch_d56   //chanel 8
                  en2_reg   <= {1'b1, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0};
                end
        8'd152: begin
                  a2_reg    <= {1'b1, 1'b0, 1'b0, 1'b0};     //ch_d57   //chanel 9
                  en2_reg   <= {1'b1, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0};
                end
        8'd153: begin
                  a2_reg    <= {1'b1, 1'b0, 1'b0, 1'b1};     //ch_d58   //chanel 10
                  en2_reg   <= {1'b1, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0};
                end
        8'd154: begin
                  a2_reg    <= {1'b1, 1'b0, 1'b1, 1'b0};     //ch_d59   //chanel 11
                  en2_reg   <= {1'b1, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0};
                end
        8'd155: begin
                  a2_reg    <= {1'b1, 1'b0, 1'b1, 1'b1};     //ch_d60   //chanel 12
                  en2_reg   <= {1'b1, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0};
                end
        8'd156: begin
                  a2_reg    <= {1'b1, 1'b1, 1'b0, 1'b0};     //ch_d61   //chanel 13
                  en2_reg   <= {1'b1, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0};
                end
        8'd157: begin
                  a2_reg    <= {1'b1, 1'b1, 1'b0, 1'b1};     //ch_d62   //chanel 14
                  en2_reg   <= {1'b1, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0};
                end
        8'd158: begin
                  a2_reg    <= {1'b1, 1'b1, 1'b1, 1'b0};     //ch_d63   //chanel 15
                  en2_reg   <= {1'b1, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0};
                end
        8'd159: begin
                  a2_reg    <= {1'b1, 1'b1, 1'b1, 1'b1};     //ch_d64   //chanel 16
                  en2_reg   <= {1'b1, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0};
                end
        default: begin
                  a2_reg    <= {1'b0, 1'b0, 1'b0, 1'b0};     //ch_d64   //chanel 16
                  en2_reg   <= {1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0};
                end
    endcase
  end else begin
                  a2_reg    <= {1'b0, 1'b0, 1'b0, 1'b0};     //ch_d64   //chanel 16
                  en2_reg   <= {1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0};
  end
end

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
      end else begin      
          r_reg <= r_next;
   	  end
 	  end
 
	assign r_next = {~(|en2_reg), r_reg[N-1:1]};
	assign s_out = r_reg[0];

endmodule
