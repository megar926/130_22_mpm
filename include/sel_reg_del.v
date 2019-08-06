`timescale 1ns/1ns
`include "g_define.vh"

module sel_reg_del(
//SIGNALS FROM PCI CONTROLLER
clk,
rst_,
valid_pci,
ad_to_tuvv,
ad_from_tuvv,
rd_wr,
dat_spi_out,
send_data_spi,
send_ok_strobe,
//MUX D19, D20, D21, D117 SIGNALS
a3_0,
a3_1,
a3_2,
en3_1,
en3_2,
en3_3,
a6_0,
a6_1,
a6_2,
en_izm,
sel_reg_sel,
//BUSY POTENTIOMETER SIGNAL
pot_busy,
//active EN_3[0] signal
sel_reg_sel_active,
conn_mult_active
);
parameter N = 25*(`DELAY_MKS);

input clk;
input rst_;
input valid_pci;
input [31:0] ad_to_tuvv;
input pot_busy;
output [31:0] ad_from_tuvv;
input rd_wr;
input send_ok_strobe;
input sel_reg_sel;
input conn_mult_active;
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
output [15:0] dat_spi_out;
output reg send_data_spi;
output sel_reg_sel_active;

reg [2:0] a3_reg;
reg [2:0] a6_reg;
reg en_izm;
reg [2:0]en3_reg;
reg reg_0_in_ok;
reg reg_1_in_ok;
reg reg_2_in_ok;
reg reg_3_in_ok;
wire reg_in_ok_str;
reg en3_reg_0;
reg en3_reg_1;
wire en3_strobe;
reg [31:0] SEL_REG;
reg [31:0] SEL_REG_;
reg  [N-1:0] r_reg;
wire [N-1:0] r_next;
wire s_out;
//assign sel_reg_sel = (ADRESS[19:4] == 16'h1360) ? 1'b1 : 1'b0;
assign ad_from_tuvv[31:0] = (!rd_wr & sel_reg_sel) ? {SEL_REG[31:15] ,pot_busy ,SEL_REG[13:0]} : 32'bz;
assign dat_spi_out = (SEL_REG`A3_MUX == (5'd10) || SEL_REG`A3_MUX == (5'd11) || SEL_REG`A3_MUX == (5'd12))?SEL_REG`POT_DAN_OUT:16'b0;
assign a3_0  = a3_reg[0];
assign a3_1  = a3_reg[1];
assign a3_2  = a3_reg[2];
assign a6_0  = a6_reg[0];
assign a6_1  = a6_reg[1];
assign a6_2  = a6_reg[2];
assign en3_1 = en3_reg [0];
assign en3_2 = en3_reg [1];
assign en3_3 = en3_reg [2];

always @ (posedge clk)
  if (!rst_)
  begin
    SEL_REG[31:0]   <= {32{1'b0}};
    SEL_REG_[31:0]  <= {32{1'b0}};
    reg_0_in_ok     <= 1'b0;
  end
  else if (reg_2_in_ok)
  begin
    SEL_REG[31:0] <= SEL_REG_[31:0];
  end  
  else if (sel_reg_sel)
  begin
    if (valid_pci)
  begin
    SEL_REG_[31:0] <= ad_to_tuvv[31:0];
    SEL_REG[31:0]  <= 32'b0;
    reg_0_in_ok <= 1'b1;
  end else if (reg_0_in_ok==1'b1)
    reg_0_in_ok <= 1'b0;
  end

always @ (posedge clk)
  if(!rst_)
  begin
    reg_1_in_ok     <= 1'b0;
    reg_2_in_ok     <= 1'b0;
    reg_3_in_ok     <= 1'b0;
  end else
  begin
    reg_1_in_ok     <= reg_0_in_ok;
    reg_2_in_ok     <= reg_1_in_ok;
    reg_3_in_ok     <= reg_2_in_ok;
  end
  
assign reg_in_ok_str = reg_0_in_ok && !reg_3_in_ok;

always @ (posedge clk) begin
  if (!rst_) begin
    a3_reg <= 3'b0;
    en3_reg <= 3'b0;
  end else if (SEL_REG`En_A3_MUX==1'b0) begin
    a3_reg <= 3'b0;
    en3_reg <= 3'b0;
  end else if (SEL_REG`En_A3_MUX==1'b1) begin
    case(SEL_REG`A3_MUX)
      5'd0: begin
              a3_reg    <= 3'd0;     //dac_pos   //chanel 1// turn on time after en == 1, ~140 ns max
                if(a3_reg==3'd0 && !conn_mult_active)
                  en3_reg   <= {1'b0, 1'b0, 1'b1};
            end
      5'd1: begin      //A3/A2/A1/A0
              a3_reg    <= 3'd1;     //dac_neg   //chanel 1
                if(a3_reg==3'd1 && !conn_mult_active)
                  en3_reg   <= {1'b0, 1'b0, 1'b1};
            end
      5'd2: begin      //A3/A2/A1/A0
              a3_reg    <= 3'd2;     //gnd_r   //chanel 1
                if(a3_reg==3'd2 && !conn_mult_active)
                  en3_reg   <= {1'b0, 1'b0, 1'b1};
            end
      5'd3: begin      //A3/A2/A1/A0
              a3_reg    <= 3'd3;     //12v_filt   //chanel 1
                if(a3_reg==3'd3 && !conn_mult_active)
                  en3_reg   <= {1'b0, 1'b0, 1'b1};
            end
      5'd4: begin      //A3/A2/A1/A0
              a3_reg    <= 3'd4;     //-12v_filt   //chanel 1
                if(a3_reg==3'd4 && !conn_mult_active)
                  en3_reg   <= {1'b0, 1'b0, 1'b1};
            end
      5'd5: begin      //A3/A2/A1/A0///////////////////////////////D19
              a3_reg    <= 3'd0;     //dac_pos   //chanel 1
                if(a3_reg==3'd0)
                  en3_reg   <= {1'b0, 1'b1, 1'b0};
            end
      5'd6: begin      //A3/A2/A1/A0
              a3_reg    <= 3'd1;     //dac_neg   //chanel 1
                if(a3_reg==3'd1)
                  en3_reg   <= {1'b0, 1'b1, 1'b0};
            end
      5'd7: begin      //A3/A2/A1/A0
              a3_reg    <= 3'd2;     //gnd_r   //chanel 1
                if(a3_reg==3'd2)
                  en3_reg   <= {1'b0, 1'b1, 1'b0};
            end
      5'd8: begin      //A3/A2/A1/A0
              a3_reg    <= 3'd3;     //12v_filt   //chanel 1
                if(a3_reg==3'd3)
                  en3_reg   <= {1'b0, 1'b1, 1'b0};
            end
      5'd9: begin      //A3/A2/A1/A0
              a3_reg    <= 3'd4;     //-12v_filt   //chanel 1
                if(a3_reg==3'd4)
                  en3_reg   <= {1'b0, 1'b1, 1'b0};
            end
      5'd10: begin      //A3/A2/A1/A0                /////////////////////////D20
              a3_reg    <= 3'd0;     //POW   //chanel 1
                if(a3_reg==3'd0)
                  en3_reg   <= {1'b1, 1'b0, 1'b0};
            end
      5'd11: begin      //A3/A2/A1/A0
              a3_reg    <= 3'd1;     //POB   //chanel 1
                if(a3_reg==3'd1)
                  en3_reg   <= {1'b1, 1'b0, 1'b0};
            end
      5'd12: begin      //A3/A2/A1/A0
              a3_reg    <= 3'd2;     //D_GND   //chanel 1
                if(a3_reg==3'd2)
                  en3_reg   <= {1'b1, 1'b0, 1'b0};
            end
      default: begin
                 a3_reg    <= 3'd0;    //off
                 en3_reg   <= {1'b0, 1'b0, 1'b0};
               end
    endcase
  end else begin
    a3_reg    <= 3'd0;     //gnd_r   //chanel 1
    en3_reg   <= {1'b0, 1'b0, 1'b0};
  end
end

///SPI CONTROL POT
always @ (posedge clk) 
  begin
    if (!rst_ || send_ok_strobe) 
	begin
      send_data_spi <= 1'b0;
    end else if (reg_3_in_ok && (SEL_REG`A3_MUX == (5'd10) || SEL_REG`A3_MUX == (5'd11) || SEL_REG`A3_MUX == (5'd12))) 
	begin
      send_data_spi <= 1'b1;
    end
end

always @ (posedge clk) 
  begin
    if (!rst_) begin
      a6_reg <= 3'b0;
      en_izm <= 1'b0;
	 end else if (SEL_REG`En_A6_MUX==1'b0) begin
	   a6_reg <= 3'b0;
      en_izm <= 1'b0;
    end else if (SEL_REG`En_A6_MUX==1'b1) begin
      case(SEL_REG`A6_MUX)
        3'd0: begin
                a6_reg    <= 3'd0;     //ADC             //chanel 1
                  if(a6_reg==3'd0)
                    en_izm    <= 1'b1;
              end
        3'd1: begin
                a6_reg    <= 3'd1;     //VREF_ADC_2.5V   //chanel 1
                  if(a6_reg==3'd1)
                    en_izm    <= 1'b1;
              end
        3'd2: begin
                a6_reg    <= 3'd2;     //VIP_D          //chanel 1
                  if(a6_reg==3'd2)
                    en_izm    <= 1'b1;
              end
        3'd3: begin
                a6_reg    <= 3'd3;     //VREF_DAC_10V   //chanel 1
                  if(a6_reg==3'd3)
                    en_izm    <= 1'b1;
              end
        3'd4: begin
                a6_reg    <= 3'd4;     //VREF_2.5V     //chanel 1
                  if(a6_reg==3'd4)
                    en_izm    <= 1'b1;
              end
     default: begin
                a6_reg    <= 3'd0;
                en_izm    <= 1'b0;
              end
      endcase
  end else begin
    a6_reg    <= 3'd0;
    en_izm    <= 1'b0;
  end
end

//////////////////////////delay after turn off///////////////////////////

assign sel_reg_sel_active = |en3_reg[0] || !s_out;

always @ (posedge clk) begin
  if (!rst_)
    begin
      en3_reg_0 <= 1'b0;
      en3_reg_1 <= 1'b0;
    end else
    begin
      en3_reg_0 <= |en3_reg[0];
      en3_reg_1 <= en3_reg_0;
    end
  end
  
assign  en3_strobe =  |en3_reg && !en3_reg_1;

always @(posedge clk)
   begin
      if (!rst_)
        begin 
          r_reg <= {N{1'h1}};
        end else 
      if (en3_strobe)
        begin
          r_reg <= {N{1'h0}};
      end else if(SEL_REG`En_A3_MUX==1'b0) 
      begin      
          r_reg <= r_next;
   	  end
 	  end
 
	assign r_next = {~(|en3_reg), r_reg[N-1:1]};
	assign s_out = r_reg[0];

endmodule
