create_clock -period 20ns -name CLOCK_50 [get_ports CLOCK_50]
derive_pll_clocks
derive_clock_uncertainty