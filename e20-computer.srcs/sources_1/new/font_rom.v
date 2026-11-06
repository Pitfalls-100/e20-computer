`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/21/2026 04:15:42 PM
// Design Name: 
// Module Name: font_rom
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
module font_rom (
    input  wire       clk,
    input  wire [7:0] asciiCode, // 8-bit ASCII character code
    input  wire [3:0] charRow,   // Row within character (0 to 15)
    output reg  [7:0] rowData    // 8-pixel slice for the requested row
);

    // 256 characters * 16 rows = 2048 bytes (Synthesizes into BRAM)
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
