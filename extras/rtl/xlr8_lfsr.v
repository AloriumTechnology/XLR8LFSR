///////////////////////////////////////////////////////////////////
//=================================================================
//  Copyright (c) Alorium Technology 2016
//  ALL RIGHTS RESERVED
//  $Id:  $
//=================================================================
//
// File name:  : xlr8_lfsr.v
// Author      :  Bryan Craker
// Description : Simple XB instantiating an LFSR for XLR8
//=================================================================
///////////////////////////////////////////////////////////////////

module xlr8_lfsr (
   // Outputs
   dbus_out, io_out_en,
   // Inputs
   rstn, clk, clken, dbus_in, ramadr, ramre, ramwe, dm_sel,
   );

   parameter LFSR_CTRL_ADDR = 0;
   parameter LFSR_SEED_ADDR = 0;
   parameter LFSR_DATA_ADDR = 0;
   parameter WIDTH = 8;

   // Clock and Reset
   input                     rstn;
   input                     clk;
   input                     clken;
   // I/O 
   input [7:0]               dbus_in;
   output [7:0]              dbus_out;
   output                    io_out_en;
   // DM
   input [7:0]               ramadr;
   input                     ramre;
   input                     ramwe;
   input                     dm_sel;

   logic ctrl_sel;
   logic ctrl_we;
   logic ctrl_re;
   logic [WIDTH-1:0] lfsr_ctrl;
   logic seed_sel;
   logic seed_we;
   logic seed_re;
   logic [WIDTH-1:0] lfsr_seed;
   logic data_sel;
   logic data_we;
   logic data_re;
   logic [WIDTH-1:0] lfsr_data;

   assign ctrl_sel = (dm_sel && ramadr == LFSR_CTRL_ADDR);
   assign ctrl_we  = ctrl_sel && (ramwe);
   assign ctrl_re  = ctrl_sel && (ramre);
   assign seed_sel = (dm_sel && ramadr == LFSR_SEED_ADDR);
   assign seed_we  = seed_sel && (ramwe);
   assign seed_re  = seed_sel && (ramre);
   assign data_sel = (dm_sel && ramadr == LFSR_DATA_ADDR);
   assign data_we  = data_sel && (ramwe);
   assign data_re  = data_sel && (ramre);
   assign dbus_out =  ({8{ctrl_sel}} & lfsr_ctrl) |
                      ({8{seed_sel}} & lfsr_seed) |
                      ({8{data_sel}} & lfsr_data);
   assign io_out_en = ctrl_re ||
                      seed_re ||
                      data_re;

   always @(posedge clk or negedge rstn) begin
      if (!rstn)  begin
         lfsr_ctrl <= {WIDTH{1'b0}};
      end else if (clken && ctrl_we) begin
         lfsr_ctrl <= dbus_in[WIDTH-1:0];
      end
   end // always @ (posedge clk or negedge rstn)

   always @(posedge clk or negedge rstn) begin
      if (!rstn)  begin
         lfsr_seed <= {WIDTH{1'b0}};
      end else if (clken && seed_we) begin
         lfsr_seed <= dbus_in[WIDTH-1:0];
      end
   end // always @ (posedge clk or negedge rstn)

   alorium_lfsr lfsr_inst (
                        // Clock and Reset
                        .clk       (clk),
                        .reset_n   (rstn),
                        // Inputs
                        .new_seed  (seed_we),
                        .enable    (lfsr_ctrl[0] | data_re),
                        .seed      (lfsr_seed),
                        // Output
                        .lfsr_data (lfsr_data));

endmodule // xlr8_lfsr

