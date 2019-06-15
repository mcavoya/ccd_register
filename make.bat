@prompt $g
@path = C:\iverilog\bin;C:\iverilog\gtkwave\bin

rem clean
@del *.sim
@del *.lxt

rem compile and simulate
iverilog -o testbench.sim testbench.v ccd_register.v
vvp testbench.sim -lxt2

rem view waveforms
gtkwave testbench.lxt testbench.gtkw
rem pause
