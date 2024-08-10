module mux4x1 #(parameter WIDTH = 16)(
    input [WIDTH-1:0]IN0,IN1,IN2,IN3,
    input [1:0]SEL,
    output reg [WIDTH-1:0] out
);
always @(*) begin
    case (SEL)
        2'b00: out <= IN0;
        2'b01: out <= IN1;
        2'b10: out <= IN2;
        2'b11: out <= IN3;
    endcase
end
endmodule
