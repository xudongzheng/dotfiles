# Define function to load new binary and restart application.
define xv
	mon reset 0
	load
	mon reset 0
	continue
end

# Define function restart application.
define xc
	mon reset 0
	continue
end
