module reg_mux#(parameter WIDTH = 10, parameter RSTTYPE = "SYNC")(
    input CLK, RST, EN, SEL,
    input [WIDTH-1:0] D,
    output [WIDTH-1:0] out
);
reg [WIDTH-1:0] out_reg;

    generate
        if (RSTTYPE == "ASYNC") begin 
            always @(posedge CLK or posedge RST) begin
                if (RST) begin
                    out_reg <= 48'b0;     // Asynchronous reset
                end else if (EN) begin
                    out_reg <= D;         
                end
            end
        end 
        else if(RSTTYPE=="SYNC") begin 
            always @(posedge CLK) begin
                if (RST) begin
                    out_reg <= 48'b0;     // Synchronous reset
                end else if (EN) begin
                    out_reg <= D;         
                end
            end
        end
    endgenerate

assign out=(SEL)?out_reg:D;

endmodule

