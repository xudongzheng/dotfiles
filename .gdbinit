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

# Define function to enter bootloader mode on RP2040. See
# https://bit.ly/4mhgIJn.
define bootl_rp2040
	mon halt
	set $pc = 0x2591
	set $r0 = 0
	set $r1 = 0
	continue
end

# When calling nvsclear and its derivatives from the GDB command line, the
# string argument must be quoted.
define nvsclear
	mon halt
	mon flash erase_address $arg0 $arg1
	if ((int) strcmp($arg2, "lr") == 0)
		lr
	end
	if ((int) strcmp($arg2, "mr") == 0)
		mr
	end
end

# Define function to halt and erase the storage partition for nRF52833.
define nvsclear_nrf52833
	nvsclear 0x6d000 0x7000 $arg0
end

# Define function to halt and erase the storage partition for nRF52840.
define nvsclear_nrf52840
	nvsclear 0xea000 0xa000 $arg0
end
