# By default GDB will require additional user interaction when the debugging
# window is small and the output exceeds the visible area. Disable pagination so
# the command is executed directly.
set pagination off

# Load executable and reset in background.
define lr
	load
	mon reset
end

# Load executable and continue interactively.
define lc
	load
	continue
end

# Halt process running in background.
define mh
	mon halt
end

# Reset in background.
define mr
	mon reset
end

# Reset and continue interactively.
define mc
	mon reset halt
	continue
end

# Define function to enter bootloader mode with the Adafruit UF2 bootloader.
define bootl_nrf52
	set {char} 0x4000051c = 0x57
	mon reset
end

# Define function to enter bootloader mode on RP2040.
define bootl_rp2040
	mon halt
	call ((void (*)(uint32_t, uint32_t)) 0x00002591)(0, 0)
end
