# Computer-Organization-and-Assembly-Language
X86_assembly_project

Project Overview:
A program in Assembly language that can perform the following tasks:

1.Multiplication of two matrices using standard x86 Assembly instructions.
2.Multiplication of two matrices using vector (parallel) x86 Assembly instructions.
3.Calculation of the convolution matrix of two matrices (one as the image matrix and the other as the kernel matrix).
4.Demonstration of a practical application of matrix convolution, specifically in the context of image processing for this project.


### How to Work with the Program:
## 1.Run imgToMat.py file: Execute the following command:

bash
Copy code
python3 imgToMat.py
This file takes an image as input and resizes it to the desired pixel dimensions (e.g., 200x200). In the provided version, the input image is embedded in the code, so there's no need to provide an input image. The script converts the image into a matrix of the same dimensions and writes the data into a text file called input.txt.

## 2.Disassemble the Assembly file: Run the following command:

bash
Copy code
./run.sh template <input.txt >output.txt
If you are running the run.sh file for the first time, you need to execute the following command beforehand:

bash
Copy code
chmod +x ./run.sh
This command takes the contents of input.txt as input for the Assembly code, and the output of the program is written to another text file called output.txt. The output file contains the result of multiplying two matrices, followed by the result of the convolution of two other matrices (the matrices are the ones generated from imgToMat.py and stored in input.txt).

## 3.Run matToImg.py to convert the matrix back to an image: Execute the following command:

bash
Copy code
python3 matToImg.py
This script reads the convolution matrix from the output.txt file and converts it into the desired image, saving the generated image in a file called output_image.png.

## 4.View the generated image: Use an appropriate image viewer to display the output image. Some recommended image viewers include imviewer and nomacs. You can install nomacs using the following command:

**bash**
```Copy code
sudo apt install nomacs
After installation, you can view the image using the following command:
```
bash
Copy code
nomacs output_image.png


