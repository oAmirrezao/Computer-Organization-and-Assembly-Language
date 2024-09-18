from PIL import Image
import numpy as np

# Read the matrix from the input file (replace "input.txt" with your actual filename)
input_filename = "output.txt"
with open(input_filename, "r") as file:
    lines = file.readlines()[18:418]
    matrix = [list(map(float, line.strip().split())) for line in lines]

# Normalize the matrix to [0, 255]
matrix_normalized = np.array(matrix)
matrix_normalized -= np.min(matrix_normalized)
matrix_normalized /= np.max(matrix_normalized)
matrix_normalized *= 255

# Convert the normalized matrix to a grayscale Pillow Image
img = Image.fromarray(np.uint8(matrix_normalized), 'L')

# Save the image (replace "output_image.png" with your desired filename)
output_filename = "output_image.png"
img.save(output_filename)

print(f"Image saved as {output_filename}")

