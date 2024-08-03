import os
import shutil
import fnmatch

src_dir = os.getcwd()
dest_dir = r"C:\Program Files (x86)\World of Warcraft\_classic_era_\Interface\AddOns\Reaper"

include_patterns = [
    "*.lua",
    "*.xml",
    "*.toc",
    "*.tga",
    "*.ogg",
    "README.md",
    "LICENSE"
]

exclude_patterns = [
    ".git",
    "Scripts"
]

def matches_include_patterns(file_path, patterns):
    for pattern in patterns:
        if fnmatch.fnmatch(file_path, pattern):
            return True
    return False

def matches_exclude_patterns(file_path, patterns):
    for pattern in patterns:
        if fnmatch.fnmatch(file_path, pattern):
            return True
    return False

def copy_file(src, dest):
    try:
        shutil.copy2(src, dest)
    except IOError as e:
        print(f"Unable to copy file {src} to {dest}. {e}")
    except Exception as e:
        print(f"Unexpected error while copying file {src} to {dest}: {e}")

def copy_directory(src, dest, include_patterns, exclude_patterns):
    if not os.path.exists(dest):
        os.makedirs(dest)
    for item in os.listdir(src):
        src_path = os.path.join(src, item)
        dest_path = os.path.join(dest, item)
        relative_path = os.path.relpath(src_path, src_dir)
        if matches_exclude_patterns(relative_path, exclude_patterns):
            continue
        if os.path.isdir(src_path):
            copy_directory(src_path, dest_path, include_patterns, exclude_patterns)
        else:
            if matches_include_patterns(relative_path, include_patterns):
                if not os.path.exists(os.path.dirname(dest_path)):
                    os.makedirs(os.path.dirname(dest_path))
                copy_file(src_path, dest_path)

if os.path.exists(dest_dir):
    shutil.rmtree(dest_dir)

os.makedirs(dest_dir)

copy_directory(src_dir, dest_dir, include_patterns, exclude_patterns)

print("Build complete. Addon files have been copied.")
