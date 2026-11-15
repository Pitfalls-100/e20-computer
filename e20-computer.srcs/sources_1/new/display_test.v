`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Pitfalls-100
// 
// Create Date: 11/15/2026 06:17:36 PM
// Design Name: 
// Module Name: display_test
// Project Name: e20-computer
// Target Devices: Basys3
// Tool Versions: Vivado 2026.1
// Description: A "robust" (in my opinion) test of the  "VGA display" subsystem of
//              this project that connects each display submodule and tests each
//              aspect of text rendering (e.g. newlines, corners,
//              edge of the screen, and cursor generation)
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments: This is a temporary module that will eventually be replaced
//                      as the project grows in scope/completion (essentially, it
//                      will go from a top-level module that tests the current
//                      subsystem to just another submodule in the larger project's
//                      final top module)
// 
//////////////////////////////////////////////////////////////////////////////////
`timescale 1ns / 1ps

module display_test;
    reg clk25MHz = 0;
    reg reset    = 1;

    // 25 MHz clock (40 ns period)
    always #20 clk25MHz = ~clk25MHz;

    // Interconnects
    wire [9:0]  pixel_x, pixel_y;
    wire        video_on, hsync, vsync;
    wire [12:0] char_addr;
    reg  [7:0]  char_data;
    wire [3:0]  vga_red, vga_green, vga_blue;
    wire        hsync_out, vsync_out;

    // Cursor test controls (place cursor over cell (1, 0))
    reg [6:0] cursor_col = 7'd1;
    reg [5:0] cursor_row = 6'd0;
    reg       cursor_en  = 1'b1;

    // Mock 80x60 Character Buffer (1-cycle synchronous read)
    reg [7:0] text_ram [0:4799];
    always @(posedge clk25MHz) begin
        char_data <= text_ram[char_addr];
    end

    // Instantiate DUTs
    vga_ctrl sync_gen (
        .clk_25MHz (clk25MHz),
        .reset     (reset),
        .pixel_x   (pixel_x),
        .pixel_y   (pixel_y),
        .video_on  (video_on),
        .vsync     (vsync),
        .hsync     (hsync)
    );

    vga_renderer eyoyo_screen (
        .clk25MHz   (clk25MHz),
        .reset      (reset),
        .pixel_x    (pixel_x),
        .pixel_y    (pixel_y),
        .video_on   (video_on),
        .hsync      (hsync),
        .vsync      (vsync),
        .char_data  (char_data),
        .cursor_col (cursor_col),
        .cursor_row (cursor_row),
        .cursor_en  (cursor_en),
        .char_addr  (char_addr),
        .vga_red    (vga_red),
        .vga_green  (vga_green),
        .vga_blue   (vga_blue),
        .hsync_out  (hsync_out),
        .vsync_out  (vsync_out)
    );
    
    reg [7:0] ref_font [0:2047];
    integer i;

    initial begin
        for (i = 0; i < 2048; i = i + 1) ref_font[i] = 8'h00;
        $readmemb("font_bitmaps.mem", ref_font);

        for (i = 0; i < 4800; i = i + 1) text_ram[i] = 8'h20; // Fill with SPACE

        // Top-left banner ("E20" -> '2' at (1,0) will be inverted by cursor)
        text_ram[0] = "E";
        text_ram[1] = "2";
        text_ram[2] = "0";

        // Screen corner & line-wrap checks (asymmetric glyphs)
        text_ram[79]   = "L"; // Top-right: (col 79, row 0)
        text_ram[159]  = "R"; // End of row 1: (col 79, row 1)
        text_ram[160]  = "Q"; // Start of row 2: (col 0, row 2)
        text_ram[4720] = "A"; // Bottom-left: (col 0, row 59)
        text_ram[4799] = "Z"; // Bottom-right: (col 79, row 59)

        // Hold reset for 5 clocks, then release
        repeat (5) @(posedge clk25MHz);
        reset <= 1'b0;
    end
    
    reg [9:0] x_d1, x_d2, y_d1, y_d2;
    reg [1:0] von_sr;

    always @(posedge clk25MHz) begin
        if (reset) begin
            x_d1 <= 0; x_d2 <= 0;
            y_d1 <= 0; y_d2 <= 0;
            von_sr <= 2'b00;
        end else begin
            x_d1 <= pixel_x; x_d2 <= x_d1;
            y_d1 <= pixel_y; y_d2 <= y_d1;
            von_sr <= {von_sr[0], video_on};
        end
    end

    // Golden pixel calculation at Stage T2
    wire [12:0] exp_addr   = (y_d2[8:3] * 80) + x_d2[9:3];
    wire [7:0]  exp_ascii  = text_ram[exp_addr];
    wire [7:0]  exp_row    = ref_font[{exp_ascii, y_d2[2:0]}];
    wire        exp_glyph  = exp_row[~x_d2[2:0]];
    wire        exp_cursor = cursor_en && (x_d2[9:3] == cursor_col) && (y_d2[8:3] == cursor_row);
    wire [11:0] exp_rgb    = (von_sr[1] && (exp_glyph ^ exp_cursor)) ? 12'h0F0 : 12'h000;

    integer hsync_low_cnt = 0;
    integer vsync_low_cnt = 0;

    always @(posedge clk25MHz) begin
        if (!reset) begin
            // 1. Pixel-accurate golden match & blanking guard
            if ({vga_red, vga_green, vga_blue} !== exp_rgb) begin
                $display("ERROR at t=%0t (x=%0d, y=%0d): got RGB=%h, expected=%h",
                         $time, x_d2, y_d2, {vga_red, vga_green, vga_blue}, exp_rgb);
                $stop;
            end

            // 2. HSYNC pulse width check (must equal 92 clocks)
            if (!hsync_out) begin
                hsync_low_cnt <= hsync_low_cnt + 1;
            end else if (hsync_low_cnt != 0) begin
                if (hsync_low_cnt != 92) begin
                    $display("ERROR: hsync_out width = %0d (expected 92)", hsync_low_cnt);
                    $stop;
                end
                hsync_low_cnt <= 0;
            end

            // 3. VSYNC pulse width check (must equal 2 * 800 = 1600 clocks)
            if (!vsync_out) begin
                vsync_low_cnt <= vsync_low_cnt + 1;
            end else if (vsync_low_cnt != 0) begin
                if (vsync_low_cnt != 1600) begin
                    $display("ERROR: vsync_out width = %0d (expected 1600)", vsync_low_cnt);
                    $stop;
                end
                vsync_low_cnt <= 0;
            end
        end
    end
    
    integer ppm_fd;
    integer total_clocks = 0;

    initial begin
        ppm_fd = $fopen("vga_frame.ppm", "w");
        $fwrite(ppm_fd, "P3\n640 480\n15\n");

        @(negedge reset);
        // Wait until the pipeline outputs pixel (0, 0)
        wait (!reset && von_sr[1] && (x_d2 == 10'd0) && (y_d2 == 10'd0));

        // Run for 1 full frame (800 * 525 = 420,000 clocks)
        while (total_clocks < 420000) begin
            @(posedge clk25MHz);
            if (von_sr[1]) begin
                $fwrite(ppm_fd, "%0d %0d %0d\n", vga_red, vga_green, vga_blue);
            end
            total_clocks = total_clocks + 1;
        end

        $fclose(ppm_fd);
        $display("SUCCESS: Frame 1 verified and saved to vga_frame.ppm");
        $finish;
    end
endmodule