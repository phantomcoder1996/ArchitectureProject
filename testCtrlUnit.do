vsim -gui work.controlunit

add wave sim:/controlunit/*

force -freeze sim:/controlunit/PLAInput 0010000 0
force -freeze sim:/controlunit/Clk 1 0, 0 {50 ps} -r 100
force -freeze sim:/controlunit/oneoperand 0 0
force -freeze sim:/controlunit/IR_input 0000000000011001 0
run

run
run
run
run
run
run
run
run
run
run
force -freeze sim:/controlunit/PLAInput 0110110 0

force -freeze sim:/controlunit/IR_input 0010011000011001 0
run
run
run
run
run
run
run
run
force -freeze sim:/controlunit/PLAInput 0011100 0
force -freeze sim:/controlunit/IR_input 0010011100011001 0
run
run
run
run
run
run
run
run
run
run
run
run
run
force -freeze sim:/controlunit/PLAInput 0010100 0
force -freeze sim:/controlunit/IR_input 0001000100010001 0
run
run
run
run
run
run
run
run
run
force -freeze sim:/controlunit/PLAInput 0011000 0
force -freeze sim:/controlunit/IR_input 0100011001100000 0
run
run
run
run
run