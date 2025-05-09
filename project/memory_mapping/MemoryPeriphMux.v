// megafunction wizard: %LPM_MUX%
// GENERATION: STANDARD
// VERSION: WM1.0
// MODULE: LPM_MUX 

// ============================================================
// File Name: MemoryPeriphMux.v
// Megafunction Name(s):
// 			LPM_MUX
//
// Simulation Library Files(s):
// 			lpm
// ============================================================
// ************************************************************
// THIS IS A WIZARD-GENERATED FILE. DO NOT EDIT THIS FILE!
//
// 23.1std.0 Build 991 11/28/2023 SC Lite Edition
// ************************************************************


//Copyright (C) 2023  Intel Corporation. All rights reserved.
//Your use of Intel Corporation's design tools, logic functions 
//and other software and tools, and any partner logic 
//functions, and any output files from any of the foregoing 
//(including device programming or simulation files), and any 
//associated documentation or information are expressly subject 
//to the terms and conditions of the Intel Program License 
//Subscription Agreement, the Intel Quartus Prime License Agreement,
//the Intel FPGA IP License Agreement, or other applicable license
//agreement, including, without limitation, that your use is for
//the sole purpose of programming logic devices manufactured by
//Intel and sold by Intel or its authorized distributors.  Please
//refer to the applicable agreement for further details, at
//https://fpgasoftware.intel.com/eula.


// synopsys translate_off
`timescale 1 ps / 1 ps
// synopsys translate_on
module MemoryPeriphMux (
	data0x,
	data1x,
	sel,
	result);

	input	[31:0]  data0x;
	input	[31:0]  data1x;
	input	  sel;
	output	[31:0]  result;

	wire [31:0] sub_wire5;
	wire [31:0] sub_wire2 = data1x[31:0];
	wire [31:0] sub_wire0 = data0x[31:0];
	wire [63:0] sub_wire1 = {sub_wire2, sub_wire0};
	wire  sub_wire3 = sel;
	wire  sub_wire4 = sub_wire3;
	wire [31:0] result = sub_wire5[31:0];

	lpm_mux	LPM_MUX_component (
				.data (sub_wire1),
				.sel (sub_wire4),
				.result (sub_wire5)
				// synopsys translate_off
				,
				.aclr (),
				.clken (),
				.clock ()
				// synopsys translate_on
				);
	defparam
		LPM_MUX_component.lpm_size = 2,
		LPM_MUX_component.lpm_type = "LPM_MUX",
		LPM_MUX_component.lpm_width = 32,
		LPM_MUX_component.lpm_widths = 1;


endmodule

// ============================================================
// CNX file retrieval info
// ============================================================
// Retrieval info: PRIVATE: INTENDED_DEVICE_FAMILY STRING "Cyclone IV E"
// Retrieval info: PRIVATE: SYNTH_WRAPPER_GEN_POSTFIX STRING "0"
// Retrieval info: PRIVATE: new_diagram STRING "1"
// Retrieval info: LIBRARY: lpm lpm.lpm_components.all
// Retrieval info: CONSTANT: LPM_SIZE NUMERIC "2"
// Retrieval info: CONSTANT: LPM_TYPE STRING "LPM_MUX"
// Retrieval info: CONSTANT: LPM_WIDTH NUMERIC "32"
// Retrieval info: CONSTANT: LPM_WIDTHS NUMERIC "1"
// Retrieval info: USED_PORT: data0x 0 0 32 0 INPUT NODEFVAL "data0x[31..0]"
// Retrieval info: USED_PORT: data1x 0 0 32 0 INPUT NODEFVAL "data1x[31..0]"
// Retrieval info: USED_PORT: result 0 0 32 0 OUTPUT NODEFVAL "result[31..0]"
// Retrieval info: USED_PORT: sel 0 0 0 0 INPUT NODEFVAL "sel"
// Retrieval info: CONNECT: @data 0 0 32 0 data0x 0 0 32 0
// Retrieval info: CONNECT: @data 0 0 32 32 data1x 0 0 32 0
// Retrieval info: CONNECT: @sel 0 0 1 0 sel 0 0 0 0
// Retrieval info: CONNECT: result 0 0 32 0 @result 0 0 32 0
// Retrieval info: GEN_FILE: TYPE_NORMAL MemoryPeriphMux.v TRUE
// Retrieval info: GEN_FILE: TYPE_NORMAL MemoryPeriphMux.inc FALSE
// Retrieval info: GEN_FILE: TYPE_NORMAL MemoryPeriphMux.cmp FALSE
// Retrieval info: GEN_FILE: TYPE_NORMAL MemoryPeriphMux.bsf TRUE
// Retrieval info: GEN_FILE: TYPE_NORMAL MemoryPeriphMux_inst.v FALSE
// Retrieval info: GEN_FILE: TYPE_NORMAL MemoryPeriphMux_bb.v TRUE
// Retrieval info: LIB_FILE: lpm
