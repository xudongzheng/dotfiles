import subprocess

# Git LFS doesn't provide a way to only list files in the working directory.
# This implements that.

def run_command(command):
	return subprocess.run(command.split(), capture_output=True, text=True).stdout.strip()

# Handle LFS file list only if not empty. This additional if statement is
# necessary since split() on an empty string will return an array with length 1
# instead of an empty array.
lfs_files = run_command("git lfs ls-files -n")
if lfs_files:
	prefix = run_command("git rev-parse --show-prefix")
	for file in lfs_files.split("\n"):
		if file.startswith(prefix):
			print(file[len(prefix):])
