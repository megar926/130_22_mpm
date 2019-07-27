module spi_ctrl(
//SIGNALS FROM PCI CONTROLLER
clk,
rst_,
dat_spi_in,
dat_spi_out,
send_data,
send_ok_strobe,
//POT MCP41HVX1 SIGNALS
pot_cs_,
pot_mosi,
pot_miso,
pot_sclk,
pot_wlat_,
pot_shdn_,
//BUSY POTENTIOMETER SIGNAL
pot_busy
);

parameter WIDTH = 3; // 4
parameter N = 4;// 8
//INTERNAL POT  REGISTER CONSTANT
parameter AD = 4'b0000;
parameter C0 = 1'b0;
parameter C1 = 1'b0;

input clk;
input rst_;
input [8:0] dat_spi_in;
input send_data;
output [8:0] dat_spi_out;
output send_ok_strobe;
output reg pot_cs_;
output reg pot_wlat_;
output reg pot_mosi;
output pot_sclk;
output pot_busy;
output pot_shdn_;
input pot_miso;

reg [5:0] shift_spi;
reg [8:0] data_to_pot;
reg [WIDTH-1:0] r_reg;
wire [WIDTH-1:0] r_nxt;
reg clk_track;
reg CLK_4_REG_0=1'b0;
reg CLK_4_REG_1=1'b0;
wire CLK_4_STROBE;
wire send_data_strobe;
reg send_data_reg_0;
reg send_data_reg_1;
reg start_send;
reg end_send_reg_0;
reg end_send_reg_1;

assign pot_shdn_ = 1'b1;
//4 MHZ
always @(posedge clk)
  begin
  if (!rst_ || !start_send)
  begin
    r_reg <= 0;
    clk_track <= 1'b0;
  end
  else if (r_nxt == N)
  begin
    r_reg <= 0;
    clk_track <= ~clk_track;
  end
  else
    r_reg <= r_nxt;
  end
assign r_nxt = r_reg+1;
assign CLK_4 = ~clk_track;

always @ (posedge clk) 
begin
  if (!rst_) begin
    CLK_4_REG_1 <= 1'b0;
    CLK_4_REG_0 <= 1'b0;
  end else if (rst_)
    CLK_4_REG_1 <= CLK_4;
    CLK_4_REG_0 <= CLK_4_REG_1;
  end
assign CLK_4_STROBE = CLK_4 && ~CLK_4_REG_1;

always @ (posedge clk) 
begin
  if (!rst_) begin
    send_data_reg_0 <= 1'b0;
    send_data_reg_1 <= 1'b0;
  end else if (rst_) begin
    send_data_reg_0 <= send_data;
    send_data_reg_1 <= send_data_reg_0;
  end
end

assign send_data_strobe = send_data && ~send_data_reg_1;
assign pot_busy         = start_send;
always @ (posedge clk) begin
  if(!rst_) begin///////////////////////////reset by counter
    data_to_pot <= 16'b0;
    start_send  <= 1'b0;
  end else if (shift_spi == 6'd40) begin
    start_send <= 1'b0;
  end else
    if(send_data_strobe) 
	begin
      data_to_pot <= dat_spi_in;
      start_send <= 1'b1;
    end
end

always @ (posedge clk) begin
  if(!rst_) 
  begin
    shift_spi<= 6'd0;
    pot_cs_ <= 1'b1;
    pot_wlat_ <= 1'b1;
  end else if (send_data_strobe) 
  begin
    shift_spi<= 6'd0;
    pot_cs_ <= 1'b1;
    pot_wlat_ <= 1'b1;
  end else if (start_send && CLK_4_STROBE) 
  begin
    shift_spi <= shift_spi + 1'b1;
    case(shift_spi)
    6'd1: begin
	         pot_cs_  <= 1'b0;
				pot_mosi <= AD[3];
			 end
    6'd2: pot_wlat_ <= 1'b0;
    6'd5: pot_mosi <= AD[3];
    6'd7: pot_mosi <= AD[2];
    6'd9: pot_mosi <= AD[1];
    6'd11: pot_mosi <= AD[0];
    6'd13: pot_mosi <= C1;
    6'd15: pot_mosi <= C0;
    6'd17: pot_mosi <= 1'b1;//1'bx bit
    6'd19: pot_mosi <= data_to_pot[8];
    6'd21: pot_mosi <= data_to_pot[7];
    6'd23: pot_mosi <= data_to_pot[6];
    6'd25: pot_mosi <= data_to_pot[5];
    6'd27: pot_mosi <= data_to_pot[4];
    6'd29: pot_mosi <= data_to_pot[3];
    6'd31: pot_mosi <= data_to_pot[2];
    6'd33: pot_mosi <= data_to_pot[1];
    6'd35: pot_mosi <= data_to_pot[0];
    6'd38: begin
             pot_cs_   <= 1'b1;
             pot_wlat_ <= 1'b1;
           end
// default: cs_ <= 1'b1;
    endcase
  end
end

always @ (posedge clk) 
begin
  if (!rst_) begin
    end_send_reg_0 <= 1'b0;
    end_send_reg_1 <= 1'b0;
  end else if (rst_) begin
    end_send_reg_0 <= pot_cs_;
    end_send_reg_1 <= end_send_reg_0;
  end
end

assign send_ok_strobe = pot_cs_ && ~end_send_reg_1;

assign pot_sclk = (shift_spi == 6'd7 ||
               shift_spi == 6'd9 || shift_spi == 6'd11|| shift_spi == 6'd13 ||
               shift_spi == 6'd15 || shift_spi == 6'd17|| shift_spi == 6'd19 ||
               shift_spi == 6'd21 || shift_spi == 6'd23|| shift_spi == 6'd25 ||
               shift_spi == 6'd27 || shift_spi == 6'd29|| shift_spi == 6'd31 ||
               shift_spi == 6'd33 || shift_spi == 6'd35 || shift_spi == 6'd37)?1'b1:1'b0;

endmodule
