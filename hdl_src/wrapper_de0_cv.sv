module wrapper #(
    parameter NUM_HEX_INDICATORS = 6
) (
    input logic i_clock,
    input logic i_reset_n,
    input logic [3:0] i_key,
    input logic [9:0] i_switch,
    output logic [9:0] o_led,
    output logic [6:0] o_hex [NUM_HEX_INDICATORS - 1:0]
);

logic [3:0] hex_val [NUM_HEX_INDICATORS - 1:0];
logic en_seven_segment;
assign en_seven_segment = i_switch[0];

project_info_viewer
#(
    .NUM_HEX(NUM_HEX_INDICATORS)
) project_info_viewer_inst
(
    .i_clock(i_clock),
    .i_reset(async_reset),
    .i_enable(i_switch[1]),
    .i_change(button_down[3]),
    .o_hex(hex_val),
);

genvar q;
generate
    for (q = 0; q < NUM_HEX_INDICATORS; q++) begin : generate_seven_segment_inst
        seven_segment seven_segment_inst (
            .i_hex(hex_val[q]),
            .i_en(en_seven_segment),
            .o_segment(o_hex[q])
        );
    end
endgenerate

logic async_reset;
// assign async_reset = ~i_reset_n;
debouncer debouncer_inst_1 (
    .i_clk(i_clock),
    .i_button(~i_reset_n),
    .o_button(async_reset)
);

parameter NUM_BUTTONS = 4;
logic [NUM_BUTTONS - 1:0] button;
logic [NUM_BUTTONS - 1:0] button_down;
logic [NUM_BUTTONS - 1:0] button_up;
genvar i;
generate
    for (i = 0; i < NUM_BUTTONS; i++) begin : generate_debouncer_inst
        // debouncer debouncer_inst (
        //     .i_clk(i_clock),
            // .i_button(~i_key[i]),
        //     .o_button(button[i])
        // );

        debouncer_states debouncer_states_inst (
            .i_clock(i_clock),
            .i_push_button(i_key[i]),
            .o_push_button_state(button[i]),
            .o_push_button_down(button_down[i]),
            .o_push_button_up(button_up[i])
        );

        assign o_led[i] = button[i];
    end
endgenerate

blinker blinker_inst (
    .i_clk(i_clock),
    .i_rst(1'b0),
    .i_arst(async_reset),
    .i_en(i_switch[9]),
    .o_led(o_led[9])
);

// counter counter_inst (
//     .clk(i_clock),
//     .o(o_led[7])
// );

endmodule
