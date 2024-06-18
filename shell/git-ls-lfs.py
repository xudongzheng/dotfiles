import subprocess

# Git LFS doesn't provide a way to only list files in the working directory.
# This implements that.

def run_command(command):
	return subprocess.run(command.split(), capture_output=True, text=True).stdout.strip()

lfs_files = run_command("git lfs ls-files -n").split("\n")
prefix = run_command("git rev-parse --show-prefix")
for file in lfs_files:
    if file.startswith(prefix):
        print(file[len(prefix):])
