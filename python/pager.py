#!/usr/bin/python3

import argparse
import os
import sys
import subprocess
import tempfile

def main():
	parser = argparse.ArgumentParser()
	parser.add_argument("query", nargs="*")
	parser.add_argument("--tabs", type=int, default=4)
	args = parser.parse_args()

	# If file given as argument, edit with Vim directly.
	if len(args.query) > 0:
		subprocess.run(["vim", args.query[0]])
		return

	with tempfile.NamedTemporaryFile(delete=False, mode="w") as file:
		for line in sys.stdin:
			if args.tabs > 0:
				spaces = " " * args.tabs
				line = line.replace("\t", spaces)
			file.write(line)

	with open("/dev/tty", "r") as tty:
		# Pass TTY as standard input since standard input on this process is
		# used for the content.
		command = f"call LoadPager('{file.name}')"
		subprocess.run(["vim", "-c", command], stdin=tty)

	# Delete temporary file.
	os.remove(file.name)

if __name__ == "__main__":
	main()
