`define Enable_CLOCK2
`define Enable_CLOCK3
`define Enable_CLOCK4
`define Enable_CLOCK
`define Enable_DRAM
`define Enable_GPIO
`define Enable_HEX0
`define Enable_HEX1
`define Enable_HEX2
`define Enable_HEX3
`define Enable_HEX4
`define Enable_HEX5
`define Enable_KEY
`define Enable_LEDR
`define Enable_PS2
`define Enable_RESET
`define Enable_SD
`define Enable_SW
`define Enable_VGA

module top (

`ifdef Enable_CLOCK
      ///////// CLOCK  "3.3-V LVTTL" /////////
      input              CLOCK_50,
`endif
`ifdef Enable_CLOCK2
      ///////// CLOCK2 "3.3-V LVTTL" /////////
      input              CLOCK2_50,
`endif	  

`ifdef Enable_CLOCK3
      ///////// CLOCK3 "3.3-V LVTTL" /////////
      input              CLOCK3_50,
`endif

`ifdef Enable_CLOCK4
      ///////// CLOCK4  "3.3-V LVTTL"  /////////
      inout              CLOCK4_50,
`endif
`ifdef Enable_DRAM
      ///////// DRAM  "3.3-V LVTTL" /////////
      output      [12:0] DRAM_ADDR,
      output      [1:0]  DRAM_BA,
      output             DRAM_CAS_N,
      output             DRAM_CKE,
      output             DRAM_CLK,
      output             DRAM_CS_N,
      inout       [15:0] DRAM_DQ,
      output             DRAM_LDQM,
      output             DRAM_RAS_N,
      output             DRAM_UDQM,
      output             DRAM_WE_N,
`endif
`ifdef Enable_GPIO
      ///////// GPIO "3.3-V LVTTL" /////////
      inout       [35:0] GPIO_0,
      inout       [35:0] GPIO_1,
`endif
`ifdef Enable_HEX0
      ///////// HEX0  "3.3-V LVTTL" /////////
      output      [6:0]  HEX0,
`endif
`ifdef Enable_HEX1
      ///////// HEX1 "3.3-V LVTTL" /////////
      output      [6:0]  HEX1,
`endif
`ifdef Enable_HEX2
      ///////// HEX2 "3.3-V LVTTL" /////////
      output      [6:0]  HEX2,
`endif
`ifdef Enable_HEX3
      ///////// HEX3 "3.3-V LVTTL" /////////
      output      [6:0]  HEX3,
`endif
`ifdef Enable_HEX4
      ///////// HEX4 "3.3-V LVTTL" /////////
      output      [6:0]  HEX4,
`endif
`ifdef Enable_HEX5
      ///////// HEX5 "3.3-V LVTTL" /////////
      output      [6:0]  HEX5,
`endif
`ifdef Enable_KEY
      ///////// KEY  "3.3-V LVTTL" /////////
      input       [3:0]  KEY,
`endif
`ifdef Enable_LEDR
      ///////// LEDR /////////
      output      [9:0]  LEDR,
`endif
`ifdef Enable_PS2
      ///////// PS2 "3.3-V LVTTL" /////////
      inout              PS2_CLK,
      inout              PS2_CLK2,
      inout              PS2_DAT,
      inout              PS2_DAT2,
`endif
`ifdef Enable_RESET
      ///////// RESET "3.3-V LVTTL" /////////
      input              RESET_N,
`endif
`ifdef Enable_SD
      ///////// SD "3.3-V LVTTL" /////////
      output             SD_CLK,
      inout              SD_CMD,
      inout       [3:0]  SD_DATA,
`endif
`ifdef Enable_SW
      ///////// SW "3.3-V LVTTL"/////////
      input       [9:0]  SW,
`endif
`ifdef Enable_VGA
      ///////// VGA  "3.3-V LVTTL" /////////
      output      [3:0]  VGA_B,
      output      [3:0]  VGA_G,
      output             VGA_HS,
      output      [3:0]  VGA_R,
      output             VGA_VS
`endif	 
);

wire [6:0] hex [5:0];
assign HEX0 = hex[0];
assign HEX1 = hex[1];
assign HEX2 = hex[2];
assign HEX3 = hex[3];
assign HEX4 = hex[4];
assign HEX5 = hex[5];

wrapper wrapper_inst
(
    .i_clock(CLOCK_50),
    .i_reset_n(RESET_N),
    .i_key(KEY),
    .i_switch(SW),
    .o_hex(hex),
    .o_led(LEDR)
);

endmodule
