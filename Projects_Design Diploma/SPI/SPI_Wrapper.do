vlib work
vlog SPI_SLAVE.v RAM.v SPI_Wrapper.v SPI_Wrapper_tb.v
vsim -voptargs=+acc SPI_Wrapper_TB
add wave -position insertpoint  \
sim:/SPI_Wrapper_TB/MEM_DEPTH \
sim:/SPI_Wrapper_TB/ADDR_SIZE \
sim:/SPI_Wrapper_TB/IDLE \
sim:/SPI_Wrapper_TB/CHK_CMD \
sim:/SPI_Wrapper_TB/WRITE \
sim:/SPI_Wrapper_TB/READ_ADD \
sim:/SPI_Wrapper_TB/READ_DATA \
sim:/SPI_Wrapper_TB/rst_n \
sim:/SPI_Wrapper_TB/clk \
sim:/SPI_Wrapper_TB/SS_n \
sim:/SPI_Wrapper_TB/MOSI \
sim:/SPI_Wrapper_TB/MISO \
sim:/SPI_Wrapper_TB/DUT/SPI/cs \
sim:/SPI_Wrapper_TB/DUT/SPI/ns \
sim:/SPI_Wrapper_TB/DUT/rx_valid \
sim:/SPI_Wrapper_TB/DUT/rxdata \
sim:/SPI_Wrapper_TB/DUT/tx_valid \
sim:/SPI_Wrapper_TB/DUT/txdata \
sim:/SPI_Wrapper_TB/DUT/RAM/Ram \
sim:/SPI_Wrapper_TB/DUT/RAM/ADD_REG_W \
sim:/SPI_Wrapper_TB/DUT/RAM/ADD_REG_R \
sim:/SPI_Wrapper_TB/DUT/SPI/Counter \
sim:/SPI_Wrapper_TB/DUT/SPI/Counter_t \
sim:/SPI_Wrapper_TB/DUT/SPI/Have_Addrress
run -all