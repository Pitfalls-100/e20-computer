`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: ...
// Engineer: Pitfalls100
// 
// Create Date: 10/21/2026 04:16:12 PM
// Design Name: 
// Module Name: vga_ctrl
// Project Name: e20-computer
// Target Devices: Basys3
// Tool Versions: Vivado 2026.1
// Description: A VGA Adapter (signal generator) for the E20 computer.
// 
// Dependencies: None?
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments: This file is based on NazaninAzhdari's VGAsync.vhd
// 
//////////////////////////////////////////////////////////////////////////////////


module vga_ctrl(
    input       clk_25MHz,
    input       reset,
    output[9:0] pixel_x, pixel_y,
    output      video_on, vsync, hsync 
    );
    
    // Vesa Specification Constants
    
    // Horizontal Sync Components
    localparam h_active_video = 10'b1010000000; // 640
    localparam h_front_porch = 5'b10010; // 18
    localparam h_pulse = 7'b1011100; // 92
    localparam h_back_porch = 6'b110010; // 50
    localparam h_total_timing = h_active_video + h_front_porch + h_back_porch + h_pulse;
    
    // Vertical Sync Components
    localparam v_active_video = 9'b111100000; // 480
    localparam v_front_porch = 4'b1010; // 10
    localparam v_pulse = 2'b10; // 2
    localparam v_back_porch = 6'b100001; // 33
    localparam v_total_timing = v_active_video + v_front_porch + v_back_porch + v_pulse;
    
    reg [9:0] pixel_x_pos = 10'b0;
    reg [9:0] pixel_y_pos = 10'b0;
    
    // VGA Pixel Generation Logic
    always @(posedge clk_25MHz) begin
        if (reset) begin
            pixel_x_pos <= 1'b0;
            pixel_y_pos <= 1'b0;
        end
        
        else begin
            if (pixel_x_pos == h_total_timing - 1) begin
                // The pixel's horizontal position needs to
                // be reset
                pixel_x_pos <= 0;
                
                if (pixel_y_pos == v_total_timing - 1) begin
                    // The pixel's vertical position needs to be
                    // reset
                    pixel_y_pos <= 0;
                end
                
                else begin
                    // Otherwise increment to next VGA column
                    pixel_y_pos <= pixel_y_pos + 1;
                end
            end
            
            else begin
                // Otherwise increment to next VGA row
                pixel_x_pos <= pixel_x_pos + 1;
            end
        end
    end
    
    // Output Signal Intermediate Declerations
    wire video_subcondition1a = (pixel_x_pos == h_active_video - 1);
    wire video_subcondition1b = (pixel_x_pos < h_active_video - 1);
    wire video_subcondition2a = (pixel_y_pos == v_active_video - 1);
    wire video_subcondition2b = (pixel_y_pos < v_active_video - 1);
    wire video_condition1 = video_subcondition1a || video_subcondition1b;
    wire video_condition2 = video_subcondition2a || video_subcondition2b;
    
    wire hsync_subcondition1a = (pixel_x_pos == (h_active_video + h_front_porch));
    wire hsync_subcondition1b = (pixel_x_pos > (h_active_video + h_front_porch));
    wire hsync_condition1 = hsync_subcondition1a || hsync_subcondition1b;
    wire hsync_condition2 = (pixel_x_pos < (h_total_timing - h_back_porch));
    
    wire vsync_subcondition1a = (pixel_y_pos == (v_active_video + v_front_porch));
    wire vsync_subcondition1b = (pixel_y_pos > (v_active_video + v_front_porch));
    wire vsync_condition1 = vsync_subcondition1a || vsync_subcondition1b;
    wire vsync_condition2 = (pixel_y_pos < (v_total_timing - v_back_porch));
    
    // Actually assigning VGA output signals
    assign video_on = video_condition1 && video_condition2;
    assign hsync = !(hsync_condition1 && hsync_condition2);
    assign vsync = !(vsync_condition1 && vsync_condition2);
    assign pixel_x = pixel_x_pos;
    assign pixel_y = pixel_y_pos;
    
endmodule