import argparse
import os
import sys
import urllib.parse

def generate_index(output, dirs, sort):
	# If output file already exists, check that it contains the magic token to
	# avoid unintentionally overwriting an unrelated file.
	magic = "<!-- 802b3fdf -->"
	if os.path.exists(output):
		with open(output, "r") as file:
			if magic not in file.read():
				print(f"{output} must be deleted manually")
				sys.exit()

	# Construct array of files.
	all_files = []
	for dir_path in dirs:
		for root, _, filenames in os.walk(dir_path):
			for filename in filenames:
				file_path = os.path.join(root, filename)
				if sort == "size":
					file_size = os.path.getsize(file_path)
					all_files.append((file_path, file_size))
				elif sort == "date":
					mod_time = os.path.getmtime(file_path)
					all_files.append((file_path, mod_time))
				elif sort == "name":
					all_files.append((file_path, file_path))

	# Sort files based on the sorting parameter.
	all_files.sort(key=lambda x: x[1])
	sorted_files = [file_path[0] for file_path in all_files]

	with open(output, "w") as file:
		file.write(f"{magic}\n")
		file.write("<!doctype html>\n")
		file.write("<title>Generated Index</title>\n")
		for file_path in sorted_files:
			html_path = urllib.parse.quote(file_path)
			_, file_ext = os.path.splitext(file_path)
			if file_ext in [".gif", ".jpg", ".jpeg", ".png", ".svg", ".webp"]:
				file.write(f"<a href='{html_path}' target='_blank'><img src='{html_path}' width='600'></a>\n")
			elif file_ext in [".mov", ".mp4", ".webm"]:
				file.write(f"<video width='600' controls loop muted><source src='{html_path}' type='video/mp4'></video>\n")

if __name__ == "__main__":
	parser = argparse.ArgumentParser()
	parser.add_argument("dirs", nargs="*", default=["."])
	parser.add_argument("-o", "--output", type=str, default="index.html")
	parser.add_argument("-s", "--sort", type=str, choices=["size", "name", "date"], default="name")
	args = parser.parse_args()

	generate_index(args.output, args.dirs, args.sort)
