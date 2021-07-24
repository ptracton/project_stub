//
// File Created At 2019-08-28 19:37:28.034161
// File Created By ptracton
// File Created On testbench
//

`CPU_WRITE_FILE_CONFIG(4, `WB_RAM1, `WB_RAM1+32'h00000100, `WB_RAM1, `WB_RAM1, `B_CONTROL_DATA_SIZE_WORD);

files_used = ((1<< 1) | 
              (1 << 2) | 
              (1 << 3)                                 
              );

`DAQ_WRITES_FILE(4, files_used[031:000]); //0x20002000
`DAQ_WRITES_FILE(4, files_used[063:032]); //0x20002004
`DAQ_WRITES_FILE(4, files_used[095:064]); //0x20002008
`DAQ_WRITES_FILE(4, files_used[127:096]); //0x2000200C 
`DAQ_WRITES_FILE(4, files_used[159:128]); //0x20002010
`DAQ_WRITES_FILE(4, files_used[191:160]); //0x20002014
`DAQ_WRITES_FILE(4, files_used[223:192]); //0x20002018
`DAQ_WRITES_FILE(4, files_used[255:224]); //0x2000201C
$display("Wrote Files Used 0x%h @ %d", files_used, $time);
  

// Node 1
//dtree_node[`F_DSP_DTREE_OUTPUT] = 0;
dtree_node[`F_DSP_DTREE_SENSOR_NODE] = 1;
dtree_node[`F_DSP_DTREE_LEAF] = 0;
`DAQ_WRITES_FILE(4, 32'h00000046);
`DAQ_WRITES_FILE(4, dtree_node);
`DAQ_WRITES_FILE(4, 0);
`DAQ_WRITES_FILE(4, ((16'h0030 << 16)| 16'h0040));  //0x2000202C,  node 1 and node 2

// Node 2
//dtree_node[`F_DSP_DTREE_OUTPUT] = 0;
dtree_node[`F_DSP_DTREE_SENSOR_NODE] = 2;
dtree_node[`F_DSP_DTREE_LEAF] = 0;
`DAQ_WRITES_FILE(4, 32'h00000019);
`DAQ_WRITES_FILE(4, dtree_node);
`DAQ_WRITES_FILE(4, 0);
`DAQ_WRITES_FILE(4, ((16'h0050 << 16)| 16'h0060));  // node 4 and node 5

// Node 3
//dtree_node[`F_DSP_DTREE_OUTPUT] = 0;
dtree_node[`F_DSP_DTREE_SENSOR_NODE] = 0;
dtree_node[`F_DSP_DTREE_LEAF] = 1;
`DAQ_WRITES_FILE(4, 32'h00000000);
`DAQ_WRITES_FILE(4, dtree_node);
`DAQ_WRITES_FILE(4, 0);
`DAQ_WRITES_FILE(4, ((16'h0070 << 16)| 16'h0080));  // node 6 and node 7

// Node 4
//dtree_node[`F_DSP_DTREE_OUTPUT] = 0;
dtree_node[`F_DSP_DTREE_SENSOR_NODE] = 3;
dtree_node[`F_DSP_DTREE_LEAF] = 0;
`DAQ_WRITES_FILE(4, 32'h00000003);
`DAQ_WRITES_FILE(4, dtree_node);
`DAQ_WRITES_FILE(4, 0);
`DAQ_WRITES_FILE(4, ((16'h0090 << 16)| 16'h00A0));  // node 8 and node 9

// Node 5
//dtree_node[`F_DSP_DTREE_OUTPUT] = 0;
dtree_node[`F_DSP_DTREE_SENSOR_NODE] = 0;
dtree_node[`F_DSP_DTREE_LEAF] = 0;
`DAQ_WRITES_FILE(4, 32'h0000003a);
`DAQ_WRITES_FILE(4, dtree_node);
`DAQ_WRITES_FILE(4, 0);
`DAQ_WRITES_FILE(4, ((16'h00B0 << 16)| 16'h00C0));  // node 10 and node 11

// Node 6
//dtree_node[`F_DSP_DTREE_OUTPUT] = 0;
dtree_node[`F_DSP_DTREE_SENSOR_NODE] = 0;
dtree_node[`F_DSP_DTREE_LEAF] = 1;
`DAQ_WRITES_FILE(4, 32'h00000000);
`DAQ_WRITES_FILE(4, dtree_node);
`DAQ_WRITES_FILE(4, 0);
`DAQ_WRITES_FILE(4, ((16'h00D0 << 16)| 16'h00E0));  // node 12 and node 13

// Node 7
//dtree_node[`F_DSP_DTREE_OUTPUT] = 0;
dtree_node[`F_DSP_DTREE_SENSOR_NODE] = 0;
dtree_node[`F_DSP_DTREE_LEAF] = 1;
`DAQ_WRITES_FILE(4, 32'h00000000);
`DAQ_WRITES_FILE(4, dtree_node);
`DAQ_WRITES_FILE(4, 0);
`DAQ_WRITES_FILE(4, ((16'h00F0 << 16)| 16'h0100));  // node 14 and node 15

// Node 8
//dtree_node[`F_DSP_DTREE_OUTPUT] = 0;
dtree_node[`F_DSP_DTREE_SENSOR_NODE] = 0;
dtree_node[`F_DSP_DTREE_LEAF] = 1;
`DAQ_WRITES_FILE(4, 32'h00000000);
`DAQ_WRITES_FILE(4, dtree_node);
`DAQ_WRITES_FILE(4, 0);
`DAQ_WRITES_FILE(4, 0);    // leaf node, no offsets

// Node 9
//dtree_node[`F_DSP_DTREE_OUTPUT] = 1;
dtree_node[`F_DSP_DTREE_SENSOR_NODE] = 0;
dtree_node[`F_DSP_DTREE_LEAF] = 1;
`DAQ_WRITES_FILE(4, 32'h00000000);
`DAQ_WRITES_FILE(4, dtree_node);
`DAQ_WRITES_FILE(4, 1);
`DAQ_WRITES_FILE(4, 0);    // leaf node, no offsets

// Node 10
//dtree_node[`F_DSP_DTREE_OUTPUT] = 1;
dtree_node[`F_DSP_DTREE_SENSOR_NODE] = 0;
dtree_node[`F_DSP_DTREE_LEAF] = 1;
`DAQ_WRITES_FILE(4, 32'h00000000);
`DAQ_WRITES_FILE(4, dtree_node);
`DAQ_WRITES_FILE(4, 1);
`DAQ_WRITES_FILE(4, 0);    // leaf node, no offsets

// Node 11
//dtree_node[`F_DSP_DTREE_OUTPUT] = 0;
dtree_node[`F_DSP_DTREE_SENSOR_NODE] = 0;
dtree_node[`F_DSP_DTREE_LEAF] = 1;
`DAQ_WRITES_FILE(4, 32'h00000000);
`DAQ_WRITES_FILE(4, dtree_node);
`DAQ_WRITES_FILE(4, 0);
`DAQ_WRITES_FILE(4, 0);    // leaf node, no offsets

// Node 12
//dtree_node[`F_DSP_DTREE_OUTPUT] = 0;
dtree_node[`F_DSP_DTREE_SENSOR_NODE] = 0;
dtree_node[`F_DSP_DTREE_LEAF] = 1;
`DAQ_WRITES_FILE(4, 32'h00000000);
`DAQ_WRITES_FILE(4, dtree_node);
`DAQ_WRITES_FILE(4, 0);
`DAQ_WRITES_FILE(4, 0);    // leaf node, no offsets

// Node 13
//dtree_node[`F_DSP_DTREE_OUTPUT] = 0;
dtree_node[`F_DSP_DTREE_SENSOR_NODE] = 0;
dtree_node[`F_DSP_DTREE_LEAF] = 1;
`DAQ_WRITES_FILE(4, 32'h00000000);
`DAQ_WRITES_FILE(4, dtree_node);
`DAQ_WRITES_FILE(4, 0);
`DAQ_WRITES_FILE(4, 0);    // leaf node, no offsets

// Node 14
//dtree_node[`F_DSP_DTREE_OUTPUT] = 0;
dtree_node[`F_DSP_DTREE_SENSOR_NODE] = 0;
dtree_node[`F_DSP_DTREE_LEAF] = 1;
`DAQ_WRITES_FILE(4, 32'h00000000);
`DAQ_WRITES_FILE(4, dtree_node);
`DAQ_WRITES_FILE(4, 0);
`DAQ_WRITES_FILE(4, 0);    // leaf node, no offsets

// Node 15
//dtree_node[`F_DSP_DTREE_OUTPUT] = 0;
dtree_node[`F_DSP_DTREE_SENSOR_NODE] = 0;
dtree_node[`F_DSP_DTREE_LEAF] = 1;
`DAQ_WRITES_FILE(4, 32'h00000000);
`DAQ_WRITES_FILE(4, dtree_node);
`DAQ_WRITES_FILE(4, 0);
`DAQ_WRITES_FILE(4, 0);    // leaf node, no offsets
