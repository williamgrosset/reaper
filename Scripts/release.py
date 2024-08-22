import os
import shutil
import zipfile
import sys
import subprocess
from utils import copy_directory

src_dir = os.getcwd()
dest_dir = r"C:\Program Files (x86)\World of Warcraft\_classic_era_\Interface\AddOns\Reaper"
release_dir = os.path.join(src_dir, "Releases")
toc_file = os.path.join(src_dir, "Reaper.toc")

def update_version_in_toc(version):
    try:
        with open(toc_file, 'r') as file:
            lines = file.readlines()
        
        with open(toc_file, 'w') as file:
            for line in lines:
                if line.startswith("## Version:"):
                    file.write(f"## Version: {version}\n")
                else:
                    file.write(line)
        print(f"Version updated to {version} in {toc_file}")
    except Exception as e:
        print(f"Failed to update version in {toc_file}: {e}")
        sys.exit(1)

def create_zip_archive(version):
    zip_filename = os.path.join(release_dir, f"Reaper-v{version}.zip")
    with zipfile.ZipFile(zip_filename, 'w', zipfile.ZIP_DEFLATED) as zipf:
        reaper_dir = "Reaper"
        for root, dirs, files in os.walk(dest_dir):
            for file in files:
                abs_file_path = os.path.join(root, file)
                rel_file_path = os.path.relpath(abs_file_path, dest_dir)
                zipf.write(abs_file_path, os.path.join(reaper_dir, rel_file_path))
    print(f"Created archive: {zip_filename}")

def git_operations(version):
    try:
        subprocess.run(["git", "add", "."], check=True)
        subprocess.run(["git", "commit", "-m", f"v{version}"], check=True)
        subprocess.run(["git", "tag", f"v{version}"], check=True)
        subprocess.run(["git", "push"], check=True)
        subprocess.run(["git", "push", "--tags"], check=True)
        print(f"Git operations completed: committed, tagged, and pushed as v{version}")
    except subprocess.CalledProcessError as e:
        print(f"Git operation failed: {e}")
        sys.exit(1)

def main():
    if len(sys.argv) != 2:
        print("Usage: release.py <version>")
        sys.exit(1)

    version = sys.argv[1]

    # Update version in .toc file
    update_version_in_toc(version)

    # Clean build destination directory and copy files
    if os.path.exists(dest_dir):
        shutil.rmtree(dest_dir)
    os.makedirs(dest_dir)
    copy_directory(src_dir, dest_dir, src_dir=src_dir)

    # Create releases directory
    if not os.path.exists(release_dir):
        os.makedirs(release_dir)

    # Create .zip archive
    create_zip_archive(version)

    # Run git operations (add, commit, tag, push)
    git_operations(version)

    print("Release process completed successfully.")

if __name__ == "__main__":
    main()