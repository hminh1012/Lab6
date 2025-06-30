add wave -noupdate -divider {cpu_0: top-level ports}
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

configure wave -justifyvalue right
configure wave -signalnamewidth 1
TreeUpdate [SetDefaultTree]
