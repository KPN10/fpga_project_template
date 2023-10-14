// https://www.fpga4fun.com/CrossClockDomain2.html
module flag_cross_domain (
    input logic clock_domain_1,
    input logic flag_domain_1,
    input logic clock_domain_2,
    output logic flag_domain_2
);

logic flag_toggle_clock_1;
always_ff @(posedge clock_domain_1)
    flag_toggle_clock_1 <= flag_toggle_clock_1 ^ flag_domain_1;

logic [2:0] sync;
always_ff @(posedge clock_domain_2)
    sync <= {sync[1:0], flag_toggle_clock_1};

assign flag_domain_2 = (sync[2] ^ sync[1]);

endmodule
