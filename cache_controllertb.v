`timescale 1ns / 1ps

//////////////////////////////////////////////////////////////////////////////////

// Company:

// Engineer:

//

// Create Date: 21.02.2023 21:46:13

// Design Name:

// Module Name: cache_tb

// Project Name:

// Target Devices:

// Tool Versions:

// Description:

//

// Dependencies:

//

// Revision:

// Revision 0.01 - File Created

// Additional Comments:

//

//////////////////////////////////////////////////////////////////////////////////

 

 

module cache_controller_tb;

 

reg clock;

reg rst;

reg [31:0] CPU_ADDRESS;

reg [64:0] CPU_DATAIN;

wire [64:0] CPU_DATAOUT;

reg cpu_rw; //1=write, 0=read

reg cpu_val;

wire cache_ready;
 

wire [31:0] MEM_ADDRESS;

reg [64:0] MEM_DATAIN;

wire [64:0] MEM_DATAOUT;

wire mem_rw;

wire mem_val;

reg mem_ready;

 

cache_controller dut (

    .clock        (clock),

    .rst             (rst),

    .CPU_ADDRESS      (CPU_ADDRESS), 

    .CPU_DATAIN    (CPU_DATAIN),

    .CPU_DATAOUT   (CPU_DATAOUT),

    .cpu_rw        (cpu_rw),

    .cpu_val     (cpu_val),

    .cache_ready       (cache_ready),  

    .MEM_ADDRESS     (MEM_ADDRESS), 

    .MEM_DATAIN    (MEM_DATAIN),

    .MEM_DATAOUT   (MEM_DATAOUT),

    .mem_rw        (mem_rw),

    .mem_val     (mem_val),

    .mem_ready     (mem_ready)

               );

              

always #5 clock = ~clock;

always #200 rst=~rst;

task reset_values ();

begin

  clock = 1'b1; rst = 1'b0;

  CPU_ADDRESS = 32'd0; CPU_DATAIN = 64'd0; cpu_rw = 1'b0; cpu_val = 1'b0;

  MEM_DATAIN = 64'd0; mem_ready = 1'b1;

 

end

endtask

 

task write_cpu (input [31:0]addr, input [64:0]data);

begin

  #20 CPU_ADDRESS = addr; cpu_rw = 1'b1; cpu_val = 1'b1; CPU_DATAIN = data; //write to cache (AB)

  #10 CPU_ADDRESS = 32'd0; cpu_rw = 1'b0; cpu_val = 1'b0; CPU_DATAIN = 64'd0;

end

endtask

 

task read_cpu (input [31:0]addr);

begin

  #20 CPU_ADDRESS = addr; cpu_rw = 1'b0; cpu_val = 1'b1; 

  #10 CPU_ADDRESS = 32'd0; cpu_rw = 1'b0; cpu_val = 1'b0;

end

endtask

 

initial begin

  reset_values();

  write_cpu (64'hB00,64'h122);  //write

  read_cpu  (32'hAB00);                     //read hit (same tag, same index)

  read_cpu  (32'hBB00);                     //read miss, clean (same tag, diff index)

  @(negedge mem_val) mem_ready = 1'b0;

  #20 MEM_DATAIN = 64'h344; mem_ready = 1'b1; 

 

  read_cpu  (32'hEB00);                     //read miss, dirty (diff tag, same index)

  @(negedge mem_val) mem_ready = 1'b0;

  #20 mem_ready = 1'b1;

  @(negedge mem_val) mem_ready = 1'b0;

  #30 MEM_DATAIN = 64'h66; mem_ready = 1'b1;

end

endmodule
