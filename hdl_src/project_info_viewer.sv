module project_info_viewer
#(
    parameter NUM_HEX = 6    
) (
    input logic i_clock,
    input logic i_reset,
    input logic i_enable,
    input logic i_change,
    output logic [3:0] o_hex [NUM_HEX - 1:0]
);

logic [3:0] hex [NUM_HEX - 1:0];
genvar i;
generate
    for (i = 0; i < NUM_HEX; i++) begin : generate_assign_hex
        assign o_hex[i] = i_enable ? hex[i] : 'h0;
    end
endgenerate

logic [160 - 1:0] commit_hash;
logic [7:0] major;
logic [7:0] minor;
logic [7:0] patch;
logic [7:0] build;

project_info project_info_inst (
    .o_commit_hash(commit_hash),
    .o_major(major),
    .o_minor(minor),
    .o_patch(patch),
    .o_build(build)
);

logic [1:0] state;
parameter s0 = 0, s1 = 1, s2 = 2, s3 = 3;

always @(state) begin
    case (state)
        s0: begin
            hex[0] = commit_hash[139:136];
            hex[1] = commit_hash[143:140];
            hex[2] = commit_hash[147:144];
            hex[3] = commit_hash[151:148];
            hex[4] = commit_hash[155:152];
            hex[5] = commit_hash[159:156];
        end
        
        s1: begin
            hex[0] = patch[3:0];
            hex[1] = patch[7:4];
            hex[2] = minor[3:0];
            hex[3] = minor[7:4];
            hex[4] = major[3:0];
            hex[5] = major[7:4];
        end
        
        s2: begin
            hex[0] = build[3:0];
            hex[1] = build[7:4];
            hex[2] = 4'h0;
            hex[3] = 4'h0;
            hex[4] = 4'h0;
            hex[5] = 4'h0;
        end

        s3: begin
            hex[0] = 4'h0;
            hex[1] = 4'h0;
            hex[2] = 4'h0;
            hex[3] = 4'h0;
            hex[4] = 4'h0;
            hex[5] = 4'h0;
        end

        default: begin
            hex[0] = 4'h0;
            hex[1] = 4'h0;
            hex[2] = 4'h0;
            hex[3] = 4'h0;
            hex[4] = 4'h0;
            hex[5] = 4'h0;
        end
    endcase
end

always @(posedge i_clock, posedge i_reset) begin
    if (i_reset)
        state <= s0;
    else
        case (state)
            s0:
                if (i_change)
                    state <= s1;
                else
                    state <= s0;
            s1:
                if (i_change)
                    state <= s2;
                else
                    state <= s1;
            s2:
                if (i_change)
                    state <= s3;
                else
                    state <= s2;
            s3:
                if (i_change)
                    state <= s0;
                else
                    state <= s3;
        endcase
end

endmodule
