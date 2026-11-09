import argparse
import os
import sys
import termios
import tty

# This script captures a bracketed paste without echoing it and writes to a file
# or standard output. This can be useful for piping my clipboard to programs
# such as "git apply" or "git am".

def main():
	parser = argparse.ArgumentParser()
	parser.add_argument("output", nargs="?")
	args = parser.parse_args()

	input_fd = sys.stdin.fileno()
	terminal_settings = termios.tcgetattr(input_fd)
	with open(os.ttyname(input_fd), "wb", buffering=0) as terminal:
		try:
			# Hide pasted text and read it without waiting for Enter.
			tty.setcbreak(input_fd, termios.TCSANOW)

			# Enable bracketed paste so pastes include start and end markers.
			terminal.write(b"\x1b[?2004h")

			# Discard input through the start marker, then capture through the
			# end marker.
			for marker in (b"\x1b[200~", b"\x1b[201~"):
				data = bytearray()
				while not data.endswith(marker):
					data.append(os.read(input_fd, 1)[0])

		# Restore normal input processing and disable bracketed paste, even if
		# reading fails or is interrupted.
		finally:
			termios.tcsetattr(input_fd, termios.TCSANOW, terminal_settings)
			terminal.write(b"\x1b[?2004l")

	# Exclude the end marker from the captured text.
	content = data[:-len(b"\x1b[201~")]

	# Write to output file if specified, otherwise write to standard output.
	if args.output is not None:
		with open(args.output, "wb") as file:
			file.write(content)
	else:
		sys.stdout.buffer.write(content)

	# Keep the byte count out of standard output so it can be piped.
	print(f"Captured {len(content)} pasted bytes", file=sys.stderr)

if __name__ == "__main__":
	main()
