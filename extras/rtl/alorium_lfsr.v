///////////////////////////////////////////////////////////////////
//=================================================================
//  Copyright (c) Alorium Technology 2016
//  ALL RIGHTS RESERVED
//  $Id:  $
//=================================================================
//
// File name:  : alorium_lfsr.v
// Author      :  Jason Pecor
// Description : Simple LFSR module
//=================================================================
///////////////////////////////////////////////////////////////////

module alorium_lfsr
  (
   // Clock and Reset
   input clk,
   input reset_n,
   // Inputs
   input new_seed,
   input enable,
   input wire [7:0] seed,
   input long_hb,
   // Output
   output reg heartbeat,
   output reg [7:0] lfsr_data
  );

   reg [29:0] hb_cnt;
   wire	feedback;

   assign feedback = ~(lfsr_data[7] ^ lfsr_data[5] ^ 
                       lfsr_data[4] ^ lfsr_data[3]);
   
   always @(posedge clk) begin

      if (!reset_n) begin
         heartbeat <= 0;
         hb_cnt <= 0;
         // LFSR register cannot be all 1's for XNOR LFSR
	 lfsr_data <= 8'h01;
      end
      else if (new_seed) begin
         // LFSR register cannot be all 1's for XNOR LFSR
         lfsr_data <= &seed ? 8'h01 : seed;
         hb_cnt <= hb_cnt + 1;
      end
      else if (enable) begin
	 lfsr_data <= {lfsr_data[6:0],feedback};
         hb_cnt <= hb_cnt + 1;
      end // else: !if(!reset_n)

      if ((long_hb) && (hb_cnt > 9999999)) begin
        hb_cnt <= 0;
        heartbeat <= ~heartbeat;
      end
      else if ((!long_hb) && (hb_cnt > 9)) begin
        hb_cnt <= 0;
        heartbeat <= ~heartbeat;
      end

   end // always @ (posedge clk)

endmodule
