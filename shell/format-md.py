import re
import sys

def format_file(file):
	start_of_paragraph = True
	inside_code_block = False
	inside_bullet = False

	for line in file:
		line = line.rstrip("\n")

		# Handle code block.
		if line.startswith("```"):
			inside_code_block = not inside_code_block
			print(line, end = "")
			if inside_code_block:
				print()
			continue
		if inside_code_block:
			print(line)
			continue

		# Handle bullets.
		stripped = line.lstrip()
		if stripped.startswith("- ") or re.match(r"^[0-9]+\.", stripped):
			inside_bullet = True
			if not start_of_paragraph:
				print()
			start_of_paragraph = False
			print(line, end = "")
			continue
		elif inside_bullet and line != "":
			print(" " + stripped, end = "")
			continue

		# Handle standard lines.
		if line == "":
			print()
			print()
			start_of_paragraph = True
			inside_bullet = False
		else:
			if not start_of_paragraph:
				print(" ", end = "")
			start_of_paragraph = False
			print(line, end = "")

	print()

if len(sys.argv) > 1:
	with open(sys.argv[1], "r") as file:
		format_file(file)
else:
	format_file(sys.stdin)
