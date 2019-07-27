`timescale 1ns/1ns
`include "g_define.vh"

//`define MHZ6

module data_in(  
//SIGNALS FROM PCI CONTROLLER
clk,
rst_,
valid_pci,
ad_to_tuvv,
ad_from_tuvv,
rd_wr,
//ADC AD7938 SIGNALS
adc1_convst_,
clk_adc,
rd_buf,
wr_buf,
cs_buf,
d_buf,
data_wr_adc_sel,
dac2_clr,
//DAC 5725 SIGNALS (  FOR OLD SCHEMATIC  )
DAC2_D,
a1,
a,
dac2_wr,
dac2_cs,
en_rb,
adc_ready,
data_in_sel,
dac2_ldac_,
data_out_sel,
//
//adc_en
  );
parameter WIDTH = 1; // 4
parameter N = 1;// 8

//ADC constant internal registers
parameter RANGE = 1'b0;
parameter SEQ = 1'b0;
parameter SHDW = 1'b0;
parameter MODE0 = 1'b0;
parameter MODE1 = 1'b0;
parameter REF = 1'b0;
parameter CODING = 1'b0;
parameter PM0 = 1'b0;
parameter PM1 = 1'b0;

input clk;
input rst_;
input valid_pci;
input [31:0] ad_to_tuvv;
inout [11:0] d_buf;//from adc dan
input rd_wr;
input data_out_sel;
input data_wr_adc_sel;
input data_in_sel;
output [8:0] a1;
output [1:0] a;
output en_rb;
output reg adc1_convst_;
output reg clk_adc;
output rd_buf;
output wr_buf;
output cs_buf;
output [31:0] ad_from_tuvv;
output [11:0] DAC2_D;
output adc_ready;
output reg dac2_ldac_;
output reg dac2_wr;
output reg dac2_cs;
output dac2_clr;
//output adc_en;

assign adc_ready = 1'b1;
reg [7:0] count_rd_adc;
reg [4:0] count_wr_dac;
reg wr_buf_reg_0;
reg wr_buf_reg_1;
reg wr_buf_reg_2;
reg wr_buf_;
reg end_cicle_wr_dac;
wire data_in_sel;
wire rd_wr_dac;
reg [31:0] DATA_IN;
reg [31:0] DATA_IN_ADC;
reg [3:0] del;
reg wr_buf_del;
wire busy_adc;
wire busy_dac;
wire rd_dac;
wire [11:0] data_from_adc;
wire [11:0] DAC2_D;
wire [8:0] a1;
wire en_rb;
wire [1:0] count_rd_adc_time = 2'b10;
wire [13:0] adc_end_time = 14'd15;	//Ozhidanie priema - 300000 taktov
wire data_out_sel;
wire data_wr_adc_sel;
wire valid_del;
reg rd_wr_adc;
reg rd_wr_adc_request;
reg rd_wr_dac_request;
reg end_wr_reg_0;
reg end_wr_reg_1;
reg [19:0]data_from_adc_reg_0;
reg end_cicle_rd_adc;
reg [8:0]count_rd_adc_adc_cicle;
wire end_wr_strobe;
reg [WIDTH-1:0] r_reg;
wire [WIDTH-1:0] r_nxt; 
reg clk_track;
reg CLK_8_REG_0=1'b0;
reg CLK_8_REG_1=1'b0;
reg [2:0] ch_adc_last = 3'b111;
reg count_rd_adc_adc_cicle_reg_0;
reg count_rd_adc_adc_cicle_reg_1;
wire count_rd_adc_adc_cicle_strobe;
wire CLK_8_STROBE;
reg rd_buf_;
reg rd_buf_reg_0;
reg rd_buf_reg_1;
reg rd_buf_reg_2;
reg rd_buf_reg_3;
//read regs
assign ad_from_tuvv[31:0] = ( !rd_wr & data_out_sel ) ? { !busy_adc,  data_from_adc [11:0]} :
( !rd_wr & data_in_sel ) ? {busy_dac ,DATA_IN [30:0]} :
( !rd_wr & data_wr_adc_sel ) ? DATA_IN_ADC [31:0] : 32'bz;
//MUX CTRL ADG1404
//assign adc_en =  ( rst_ ) ? DATA_IN[1] : 1'b0;
//DAC control signals
assign a[0]		   =  ( rst_ ) ? DATA_IN[4] : 1'b0;
assign a[1]		   =  ( rst_ ) ? DATA_IN[5] : 1'b0;
assign en_rb	   =  ( rst_ ) ? DATA_IN[3] : 1'b0;//res block turn on/off
assign dac2_clr   =  ( rst_ ) ? ~DATA_IN[1] : 1'b0;
assign DAC2_D[11:0]	 = DATA_IN[30:20];
assign a1[8:0]	 = DATA_IN[16:8];
assign rd_wr_dac = DATA_IN[2];
assign rd_dac = 1'b1;
//ADC control signals
//assign rd_wr_adc = ( DATA_IN_ADC[3] )?1'b1:1'b0;
//assign d_buf = ( wr_buf == 1'b0 || end_wr_reg_0==1'b0 ) ? DATA_IN_ADC[19:4]:12'bz;
assign d_buf = ( wr_buf == 1'b0 || end_wr_reg_0==1'b0 ) ? {PM1 ,PM0 ,CODING ,REF ,DATA_IN_ADC`CH_SEL_ADC, MODE1, MODE0 ,SHDW, SEQ, RANGE}:12'bz;
assign  cs_buf = ( (wr_buf_reg_0 == 1'b0 ||  wr_buf_reg_1 == 1'b0 ||  wr_buf_reg_2 == 1'b0) || (rd_buf_reg_0==1'b0 ||  rd_buf_reg_1==1'b0 || rd_buf_reg_2==1'b0) )?1'b0:1'b1;
assign busy_adc = ( count_rd_adc_adc_cicle>0 )?1'b1:1'b0;
assign busy_dac = ( count_wr_dac>0 )?1'b1:1'b0;
//--------------------------------- DATA_OUT ------------------------------------------//
//assign data_out_sel = ( ADRESS[19:4] == 16'hE020 ) ? 1'b1 : 1'b0;
//---------------------------- WRITE DATA TO ADC --------------------------------------//
//assign data_wr_adc_sel = ( ADRESS[19:4] == 16'hE030 ) ? 1'b1 : 1'b0;	//wr data to adc and read
//6,125 MHZ
always @( posedge clk )
  begin
  if ( !rst_ )
  begin
    r_reg <= 0;
    clk_track <= 1'b0;
  end
  else if (!rd_wr_adc)
  begin
    r_reg <= 0;
    clk_track <= 1'b0;
  end
  else if ( r_nxt == N )
  begin
    r_reg <= 0;
    clk_track <= ~clk_track;
  end
  else
    r_reg <= r_nxt;
end
assign r_nxt = r_reg+1;
assign CLK_8 = ~clk_track;

always @ ( posedge clk ) begin
  CLK_8_REG_1 <= CLK_8;
  CLK_8_REG_0 <= CLK_8_REG_1;
end
`ifdef MHZ6
assign CLK_8_STROBE = CLK_8 && ~CLK_8_REG_1;
`else
assign CLK_8_STROBE = clk;
`endif
//write data to DAC
//assign data_in_sel = ( ADRESS[19:4] == 16'hE010 ) ? 1'b1 : 1'b0;
always @ ( posedge clk )
  if ( !rst_ )
  begin
    DATA_IN[31:0] <= 0;
    rd_wr_dac_request <= 1'b0;
  end
  else if ( data_in_sel )
  begin
    if ( valid_pci )
    begin
      DATA_IN[31:0] <= ad_to_tuvv[31:0];
      rd_wr_dac_request <= 1'b1;
      end else if ( rd_wr_dac_request ) 
	  begin
        rd_wr_dac_request <= 1'b0;
      end
  end

always @ ( posedge clk ) begin
  if( !rst_ ) begin
    dac2_wr           <= 1'b1;
    dac2_cs           <= 1'b1;
    dac2_ldac_            <= 1'b1;
    count_wr_dac     <= 4'b0;
    end_cicle_wr_dac <= 1'b1;
  end else if ( rd_wr_dac_request && rd_wr_dac) 
  begin
    dac2_wr           <= 1'b1;
    dac2_cs           <= 1'b1;
    dac2_ldac_        <= 1'b1;
    count_wr_dac      <= 4'b0;
    end_cicle_wr_dac  <= 1'b0;
  end else if ( end_cicle_wr_dac == 1'b1 ) 
  begin
    dac2_wr           <= 1'b1;
    dac2_cs           <= 1'b1;
    dac2_ldac_        <= 1'b1;
    count_wr_dac      <= 4'b0;
  end else if ( rd_wr_dac) 
  begin
    count_wr_dac <= count_wr_dac  +  1'b1;
    case ( count_wr_dac )
      5'd1: begin
              dac2_wr 		<= 1'b1;
              dac2_ldac_ 		<= 1'b1;
              dac2_cs 		<= 1'b1;
            end
      5'd2: begin
              dac2_wr 		<= 1'b0;
              dac2_ldac_ 		<= 1'b0;
              dac2_cs 		<= 1'b1;
            end
      5'd3: begin
              dac2_wr 		<= 1'b0;
              dac2_ldac_ 		<= 1'b0;
              dac2_cs 		<= 1'b0;
            end
      5'd4: begin
              dac2_wr 		<= 1'b0;
              dac2_ldac_ 		<= 1'b0;
              dac2_cs 		<= 1'b0;
            end
      5'd5: begin
              dac2_wr 		<= 1'b0;
              dac2_ldac_ 		<= 1'b0;
              dac2_cs 		<= 1'b1;
            end
      5'd6: begin
              dac2_wr 		<= 1'b1;
              dac2_ldac_ 		<= 1'b1;
              dac2_cs 		<= 1'b1;
            end
      5'd7: begin
              dac2_wr 		<= 1'b1;
              dac2_ldac_ 		<= 1'b0;
              dac2_cs 		<= 1'b1;
            end
      5'd8: begin
              dac2_wr 		   <= 1'b1;
              dac2_ldac_ 		   <= 1'b1;
              dac2_cs 		   <= 1'b1;
              end_cicle_wr_dac <= 1'b1;
            end
    endcase
  end
end

//ADC control
always @ ( posedge clk )
  if ( !rst_ )
  begin
    DATA_IN_ADC[31:0] <= 0;
    rd_wr_adc_request <= 1'b0;
  end
  else if ( data_wr_adc_sel )
  begin
    if ( valid_pci )
    begin
      DATA_IN_ADC[31:0] <= ad_to_tuvv[31:0];
      rd_wr_adc_request <= 1'b1;
    end else if ( rd_wr_adc_request ) 
	begin
      rd_wr_adc_request <= 1'b0;
    end
  end

//write data to adc ( select chanel )
always @ ( posedge clk ) 
  begin
  if ( !rst_ ) begin
    wr_buf_      <= 1'b1;
	  rd_wr_adc   <= 1'b0;
	  ch_adc_last <= 3'b111;
  end else if ( count_rd_adc_adc_cicle_strobe && DATA_IN_ADC`En_ADC ) 
  begin
    wr_buf_      <= 1'b1;
	  rd_wr_adc   <= 1'b0;
  end else if ( ( ch_adc_last == DATA_IN_ADC`CH_SEL_ADC && DATA_IN_ADC`En_ADC && rd_wr_adc_request )|| end_wr_strobe==1'b1)
  begin
    rd_wr_adc   <= 1'b1;
  end else if ( ch_adc_last !== DATA_IN_ADC`CH_SEL_ADC && DATA_IN_ADC`En_ADC && rd_wr_adc_request && valid_del ) 
  begin
    wr_buf_      <= 1'b0;
  end else if ( wr_buf == 1'b0) 
  begin
    wr_buf_      <= 1'b1;
	  //rd_wr_adc   <= 1'b1;
	  ch_adc_last <= DATA_IN_ADC`CH_SEL_ADC;
  end
end

always @ (posedge clk) begin
  if (!rst_) 
  begin
    wr_buf_reg_0 <= 1'b1;
    wr_buf_reg_1 <= 1'b1;
    wr_buf_reg_2 <= 1'b1;
  end else 
  begin
    wr_buf_reg_0 <= wr_buf_;
    wr_buf_reg_1 <= wr_buf_reg_0;
    wr_buf_reg_2 <= wr_buf_reg_1;
  end
end

assign wr_buf = wr_buf_reg_1;

always @ ( posedge clk ) begin
  if( !rst_ ) 
  begin
    end_wr_reg_0 <= 1'b1;
    end_wr_reg_1 <= 1'b1;
  end else 
  begin
    end_wr_reg_0 <= wr_buf;
    end_wr_reg_1 <= end_wr_reg_0;
  end
end
assign end_wr_strobe = wr_buf && ~end_wr_reg_1;

//read data from ADC
always @ ( posedge clk ) begin
  if( !rst_ ) begin
    clk_adc                <= 1'b1;
    adc1_convst_                <= 1'b1;
    count_rd_adc           <= 8'b0;
    rd_buf_                 <= 1'b1;
    data_from_adc_reg_0 <= 20'b0;
    count_rd_adc_adc_cicle <= 8'b0;
  end else if ( rd_wr_adc_request && DATA_IN_ADC`En_ADC && valid_del ) begin
    clk_adc                <= 1'b1;
    adc1_convst_                <= 1'b1;
    count_rd_adc           <= 6'b0;
    rd_buf_                 <= 1'b1;
    end_cicle_rd_adc       <=1'b0;
    data_from_adc_reg_0    <= 20'b0;
    count_rd_adc_adc_cicle <= DATA_IN_ADC`Dev_ADC;
  end else if ( end_cicle_rd_adc == 1'b1 ) begin
    end_cicle_rd_adc       <=1'b0;
    count_rd_adc           <= 6'd0;
    count_rd_adc_adc_cicle <= count_rd_adc_adc_cicle - 1'b1;
 `ifdef MHZ6
  end else if ( rd_wr_adc && DATA_IN_ADC`En_ADC && CLK_8_STROBE && ( count_rd_adc_adc_cicle > 1'd0 ) && valid_del)
 `else
  end else if ( rd_wr_adc && DATA_IN_ADC`En_ADC && ( count_rd_adc_adc_cicle > 1'd0 ) && valid_del)
 `endif  
  begin
    count_rd_adc <= count_rd_adc  +  1'b1;
    case ( count_rd_adc )
      8'd1: begin//one tact
              clk_adc <= 1'b1;
              adc1_convst_ <= 1'b0;
            end
      8'd2: begin
              clk_adc <= 1'b0;
              adc1_convst_ <= 1'b0;
            end
      8'd3: begin//two tact
              clk_adc <= 1'b1;
              adc1_convst_ <= 1'b0;
            end
      8'd4: begin
              clk_adc <= 1'b0;
              adc1_convst_ <= 1'b0;
            end
      8'd5: begin//3 tact
              clk_adc <= 1'b1;
              adc1_convst_ <= 1'b0;
            end
      8'd6: begin
              clk_adc <= 1'b0;
              adc1_convst_ <= 1'b0;
            end
      8'd7: begin//4 tact
              clk_adc <= 1'b1;
              adc1_convst_ <= 1'b0;
            end
      8'd8: begin
              clk_adc <= 1'b0;
              adc1_convst_ <= 1'b0;
            end
      8'd9: begin//5 tact
              clk_adc <= 1'b1;
              adc1_convst_ <= 1'b0;
            end
      8'd10: begin
              clk_adc <= 1'b0;
              adc1_convst_ <= 1'b0;
            end
      8'd11: begin//6 tact
               clk_adc <= 1'b1;
               adc1_convst_ <= 1'b0;
             end
      8'd12: begin
               clk_adc <= 1'b0;
               adc1_convst_ <= 1'b0;
            end
      8'd13: begin//7 tact
               clk_adc <= 1'b1;
               adc1_convst_ <= 1'b0;
            end
      8'd14: begin
               clk_adc <= 1'b0;
               adc1_convst_ <= 1'b0;
            end
      8'd15: begin//8 tact
               clk_adc <= 1'b1;
               adc1_convst_ <= 1'b0;
            end
      8'd16: begin
               clk_adc <= 1'b0;
               adc1_convst_ <= 1'b0;
            end
      8'd17: begin//9 tact
               clk_adc <= 1'b1;
               adc1_convst_ <= 1'b0;
            end
      8'd18: begin
               clk_adc <= 1'b0;
               adc1_convst_ <= 1'b0;
            end
      8'd19: begin//10 tact
               clk_adc <= 1'b1;
               adc1_convst_ <= 1'b0;
            end
      8'd20: begin
               clk_adc <= 1'b0;
               adc1_convst_ <= 1'b0;
            end
      8'd21: begin//11 tact
               clk_adc <= 1'b1;
               adc1_convst_ <= 1'b0;
            end
      8'd22: begin
               clk_adc <= 1'b0;
               adc1_convst_ <= 1'b0;
            end
      8'd23: begin//12 tact
               clk_adc <= 1'b1;
               adc1_convst_ <= 1'b0;
            end
      8'd24: begin
               clk_adc <= 1'b0;
               adc1_convst_ <= 1'b0;
            end
      8'd25: begin//13 tact
               clk_adc <= 1'b1;
               adc1_convst_ <= 1'b0;
            end
      8'd26: begin
               clk_adc <= 1'b0;
               adc1_convst_ <= 1'b0;
            end
      8'd27: begin//14 tact
               clk_adc <= 1'b1;
               adc1_convst_ <= 1'b0;
            end
      8'd28: begin
               clk_adc <= 1'b0;
               adc1_convst_ <= 1'b0;
            end
      8'd29: begin//14 tact
               clk_adc <= 1'b1;
               adc1_convst_ <= 1'b1;//convsr_ to 1
               rd_buf_  <= 1'b0;//start rd
            end
      8'd30: begin//
               clk_adc <= 1'b1;
               adc1_convst_ <= 1'b1;
               rd_buf_  <= 1'b1;//end rd
               data_from_adc_reg_0 <= data_from_adc_reg_0 + d_buf;
               //end_cicle_rd_adc <= 1'b1;
            end
      8'd31: begin          //if 1 end cicle
               end_cicle_rd_adc <= 1'b1;
            end
    endcase
  end
end

always @ (posedge clk) begin
  if (!rst_) 
    begin
      rd_buf_reg_0 <= 1'b1;
      rd_buf_reg_1 <= 1'b1;
      rd_buf_reg_2 <= 1'b1;
      rd_buf_reg_3 <= 1'b1;
  end else
    begin
      rd_buf_reg_0 <= rd_buf_;
      rd_buf_reg_1 <= rd_buf_reg_0;
      rd_buf_reg_2 <= rd_buf_reg_1;
      rd_buf_reg_3 <= rd_buf_reg_2;
    end
  end
      
assign rd_buf = !(rd_buf_reg_2 &&  !rd_buf_reg_1);     

always @ ( posedge clk ) begin
  if ( !rst_ ) begin
    count_rd_adc_adc_cicle_reg_0 <= 0;
    count_rd_adc_adc_cicle_reg_1 <= 0;
  end else
  begin
    count_rd_adc_adc_cicle_reg_0 <= ~(|count_rd_adc_adc_cicle);
    count_rd_adc_adc_cicle_reg_1 <= count_rd_adc_adc_cicle_reg_0;
  end
end
  
assign count_rd_adc_adc_cicle_strobe = ~(|count_rd_adc_adc_cicle) && ~count_rd_adc_adc_cicle_reg_1;

always @ ( posedge clk ) begin
  if ( !rst_ ) begin
    del <= 1'b0;
  end else if ( DATA_IN_ADC[0] ) 
  begin
    case( DATA_IN_ADC`Dev_ADC )
    9'd1: del    <= 4'd0;  
    9'd2: del    <= 4'd1;
    9'd4: del    <= 4'd2;
    9'd8: del    <= 4'd3;
    9'd16: del   <= 4'd4;
    9'd32: del   <= 4'd5;
    9'd64: del   <= 4'd6;
    9'd128: del  <= 4'd7;
    9'd256: del  <= 4'd8;
    default: del <= 4'd0;
    endcase
  end
end
assign data_from_adc = data_from_adc_reg_0>>del;
assign valid_del     = (DATA_IN_ADC`Dev_ADC == 9'd1 || DATA_IN_ADC`Dev_ADC == 9'd2 ||
                        DATA_IN_ADC`Dev_ADC == 9'd4 || DATA_IN_ADC`Dev_ADC == 9'd8 ||
                        DATA_IN_ADC`Dev_ADC == 9'd16 || DATA_IN_ADC`Dev_ADC == 9'd32 ||
                        DATA_IN_ADC`Dev_ADC == 9'd64 || DATA_IN_ADC`Dev_ADC == 9'd128 ||
                        DATA_IN_ADC`Dev_ADC == 9'd256)? 1'b1: 1'b0;
endmodule


