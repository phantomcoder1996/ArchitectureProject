vsim -gui work.romsequencingcircuit

add wave sim:/romsequencingcircuit/*

force -freeze sim:/romsequencingcircuit/PLAInput 0010000 0
force -freeze sim:/romsequencingcircuit/Clk 1 0, 0 {50 ps} -r 100
force -freeze sim:/romsequencingcircuit/rst 1 0
force -freeze sim:/romsequencingcircuit/oneoperand 0 0
force -freeze sim:/romsequencingcircuit/endi 0 0
force -freeze sim:/romsequencingcircuit/IR_input 0000000000011001 0
run

force -freeze sim:/romsequencingcircuit/rst 0 0

run
run
run
force -freeze sim:/romsequencingcircuit/ROMout 001 0
run
force -freeze sim:/romsequencingcircuit/ROMout 000 0
run
run
run
force -freeze sim:/romsequencingcircuit/ROMout 011 0
run
force -freeze sim:/romsequencingcircuit/ROMout 000 0
run
run
force -freeze sim:/romsequencingcircuit/rst 1 0
run
force -freeze sim:/romsequencingcircuit/rst 0 0
run
force -freeze sim:/romsequencingcircuit/endi 1 0
run
force -freeze sim:/romsequencingcircuit/endi 0 0
run
run