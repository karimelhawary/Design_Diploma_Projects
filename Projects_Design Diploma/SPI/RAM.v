module RAM(
	input clk,rst_n,rx_valid,
	input [9:0]din,
	output reg [7:0]dout,
	output reg tx_valid
);
	parameter MEM_DEPTH=256;
	parameter ADDR_SIZE=8;

	// Declare RAM variable
	reg [7:0] Ram [MEM_DEPTH-1:0]; 
	reg [ADDR_SIZE-1:0] ADD_REG_W;
	reg [ADDR_SIZE-1:0] ADD_REG_R;
    reg [3:0] counter_tx ;
    
	always @(posedge clk) begin
		if (~rst_n) begin
            dout <= 1'b0;
			ADD_REG_W <= 1'b0;
			ADD_REG_R <= 1'b0;
            tx_valid <= 1'b0;	
			counter_tx <= 1'b0;
		end else if(rx_valid) begin
				case(din[9:8])
					2'b00:begin
						ADD_REG_W<=din[7:0];
						tx_valid<=1'b0;
					end 
					2'b01:begin
						Ram[ADD_REG_W]<=din[7:0];
						tx_valid<=1'b0;
					end
					2'b10:begin
						ADD_REG_R<=din[7:0];
						tx_valid<=1'b0;
					end
					2'b11:begin
						dout<=Ram[ADD_REG_R];
						tx_valid<=1'b1;
					end
				endcase
		end 
		if (tx_valid)begin
			counter_tx<=counter_tx+1'b1;
		    if (counter_tx == 8)begin
                tx_valid<=1'b0;
			    counter_tx<=1'b0;
			end
		end
	end
endmodule