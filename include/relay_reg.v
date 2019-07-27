`timescale 1ns/1ns
`include "g_define.vh"

module relay_reg(
//SIGNALS FROM PCI CONTROLLER
clk,
rst_,
valid_pci,
ad_to_tuvv,
ad_from_tuvv,
rd_wr,
relay_reg_sel,
conn_4wire,
conn_mult,
conn_4wire_active,
conn_mult_active
);

parameter N = 25*(`DELAY_MKS_CONN4WIRE);
parameter K = 25*(`DELAY_MKS_CONNMULT);

input clk;
input rst_;
input valid_pci;
input [31:0] ad_to_tuvv;
output [31:0] ad_from_tuvv;
input rd_wr;
input relay_reg_sel;
output conn_4wire;
output conn_mult;
output conn_4wire_active;
output conn_mult_active;

reg [31:0] RELAY_REG;
reg reg_in_ok;
reg conn_mult;
reg conn_4wire;

reg  [N-1:0] r_reg;
wire [N-1:0] r_next;
wire s_out;
reg  [N-1:0] r_reg_0;
wire [N-1:0] r_next_0;
wire s_out_0;
reg conn_4wire_reg_0;
reg conn_4wire_reg_1;
wire conn_4wire_strobe;
reg conn_mult_reg_0;
reg conn_mult_reg_1;
wire conn_mult_strobe;

assign ad_from_tuvv[31:0] = (!rd_wr & relay_reg_sel) ? {RELAY_REG [31:0]} : 32'bz;

always @ (posedge clk)
  if (!rst_)
  begin
    RELAY_REG[31:0] <= 0;
    reg_in_ok       <= 1'b0; 
  end
  else if (relay_reg_sel)
  begin
    if (valid_pci)
  begin
    RELAY_REG[31:0] <= ad_to_tuvv[31:0];
    reg_in_ok       <= 1'b1;             //strob of available data 
  end else if (reg_in_ok == 1'b1) begin
    reg_in_ok       <= 1'b0;
  end
end

always @ (posedge clk) begin
  if (!rst_)
    begin
	  conn_mult <= 1'b0;
	  conn_4wire<= 1'b0;
	end else
  if (RELAY_REG`ConnMult == 1'b0 && RELAY_REG`Conn4wire == 1'b1)
    begin
	  conn_4wire<= 1'b1;
	  conn_mult <= 1'b0;
	end else 
  if (RELAY_REG`ConnMult == 1'b1 && RELAY_REG`Conn4wire == 1'b0)
  begin
	  conn_4wire<= 1'b0;
	  conn_mult <= 1'b1;
  end else
    begin
      conn_4wire<= 1'b0;
	  conn_mult <= 1'b0;   
    end
end	
	

//Generate delay after conn_4wire off
assign conn_4wire_active = |conn_4wire || !s_out;

always @ (posedge clk) begin
  if (!rst_)
    begin
      conn_4wire_reg_0 <= 1'b0;
      conn_4wire_reg_1 <= 1'b0;
    end else
    begin
      conn_4wire_reg_0 <= |conn_4wire;
      conn_4wire_reg_1 <= conn_4wire_reg_0;
    end
  end
  
assign  conn_4wire_strobe =  |conn_4wire && !conn_4wire_reg_1;

always @(posedge clk)
   begin
      if (!rst_)
        begin 
          r_reg <= {N{1'h1}};
        end else 
      if (conn_4wire_strobe)
        begin
          r_reg <= {N{1'h0}};
      end else if(RELAY_REG`Conn4wire==1'b0) 
      begin      
          r_reg <= r_next;
   	  end
 	  end
 
	assign r_next = {~(|conn_4wire), r_reg[N-1:1]};
	assign s_out = r_reg[0];

//Generate delay after conn_mult off
assign conn_mult_active = |conn_mult || !s_out_0;

always @ (posedge clk) begin
  if (!rst_)
    begin
      conn_mult_reg_0 <= 1'b0;
      conn_mult_reg_1 <= 1'b0;
    end else
    begin
      conn_mult_reg_0 <= |conn_mult;
      conn_mult_reg_1 <= conn_mult_reg_0;
    end
  end
  
assign  conn_mult_strobe =  |conn_mult && !conn_mult_reg_1;

always @(posedge clk)
   begin
      if (!rst_)
        begin 
          r_reg_0 <= {K{1'h1}};
        end else 
      if (conn_mult_strobe)
        begin
          r_reg_0 <= {K{1'h0}};
      end else if(RELAY_REG`ConnMult==1'b0) 
      begin      
          r_reg_0 <= r_next_0;
   	  end
 	  end
 
	assign r_next_0 = {~(|conn_mult), r_reg_0[K-1:1]};
	assign s_out_0 = r_reg_0[0];


endmodule