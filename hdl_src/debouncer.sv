module debouncer (
    input logic i_clk,
    input logic i_button,
    output logic o_button
);

logic slow_clock;
logic q1, q2, q2_bar, q0;

slow_clock slow_clock_inst (
    .i_clk(i_clk),
    .o_slow_clk(slow_clock)
);

d_flip_flop d0 (
    .i_dff_clock(i_clk),
    .i_slow_clock(slow_clock),
    .i_d(i_button),
    .o_q(q0)
);

d_flip_flop d1 (
    .i_dff_clock(i_clk),
    .i_slow_clock(slow_clock),
    .i_d(q0),
    .o_q(q1)
);

d_flip_flop d2 (
    .i_dff_clock(i_clk),
    .i_slow_clock(slow_clock),
    .i_d(q1),
    .o_q(q2)
);

assign q2_bar = ~q2;
assign o_button = q1 & q2_bar;

endmodule

module slow_clock (
    input logic i_clk,
    output logic o_slow_clk
);

parameter WIDTH = 26;
logic [WIDTH-1:0] counter = '0;
const bit [WIDTH-1:0] a = 'd127999;

always @ (posedge i_clk)
    counter <= (counter >= a) ? 0 : counter + 1'b1;

assign o_slow_clk = (counter == a) ? 1'b1 : 1'b0;

endmodule

module d_flip_flop (
    input logic i_dff_clock,
    input logic i_slow_clock,
    input logic i_d,
    output logic o_q
);

always @ (posedge i_dff_clock)
    if (i_slow_clock == 1)
        o_q <= i_d;

endmodule

// https://www.fpga4fun.com/Debouncer.html
module debouncer_states (
    input logic i_clock,
    input logic i_push_button,
    output logic o_push_button_state,
    output logic o_push_button_down,
    output logic o_push_button_up
);

logic push_button_state;
logic [15:0] pb_counter;
logic pb_idle;
logic pb_counter_max;
logic pb_sync_0;
logic pb_sync_1;

always_ff @(posedge i_clock)
    pb_sync_0 <= ~i_push_button;

always_ff @(posedge i_clock)
    pb_sync_1 <= pb_sync_0;

assign pb_idle = (push_button_state == pb_sync_1);
assign pb_counter_max = &pb_counter;

always_ff @(posedge i_clock)
    if(pb_idle)
        pb_counter <= '0;
    else begin
        pb_counter <= pb_counter + 1'b1;

        if (pb_counter_max) push_button_state <= ~push_button_state;
    end

assign o_push_button_state = push_button_state;
assign o_push_button_down = ~pb_idle & pb_counter_max & ~push_button_state;
assign o_push_button_up = ~pb_idle & pb_counter_max & push_button_state;

endmodule
