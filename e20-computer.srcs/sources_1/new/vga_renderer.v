`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Pitfalls-100
// 
// Create Date: 11/15/2026 02:48:45 PM
// Design Name: 
// Module Name: vga_renderer
// Project Name: e20-computer
// Target Devices: Basys3
// Tool Versions: Vivado 2026.1
// Description: A VGA text render that relies on the VGA synchronization and ROM
//              submodules to display text in the viewport of the Eyoyo Monitor
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments: This top-level module will be replaced as the top-level
//                      module as the design grows through its iterative versions
// 
//////////////////////////////////////////////////////////////////////////////////


module vga_renderer(
    // Needed by submodules
    input clk25MHz,
    input reset,
    // Needed by sync_gen (the VGA controller)
    input [9:0] pixel_x, pixel_y,
    input video_on, hsync, vsync,
    // Provided by viewport (the character buffer) 
    input [7:0] char_data,
    // Needed by editor_core.v (soon to come...)
    input [6:0] cursor_col,
    input [5:0] cursor_row,
    input cursor_en,
    // Sent to the viewport
    output [12:0] char_addr,
    // Produced by sync_gen and used to display the viewport
    output [3:0] vga_red, vga_green, vga_blue,
    // Delay adjusted synchronizations
    output hsync_out, vsync_out
    );
    
    /*
    
        Extracting pixel data for rendering from pixel "coordinates"
            
            * Note that the glyph ostensibly referrs to the cursor,
              for a more visual explaination of what that means,
              see "The Screen Grid" section of Naz's README.md
            
            - The 7 MSB of pixel_x are the current column number (0 - 80)
            - The 3 LSB of pixel_x are the x pos of the glyph
            
            - The 7 MSB of pixel_y are the current row number (0 - 60)
            - The 3 LSB of pixel_y are the y pos of the glyph
    
    */
    wire [6:0] col = pixel_x[9:3];
    wire [2:0] glyph_x = pixel_x[2:0];
    wire [5:0] row = pixel_y[8:3];
    wire [2:0] glyph_y = pixel_y[2:0];
    
    assign char_addr = (row << 6) + (row << 4) + col;
    
    // Setting up sync_gen delay to account for BRAM timing
    reg [1:0] delay_video, delay_hsync, delay_vsync; 
    
    always @(posedge clk25MHz) begin
        // Delay state initialization
        if (reset) begin
            delay_video = 2'b00;
            delay_hsync = 2'b11;
            delay_vsync = 2'b11;
        end
        
        // Delaying addressable video and synchronization pulses
        else begin
            delay_video <= { delay_video[0], video_on };
            delay_hsync <= { delay_hsync[0], hsync };
            delay_vsync <= { delay_vsync[0], vsync };
        end
    end
    
    
    // Setting up text processing delay pipeline
    reg [2:0] glyph_x_delay_1, glyph_x_delay_2;
    reg [2:0] glyph_y_delay;
    reg [5:0] row_delay_1, row_delay_2;
    reg [6:0] col_delay_1, col_delay_2;
    
    always @(posedge clk25MHz) begin
        // Initialize all pipeline shift (delay) registers
        // to zero (to avoid X propagation)
        if (reset) begin
            glyph_x_delay_1 <= 3'd0;
            glyph_y_delay <= 3'd0;
            row_delay_1 <= 6'd0;
            col_delay_1 <= 7'd0;
            
            glyph_x_delay_2 <= 3'd0;
            row_delay_2 <= 6'd0;
            col_delay_2 <= 7'd0;
        end
        
        else begin
            /*
            
            Concatenation is not used here (even though it was earlier)
            because discrete shift registers are easier for me to reason
            about (which is also why this procedural block is separate
            from the sync_gen one...because they use "different" timing
            delay approaches)
            
            */
            
            glyph_x_delay_1 <= glyph_x;
            glyph_x_delay_2 <= glyph_x_delay_1;
            
            glyph_y_delay <= glyph_y;
            
            row_delay_1 <= row;
            row_delay_2 <= row_delay_1;
            
            col_delay_1 <= col;
            col_delay_2 <= col_delay_1;
            
        end
    end
    
    wire [7:0] row_data;
    
    // Font ROM initialization
    font_rom ROM ( .clk(clk25MHz), .asciiCode(char_data), .charRow(glyph_y_delay), .rowData(row_data) );
    
    // Mapping the cursor to the pixel coordinates
    wire glyph_bit, cursor_match, pixel_on;
    
    /*
        
            Need to use the stage 2 data from the pipeline so that all
            of the text data (i.e. the ASCII code, character bitmap, and
            display position are ready to use)
            
       */
       
       // Cursor detection logic
       assign glyph_bit = row_data[~glyph_x_delay_2];
       assign cursor_match = cursor_en && (col_delay_2 == cursor_col) && (row_delay_2 == cursor_row);
       
       // Color control
       assign pixel_on = glyph_bit ^ cursor_match;
       
       // sync_gen
       assign { vga_red, vga_green, vga_blue } = (delay_video[1] && pixel_on) ? 12'h0F0 : 12'h000;
       assign hsync_out = delay_hsync[1];
       assign vsync_out = delay_vsync[1];


endmodule
