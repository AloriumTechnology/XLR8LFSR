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
   // Output
   output reg [7:0] lfsr_data
  );

   wire	feedback;

   assign feedback = ~(lfsr_data[7] ^ lfsr_data[5] ^ lfsr_data[4] ^ lfsr_data[3]);
   
   always @(posedge clk or negedge reset_n) begin

      if (!reset_n) begin
	 lfsr_data <= 8'h01 ;  // LFSR register cannot be all 1's for XNOR LFSR
      end
      else if (new_seed) begin
	 lfsr_data <= &seed ? 8'h01 : seed ;  // LFSR register cannot be all 1's for XNOR LFSR
      end
      else if (enable) begin
	 lfsr_data <= {lfsr_data[6:0],feedback};
      end // else: !if(!reset_n)
   end // always @ (posedge clk or negedge reset_n)

endmodule // alorium_lfsr

