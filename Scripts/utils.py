import os
import shutil
import fnmatch

INCLUDE_PATTERNS = [
    "*.lua",
    "*.xml",
    "*.toc",
    "*.tga",
    "*.ogg",
    "README.md",
    "LICENSE"
]

EXCLUDE_PATTERNS = [
    ".git",
    "Scripts",
    "Releases"
]

def matches_include_patterns(file_path, patterns=INCLUDE_PATTERNS):
    for pattern in patterns:
        if fnmatch.fnmatch(file_path, pattern):
            return True
    return False

def matches_exclude_patterns(file_path, patterns=EXCLUDE_PATTERNS):
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

def copy_directory(src, dest, include_patterns=INCLUDE_PATTERNS, exclude_patterns=EXCLUDE_PATTERNS, src_dir=None):
    if not os.path.exists(dest):
        os.makedirs(dest)
    for item in os.listdir(src):
        src_path = os.path.join(src, item)
        dest_path = os.path.join(dest, item)
        relative_path = os.path.relpath(src_path, src_dir)
        if matches_exclude_patterns(relative_path, exclude_patterns):
            continue
        if os.path.isdir(src_path):
            copy_directory(src_path, dest_path, include_patterns, exclude_patterns, src_dir)
        else:
            if matches_include_patterns(relative_path, include_patterns):
                if not os.path.exists(os.path.dirname(dest_path)):
                    os.makedirs(os.path.dirname(dest_path))
                copy_file(src_path, dest_path)