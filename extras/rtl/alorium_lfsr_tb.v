`include "alorium_lfsr.v"

module alorium_lfsr_tb();

  reg clock, reset, new_seed, enable, long_hb;
  reg [7:0] in;
  wire heartbeat;
  wire [7:0] out;

  initial begin
    clock = 1;
    reset = 1;
    new_seed = 0;
    enable = 0;
	long_hb = 1;
    #5 reset = 0;
    #10 reset = 1;
    #10 in = 8'b10101010;
    #15 new_seed = 1;
    #5 new_seed = 0;
    #5 enable = 1;
    #5 enable = 0;
    #25 enable = 1;
    #5 enable = 0;
    #25 enable = 1;
    #200;
    #5 $stop;
  end

  always begin
    #5 clock = ~clock;
  end

  alorium_lfsr lfsr_inst (
    // Clock and Reset
    .clk       (clock),
    .reset_n   (reset),
    // Inputs
    .new_seed  (new_seed),
    .enable    (enable),
    .seed      (in),
	.long_hb   (long_hb),
    // Output
	.heartbeat (heartbeat),
    .lfsr_data (out));

endmodule

