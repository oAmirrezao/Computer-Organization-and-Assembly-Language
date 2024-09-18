# Computer-Organization-and-Assembly-Language
X86_assembly_project

### Project Overview:
A program in Assembly language that can perform the following tasks:

1.Multiplication of two matrices using standard x86 Assembly instructions.
2.Multiplication of two matrices using vector (parallel) x86 Assembly instructions.
3.Calculation of the convolution matrix of two matrices (one as the image matrix and the other as the kernel matrix).
4.Demonstration of a practical application of matrix convolution, specifically in the context of image processing for this project.


### How to Work with the Program:
## 1.Run imgToMat.py file: Execute the following command:

```
python3 imgToMat.py
```
This file takes an image as input and resizes it to the desired pixel dimensions (e.g., 200x200). In the provided version, the input image is embedded in the code, so there's no need to provide an input image. The script converts the image into a matrix of the same dimensions and writes the data into a text file called input.txt.

## 2.Disassemble the Assembly file: Run the following command:


```
./run.sh template <input.txt >output.txt
```
If you are running the run.sh file for the first time, you need to execute the following command beforehand:


```
chmod +x ./run.sh
```
This command takes the contents of input.txt as input for the Assembly code, and the output of the program is written to another text file called output.txt. The output file contains the result of multiplying two matrices, followed by the result of the convolution of two other matrices (the matrices are the ones generated from imgToMat.py and stored in input.txt).

## 3.Run matToImg.py to convert the matrix back to an image: Execute the following command:

bash
Copy code
```
python3 matToImg.py
```
This script reads the convolution matrix from the output.txt file and converts it into the desired image, saving the generated image in a file called output_image.png.

## 4.View the generated image: Use an appropriate image viewer to display the output image. Some recommended image viewers include imviewer and nomacs. You can install nomacs using the following command:

```
sudo apt install nomacs
```
After installation, you can view the image using the following command:


```
nomacs output_image.png
```


# Project Files

## 1. `asm_io.asm`
Contains various assembly functions for handling input and output.

## 2. `Flower.jpg`
The target image on which transformations will be applied.

## 3. `matToImg.py`
A Python script that converts a matrix into an image.

## 4. `resized.jpg`
The resized image with the desired dimensions, generated by the `imgToMat.py` file.

## 5. `Template.asm`
The main assembly code. This file contains several functions for input and output, as well as functions for standard and vectorized matrix multiplication.

## 6. `Asm_io.inc`
Externalizes the input and output functions.

## 7. `driver.c`
A C file that calls the required assembly code (`template.asm`).

## 8. `imgToMat.py`
A Python script that converts the target image into a matrix.

## 9. `output.txt`
A text file containing the outputs of the assembly code (`template.asm`).

## 10. `run.sh`
A script that compiles the C code and runs the assembly code.

## 11. `Template.o`
The object file generated from `template.asm`.

## 12. `Asm_io.o`
The object file generated from `asm_io.asm`.

## 13. `Driver.o`
The object file generated from the C code (`driver.c`).

## 14. `input.txt`
A text file containing the inputs required for the assembly code.

## 15. `output_image.png`
The image produced after processing.

## 16. `Template`
The executable file generated from `template.asm`.


### Kernel Matrices Suitable for Various Purposes

![image](https://github.com/user-attachments/assets/bfb12c43-0f2d-4032-bc0b-d227780f3ba4)


![image](https://github.com/user-attachments/assets/fbd129ee-78f7-4558-8971-e2c0117c97ee)

### Visual Representation of Program Execution

![Screenshot 2024-02-11 225743](https://github.com/user-attachments/assets/860dab20-ffb5-457b-b08d-9788994f3ad4)

