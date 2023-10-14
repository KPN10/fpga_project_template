module wrapper (
    input logic i_clock,
    input logic [1:0] i_key,
    input logic [3:0] i_switch,
    output logic [7:0] o_led
);

// blinker blinker_inst (
//     .i_clk(i_clock),
//     .o_led(o_led[5])
// );

// counter counter_inst (
//     .clk(i_clock),
//     .o(o_led[7])
// );

endmodule
