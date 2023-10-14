module top (
    input logic i_clock,
    input logic [1:0] i_key,
    input logic [3:0] i_switch,
    output logic [7:0] o_led
);

wrapper wrapper_inst (
    .i_clock(i_clock),
    .i_key(i_key),
    .i_switch(i_switch),
    .o_led(o_led)
);

endmodule
