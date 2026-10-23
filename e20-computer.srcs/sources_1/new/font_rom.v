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
    input  wire [7:0] ascii_code, // 8-bit ASCII character code
    input  wire [3:0] char_row,   // Row within character (0 to 15)
    output reg  [7:0] row_data    // 8-pixel slice for the requested row
);

    // 256 characters * 16 rows = 2048 bytes (Synthesizes into BRAM)
    reg [7:0] rom [0:2047];

    integer i;
    initial begin
        // Default all characters to empty space (0x00)
        for (i = 0; i < 2048; i = i + 1) begin
            rom[i] = 8'h00;
        end

        // --- PUNCTUATION & SYMBOLS ---
        // '!' (0x21)
        rom[12'h212] = 8'h18; rom[12'h213] = 8'h18; rom[12'h214] = 8'h18;
        rom[12'h215] = 8'h18; rom[12'h216] = 8'h18; rom[12'h217] = 8'h18;
        rom[12'h218] = 8'h18; rom[12'h21B] = 8'h18; rom[12'h21C] = 8'h18;

        // '"' (0x22)
        rom[12'h222] = 8'h66; rom[12'h223] = 8'h66; rom[12'h224] = 8'h66; rom[12'h225] = 8'h24;

        // ''' (0x27)
        rom[12'h272] = 8'h18; rom[12'h273] = 8'h18; rom[12'h274] = 8'h08; rom[12'h275] = 8'h10;

        // '(' (0x28)
        rom[12'h282] = 8'h0C; rom[12'h283] = 8'h18; rom[12'h284] = 8'h30;
        rom[12'h285] = 8'h30; rom[12'h286] = 8'h30; rom[12'h287] = 8'h30;
        rom[12'h288] = 8'h30; rom[12'h289] = 8'h30; rom[12'h28A] = 8'h30;
        rom[12'h28B] = 8'h30; rom[12'h28C] = 8'h18; rom[12'h28D] = 8'h0C;

        // ')' (0x29)
        rom[12'h292] = 8'h30; rom[12'h293] = 8'h18; rom[12'h294] = 8'h0C;
        rom[12'h295] = 8'h0C; rom[12'h296] = 8'h0C; rom[12'h297] = 8'h0C;
        rom[12'h298] = 8'h0C; rom[12'h299] = 8'h0C; rom[12'h29A] = 8'h0C;
        rom[12'h29B] = 8'h0C; rom[12'h29C] = 8'h18; rom[12'h29D] = 8'h30;

        // ',' (0x2C)
        rom[12'h2CB] = 8'h18; rom[12'h2CC] = 8'h18; rom[12'h2CD] = 8'h08; rom[12'h2CE] = 8'h10;

        // '-' (0x2D)
        rom[12'h2D7] = 8'h7E; rom[12'h2D8] = 8'h7E;

        // '.' (0x2E)
        rom[12'h2EB] = 8'h18; rom[12'h2EC] = 8'h18;

        // '/' (0x2F)
        rom[12'h2F3] = 8'h02; rom[12'h2F4] = 8'h06; rom[12'h2F5] = 8'h0C; rom[12'h2F6] = 8'h18;
        rom[12'h2F7] = 8'h30; rom[12'h2F8] = 8'h60; rom[12'h2F9] = 8'h40;

        // ':' (0x3A)
        rom[12'h3A4] = 8'h18; rom[12'h3A5] = 8'h18; rom[12'h3AA] = 8'h18; rom[12'h3AB] = 8'h18;

        // '>' (0x3E)
        rom[12'h3E2] = 8'h60; rom[12'h3E3] = 8'h30; rom[12'h3E4] = 8'h18; rom[12'h3E5] = 8'h0C;
        rom[12'h3E6] = 8'h06; rom[12'h3E7] = 8'h03; rom[12'h3E8] = 8'h06; rom[12'h3E9] = 8'h0C;
        rom[12'h3EA] = 8'h18; rom[12'h3EB] = 8'h30; rom[12'h3EC] = 8'h60;

        // '?' (0x3F)
        rom[12'h3F2] = 8'h3C; rom[12'h3F3] = 8'h66; rom[12'h3F4] = 8'h06; rom[12'h3F5] = 8'h0C;
        rom[12'h3F6] = 8'h18; rom[12'h3F7] = 8'h18; rom[12'h3F9] = 8'h18; rom[12'h3FA] = 8'h18;

        // '\' (0x5C)
        rom[12'h5C3] = 8'h40; rom[12'h5C4] = 8'h60; rom[12'h5C5] = 8'h30; rom[12'h5C6] = 8'h18;
        rom[12'h5C7] = 8'h0C; rom[12'h5C8] = 8'h06; rom[12'h5C9] = 8'h02;

        // '|' (0x7C)
        rom[12'h7C2] = 8'h18; rom[12'h7C3] = 8'h18; rom[12'h7C4] = 8'h18; rom[12'h7C5] = 8'h18;
        rom[12'h7C6] = 8'h18; rom[12'h7C7] = 8'h18; rom[12'h7C8] = 8'h18; rom[12'h7C9] = 8'h18;
        rom[12'h7CA] = 8'h18; rom[12'h7CB] = 8'h18;

        // --- DIGITS 0-9 ---
        // '0'
        rom[12'h302] = 8'h3C; rom[12'h303] = 8'h66; rom[12'h304] = 8'h6E; rom[12'h305] = 8'h76;
        rom[12'h306] = 8'h66; rom[12'h307] = 8'h66; rom[12'h308] = 8'h66; rom[12'h309] = 8'h66;
        rom[12'h30A] = 8'h66; rom[12'h30B] = 8'h3C;
        // '1'
        rom[12'h312] = 8'h18; rom[12'h313] = 8'h38; rom[12'h314] = 8'h18; rom[12'h315] = 8'h18;
        rom[12'h316] = 8'h18; rom[12'h317] = 8'h18; rom[12'h318] = 8'h18; rom[12'h319] = 8'h18;
        rom[12'h31A] = 8'h18; rom[12'h31B] = 8'h3C;
        // '2'
        rom[12'h322] = 8'h3C; rom[12'h323] = 8'h66; rom[12'h324] = 8'h06; rom[12'h325] = 8'h0C;
        rom[12'h326] = 8'h18; rom[12'h327] = 8'h30; rom[12'h328] = 8'h60; rom[12'h329] = 8'h60;
        rom[12'h32A] = 8'h66; rom[12'h32B] = 8'h7E;
        // '3'
        rom[12'h332] = 8'h3C; rom[12'h333] = 8'h66; rom[12'h334] = 8'h06; rom[12'h335] = 8'h06;
        rom[12'h336] = 8'h1C; rom[12'h337] = 8'h06; rom[12'h338] = 8'h06; rom[12'h339] = 8'h06;
        rom[12'h33A] = 8'h66; rom[12'h33B] = 8'h3C;
        // '4'
        rom[12'h342] = 8'h0E; rom[12'h343] = 8'h1E; rom[12'h344] = 8'h36; rom[12'h345] = 8'h66;
        rom[12'h346] = 8'h66; rom[12'h347] = 8'h7F; rom[12'h348] = 8'h06; rom[12'h349] = 8'h06;
        rom[12'h34A] = 8'h06; rom[12'h34B] = 8'h0F;
        // '5'
        rom[12'h352] = 8'h7E; rom[12'h353] = 8'h60; rom[12'h354] = 8'h60; rom[12'h355] = 8'h7C;
        rom[12'h356] = 8'h06; rom[12'h357] = 8'h06; rom[12'h358] = 8'h06; rom[12'h359] = 8'h06;
        rom[12'h35A] = 8'h66; rom[12'h35B] = 8'h3C;
        // '6'
        rom[12'h362] = 8'h1C; rom[12'h363] = 8'h30; rom[12'h364] = 8'h60; rom[12'h365] = 8'h60;
        rom[12'h366] = 8'h7C; rom[12'h367] = 8'h66; rom[12'h368] = 8'h66; rom[12'h369] = 8'h66;
        rom[12'h36A] = 8'h66; rom[12'h36B] = 8'h3C;
        // '7'
        rom[12'h372] = 8'h7E; rom[12'h373] = 8'h66; rom[12'h374] = 8'h06; rom[12'h375] = 8'h0C;
        rom[12'h376] = 8'h0C; rom[12'h377] = 8'h18; rom[12'h378] = 8'h18; rom[12'h379] = 8'h18;
        rom[12'h37A] = 8'h18; rom[12'h37B] = 8'h18;
        // '8'
        rom[12'h382] = 8'h3C; rom[12'h383] = 8'h66; rom[12'h384] = 8'h66; rom[12'h385] = 8'h66;
        rom[12'h386] = 8'h3C; rom[12'h387] = 8'h66; rom[12'h388] = 8'h66; rom[12'h389] = 8'h66;
        rom[12'h38A] = 8'h66; rom[12'h38B] = 8'h3C;
        // '9'
        rom[12'h392] = 8'h3C; rom[12'h393] = 8'h66; rom[12'h394] = 8'h66; rom[12'h395] = 8'h66;
        rom[12'h396] = 8'h66; rom[12'h397] = 8'h3E; rom[12'h398] = 8'h06; rom[12'h399] = 8'h06;
        rom[12'h39A] = 8'h0C; rom[12'h39B] = 8'h38;

        // --- UPPERCASE LETTERS A-Z ---
        // 'A'
        rom[12'h412] = 8'h18; rom[12'h413] = 8'h3C; rom[12'h414] = 8'h66; rom[12'h415] = 8'h66;
        rom[12'h416] = 8'h66; rom[12'h417] = 8'h7E; rom[12'h418] = 8'h66; rom[12'h419] = 8'h66;
        rom[12'h41A] = 8'h66; rom[12'h41B] = 8'h66;
        // 'B'
        rom[12'h422] = 8'h7C; rom[12'h423] = 8'h66; rom[12'h424] = 8'h66; rom[12'h425] = 8'h66;
        rom[12'h426] = 8'h7C; rom[12'h427] = 8'h66; rom[12'h428] = 8'h66; rom[12'h429] = 8'h66;
        rom[12'h42A] = 8'h66; rom[12'h42B] = 8'h7C;
        // 'C'
        rom[12'h432] = 8'h3C; rom[12'h433] = 8'h66; rom[12'h434] = 8'h60; rom[12'h435] = 8'h60;
        rom[12'h436] = 8'h60; rom[12'h437] = 8'h60; rom[12'h438] = 8'h60; rom[12'h439] = 8'h60;
        rom[12'h43A] = 8'h66; rom[12'h43B] = 8'h3C;
        // 'D'
        rom[12'h442] = 8'h78; rom[12'h443] = 8'h6C; rom[12'h444] = 8'h66; rom[12'h445] = 8'h66;
        rom[12'h446] = 8'h66; rom[12'h447] = 8'h66; rom[12'h448] = 8'h66; rom[12'h449] = 8'h66;
        rom[12'h44A] = 8'h6C; rom[12'h44B] = 8'h78;
        // 'E'
        rom[12'h452] = 8'h7E; rom[12'h453] = 8'h60; rom[12'h454] = 8'h60; rom[12'h455] = 8'h60;
        rom[12'h456] = 8'h7C; rom[12'h457] = 8'h60; rom[12'h458] = 8'h60; rom[12'h459] = 8'h60;
        rom[12'h45A] = 8'h60; rom[12'h45B] = 8'h7E;
        // 'F'
        rom[12'h462] = 8'h7E; rom[12'h463] = 8'h60; rom[12'h464] = 8'h60; rom[12'h465] = 8'h60;
        rom[12'h466] = 8'h7C; rom[12'h467] = 8'h60; rom[12'h468] = 8'h60; rom[12'h469] = 8'h60;
        rom[12'h46A] = 8'h60; rom[12'h46B] = 8'h60;
        // 'G'
        rom[12'h472] = 8'h3C; rom[12'h473] = 8'h66; rom[12'h474] = 8'h60; rom[12'h475] = 8'h60;
        rom[12'h476] = 8'h60; rom[12'h477] = 8'h6E; rom[12'h478] = 8'h66; rom[12'h479] = 8'h66;
        rom[12'h47A] = 8'h66; rom[12'h47B] = 8'h3E;
        // 'H'
        rom[12'h482] = 8'h66; rom[12'h483] = 8'h66; rom[12'h484] = 8'h66; rom[12'h485] = 8'h66;
        rom[12'h486] = 8'h7E; rom[12'h487] = 8'h66; rom[12'h488] = 8'h66; rom[12'h489] = 8'h66;
        rom[12'h48A] = 8'h66; rom[12'h48B] = 8'h66;
        // 'I'
        rom[12'h492] = 8'h3C; rom[12'h493] = 8'h18; rom[12'h494] = 8'h18; rom[12'h495] = 8'h18;
        rom[12'h496] = 8'h18; rom[12'h497] = 8'h18; rom[12'h498] = 8'h18; rom[12'h499] = 8'h18;
        rom[12'h49A] = 8'h18; rom[12'h49B] = 8'h3C;
        // 'J'
        rom[12'h4A2] = 8'h1E; rom[12'h4A3] = 8'h0C; rom[12'h4A4] = 8'h0C; rom[12'h4A5] = 8'h0C;
        rom[12'h4A6] = 8'h0C; rom[12'h4A7] = 8'h0C; rom[12'h4A8] = 8'h0C; rom[12'h4A9] = 8'h6C;
        rom[12'h4AA] = 8'h6C; rom[12'h4AB] = 8'h38;
        // 'K'
        rom[12'h4B2] = 8'h66; rom[12'h4B3] = 8'h6C; rom[12'h4B4] = 8'h78; rom[12'h4B5] = 8'h70;
        rom[12'h4B6] = 8'h7C; rom[12'h4B7] = 8'h6E; rom[12'h4B8] = 8'h66; rom[12'h4B9] = 8'h66;
        rom[12'h4BA] = 8'h66; rom[12'h4BB] = 8'h66;
        // 'L'
        rom[12'h4C2] = 8'h60; rom[12'h4C3] = 8'h60; rom[12'h4C4] = 8'h60; rom[12'h4C5] = 8'h60;
        rom[12'h4C6] = 8'h60; rom[12'h4C7] = 8'h60; rom[12'h4C8] = 8'h60; rom[12'h4C9] = 8'h60;
        rom[12'h4CA] = 8'h60; rom[12'h4CB] = 8'h7E;
        // 'M'
        rom[12'h4D2] = 8'h63; rom[12'h4D3] = 8'h77; rom[12'h4D4] = 8'h7F; rom[12'h4D5] = 8'h6B;
        rom[12'h4D6] = 8'h6B; rom[12'h4D7] = 8'h63; rom[12'h4D8] = 8'h63; rom[12'h4D9] = 8'h63;
        rom[12'h4DA] = 8'h63; rom[12'h4DB] = 8'h63;
        // 'N'
        rom[12'h4E2] = 8'h66; rom[12'h4E3] = 8'h76; rom[12'h4E4] = 8'h7E; rom[12'h4E5] = 8'h7E;
        rom[12'h4E6] = 8'h6E; rom[12'h4E7] = 8'h66; rom[12'h4E8] = 8'h66; rom[12'h4E9] = 8'h66;
        rom[12'h4EA] = 8'h66; rom[12'h4EB] = 8'h66;
        // 'O'
        rom[12'h4F2] = 8'h3C; rom[12'h4F3] = 8'h66; rom[12'h4F4] = 8'h66; rom[12'h4F5] = 8'h66;
        rom[12'h4F6] = 8'h66; rom[12'h4F7] = 8'h66; rom[12'h4F8] = 8'h66; rom[12'h4F9] = 8'h66;
        rom[12'h4FA] = 8'h66; rom[12'h4FB] = 8'h3C;
        // 'P'
        rom[12'h502] = 8'h7C; rom[12'h503] = 8'h66; rom[12'h504] = 8'h66; rom[12'h505] = 8'h66;
        rom[12'h506] = 8'h7C; rom[12'h507] = 8'h60; rom[12'h508] = 8'h60; rom[12'h509] = 8'h60;
        rom[12'h50A] = 8'h60; rom[12'h50B] = 8'h60;
        // 'Q'
        rom[12'h512] = 8'h3C; rom[12'h513] = 8'h66; rom[12'h514] = 8'h66; rom[12'h515] = 8'h66;
        rom[12'h516] = 8'h66; rom[12'h517] = 8'h66; rom[12'h518] = 8'h66; rom[12'h519] = 8'h6A;
        rom[12'h51A] = 8'h6C; rom[12'h51B] = 8'h36;
        // 'R'
        rom[12'h522] = 8'h7C; rom[12'h523] = 8'h66; rom[12'h524] = 8'h66; rom[12'h525] = 8'h66;
        rom[12'h526] = 8'h7C; rom[12'h527] = 8'h6C; rom[12'h528] = 8'h66; rom[12'h529] = 8'h66;
        rom[12'h52A] = 8'h66; rom[12'h52B] = 8'h66;
        // 'S'
        rom[12'h532] = 8'h3C; rom[12'h533] = 8'h66; rom[12'h534] = 8'h60; rom[12'h535] = 8'h30;
        rom[12'h536] = 8'h18; rom[12'h537] = 8'h0C; rom[12'h538] = 8'h06; rom[12'h539] = 8'h06;
        rom[12'h53A] = 8'h66; rom[12'h53B] = 8'h3C;
        // 'T'
        rom[12'h542] = 8'h7E; rom[12'h543] = 8'h18; rom[12'h544] = 8'h18; rom[12'h545] = 8'h18;
        rom[12'h546] = 8'h18; rom[12'h547] = 8'h18; rom[12'h548] = 8'h18; rom[12'h549] = 8'h18;
        rom[12'h54A] = 8'h18; rom[12'h54B] = 8'h18;
        // 'U'
        rom[12'h552] = 8'h66; rom[12'h553] = 8'h66; rom[12'h554] = 8'h66; rom[12'h555] = 8'h66;
        rom[12'h556] = 8'h66; rom[12'h557] = 8'h66; rom[12'h558] = 8'h66; rom[12'h559] = 8'h66;
        rom[12'h55A] = 8'h66; rom[12'h55B] = 8'h3C;
        // 'V'
        rom[12'h562] = 8'h66; rom[12'h563] = 8'h66; rom[12'h564] = 8'h66; rom[12'h565] = 8'h66;
        rom[12'h566] = 8'h66; rom[12'h567] = 8'h66; rom[12'h568] = 8'h66; rom[12'h569] = 8'h3C;
        rom[12'h56A] = 8'h18; rom[12'h56B] = 8'h18;
        // 'W'
        rom[12'h572] = 8'h63; rom[12'h573] = 8'h63; rom[12'h574] = 8'h63; rom[12'h575] = 8'h63;
        rom[12'h576] = 8'h6B; rom[12'h577] = 8'h6B; rom[12'h578] = 8'h7F; rom[12'h579] = 8'h77;
        rom[12'h57A] = 8'h63; rom[12'h57B] = 8'h63;
        // 'X'
        rom[12'h582] = 8'h66; rom[12'h583] = 8'h66; rom[12'h584] = 8'h3C; rom[12'h585] = 8'h18;
        rom[12'h586] = 8'h18; rom[12'h587] = 8'h18; rom[12'h588] = 8'h3C; rom[12'h589] = 8'h66;
        rom[12'h58A] = 8'h66; rom[12'h58B] = 8'h66;
        // 'Y'
        rom[12'h592] = 8'h66; rom[12'h593] = 8'h66; rom[12'h594] = 8'h66; rom[12'h595] = 8'h66;
        rom[12'h596] = 8'h3C; rom[12'h597] = 8'h18; rom[12'h598] = 8'h18; rom[12'h599] = 8'h18;
        rom[12'h59A] = 8'h18; rom[12'h59B] = 8'h18;
        // 'Z'
        rom[12'h5A2] = 8'h7E; rom[12'h5A3] = 8'h06; rom[12'h5A4] = 8'h0C; rom[12'h5A5] = 8'h0C;
        rom[12'h5A6] = 8'h18; rom[12'h5A7] = 8'h30; rom[12'h5A8] = 8'h30; rom[12'h5A9] = 8'h60;
        rom[12'h5AA] = 8'h60; rom[12'h5AB] = 8'h7E;

        // --- LOWERCASE LETTERS a-z ---
        // 'a'
        rom[12'h615] = 8'h3C; rom[12'h616] = 8'h06; rom[12'h617] = 8'h3E; rom[12'h618] = 8'h66;
        rom[12'h619] = 8'h66; rom[12'h61A] = 8'h66; rom[12'h61B] = 8'h3B;
        // 'b'
        rom[12'h622] = 8'h60; rom[12'h623] = 8'h60; rom[12'h624] = 8'h60; rom[12'h625] = 8'h7C;
        rom[12'h626] = 8'h66; rom[12'h627] = 8'h66; rom[12'h628] = 8'h66; rom[12'h629] = 8'h66;
        rom[12'h62A] = 8'h66; rom[12'h62B] = 8'h7C;
        // 'c'
        rom[12'h635] = 8'h3C; rom[12'h636] = 8'h66; rom[12'h637] = 8'h60; rom[12'h638] = 8'h60;
        rom[12'h639] = 8'h60; rom[12'h63A] = 8'h66; rom[12'h63B] = 8'h3C;
        // 'd'
        rom[12'h642] = 8'h06; rom[12'h643] = 8'h06; rom[12'h644] = 8'h06; rom[12'h645] = 8'h3E;
        rom[12'h646] = 8'h66; rom[12'h647] = 8'h66; rom[12'h648] = 8'h66; rom[12'h649] = 8'h66;
        rom[12'h64A] = 8'h66; rom[12'h64B] = 8'h3E;
        // 'e'
        rom[12'h655] = 8'h3C; rom[12'h656] = 8'h66; rom[12'h657] = 8'h66; rom[12'h658] = 8'h7E;
        rom[12'h659] = 8'h60; rom[12'h65A] = 8'h66; rom[12'h65B] = 8'h3C;
        // 'f'
        rom[12'h662] = 8'h1C; rom[12'h663] = 8'h36; rom[12'h664] = 8'h30; rom[12'h665] = 8'h30;
        rom[12'h666] = 8'h7C; rom[12'h667] = 8'h30; rom[12'h668] = 8'h30; rom[12'h669] = 8'h30;
        rom[12'h66A] = 8'h30; rom[12'h66B] = 8'h30;
        // 'g'
        rom[12'h675] = 8'h3E; rom[12'h676] = 8'h66; rom[12'h677] = 8'h66; rom[12'h678] = 8'h66;
        rom[12'h679] = 8'h3E; rom[12'h67A] = 8'h06; rom[12'h67B] = 8'h3C;
        // 'h'
        rom[12'h682] = 8'h60; rom[12'h683] = 8'h60; rom[12'h684] = 8'h60; rom[12'h685] = 8'h7C;
        rom[12'h686] = 8'h66; rom[12'h687] = 8'h66; rom[12'h688] = 8'h66; rom[12'h689] = 8'h66;
        rom[12'h68A] = 8'h66; rom[12'h68B] = 8'h66;
        // 'i'
        rom[12'h692] = 8'h18; rom[12'h693] = 8'h18; rom[12'h695] = 8'h38; rom[12'h696] = 8'h18;
        rom[12'h697] = 8'h18; rom[12'h698] = 8'h18; rom[12'h699] = 8'h18; rom[12'h69A] = 8'h18;
        rom[12'h69B] = 8'h3C;
        // 'j'
        rom[12'h6A2] = 8'h0C; rom[12'h6A3] = 8'h0C; rom[12'h6A5] = 8'h1C; rom[12'h6A6] = 8'h0C;
        rom[12'h6A7] = 8'h0C; rom[12'h6A8] = 8'h0C; rom[12'h6A9] = 8'h0C; rom[12'h6AA] = 8'h0C;
        rom[12'h6AB] = 8'h0C; rom[12'h6AC] = 8'h4C; rom[12'h6AD] = 8'h38;
        // 'k'
        rom[12'h6B2] = 8'h60; rom[12'h6B3] = 8'h60; rom[12'h6B4] = 8'h60; rom[12'h6B5] = 8'h66;
        rom[12'h6B6] = 8'h6C; rom[12'h6B7] = 8'h78; rom[12'h6B8] = 8'h70; rom[12'h6B9] = 8'h6C;
        rom[12'h6BA] = 8'h66; rom[12'h6BB] = 8'h66;
        // 'l'
        rom[12'h6C2] = 8'h38; rom[12'h6C3] = 8'h18; rom[12'h6C4] = 8'h18; rom[12'h6C5] = 8'h18;
        rom[12'h6C6] = 8'h18; rom[12'h6C7] = 8'h18; rom[12'h6C8] = 8'h18; rom[12'h6C9] = 8'h18;
        rom[12'h6CA] = 8'h18; rom[12'h6CB] = 8'h3C;
        // 'm'
        rom[12'h6D5] = 8'h66; rom[12'h6D6] = 8'h7F; rom[12'h6D7] = 8'h6B; rom[12'h6D8] = 8'h6B;
        rom[12'h6D9] = 8'h63; rom[12'h6DA] = 8'h63; rom[12'h6DB] = 8'h63;
        // 'n'
        rom[12'h6E5] = 8'h7C; rom[12'h6E6] = 8'h66; rom[12'h6E7] = 8'h66; rom[12'h6E8] = 8'h66;
        rom[12'h6E9] = 8'h66; rom[12'h6EA] = 8'h66; rom[12'h6EB] = 8'h66;
        // 'o'
        rom[12'h6F5] = 8'h3C; rom[12'h6F6] = 8'h66; rom[12'h6F7] = 8'h66; rom[12'h6F8] = 8'h66;
        rom[12'h6F9] = 8'h66; rom[12'h6FA] = 8'h66; rom[12'h6FB] = 8'h3C;
        // 'p'
        rom[12'h705] = 8'h7C; rom[12'h706] = 8'h66; rom[12'h707] = 8'h66; rom[12'h708] = 8'h66;
        rom[12'h709] = 8'h7C; rom[12'h70A] = 8'h60; rom[12'h70B] = 8'h60; rom[12'h70C] = 8'h60;
        // 'q'
        rom[12'h715] = 8'h3E; rom[12'h716] = 8'h66; rom[12'h717] = 8'h66; rom[12'h718] = 8'h66;
        rom[12'h719] = 8'h3E; rom[12'h71A] = 8'h06; rom[12'h71B] = 8'h06; rom[12'h71C] = 8'h06;
        // 'r'
        rom[12'h725] = 8'h3C; rom[12'h726] = 8'h66; rom[12'h727] = 8'h60; rom[12'h728] = 8'h60;
        rom[12'h729] = 8'h60; rom[12'h72A] = 8'h60; rom[12'h72B] = 8'h60;
        // 's'
        rom[12'h735] = 8'h3E; rom[12'h736] = 8'h60; rom[12'h737] = 8'h3C; rom[12'h738] = 8'h06;
        rom[12'h739] = 8'h06; rom[12'h73A] = 8'h66; rom[12'h73B] = 8'h3C;
        // 't'
        rom[12'h742] = 8'h10; rom[12'h743] = 8'h10; rom[12'h744] = 8'h30; rom[12'h745] = 8'h7C;
        rom[12'h746] = 8'h30; rom[12'h747] = 8'h30; rom[12'h748] = 8'h30; rom[12'h749] = 8'h30;
        rom[12'h74A] = 8'h36; rom[12'h74B] = 8'h1C;
        // 'u'
        rom[12'h755] = 8'h66; rom[12'h756] = 8'h66; rom[12'h757] = 8'h66; rom[12'h758] = 8'h66;
        rom[12'h759] = 8'h66; rom[12'h75A] = 8'h66; rom[12'h75B] = 8'h3E;
        // 'v'
        rom[12'h765] = 8'h66; rom[12'h766] = 8'h66; rom[12'h767] = 8'h66; rom[12'h768] = 8'h66;
        rom[12'h769] = 8'h66; rom[12'h76A] = 8'h3C; rom[12'h76B] = 8'h18;
        // 'w'
        rom[12'h775] = 8'h63; rom[12'h776] = 8'h63; rom[12'h777] = 8'h63; rom[12'h778] = 8'h6B;
        rom[12'h779] = 8'h6B; rom[12'h77A] = 8'h7F; rom[12'h77B] = 8'h36;
        // 'x'
        rom[12'h785] = 8'h66; rom[12'h786] = 8'h66; rom[12'h787] = 8'h3C; rom[12'h788] = 8'h18;
        rom[12'h789] = 8'h3C; rom[12'h78A] = 8'h66; rom[12'h78B] = 8'h66;
        // 'y'
        rom[12'h795] = 8'h66; rom[12'h796] = 8'h66; rom[12'h797] = 8'h66; rom[12'h798] = 8'h66;
        rom[12'h799] = 8'h3E; rom[12'h79A] = 8'h06; rom[12'h79B] = 8'h0C; rom[12'h79C] = 8'h38;
        // 'z'
        rom[12'h7A5] = 8'h7E; rom[12'h7A6] = 8'h0C; rom[12'h7A7] = 8'h18; rom[12'h7A8] = 8'h30;
        rom[12'h7A9] = 8'h30; rom[12'h7AA] = 8'h60; rom[12'h7AB] = 8'h7E;
    end

    // Fetch the 8-bit row slice synchronously
    always @(posedge clk) begin
        row_data <= rom[{ascii_code, char_row}];
    end 

endmodule
