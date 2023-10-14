module blinker (
    input i_clk,
    input i_rst,
    input i_arst,
    input i_en,
    output o_led
);

reg [26:0] counter;

always @ (posedge i_clk or posedge i_arst)
    if (i_arst) begin
        counter <= 26'h0;
    end
    else if (i_rst) begin
        counter <= 26'h0;
    end
    else begin
        if (i_en) begin
            counter <= counter + 1'b1;
        end
    end

assign o_led = counter[26];

endmodule
