module SPI_SLAVE(
  input SS_n,
  input clk,
  input rst_n,
  input tx_valid,
  input [7:0]tx_data,
  input MOSI,
  output reg MISO,
  output reg rx_valid,
  output reg [9:0] rx_data
);
  parameter IDLE      = 3'b000;
  parameter CHK_CMD   = 3'b001;
  parameter WRITE     = 3'b010;
  parameter READ_ADD  = 3'b011;
  parameter READ_DATA = 3'b100;

(* fsm_encoding = "sequential" *)
//(* fsm_encoding = "gray" *)
//(* fsm_encoding = "one_hot" *)
  reg [2:0] cs,ns;
  reg [3:0] Counter=4'b0;
  reg [3:0] Counter_t=4'b0;
  reg Have_Addrress;

  //State Memory
  always @(posedge clk or negedge rst_n) begin
	      if (~rst_n)begin
	          cs <= IDLE;
	      end
	      else
	          cs <= ns;
  end

  //Next State
  always@(*)begin
      case(cs)
        IDLE:
            if(SS_n==1'b0)
              ns<=CHK_CMD;
            else
              ns<=IDLE;    

        CHK_CMD:
            if(SS_n==1'b0 && MOSI==1'b0)
                ns<=WRITE;
            else if(SS_n==1'b0 && MOSI==1'b1 && Have_Addrress==1'b0)
                ns<=READ_ADD;
            else if(SS_n==1'b0 && MOSI==1'b1 && Have_Addrress==1'b1)
                ns<=READ_DATA;
            else 
                ns<=IDLE;

        WRITE:
            if(SS_n==1'b1)
                ns<=IDLE;
            else
                ns<=WRITE;

        READ_ADD:
            if(SS_n==1'b1)
                ns<=IDLE;
            else
                ns<=READ_ADD;
  
        READ_DATA:
            if(SS_n==1'b1)
                ns<=IDLE;
            else
                ns<=READ_DATA;
        default:ns<=IDLE;
      endcase
  end

  //Output State
  always@(posedge clk)begin
      if(~rst_n)begin
          Counter <= 4'b0;
          Counter_t <= 4'b0;
          MISO<=0;
          Have_Addrress<=0;
          rx_data <=10'b0;
      end
      case(cs)
          IDLE:begin
              Counter <= 4'b0;
              Counter_t <= 4'b0;
              rx_valid <= 1'b0;
              MISO <= 1'b0;
          end

          CHK_CMD:begin
              Counter<=1'b0;
              rx_valid <= 1'b0; 
          end

          WRITE:begin
              if(SS_n==0 )begin
                rx_data[9-Counter]<=MOSI;
                Counter<=Counter+1'b1;
                rx_valid <= 1'b0; 
              end
              if(Counter==9)begin
                rx_valid<=1'b1;
                Counter<=1'b0;
              end
          end

          READ_ADD:begin
              if(SS_n==0)begin
                rx_data[9-Counter]<=MOSI;
                Counter<=Counter+1'b1;
                rx_valid <= 1'b0;
              end
              if(Counter==9)begin
                rx_valid<=1'b1;
                Counter<=1'b0;
                Have_Addrress<=1'b1;
              end
          end
    
          READ_DATA:begin
              if(SS_n==0)begin
                if(tx_valid==1'b0)begin
                  rx_data[9-Counter]<=MOSI;
                  Counter<=Counter+1'b1;
                    if(Counter==9)begin
                      //Counter<=1'b0;
                      rx_valid<=1'b1;
                    end else if (Counter== 4'b1010)begin 
                          Counter<=1'b0;
                          rx_valid<=1'b0;
                    end
                end else if(tx_valid==1'b1)begin
                  MISO<=tx_data[7-(Counter_t)];
                  Counter_t <= Counter_t +1'b1;
                    if(Counter_t==7)begin
                      Have_Addrress<=1'b0;
                      //Counter_tm<=1'b0;
                    end
                end
              end
          end
      endcase
  end
endmodule