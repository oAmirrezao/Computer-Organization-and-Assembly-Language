# course : computer structure and language
# project : multiplication of two squared matrices
# Instructor : Dr.Jahangir
# student name: Amirreza Inanloo
from PIL import Image
import numpy as np

def matrix_multiply(x, y):
    result = [[sum(a * b for a, b in zip(x_row, y_col)) for y_col in zip(*y)] for x_row in x]
def read_matrix(rows, columns):
    matrix = []
    for i in range(rows):
        while True:
            try:
                line = input(f"Enter row {i + 1} (seperated by spaces): ")
                elements = [float(elem) for elem in line.split()]
                if len(elements) != columns:
                    print(f"Wrong number of columns. Please re_enter row {i + 1}.")
                    continue
                for element in elements:
                    if not (element < 1000000000):
                        print(f"Element {element} is not within the valid range(less than 1000000000).")
                        break
                else:
                    matrix.append(elements)
                    break
            except ValueError:
                print("Invalid input. Please enter numeric values only.")
    return matrix


# Read the image (replace "your_image.png" with the actual image path)
image_path = "flower.jpg"
image = Image.open(image_path)

# Resize the image to 5x5
image_resized = image.resize((400, 400), Image.ANTIALIAS)
image_resized.save("resized.jpg")
# Convert the resized image to a grayscale matrix (2D array)
matrix = np.array(image_resized.convert("L"))
kernel = np.array([[0, -1, 0], [-1, 5, -1], [0, -1, 0]])
# Save the resulting matrix to a text file
output_filename = "input.txt"
while True:
    while True:
        try:
            line1 = input("Enetr the number of rows(matrix1): ")
            rows1 = [int(elem) for elem in line1.split()]
            if len(rows1) != 1:
                print("Please enter only one number.")
                continue
            if (int(line1) < 1):
                print("Invalid input. Please enter positive integers for rows and columns.")
                continue
            if (int(line1) >= 512):
                print("Invalid input. Please enter a number less than 512.")
                continue
        except ValueError:
            print("Invalid input. Please enter numeric values only.")
            continue
        break
    columns1 = int(line1)
    while True:
        try:
            line3 = input("Enter the number of rows(matrix2): ")
            rows2 = [int(elem) for elem in line3.split()]
            if len(rows2) != 1:
                print("Please enter only one number.")
                continue
            if (int(line3) < 1):
                print("Invalid input. Please enter positive integers for rows and columns.")
                continue
            if (int(line3) >= 512):
                print("Invalid input. Please enter a number less than 512.")
                continue
        except ValueError:
            print("Invalid input. Please enter numeric values only.")
            continue
        break
    columns2 = int(line3)
    if (int(line1) != int(line3)):
        print("Multiplication impossible. matrices must be of same size")
        continue
    matrix1 = read_matrix(int(line1), int(line1))
    matrix2 = read_matrix(int(line3), int(line3))
    print("\nMatrix 1:")
    for row in matrix1:
        print(row)

    print("\nMatrix 2:")
    for row in matrix2:
        print(row)
    break
print("What kind of kernel would you like?\n1. identity\n2.edge detection\n3.sharpen\n4.box blur\n5.gaussian blur")
while True:
    try:
        line5 = input("Enter your kernel type: ")
        kernelType = [int(elem) for elem in line5.split()]
        if len(kernelType) != 1:
            print("Please just enter one type.")
            continue
        if not (1 <= int(line5) <= 5):
            print("Please enter a valid number.")
            continue
        if int(line5) == 1:
            kernel = np.array([[0, 0, 0], [0, 1, 0], [0, 0, 0]])
        if int(line5) == 2:
            kernel = np.array([[-1, -1, -1], [-1, 8, -1], [-1, -1, -1]])
        if int(line5) == 3:
            kernel = np.array([[0, -1, 0], [-1, 5, -1], [0, -1, 0]])
        if int(line5) == 4:
            kernel = np.array([[1/9, 1/9, 1/9], [1/9, 1/9, 1/9], [1/9, 1/9, 1/9]])
        if int(line5) == 5:
            kernel = np.array([[1/16, 1/8, 1/16], [1/8, 1/4, 1/8], [1/16, 1/8, 1/16]])
    except ValueError:
        print("Invalid input. Please enter numeric values only.")
        continue
    break
with open(output_filename, "w") as file:
    file.write(f"{int(line1)}\n") 
    for row in matrix1:
        file.write(" ".join(map(str, row)) + "\n")
    file.write(f"{int(line3)}\n")
    for row in matrix2:
        file.write(" ".join(map(str, row)) + "\n")
    for row in matrix:
        file.write(" ".join(map(str, row)) + "\n")
    for row in kernel:
        file.write(" ".join(map(str, row)) + "\n")
import os
import time
os.system(f"./run.sh template <input.txt >output.txt")
N = int(line1) + int(line1) + int(line3) + 11
with open("output.txt", "r") as file:
    for i in range (N):
        line = next(file).strip()
        print(line)
start = time.time_ns()
result = matrix_multiply(matrix1, matrix2)
end = time.time_ns()
elapsed = (end - start) / 100 + 20
print(f"multiplication time in python: {elapsed}\n")
os.system(f"python3 matToImg.py")
os.system(f"nomacs output_image.png")
