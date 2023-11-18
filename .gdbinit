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

# Reset in background.
define mr
	mon reset
end

# Reset and continue interactively.
define mc
	mon reset halt
	continue
end
