`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/24/2026 03:31:40 PM
// Design Name: 
// Module Name: char_bufr
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


module char_bufr #(
    // Number of columns from the VESA standard
    parameter COL_NUM = 80,
    
    // Number of rows from the VESA standard
    parameter ROW_NUM = 30,
    
    // Size of character ram (buffer) also equal to
    // the maximum number of characters that can be
    // displayed on the screen
    parameter RAM_SIZE = 2400,
    
    // Bit-width needed to represent the columns in
    // the character buffer
    parameter COL_BIT_WIDTH = 7,
    
    // Bit-width needed to represent the rows
    parameter ROW_BIT_WIDTH = 5,
    
    // Bit-width needed to represent the RAM address
    // (or the particular character number on screen)
    parameter RAM_BIT_WIDTH = 12
)(
    input                            clk,
    input                            reset,
    input [7:0]                      ASCII_code_in,
    input                            read_en, write_en,
    input [RAM_BIT_WIDTH - 1:0]      read_addr,
    output reg [7:0]                 ASCII_code_out,
    output [COL_BIT_WIDTH - 1:0]     column,
    output [ROW_BIT_WIDTH - 1:0]     row
    );
    
    reg [7:0] ram [0:RAM_SIZE - 1];
    
    reg [COL_BIT_WIDTH - 1:0] ram_column = 0;
    reg [ROW_BIT_WIDTH - 1:0] ram_row = 0;
    wire [RAM_BIT_WIDTH - 1:0] ram_write_addr;
    
    /*
    
        RAM initialization (Naz's design dynamically initializes
        the buffer with spaces one pixel position at a time), but
        to optimize the design for my board I need to use BRAM to
        save resources, but implementing Naz's design directly
        prevents BRAM inference...(which is unfortunate since I
        quite like Naz's organization of the buffer logic)
        
    */
    integer ind;
    // The following block will only run once during
    // the FPGA's initialization process (bitstream
    // generation or power on)
    initial begin
        for (ind = 0; ind < RAM_SIZE; ind = ind + 1) begin
            ram[ind] = " ";
        end
    end
    
    always @(posedge clk) begin
        if (reset) begin
            ram_row <= 0;
            ram_column <= 0;
        end
        
        else begin
            if (write_en) begin
                // ASCII 0x08 = BACKSPACE
                if (ASCII_code_in == 8'h08) begin
                    /*
                    
                        Overwrite current address with whitespace
                       (must ensure the cursor is not at (0,0) because
                       the user can't be trusted...)
                    
                    */
                    
                    if (ram_column > 0) begin
                        // Move cursor to previous character
                        ram[ram_write_addr - 1] <= " ";
                        ram_column <= ram_column - 1;
                        ram_row <= ram_row;
                    end
                    
                    else begin
                        if (ram_row > 0) begin
                            /*
                            
                                Currently on the start of a new
                                line, need to move the cursor up 
                                one and to the end of the prevous
                                line...
                            */
                            ram[ram_write_addr - 1] <= " ";
                            ram_row <= ram_row - 1;
                            ram_column <= COL_NUM - 1;
                        end
                    end
                end
                
                else if (ASCII_code_in == 8'h0d) begin
                    // ASCII 0x0D = ENTER (Carrige Return)
                    ram[ram_write_addr] <= ASCII_code_in;
                        
                    if (ram_row < ROW_NUM - 1) begin
                        // Go to the start of a new line (row)
                        ram_column <= 0;
                        ram_row <= ram_row + 1;
                    end
                end
                        
                else begin
                    // Any other (printable) character
                    ram[ram_write_addr] <= ASCII_code_in;
                            
                    if (ram_column < COL_NUM - 1) begin
                        // Increment cursor to next empty space
                        ram_column <= ram_column + 1;
                        ram_row <= ram_row;
                    end
                            
                    else begin
                        if (ram_row < ROW_NUM - 1) begin
                            ram_column <= 0;
                            ram_row <= ram_row + 1;
                        end
                    end 
                end
            end
                    
        end
    end
    
    // Had to seperate this from the previous procedural block
    // because it wouldn't synthesize, deviating from Naz's desgin...  
    always @(posedge clk) begin
        if (read_en) begin
            ASCII_code_out <= ram[read_addr];
        end
    end
    
    assign ram_write_addr = ram_column + (ram_row * COL_NUM);
    assign column = ram_column;
    assign row = ram_row;
    
endmodule