import sys
from PIL import Image
import math
import os

def split_image(path, out_dir, tile_size=512):
    img = Image.open(path).convert("RGBA")
    w, h = img.size
    os.makedirs(out_dir, exist_ok=True)

    for y in range(0, h, tile_size):
        for x in range(0, w, tile_size):
            box = (x, y, min(x + tile_size, w), min(y + tile_size, h))
            tile = img.crop(box)
            padded = Image.new("RGBA", (tile_size, tile_size), (0, 0, 0, 0))
            padded.paste(tile, (0, 0))
            padded.save(os.path.join(out_dir, f"tile_{x}_{y}.png"))

def reassemble_image(out_path, in_dir, orig_w, orig_h, tile_size=512):
    new_img = Image.new("RGBA", (math.ceil(orig_w / tile_size) * tile_size,
                                 math.ceil(orig_h / tile_size) * tile_size),
                        (0, 0, 0, 0))

    for file in os.listdir(in_dir):
        if not file.endswith(".png"):
            continue
        parts = file.replace(".png", "").split("_")
        x, y = int(parts[1]), int(parts[2])
        tile = Image.open(os.path.join(in_dir, file)).convert("RGBA")
        new_img.paste(tile, (x, y), tile)

    new_img.save(out_path)









# main stuff
if __name__ == "__main__":
    if len(sys.argv) < 2:
        print("Usage:")
        print("   segment.exe split <image_path> <output_dir> [tile_size]")
        print("   segment.exe reassemble <output_path> <input_dir> <orig_w> <orig_h> [tile_size]")
        sys.exit(1)

    command = sys.argv[1].lower()

    if command == "split":
        if len(sys.argv) < 4:
            print("Usage:  segment.exe split <image_path> <output_dir> [tile_size]")
            sys.exit(1)
        path = sys.argv[2]
        out_dir = sys.argv[3]
        tile_size = int(sys.argv[4]) if len(sys.argv) > 4 else 512
        split_image(path, out_dir, tile_size)

    elif command == "reassemble":
        if len(sys.argv) < 6:
            print("Usage:  segment.exe reassemble <output_path> <input_dir> <orig_w> <orig_h> [tile_size]")
            sys.exit(1)
        out_path = sys.argv[2]
        in_dir = sys.argv[3]
        orig_w = int(sys.argv[4])
        orig_h = int(sys.argv[5])
        tile_size = int(sys.argv[6]) if len(sys.argv) > 6 else 512
        reassemble_image(out_path, in_dir, orig_w, orig_h, tile_size)

    else:
        print(f"Unknown command: {command}")
        sys.exit(1)
