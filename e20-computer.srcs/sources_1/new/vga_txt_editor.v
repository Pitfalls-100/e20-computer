`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/27/2026 03:14:24 PM
// Design Name: 
// Module Name: vga_txt_editor
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


module vga_txt_editor(
    input clk,
    input startL
    );
    
    reg [2:0] frame = 0; // state
    reg [2:0] combinationalLogic; // nextState
    reg draw;
    
    // VGA display frame FSM
    always @(posedge clk) begin
        case (frame)
        // Start frame
        3'b000: begin
            draw = { {6{"\n"}},
                     {34{" "}}, "Hello World!\n",
                     {36{" "}}, "Welcome to\n",
                     {32{" "}}, "the E20 Computer!"};
        end
        
        // Menu frame
        3'b001: begin
            draw = { "The sole purpose of this computer is to\n", 
                     "encode and execute valid user provided E20\n",
                     "assembly programs. To use this computer\n",
                     "use the navagation guide below...\n\n\n\n",
                     "0: Edit source\n",
                     "1: Assemble source\n",
                     "2: Run source\n",
                     "3: Cache log (coming soon...)"};
        end
        
        // Source frame
        3'b010: begin
            // Will be implemented after the microSD is integrated
        end
        
        // ASM frame
        3'b100: begin
            // Will be implemented after the resident assembler is integrated
        end
        
        // CPU frame
        3'b101: begin
            // Will be implemented after the single-cycle cpu is integerated
        end
        endcase
    end
    
    char_bufr txtRam();
    font_rom txtRom();
    vga_ctrl vgaAdapter();
    
endmodule
