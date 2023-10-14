`include "project_info.svh"

module project_info (
    output logic [`COMMIT_HASH_DEPTH - 1:0] o_commit_hash,
    output logic [`DEPTH - 1:0] o_major,
    output logic [`DEPTH - 1:0] o_minor,
    output logic [`DEPTH - 1:0] o_patch,
    output logic [`DEPTH - 1:0] o_build
);

logic [`COMMIT_HASH_DEPTH - 1:0] commit_hash = `COMMIT_HASH;
logic [`DEPTH - 1:0] major = `MAJOR;
logic [`DEPTH - 1:0] minor = `MINOR;
logic [`DEPTH - 1:0] patch = `PATCH;
logic [`DEPTH - 1:0] build = `BUILD;

assign o_commit_hash = commit_hash;
assign o_major = major;
assign o_minor = minor;
assign o_patch = patch;
assign o_build = build;
endmodule
