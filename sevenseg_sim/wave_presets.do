# Display signals from module cpu_0
add wave -noupdate -divider {cpu_0}
add wave -noupdate -format Logic -radix hexadecimal /test_bench/DUT/the_cpu_0/i_readdata
add wave -noupdate -format Logic -radix hexadecimal /test_bench/DUT/the_cpu_0/i_readdatavalid
add wave -noupdate -format Logic -radix hexadecimal /test_bench/DUT/the_cpu_0/i_waitrequest
add wave -noupdate -format Logic -radix hexadecimal /test_bench/DUT/the_cpu_0/i_address
add wave -noupdate -format Logic -radix hexadecimal /test_bench/DUT/the_cpu_0/i_read
add wave -noupdate -format Logic -radix hexadecimal /test_bench/DUT/the_cpu_0/clk
add wave -noupdate -format Logic -radix hexadecimal /test_bench/DUT/the_cpu_0/reset_n
add wave -noupdate -format Logic -radix hexadecimal /test_bench/DUT/the_cpu_0/d_readdata
add wave -noupdate -format Logic -radix hexadecimal /test_bench/DUT/the_cpu_0/d_waitrequest
add wave -noupdate -format Logic -radix hexadecimal /test_bench/DUT/the_cpu_0/d_address
add wave -noupdate -format Logic -radix hexadecimal /test_bench/DUT/the_cpu_0/d_byteenable
add wave -noupdate -format Logic -radix hexadecimal /test_bench/DUT/the_cpu_0/d_read
add wave -noupdate -format Logic -radix hexadecimal /test_bench/DUT/the_cpu_0/d_write
add wave -noupdate -format Logic -radix hexadecimal /test_bench/DUT/the_cpu_0/d_writedata
add wave -noupdate -format Logic -radix hexadecimal /test_bench/DUT/the_cpu_0/d_irq
add wave -noupdate -format Logic -radix hexadecimal /test_bench/DUT/the_cpu_0/d_readdatavalid
add wave -noupdate -format Logic -radix hexadecimal /test_bench/DUT/the_cpu_0/the_cpu_0_test_bench/W_pcb
add wave -noupdate -format Logic -radix ascii /test_bench/DUT/the_cpu_0/the_cpu_0_test_bench/W_vinst
add wave -noupdate -format Logic -radix hexadecimal /test_bench/DUT/the_cpu_0/the_cpu_0_test_bench/W_valid
add wave -noupdate -format Logic -radix hexadecimal /test_bench/DUT/the_cpu_0/the_cpu_0_test_bench/W_iw


# Display signals from module jtag_uart_0
add wave -noupdate -divider {jtag_uart_0}
add wave -noupdate -format Literal -radix hexadecimal /test_bench/DUT/the_jtag_uart_0/av_address
add wave -noupdate -format Logic /test_bench/DUT/the_jtag_uart_0/av_chipselect
add wave -noupdate -format Logic /test_bench/DUT/the_jtag_uart_0/av_irq
add wave -noupdate -format Logic /test_bench/DUT/the_jtag_uart_0/av_read_n
add wave -noupdate -format Literal -radix hexadecimal /test_bench/DUT/the_jtag_uart_0/av_readdata
add wave -noupdate -format Logic /test_bench/DUT/the_jtag_uart_0/av_waitrequest
add wave -noupdate -format Logic /test_bench/DUT/the_jtag_uart_0/av_write_n
add wave -noupdate -format Literal -radix hexadecimal /test_bench/DUT/the_jtag_uart_0/av_writedata
add wave -noupdate -format Logic /test_bench/DUT/the_jtag_uart_0/dataavailable
add wave -noupdate -format Logic /test_bench/DUT/the_jtag_uart_0/readyfordata


# Display signals from module onchip_memory2_0
add wave -noupdate -divider {onchip_memory2_0}
add wave -noupdate -format Logic /test_bench/DUT/the_onchip_memory2_0/chipselect
add wave -noupdate -format Logic /test_bench/DUT/the_onchip_memory2_0/write
add wave -noupdate -format Literal -radix hexadecimal /test_bench/DUT/the_onchip_memory2_0/address
add wave -noupdate -format Literal -radix binary /test_bench/DUT/the_onchip_memory2_0/byteenable
add wave -noupdate -format Literal -radix hexadecimal /test_bench/DUT/the_onchip_memory2_0/readdata
add wave -noupdate -format Literal -radix hexadecimal /test_bench/DUT/the_onchip_memory2_0/writedata


configure wave -justifyvalue right
configure wave -signalnamewidth 1
TreeUpdate [SetDefaultTree]