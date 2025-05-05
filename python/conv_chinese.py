import os
import pathlib
import sys

# This scripts reads traditional Chinese on standard input and writes simplified
# Chinese to standard output. The lookup file must be manually downloaded from
# https://bit.ly/3QNdnDL.

def main():
	lookup_table = {}
	conv_file = pathlib.Path(__file__).parent / "conv_chinese.txt"
	with open(conv_file, "r") as file:
		for line in file:
			pieces = line.strip().split("\t")
			if len(pieces) != 2:
				raise Exception("failed to parse lookup table")
			traditional, simplified = pieces
			lookup_table[traditional] = simplified.split()[0]

	input_text = sys.stdin.read()
	output_text = "".join(lookup_table.get(char, char) for char in input_text)
	print(output_text, end="")

if __name__ == "__main__":
	main()
