import argparse
import os
import re
import sys

import format_md

def grep_replace_color(match):
	return "\x1b[1;31m" + match.group(0) + "\x1b[0m"

def grep_markdown_file(file_path, file, query):
	output = format_md.format_file(file)
	lines = output.splitlines()
	for line in lines:
		if re.search(query, line):
			# Print without color if standard output is not a terminal.
			if not sys.stdout.isatty():
				print(f"{file_path}:{line}")
				continue

			# Output with same colors as grep.
			print(f"\x1b[35m{file_path}\x1b[0m", end = "")
			print("\x1b[36m:\x1b[0m", end = "")
			print(re.sub(query, grep_replace_color, line))

if __name__ == "__main__":
	parser = argparse.ArgumentParser()
	parser.add_argument("query", nargs="*")
	parser.add_argument("-i", "--ignore-case", action="store_true")
	parser.add_argument("-w", "--word-regexp", action="store_true")
	args = parser.parse_args()

	query = " ".join(args.query)
	if query == "":
		sys.exit(0)
	if args.word_regexp:
		query = r"\b" + re.escape(query) + r"\b"
	if args.ignore_case:
		query = "(?i)" + query

	files = [line.strip() for line in sys.stdin]
	for file_path in files:
		with open(file_path, "r") as file:
			grep_markdown_file(file_path, file, query)
