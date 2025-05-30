import re
import sys

def format_file(file):
	start_of_paragraph = True
	inside_code_block = False
	inside_bullet = False
	inside_quote = False

	output = ""
	for line in file:
		line = line.rstrip(" \n")

		# Handle code block.
		if start_of_paragraph or inside_code_block:
			if line.startswith("```"):
				inside_code_block = not inside_code_block
				output += line
				if inside_code_block:
					output += "\n"
				continue
			if inside_code_block:
				output += line + "\n"
				continue

		# Handle bullets.
		stripped = line.lstrip()
		if start_of_paragraph or inside_bullet:
			if stripped.startswith("- ") or re.match(r"^[0-9]+\. ", stripped):
				inside_bullet = True
				if not start_of_paragraph:
					output += "\n"
				start_of_paragraph = False
				output += line
				continue
			if inside_bullet and line != "":
				output += " " + stripped
				continue

		# Handle quotes
		if start_of_paragraph or inside_quote:
			if line.startswith("> "):
				if inside_quote:
					output += " " + stripped.removeprefix("> ")
				else:
					output += stripped
					inside_quote = True
				continue
			elif inside_quote and line != "":
				output += " " + stripped
				continue

		# Handle standard lines.
		if line == "":
			output += "\n\n"
			start_of_paragraph = True
			inside_quote = False
			inside_bullet = False
		else:
			if not start_of_paragraph:
				output += " "
			start_of_paragraph = False
			output += stripped

	return output

def main():
	if len(sys.argv) > 1:
		with open(sys.argv[1], "r") as file:
			print(format_file(file))
	else:
		print(format_file(sys.stdin))

if __name__ == "__main__":
	main()
