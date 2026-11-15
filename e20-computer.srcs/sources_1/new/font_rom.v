`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Pitfalls-100
// 
// Create Date: 10/21/2026 04:15:42 PM
// Design Name: 
// Module Name: font_rom
// Project Name: e20-computer
// Target Devices: Basys3
// Tool Versions: Vivado 2026.1
// Description: A ROM that positionally stores the rows of each bitmap contigously to be fetched by the VGA render.
// 
// Dependencies: font_bitmaps.mem
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments: This file (as well as font_bitmaps.mem) are an attempt at
//                      porting NazaninAzhdrai's draw_characters.v
// 
//////////////////////////////////////////////////////////////////////////////////
module font_rom (
    input  wire       clk,
    input  wire [7:0] asciiCode, // 8-bit ASCII character code
    input  wire [2:0] charRow,   // Row within character (0 to 15)
    output reg  [7:0] rowData    // 8-pixel slice for the requested row
);

    // 256 supported characters * 8 rows = 2048 bytes (Synthesizes into BRAM)
    (* ram_style = "block" *) reg [7:0] rom [0:2047];
    
    integer i;
    initial begin
        for (i = 0; i < 2048; i = i + 1) begin
            rom[i] = 8'h00; // Initializes all entries to zero
        end
        
        /*
        
            Reading valid bitmap definitions into font rom
            the directives above each bitmap handles where
            bitmap bytes are placed into rom (the rows of
            a bitmap will be placed adjacently into rom)...
            
        */
        $readmemb("font_bitmaps.mem", rom);
    end

    // Fetch the 8-bit row slice synchronously
    always @(posedge clk) begin
        rowData <= rom[{asciiCode, charRow}];
    end 

endmodule
