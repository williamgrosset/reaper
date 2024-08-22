import os
import shutil
from utils import copy_directory

src_dir = os.getcwd()
dest_dir = r"C:\Program Files (x86)\World of Warcraft\_classic_era_\Interface\AddOns\Reaper"

if os.path.exists(dest_dir):
    shutil.rmtree(dest_dir)

os.makedirs(dest_dir)

copy_directory(src_dir, dest_dir, src_dir=src_dir)

print("Build complete. Addon files have been copied.")