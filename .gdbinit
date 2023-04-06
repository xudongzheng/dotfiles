# Define function to load new binary and restart application.
define xv
	mon reset halt
	load
	continue
end

# Define function to restart application.
define xc
	mon reset halt
	continue
end
