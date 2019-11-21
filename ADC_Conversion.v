// ============================================================================
// Copyright (c) 2016 by Terasic Technologies Inc.
// ============================================================================
//
// Permission:
//
//   Terasic grants permission to use and modify this code for use
//   in synthesis for all Terasic Development Boards and Altera Development 
//   Kits made by Terasic.  Other use of this code, including the selling 
//   ,duplication, or modification of any portion is strictly prohibited.
//
// Disclaimer:
//
//   This VHDL/Verilog or C/C++ source code is intended as a design reference
//   which illustrates how these types of functions can be implemented.
//   It is the user's responsibility to verify their design for
//   consistency and functionality through the use of formal
//   verification methods.  Terasic provides no warranty regarding the use 
//   or functionality of this code.
//
// ============================================================================
//           
//  Terasic Technologies Inc
//  9F., No.176, Sec.2, Gongdao 5th Rd, East Dist, Hsinchu City, 30070. Taiwan
//  
//  
//                     web: http://www.terasic.com/  
//                     email: support@terasic.com
//
// ============================================================================



module ADC_Conversion(

      input              MAX10_CLK1_50,
		output             response_valid_out, 
		output  				[11:0] ADC_out,
		output				[11:0]		response_data

);



//=======================================================
//  REG/WIRE declarations
//=======================================================

wire reset_n;
wire sys_clk;


//=======================================================
//  Structural coding
//=======================================================

assign reset_n = 1'b1;



    adc_qsys u0 (
        .clk_clk                              (MAX10_CLK1_50),                //  clk.clk
        .reset_reset_n                        (reset_n),                      //  reset.reset_n
        .modular_adc_0_command_valid          (command_valid),          		//  modular_adc_0_command.valid
        .modular_adc_0_command_channel        (command_channel),        		//                       .channel
        .modular_adc_0_command_startofpacket  (command_startofpacket),  		//                       .startofpacket
        .modular_adc_0_command_endofpacket    (command_endofpacket),    		//                       .endofpacket
        .modular_adc_0_command_ready          (command_ready),          		//                       .ready
        .modular_adc_0_response_valid         (response_valid),         		// modular_adc_0_response.valid
        .modular_adc_0_response_channel       (response_channel),       		//                       .channel
		  .modular_adc_0_response_data          (response_data),          			//                       .data
        .modular_adc_0_response_startofpacket (response_startofpacket), 		//                       .startofpacket
        .modular_adc_0_response_endofpacket   (response_endofpacket),   		//                       .endofpacket
        .clock_bridge_sys_out_clk_clk         (sys_clk)          					// clock_bridge_sys_out_clk.clk
    );

	 
////////////////////////////////////////////
// command
wire  command_valid;
wire  [4:0] command_channel;
wire  command_startofpacket;
wire  command_endofpacket;
wire command_ready;

// continues send command
assign command_startofpacket = 1'b1;    // ignore in altera_adc_control core
assign command_endofpacket = 1'b1; 		 // ignore in altera_adc_control core
assign command_valid = 1'b1; 				 // 
assign command_channel = 1; 				 // SW2/SW1/SW0 down: map to arduino ADC_IN0

////////////////////////////////////////////
// response
wire response_valid			/* synthesis keep */;
wire [4:0] response_channel;
wire response_startofpacket;
wire response_endofpacket;
reg  [4:0]  cur_adc_ch 		/* synthesis noprune */;
reg  [11:0] adc_sample_data /* synthesis noprune */;
reg  [11:0] vol 				/* synthesis noprune */;


always @ (posedge sys_clk) 
begin
	if (response_valid)
	begin
		adc_sample_data <= response_data;
		cur_adc_ch <= response_channel;
		
		vol <= response_data;
	end
end			
 
 assign ADC_out = vol;
 assign response_valid_out = response_valid;

endmodule
