module SPI_Wrapper(
    input clk,
    input rst_n,
    input SS_n,
    input MOSI,
    output MISO
);
    //parameter 
    parameter MEM_DEPTH=256;
    parameter ADDR_SIZE=8;

    wire [9:0] rxdata;
    wire rx_valid;
    wire [7:0] txdata;
    wire tx_valid;

    RAM #(MEM_DEPTH, ADDR_SIZE) RAM(
        .din(rxdata),
        .dout(txdata),
        .rx_valid(rx_valid),
        .tx_valid(tx_valid),
        .clk(clk),
        .rst_n(rst_n)
    );

    SPI_SLAVE SPI(
        .MOSI(MOSI),
        .MISO(MISO),
        .SS_n(SS_n),
        .clk(clk),
        .rst_n(rst_n),
        .rx_data(rxdata),
        .rx_valid(rx_valid),
        .tx_data(txdata),
        .tx_valid(tx_valid)
    );

endmodule
