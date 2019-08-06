`timescale 1ns/1ns
`include "g_define.vh"

module controller (clk,
valid_pci,
a_d,
ad_from_tuvv,
ad_to_tuvv,
//tuvv_ready,
valid_tuvv,
pci_busy,
rd_wr,
trdy_,
devsel_,
rst_,
				
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

set_abc,
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
			
ADRESS,
in_1_sel,
in_2_sel,
sens_sel,
c_imsh_sel,
r_err_sel,
r_test_sel,
in_1_2_sel_active
);

parameter N = 25*(`DELAY_MKS);

	input clk;
	input [31:0]ADRESS;
  input valid_pci; //signal "dostupnie dannie" (strob)
  input a_d; //signal adres/dannie (adres "0" dannie "1")
  output [31:0]ad_from_tuvv; //vhodnaja shina PCI kontrollera ot TUVV2
  input [31:0]ad_to_tuvv; //vihodnaja shina PCI kontrollera k TUVV2
   // output tuvv_ready; //signal gotovnosti TUVV2
  output valid_tuvv; //signal vidachi dannih iz TUVV2
  input pci_busy; //signal zanatosti mastera
  input rd_wr;
	input trdy_;
	input devsel_;
	input rst_;
	input in_1_sel;
	input in_2_sel;
	input sens_sel;
	input c_imsh_sel;
	input r_err_sel;
	input r_test_sel;

output set1_v;  	   //analogoviy
output set2_v;
output set3_v;
output set4_v;
	
output set1_r;      //parametricheskiy
output set2_r;
output set3_r;
output set4_r;
	
output set1_gnd;    //diskretniy
output set2_gnd;
output set3_gnd;
output set4_gnd;
	
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

output in_1_2_sel_active;
	
output set_abc;
output a4_0;
output a4_1;
output a4_2;
output a4_3;
output en_prb;
output adc_test;	
 
	output [32:1] a_sel;
	output [32:1] b_sel;
	output [32:1] c_sel;
	output [56:1] d_sel;
	output [4:1] cntrl_e;
	
	output [32:1] a_sus;
	output [32:1] b_sus;
	output [32:1] c_sus;
	output [56:1] d_sus;
	
	reg [32:1]  a_sel_;
	reg [32:1]  b_sel_;
	reg [32:1]  c_sel_;
	reg [32:1]  d1_sel_;
	reg [32:1]  d2_sel_;
	reg [4:1] cntrl_e_;
	
	reg [32:1]  a_sus_;
	reg [32:1]  b_sus_;
	reg [32:1]  c_sus_;
	reg [32:1]  d1_sus_;
	reg [32:1]  d2_sus_;
	
reg in_1_2_sel_active_reg_0;
reg in_1_2_sel_active_reg_1;
reg in_1_2_sel_active_reg_2;
reg in_1_2_sel_active_reg_3;
reg in_1_2_sel_active_reg_4;
reg in_1_2_sel_active_reg_5;

reg  [N-1:0] r_reg;
wire [N-1:0] r_next;
wire s_in;
wire s_out;

wire sel_reg;
reg en2_reg_0;
reg en2_reg_1;
wire en2_strobe;

	    //output d_oe;
	
	output [1:0] co_a;
  output [1:0] co_b;
  output [1:0] co_c;
  output [1:0] co_d;
  output co_en;
	
	reg adr_come;
	reg dat_in1_come;
	reg dat_in2_come;
	reg err_check;
	reg fake_reg;
	reg SENS_flag;
	reg [31:0] SENS_del;
	reg wrb_delay;

	reg dac_wr;
	reg adc_wr;
	reg adc_wr_cnt;			//razreshenie scheta
	reg [13:0] adc_wr_time;	//peremennaya
	reg adc_wr_done;
	reg int_start;
	reg [1:0] data_out_del;
	
	integer delay;
	
	reg [19:0] IN_1;
	reg [19:0] IN_2;
	reg [31:0]  SENS;
	reg [8:0] C_IMSH;
	reg [7:0] R_ERR;
	reg [31:0] R_TEST;

	
	wire in_1_sel;
	wire in_2_sel;
	wire sens_sel;
	wire c_imsh_sel;
	wire r_err_sel;
	wire r_test_sel;
	wire [13:0] adc_end_time = 14'd14;	//Ozhidanie priema - 300000 taktov
	
	wire rd_done_strobe;
		
	always @ (posedge clk)
	if(!rst_)
		adr_come <= #delay 0;
	else if (valid_pci & a_d)
		adr_come <= #delay 1;
	else
		adr_come <= #delay 0;

	assign valid_tuvv = (rst_) ? (!rd_wr & adr_come) : 1'b0;

	
	assign ad_from_tuvv[31:0] = (!rd_wr & in_1_sel) ? {14'b0, in_1_2_sel_active, IN_1 [16:0]} :
								(!rd_wr & in_2_sel) ? IN_2 [19:0] :
								(!rd_wr & sens_sel) ? SENS [31:0] :
								(!rd_wr & c_imsh_sel) ? C_IMSH [8:0] :
								(!rd_wr & r_err_sel) ? R_ERR [7:0] :
								(!rd_wr & r_test_sel) ? R_TEST [31:0] : 32'bz;
				
								
	
	
		
	//--------------------------------- IN_1 ------------------------------------------//
	//assign in_1_sel = (ADRESS[19:4] == 16'h1300) ? 1'b1 : 1'b0;		
	always @ (posedge clk)//Здесь происходит запись в регистр IN_1 данных от PCI контроллера (Почему не использкется сигнал rd_wr?)
	if(!rst_)
		begin
      IN_1 <= #delay 20'b0;
			dat_in1_come <= #delay 0;
		end
	else if (in_1_sel)
		begin
			if (valid_pci  && rd_wr)
				begin
					IN_1[19:0] <= #delay ad_to_tuvv[19:0];
					dat_in1_come <= #delay 1;	//IN_1 data come
				end
		end
	else
		dat_in1_come <= #delay 0;

assign sel_reg = (|a_sel_ || |b_sel_ || |c_sel_ || |d1_sel_ || |d2_sel_ || |a_sus_ || |b_sus_ || |c_sus_ || |d1_sus_  || |d2_sus_);

always @ (posedge clk) begin
  if (!rst_)
    begin
      en2_reg_0 <= 1'b0;
      en2_reg_1 <= 1'b0;
    end else
    begin
      en2_reg_0 <= sel_reg;
      en2_reg_1 <= en2_reg_0;
    end
  end
assign  en2_strobe =  sel_reg && !en2_reg_1;

assign in_1_2_sel_active = sel_reg || !s_out;

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
 
	assign r_next = {!sel_reg, r_reg[N-1:1]};
	assign s_out = r_reg[0];

/*	
assign in_1_2_sel_active = (|a_sel_ || |b_sel_ || |c_sel_ || |d1_sel_ || |d2_sel_ || |a_sus_ || |b_sus_ || |c_sus_ || |d1_sus_  || |d2_sus_) || (~in_1_2_sel_active_reg_5 || ~in_1_2_sel_active_reg_0 || ~in_1_2_sel_active_reg_1);

always @ (posedge clk) begin
  if (!rst_) begin
    in_1_2_sel_active_reg_0 <=  1'b1;
    in_1_2_sel_active_reg_1 <=  1'b1;
    in_1_2_sel_active_reg_2 <=  1'b1;
    in_1_2_sel_active_reg_3 <=  1'b1;
    in_1_2_sel_active_reg_4 <=  1'b1;
    in_1_2_sel_active_reg_5 <=  1'b1;
  end else begin
    in_1_2_sel_active_reg_0 <= ~(|a_sel_ || |b_sel_ || |c_sel_ || |d1_sel_ || |d2_sel_ || |a_sus_ || |b_sus_ || |c_sus_ || |d1_sus_  || |d2_sus_);
    in_1_2_sel_active_reg_1 <=  in_1_2_sel_active_reg_0;
    in_1_2_sel_active_reg_2 <=  in_1_2_sel_active_reg_1;
    in_1_2_sel_active_reg_3 <=  in_1_2_sel_active_reg_2;
    in_1_2_sel_active_reg_4 <=  in_1_2_sel_active_reg_3;
    in_1_2_sel_active_reg_5 <=  in_1_2_sel_active_reg_4;
  end
end
*/
		
	//--------------------------------- IN_2 ------------------------------------------//
	//assign in_2_sel = (ADRESS[19:4] == 16'h1310) ? 1'b1 : 1'b0;		
	always @ (posedge clk)//Здесь происходит запись в регистр IN_2 данных от PCI контроллера (Почему не использкется сигнал rd_wr?)
	if(!rst_)
		begin
			IN_2[19:0] <= #delay 20'b0;
			dat_in2_come <= #delay 0;
		end
	else if (in_2_sel)
		begin
			if (valid_pci && rd_wr)
				begin
					IN_2[19:0] <= #delay ad_to_tuvv[19:0];
					dat_in2_come <= #delay 1;	//IN_2 data come
				end
		end
	else
		dat_in2_come <= #delay 0;
			
	always @ (posedge clk)
	if(!rst_)
		begin
			a_sus_ <= #delay {32{1'h0}};
			a_sel_ <= #delay {32{1'h0}};
			b_sus_ <= #delay {32{1'h0}};
			b_sel_ <= #delay {32{1'h0}};
			c_sus_ <= #delay {32{1'h0}};
			c_sel_ <= #delay {32{1'h0}};
			d1_sus_ <= #delay {32{1'h0}};
			d1_sel_ <= #delay {32{1'h0}};
			d2_sus_ <= #delay {24{1'h0}};
			d2_sel_ <= #delay {24{1'h0}};
			cntrl_e_ <= #delay {4{1'h0}};
		end
	else if (IN_1[11] == 1'b0 && IN_2[11] == 1'b0)//enable for work register// if 0 reset
	  begin
	    a_sus_ <= #delay {32{1'h0}};
			a_sel_ <= #delay {32{1'h0}};
			b_sus_ <= #delay {32{1'h0}};
			b_sel_ <= #delay {32{1'h0}};
			c_sus_ <= #delay {32{1'h0}};
			c_sel_ <= #delay {32{1'h0}};
			d1_sus_ <= #delay {32{1'h0}};
			d1_sel_ <= #delay {32{1'h0}};
			d2_sus_ <= #delay {24{1'h0}};
			d2_sel_ <= #delay {24{1'h0}};
			cntrl_e_ <= #delay {4{1'h0}};
		end
	else if (in_1_sel)
		begin
		if (IN_1[3:0] == 4'b0001)	//polnoe upravlenie//Выбран режим полного управления
			if (IN_1[4]) //если четвертый бит ==1 
				begin
					a_sus_ <= #delay {32{1'h0}};
					a_sel_ <= #delay {32{1'h1}};
					b_sus_ <= #delay {32{1'h0}};
					b_sel_ <= #delay {32{1'h1}};
					c_sus_ <= #delay {32{1'h0}};
					c_sel_ <= #delay {32{1'h1}};
					d1_sus_ <= #delay {32{1'h0}};
					d1_sel_ <= #delay {32{1'h1}};
					d2_sus_ <= #delay {24{1'h0}};
					d2_sel_ <= #delay {24{1'h1}};
					cntrl_e_ <= #delay {4{1'h1}};
				end
			else  
				begin
					a_sel_ <= #delay {32{1'h0}};
					b_sel_ <= #delay {32{1'h0}};
					c_sel_ <= #delay {32{1'h0}};
					d1_sel_ <= #delay {32{1'h0}};
					d2_sel_ <= #delay {24{1'h0}};
					cntrl_e_ <= #delay {4{1'h0}};
				end
		
		else if (IN_1[3:0] == 4'b0010)	//gruppovoe upravlenie
			case (IN_1[10:8])
				3'b001: if (IN_1[4])//4 бит разрешения
							begin
								a_sus_ <= #delay {32{1'h0}};
								a_sel_ <= #delay {32{1'h1}};
							end
						else
							a_sel_ <= #delay {32{1'h0}};
				3'b010: if (IN_1[4])
							begin
								b_sus_ <= #delay {32{1'h0}};
								b_sel_ <= #delay {32{1'h1}};
							end
						else
							b_sel_ <= #delay {32{1'h0}};
				3'b011: if (IN_1[4])
							begin
								c_sus_ <= #delay {32{1'h0}};
								c_sel_ <= #delay {32{1'h1}};
							end
						else
							c_sel_ <= #delay {32{1'h0}};
				3'b100: if (IN_1[4])
							begin
								d1_sus_ <= #delay {32{1'h0}};
								d1_sel_ <= #delay {32{1'h1}};
							end
						else
							d1_sel_ <= #delay {32{1'h0}};
				3'b101: if (IN_1[4])
							begin
								d2_sus_ <= #delay {24{1'h0}};
								d2_sel_ <= #delay {24{1'h1}};
							end
						else
							d2_sel_ <= #delay {24{1'h0}};
				3'b110: if (IN_1[4])
							cntrl_e_ <= #delay {4{1'h1}};
						else
							cntrl_e_ <= #delay {4{1'h0}};
				 default:
						fake_reg <= #delay 1;
			endcase	
		else if (IN_1[3:0] == 4'b0100)	//adresnoe upravlenie
			case (IN_1[10:8])
				3'b001: if (IN_1[4])
							begin
								a_sus_[IN_1[16:12]+1] <= #delay 0;
								a_sel_[IN_1[16:12]+1] <= #delay 1;
							end
						else
							a_sel_[IN_1[16:12]+1] <= #delay 0;
				3'b010: if (IN_1[4])
							begin
								b_sus_[IN_1[16:12]+1] <= #delay 0;
								b_sel_[IN_1[16:12]+1] <= #delay 1;
							end
						else
							b_sel_[IN_1[16:12]+1] <= #delay 0;
				3'b011: if (IN_1[4])
							begin
								c_sus_[IN_1[16:12]+1] <= #delay 0;
								c_sel_[IN_1[16:12]+1] <= #delay 1;
							end
						else
							c_sel_[IN_1[16:12]+1] <= #delay 0;
				3'b100: if (IN_1[4])
							begin
								d1_sus_[IN_1[16:12]+1] <= #delay 0;
								d1_sel_[IN_1[16:12]+1] <= #delay 1;
							end
						else
							d1_sel_[IN_1[16:12]+1] <= #delay 0;
				3'b101: if (IN_1[4])
							begin
								d2_sus_[IN_1[16:12]+1] <= #delay 0;
								d2_sel_[IN_1[16:12]+1] <= #delay 1;
							end
						else
							d2_sel_[IN_1[16:12]+1] <= #delay 0;
				3'b110: if (IN_1[4])
							cntrl_e_[IN_1[13:12]+1] <= #delay 1;
						else
							cntrl_e_[IN_1[13:12]+1] <= #delay 0;
				 default:
						fake_reg <= #delay 1;
			endcase
		else if (IN_1[3:0] == 4'b1000)	//sekcionnoe upravlenie
			if (IN_1[4])
				begin
					a_sus_[IN_1[16:12]+1] <= #delay 0;
					a_sel_[IN_1[16:12]+1] <= #delay 1;
					b_sus_[IN_1[16:12]+1] <= #delay 0;
					b_sel_[IN_1[16:12]+1] <= #delay 1;
					c_sus_[IN_1[16:12]+1] <= #delay 0;
					c_sel_[IN_1[16:12]+1] <= #delay 1;
					d1_sus_[IN_1[16:12]+1] <= #delay 0;
					d1_sel_[IN_1[16:12]+1] <= #delay 1;
				end
			else  
				begin
					a_sel_[IN_1[16:12]+1]  <= #delay 0;
					b_sel_[IN_1[16:12]+1]  <= #delay 0;
					c_sel_[IN_1[16:12]+1]  <= #delay 0;
					d1_sel_[IN_1[16:12]+1] <= #delay 0;
				end
		end
	else if ((IN_2[11] == 1'b0) && IN_1[11] == 1'b0)//enable for work register// if 0 reset
	  begin
	        a_sus_ <= #delay {32{1'h0}};
			    a_sel_ <= #delay {32{1'h0}};
			    b_sus_ <= #delay {32{1'h0}};
			    b_sel_ <= #delay {32{1'h0}};
			    c_sus_ <= #delay {32{1'h0}};
			   	c_sel_ <= #delay {32{1'h0}};
			    d1_sus_ <= #delay {32{1'h0}};
			    d1_sel_ <= #delay {32{1'h0}};
			    d2_sus_ <= #delay {24{1'h0}};
			    d2_sel_ <= #delay {24{1'h0}};
			   	cntrl_e_ <= #delay {4{1'h0}};
			  end
	else if (in_2_sel)
		begin
		if (IN_2[3:0] == 4'b0001)	//polnoe upravlenie
			if (IN_2[4])
				begin
					a_sel_ <= #delay {32{1'h0}};//отключение датчика
					a_sus_ <= #delay {32{1'h1}};//значение с цап подает
					b_sel_ <= #delay {32{1'h0}};
					b_sus_ <= #delay {32{1'h1}};
					c_sel_ <= #delay {32{1'h0}};
					c_sus_ <= #delay {32{1'h1}};
					d1_sel_ <= #delay {32{1'h0}};
					d1_sus_ <= #delay {32{1'h1}};
					d2_sel_ <= #delay {24{1'h0}};
					d2_sus_ <= #delay {24{1'h1}};
				end
			else  
				begin
					a_sus_ <= #delay {32{1'h0}};
					b_sus_ <= #delay {32{1'h0}};
					c_sus_ <= #delay {32{1'h0}};
					d1_sus_ <= #delay {32{1'h0}};
					d2_sus_ <= #delay {24{1'h0}};
				end		
		else if (IN_2[3:0] == 4'b0010)	//gruppovoe upravlenie
			case (IN_2[10:8])
				3'b001: if (IN_2[4])
							begin
								a_sel_ <= #delay {32{1'h0}};
								a_sus_ <= #delay {32{1'h1}};
							end
						else
							a_sus_ <= #delay {32{1'h0}};
				3'b010: if (IN_2[4])
							begin
								b_sel_ <= #delay {32{1'h0}};
								b_sus_ <= #delay {32{1'h1}};
							end
						else
							b_sus_ <= #delay {32{1'h0}};
				3'b011: if (IN_2[4])
							begin
								c_sel_ <= #delay {32{1'h0}};
								c_sus_ <= #delay {32{1'h1}};
							end
						else
							c_sus_ <= #delay {32{1'h0}};
				3'b100: if (IN_2[4])
							begin
								d1_sel_ <= #delay {32{1'h0}};
								d1_sus_ <= #delay {32{1'h1}};
							end
						else
							d1_sus_ <= #delay {32{1'h0}};
				3'b101: if (IN_2[4])
							begin
								d2_sel_ <= #delay {24{1'h0}};
								d2_sus_ <= #delay {24{1'h1}};
							end
						else
							d2_sus_ <= #delay {24{1'h0}};
				 default:
						fake_reg <= #delay 1;
			endcase	
		else if (IN_2[3:0] == 4'b0100)	//adresnoe upravlenie
			case (IN_2[10:8])
				3'b001: if (IN_2[4])
							begin
								a_sel_[IN_2[16:12]+1] <= #delay 0;
								a_sus_[IN_2[16:12]+1] <= #delay 1;
							end
						else
							a_sus_[IN_2[16:12]+1] <= #delay 0;
				3'b010: if (IN_2[4])
							begin
								b_sel_[IN_2[16:12]+1] <= #delay 0;
								b_sus_[IN_2[16:12]+1] <= #delay 1;
							end
						else
							b_sus_[IN_2[16:12]+1] <= #delay 0;
				3'b011: if (IN_2[4])
							begin
								c_sel_[IN_2[16:12]+1] <= #delay 0;
								c_sus_[IN_2[16:12]+1] <= #delay 1;
							end
						else
							c_sus_[IN_2[16:12]+1] <= #delay 0;
				3'b100: if (IN_2[4])
							begin
								d1_sel_[IN_2[16:12]+1] <= #delay 0;
								d1_sus_[IN_2[16:12]+1] <= #delay 1;
							end
						else
							d1_sus_[IN_2[16:12]+1] <= #delay 0;
				3'b101: if (IN_2[4])
							begin
								d2_sel_[IN_2[16:12]+1] <= #delay 0;
								d2_sus_[IN_2[16:12]+1] <= #delay 1;
							end
						else
							d2_sus_[IN_2[16:12]+1] <= #delay 0;
				 default:
						fake_reg <= #delay 1;
			endcase
		else if (IN_2[3:0] == 4'b1000)	//sekcionnoe upravlenie
			if (IN_2[4])
				begin
					a_sel_[IN_2[16:12]+1] <= #delay 0;
					a_sus_[IN_2[16:12]+1] <= #delay 1;
					b_sel_[IN_2[16:12]+1] <= #delay 0;
					b_sus_[IN_2[16:12]+1] <= #delay 1;
					c_sel_[IN_2[16:12]+1] <= #delay 0;
					c_sus_[IN_2[16:12]+1] <= #delay 1;
					d1_sel_[IN_2[16:12]+1] <= #delay 0;
					d1_sus_[IN_2[16:12]+1] <= #delay 1;
				end
			else  
				begin
					a_sus_[IN_2[16:12]+1]  <= #delay 0;
					b_sus_[IN_2[16:12]+1]  <= #delay 0;
					c_sus_[IN_2[16:12]+1]  <= #delay 0;
					d1_sus_[IN_2[16:12]+1] <= #delay 0;
				end	
		end					
	
	assign a_sel = (rst_) ? a_sel_ : 32'h0;
	assign b_sel = (rst_) ? b_sel_ : 32'h0;
	assign c_sel = (rst_) ? c_sel_ : 32'h0;
	assign d_sel = (rst_) ? {d2_sel_, d1_sel_} : 56'h0;
	assign cntrl_e = (rst_) ? cntrl_e : 4'h0;
	
	assign a_sus = (rst_) ? a_sus_ : 32'h0;
	assign b_sus = (rst_) ? b_sus_ : 32'h0;
	assign c_sus = (rst_) ? c_sus_ : 32'h0;
	assign d_sus = (rst_) ? {d2_sus_, d1_sus_} : 56'h0;
	
	
	
	
	//--------------------------------- SENS ------------------------------------------//
	//assign sens_sel = (ADRESS[19:4] == 16'h1320) ? 1'b1 : 1'b0;	
	always @ (posedge clk)
	if(!rst_)
		begin
			SENS[31:0] <= #delay 0;
			SENS_del [31:0] <= #delay 0;
			SENS_flag <= #delay 0;
		end
	else if (sens_sel)
		begin
			if (valid_pci & !a_d)
				begin
					SENS[31:0] <= #delay 0;
					SENS_del[31:0] <= #delay ad_to_tuvv[31:0];
					SENS_flag <= #delay 1;
				end
			else if (SENS_flag)
				begin
					SENS[31:0] <= #delay SENS_del[31:0];
					SENS_flag <= #delay 0;
				end
		end
	
	assign set1_v   	   = (rst_ && SENS[1:0] == 2'b01) ? 1'b1 : 1'b0;  	   //analogoviy
	assign set1_r       = (rst_ && SENS[1:0] == 2'b10) ? 1'b1 : 1'b0;       //parametricheskiy
	assign set1_gnd     = (rst_ && SENS[1:0] == 2'b11) ? 1'b1 : 1'b0;       //diskretniy
	assign set2_v   	   = (rst_ && SENS[3:2] == 2'b01) ? 1'b1 : 1'b0;  	   //analogoviy
	assign set2_r       = (rst_ && SENS[3:2] == 2'b10) ? 1'b1 : 1'b0;       //parametricheskiy
	assign set2_gnd     = (rst_ && SENS[3:2] == 2'b11) ? 1'b1 : 1'b0;       //diskretniy
	assign set3_v   	   = (rst_ && SENS[5:4] == 2'b01) ? 1'b1 : 1'b0;  	   //analogoviy
	assign set3_r       = (rst_ && SENS[5:4] == 2'b10) ? 1'b1 : 1'b0;       //parametricheskiy
	assign set3_gnd     = (rst_ && SENS[5:4] == 2'b11) ? 1'b1 : 1'b0;       //diskretniy
	assign set4_v   	   = (rst_ && SENS[7:6] == 2'b01) ? 1'b1 : 1'b0;  	   //analogoviy
	assign set4_r       = (rst_ && SENS[7:6] == 2'b10) ? 1'b1 : 1'b0;       //parametricheskiy
	assign set4_gnd     = (rst_ && SENS[7:6] == 2'b11) ? 1'b1 : 1'b0;       //diskretniy
	
	assign adc_test     = (rst_) ? SENS`ADC_EN   : 1'b0;    //Test ADC
	
	assign set1_check_a   = (rst_) ? SENS`SET1_CHECK_A : 1'b0;
	assign set2_check_a   = (rst_) ? SENS`SET2_CHECK_A : 1'b0;
	assign set3_check_a   = (rst_) ? SENS`SET3_CHECK_A : 1'b0;
	assign set4_check_a   = (rst_) ? SENS`SET4_CHECK_A : 1'b0;
	
	assign set1_check_b   = (rst_) ? SENS`SET1_CHECK_B : 1'b0;
	assign set2_check_b   = (rst_) ? SENS`SET2_CHECK_B : 1'b0;
	assign set3_check_b   = (rst_) ? SENS`SET3_CHECK_B : 1'b0;
	assign set4_check_b   = (rst_) ? SENS`SET4_CHECK_B : 1'b0;
	
	assign set1_check_c   = (rst_) ? SENS`SET1_CHECK_C : 1'b0;
	assign set2_check_c   = (rst_) ? SENS`SET2_CHECK_C : 1'b0;
	assign set3_check_c   = (rst_) ? SENS`SET3_CHECK_C : 1'b0;
	assign set4_check_c   = (rst_) ? SENS`SET4_CHECK_C : 1'b0;
	
	assign set_check_d    = (rst_) ? SENS`SET1_CHECK_D  : 1'b0;
	assign set_v_d        = (rst_) ? SENS`SET2_CHECK_D  : 1'b0;
	assign set_r_d        = (rst_) ? SENS`SET3_CHECK_D  : 1'b0;
	assign set_gnd_d      = (rst_) ? SENS`SET4_CHECK_D  : 1'b0;

  assign set_abc = (rst_ && (|SENS_del[25:0] == {26{1'b0}})) ? 	SENS`SET_A_B_C : 1'b0;
	assign a4_0    = (rst_) ? SENS`A4_0 : 1'b0;
	assign a4_1    = (rst_) ? SENS`A4_1 : 1'b0;
	assign a4_2    = (rst_) ? SENS`A4_2 : 1'b0;
	assign a4_3    = (rst_) ? SENS`A4_3 : 1'b0;
  assign en_prb   = (rst_) ? SENS`EN_RB: 1'b0;
	
	
	
	//---------------------------------C_IMSH------------------------------------------//
	//assign c_imsh_sel = (ADRESS[19:4] == 16'h1330) ? 1'b1 : 1'b0;	
	always @ (posedge clk)
	if(!rst_)
		C_IMSH[8:0] <= #delay 0;
	else if (c_imsh_sel)
		if (valid_pci && rd_wr)
			C_IMSH[8:0] <= #delay ad_to_tuvv[8:0];
		
	assign co_en 	 = (rst_) ? !C_IMSH[8] : 1'b1;	
	assign co_a[1:0] = (rst_) ? C_IMSH[7:6] : 2'b00;	
	assign co_b[1:0] = (rst_) ? C_IMSH[5:4] : 2'b00;	
	assign co_c[1:0] = (rst_) ? C_IMSH[3:2] : 2'b00;	
	assign co_d[1:0] = (rst_) ? C_IMSH[1:0] : 2'b00;	
		
		
			
	
	//---------------------------------R_ERR------------------------------------------//
	//assign r_err_sel = (ADRESS[19:4] == 16'hF000) ? 1'b1 : 1'b0;		// Проверка регистра ошибок
	always @ (posedge clk)
	if(!rst_)
		begin
			R_ERR [7:0] <= #delay 0;
			err_check <= #delay 0;
		end
	else if (adr_come)
		begin
			if (
			  ADRESS[19:4] != `IN_1 &
				ADRESS[19:4] != `IN_2 &
				ADRESS[19:4] != `SENS &
				ADRESS[19:4] != `C_IMSH &
			  ADRESS[19:4] != `R_ERR &
				ADRESS[19:4] != `R_TEST &
				ADRESS[19:4] != `DATA_IN &
				ADRESS[19:4] != `DATA_OUT &
				ADRESS[19:4] != `DATA_IN_ADC &
				ADRESS[19:4] != `SEL_REG &
				ADRESS[19:4] != `DAC_CTRL &
				ADRESS[19:4] != `DATA_IN_SEL &
				ADRESS[19:4] != `RELAY_CTRL )
					R_ERR[0] <= #delay 1;
			else if (r_err_sel)
				err_check <= #delay 1;		
			else if (err_check)
					begin
						R_ERR [7:0] <= #delay 0;
						err_check <= #delay 0;
					end	
		end				
	else if (dat_in1_come)
		begin
			if (IN_1[3:0] != 4'b0001 &
				IN_1[3:0] != 4'b0010 &
				IN_1[3:0] != 4'b0100 &
				IN_1[3:0] != 4'b1000 )
					R_ERR[7] <= #delay 1;
			
		end
	else if (dat_in2_come)
		begin
			if (IN_2[3:0] != 4'b0001 &
				IN_2[3:0] != 4'b0010 &
				IN_2[3:0] != 4'b0100 &
				IN_2[3:0] != 4'b1000 )
					R_ERR[7] <= #delay 1;
			
		end
	
	
	
	
	
	//---------------------------------R_TEST------------------------------------------//
	//assign r_test_sel = (ADRESS[19:4] == 16'hFFF0) ? 1'b1 : 1'b0;	
	always @ (posedge clk)
	if (!rst_)
		R_TEST[31:0] <= #delay 0;
	else if (r_test_sel)
		begin
			if (valid_pci && rd_wr)
				R_TEST[31:0] <= #delay ad_to_tuvv[31:0];
			end
		
	initial
		begin	
			delay = 0;
			IN_1 <= {20{1'hz}};
			IN_2 <= {20{1'hz}};
			SENS <= 8'hz;
			R_ERR <= 8'hz;
			C_IMSH <= {9{1'hz}};	
			R_TEST <= {32{1'hz}};		
			adr_come <= 1'bz;
			dat_in1_come <= 1'bz;
			dat_in2_come <= 1'bz;
			err_check <= 1'bz; 
			fake_reg <= 1'bz;	
			SENS_del <= 8'hz;
			SENS_flag <= 1'bz;
			wrb_delay <= 1'bz;
			dac_wr <= 1'bz;
			adc_wr <= 1'bz;
			
			adc_wr_time <= {14{1'hz}};
			adc_wr_cnt <= 1'bz;
			adc_wr_done <= 1'bz;
			int_start <= 1'bz;
			data_out_del <= 2'bz;
			
			
			
			
			a_sel_ <= {32{1'hz}};
			b_sel_ <= {32{1'hz}};
			c_sel_ <= {32{1'hz}};
			d1_sel_ <= {32{1'hz}};
			d2_sel_ <= {24{1'hz}};
			cntrl_e_ <= 4'hz;
			
			a_sus_ <= {32{1'hz}};
			b_sus_ <= {32{1'hz}};
			c_sus_ <= {32{1'hz}};
			d1_sus_ <= {32{1'hz}};
			d2_sus_ <= {24{1'hz}};
			
		
			
		end


endmodule
