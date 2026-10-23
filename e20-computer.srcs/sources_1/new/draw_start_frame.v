`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/22/2026 08:50:39 PM
// Design Name: 
// Module Name: draw_start_frame
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


module draw_start_frame(
    input clk,
    input reset,
    input [9:0] x, y,
    output reg draw_start_frame
    );
    
    always @(posedge clk) begin
        if (reset) begin
            draw_start_frame <= 0;
        end
        
        else begin
            // This is going to be quite long
            
            /*
            
                Essentially, to draw the start frame requires
                drawing each character to the screen individually
                (which itself entails having the drawing moddule
                color the pixels of the screen using each ASCII
                character's bitmap representation from the font rom...)
           
            */
        end
    end
    
endmodule
