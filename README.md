# ccd_register
Verilog HDL Cross Clock Domain Register

There are (at least) two clock domain crossing issues: metastability and data loss. Metastability happens when a signal changes state too close to the active edge of a clock and violates the setup or hold time. Data loss then occurs when metastability causes the destination domain to latch incorrect source data.

This project is basically a one byte FIFO with independent clocks for the write port and the read port. By using cross clock domain handshaking, the destination domain can be guaranteed to read valid data. Also, the source domain can guarantee the data has been read before writing new information.

The sequence of events is very simple. Writing to the register sets the Busy flag. The source domain should not write to the register while the Busy flag is asserted. The Busy flag is synchronized to the destination domain and appears as a Ready flag. Reading the register clears the Ready flag. This event is then synchronized back to the source domain, which clears the Busy flag. Reading from the register while the Ready flag is not set may return indeterminate results if there happens to be a concurrent write.

If you happen to be simulating with Icarus Verilog on Windows, then you may find make.bat and testbench.gtkw useful.
