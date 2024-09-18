; computer structer project
; this project calculates the multiplication and convolution of two matrices
; professor : Dr.Jahangir
; Student : Amirreza Inanloo
; StudentID : 401105667
%include "asm_io.inc"
; section that the code places in it
segment .text

; the word global makes this part(function)
; accessible by the operating system
global asm_main

; to use following functions we most extern them
; otherwise the program won't be able to use them
; because there is no such file in this assembly code
extern putchar
extern puts
extern printf
extern scanf

; notice that read_char and putchar changes
; the value that is in xmm0 so be careful
; if you want to use this functions after 
; a vector instruction for example after read float
; safe registers are as follows
; rbx, r11, r12, r13, r14 and r15
; safe means these don't change
; when we call functions or in other situations accidentally
asm_main:
        ; number of pushes must be even
        ; otherwise it will result in segmentation fault
push rbp
push rbx
push r12
push r13
push r14
push r15

; we subtract and add rsp for alignment
sub rsp, 8

call read_int                         ;reading n. read int result will be place in rax register
mov qword[size_A], rax                    ;size_A = 2; size_A can be any positive number
        ;basicall, size_A is the size of first matrix
;we can also take this number as an input from user
        ;if user enters a number it will place in rax
;so we msut do
        ;mov qword[size_A], rax
        mov r9, rax                           ; r9 = rax = [size_A] which is 2 in this example
        mul r9                              ; rax = n(n+1)
        mov rcx, rax                        ; rcx = rax
        xor r12, r12                        ; (i)r12 = 0
input_A:
push rcx                        ; saving rcx
push rcx
call read_float                 ; reading matrix
pop rcx
pop rcx                         ; loading rcx
movss [fst_matrix + r12 * 4], xmm0 ; matrix[i] = input
inc r12                         ; i++
loop input_A


call read_int                       ;reading n
mov qword[size_B], rax                  ; n = rax
        mov r9, rax                         ; r9 = n
mul r9                              ; rax = n(n+1)
        mov rcx, rax                        ; rcx = rax
        xor r12, r12                        ; (i)r12 = 0
input_B:
push rcx                        ; saving rcx
push rcx
call read_float                 ; reading matrix
pop rcx
pop rcx                         ; loading rcx
movss [sec_matrix + r12 * 4], xmm0 ; matrix[i] = input
; move single scalar
; *4 because each element of matrix has a size of 32 bits
inc r12                         ; i++
loop input_B


        lea rdi, print_label_A; loads effective address of something in rdi to print it
; content of where rdi register points  will be print when we call print or puts
call puts

        lea rdi, fst_matrix
mov rsi, [size_A]
call print_matrix
call print_nl

        lea rdi, print_label_B
call puts

        lea rdi, sec_matrix ; loads the effective address of second matrix into rdi
mov rsi, [size_B] ; rsi = value in size_B
call print_matrix ; 
call print_nl ; prints a new line after matrix B

call transpose_B ; tranposes matrix b for multiplication
                 ; we can also multiply two matrices by converting for_i to for_j and for_j to for_i in multiplication part

RDTSCP
MOV [normal_start_time], RAX

call mul_matrix
; we used RDTSCP(read time_stamp counter and processor ID) to read
; start time and finish time of multilications with different instruction

RDTSCP
MOV [normal_end_time], RAX

        lea rdi, normal_multiply_lable
call puts

mov rdi, [normal_end_time]
sub rdi, [normal_start_time]
call print_int; content of where rdi points  will be print
call print_nl

RDTSCP
; after this rax content is time
MOV [vector_start_time], RAX

call multiplication_by_vector_instruction

RDTSCP
MOV [vector_end_time], RAX


        lea rdi, single_scalar_multiply_lable
call puts

mov rdi, [vector_end_time]
sub rdi, [vector_start_time]
call print_int
call print_nl

        lea rdi, multiply_result_lable
call puts

        lea rdi, multiplication_result
mov rsi, [size_B]
call print_matrix

call print_nl


call convolution

        lea rdi, mat3 ; loads effective addres of convolved matrix into rdi register
mov r10, [n]
sub r10, [m]
inc r10
        mov rsi, r10
call print_matrix
call print_nl

add rsp, 8

pop r15
pop r14
pop r13
pop r12
pop rbx
pop rbp

ret

read_float:
sub rsp, 8

        mov rsi, rsp
        mov rdi, read_float_format
mov rax, 1
call scanf
        movsd xmm0, qword [rsp] ; movsd(move scalar double_precision float_point value). xmm0 = [rsp]
        cvtsd2ss xmm0, xmm0; this instruction converts a double precision to single precision float number. conversion follows the IEEE 754 standard
add rsp, 8
ret

print_matrix:
push rbp
push rbx
push r12
push r13
push r14
push r15

sub rsp, 8

        mov r14, rdi
        mov rax, rsi
        mov r13, rsi
        mov r9, rax
	mul r9 ; after this instruction rax will be equal to (rax ** 2)
	       ; mul instruction multiple operand with rax and result will be store in rax
        mov rcx, rax
        xor r12, r12
output_A_res:
movss xmm0, [r14 + r12 * 4]
push rcx
push rcx
call print_float
pop rcx
pop rcx
        mov rax, rcx
        mov r10, r13
        xor rdx, rdx
dec rax
div r10
cmp rdx, 0
jne no_enter_A_res
push rcx
push rcx
call print_nl
pop rcx
pop rcx
no_enter_A_res:
inc r12
loop output_A_res
add rsp, 8

pop r15
pop r14
pop r13
pop r12
pop rbx
pop rbp

ret


print_float:
sub rsp, 8
        cvtss2sd xmm0, xmm0
        mov rdi, print_float_format
mov rax, 1
call printf
add rsp, 8
ret
transpose_B:                   ; function template
push rbp
push rbx
push r12
push r13
push r14
push r15

sub rsp, 8

mov rax, [size_B]
        mov rcx, rax
mul rcx
        mov rcx, rax
        xor r12, r12
        xor r13, r13
transpose_B_loop:
push rcx
push rcx
        mov rdi, r12
        mov rsi, r13
call convert_two_dimensional_to_one_dimensional
movss xmm0, [sec_matrix + rax * 4] ; * 4 because elements are 32bits(4 bytes)
        mov rdi, r13
        mov rsi, r12
call convert_two_dimensional_to_one_dimensional
movss [auxiliary_matrix + rax * 4], xmm0 ; 
inc r13
        mov rax, r13
mov rbx, [size_B]
        xor rdx, rdx
div rbx
cmp rax, 0
je no_action_traspose_b
mov r13, 0
inc r12
no_action_traspose_b:
pop rcx
pop rcx
loop transpose_B_loop

add rsp, 8

pop r15
pop r14
pop r13
pop r12
pop rbx
pop rbp

ret

convert_two_dimensional_to_one_dimensional:             ; calculate the index for [i][j]
push rbp
push rbx
push r12
push r13
push r14
push r15

sub rsp, 8

        mov rax, rdi            ; rax = i
mov r9, [size_A]             ; r9 = n
mul r9                  ; rax = i * (n+1)
        add rax, rsi            ; rax = i * (n+1) + j

add rsp, 8

pop r15
pop r14
pop r13
pop r12
pop rbx
pop rbp

ret

mul_matrix:                   ; function template
push rbp
push rbx
push r12
push r13
push r14
push r15

sub rsp, 8

mov rax, [size_A]
        mov rcx, rax
mul rcx
        mov rcx, rax
        xor r12, r12
        xor r13, r13
mul_outer_loop:
push rcx
push rcx
mov rax, 0
mov [result], rax
mov rcx, [size_A]
        xor r14, r14
mul_inner_loop:
push rcx
push rcx
        mov rdi, r12
        mov rsi, r14
call convert_two_dimensional_to_one_dimensional
movss xmm0, [fst_matrix + rax * 4]
        mov rdi, r14
        mov rsi, r13
call convert_two_dimensional_to_one_dimensional
movss xmm1, [sec_matrix + rax * 4]
        mulss xmm0, xmm1
movss xmm2, [result]
        addss xmm2, xmm0
movss [result], xmm2
inc r14
pop rcx
pop rcx
loop mul_inner_loop
        mov rdi, r12
        mov rsi, r13
call convert_two_dimensional_to_one_dimensional
movss xmm0, [result]
movss [multiplication_result + rax * 4], xmm0
inc r13
        mov rax, r13
mov rbx, [size_A]
        xor rdx, rdx
div rbx
cmp rax, 0
je no_action
mov r13, 0
inc r12
no_action:
pop rcx
pop rcx
loop mul_outer_loop_c
jmp end_mul_matrix
mul_outer_loop_c:
jmp mul_outer_loop


end_mul_matrix:

add rsp, 8

pop r15
pop r14
pop r13
pop r12
pop rbx
pop rbp

ret

multiplication_by_vector_instruction:                   ; function template
; pushes are for data alignment
; in vector instructions the pointer must be a coefficient of xmm size(means 16 bytes)
; we should push registers which we use in our code
push rbp
push rbx
push r12
push r13
push r14
push r15
; because c language uses xmms rsp must be a coefficient of xmm size(16 bytes)
sub rsp, 8



mov rax, [size_A]
        mov rcx, rax
mul rcx
        mov rcx, rax
        xor r12, r12
        xor r13, r13

mul_outer_loop_simd:


push rcx
push rcx
mov rax, 0
mov [result], rax

mov rax, [size_A]
mov rbx, 4
        xor rdx, rdx
div rbx
        mov rcx, rax
        mov r14, rdx

        mov rax, r12
mov rdx, [size_A]
mul rdx
        mov r8, rax

        mov rax, r13
mov rdx, [size_B]
mul rdx
        mov r9, rax

cmp rcx, 0
je no_simd
vector_instruction_inner_loop_mul:
push rcx
push rcx
vmovups xmm0, [fst_matrix + r8 * 4] ; u in vmovups is stand for unaligned if we don't use a(align) 
				    ; we must write align = 64 in front of data segment otherwise 
			            ; program will give a segmentation fault if memory address is not aligned
vmovups xmm1, [auxiliary_matrix + r9 * 4] ; vmovups writes from memory into xmm1. xmm1 is like [ , , , ]
; which has 4 data. this instruction loads in parallel data to xmm1
        vmulps xmm0, xmm1
vbroadcastss xmm2, [result]
        vaddps xmm2, xmm0
vmovups [temp], xmm2
movss xmm0, [result]
mov rcx, 4
        xor rdi, rdi
sum_for_simd_loop:
addss xmm0, [temp + rdi * 4]
add rdi, 1
loop sum_for_simd_loop

movss [result], xmm0
pop rcx
pop rcx
add r8, 4
add r9, 4
loop vector_instruction_inner_loop_mul_c
jmp no_simd
vector_instruction_inner_loop_mul_c:
jmp vector_instruction_inner_loop_mul


no_simd:
        mov rcx, r14
cmp rcx, 0
je done_cal
mul_inner_loop_not_simd:
movss xmm0, [fst_matrix + r8 * 4]
movss xmm1, [auxiliary_matrix + r9 * 4]
        mulss xmm0, xmm1
movss xmm2, [result]
        addss xmm2, xmm0
movss [result], xmm2
add r8, 1
add r9, 1
loop mul_inner_loop_not_simd
done_cal:

        mov rdi, r12
        mov rsi, r13
call convert_two_dimensional_to_one_dimensional

movss xmm0, [result]
movss [multiplication_result + rax * 4], xmm0
inc r13
        mov rax, r13
mov rbx, [size_A]
        xor rdx, rdx
div rbx
cmp rax, 0
je no_action_simd
mov r13, 0
inc r12
no_action_simd:
pop rcx
pop rcx
loop mul_outer_loop_c_simd
jmp end_multiplication_by_vector_instruction
mul_outer_loop_c_simd:
jmp mul_outer_loop_simd


end_multiplication_by_vector_instruction:

add rsp, 8

pop r15
pop r14
pop r13
pop r12
pop rbx
pop rbp

ret

convolution:
        xor rax,rax
sub     rsp, 8

        ;call read_int
mov qword[n], 400

        ;call read_int
mov qword[m], 3

        ;mov rdi , 10
        xor rsi , rsi
        mov rcx,qword[n]
for_i:
        mov rdx,qword[n]
for_j:
push rsi
push rcx
push rdx
push rdx
call read_float
pop rdx
pop rdx
pop rcx
pop rsi
movss [mat1+rsi*4], xmm0
inc rsi
dec rdx
jnz for_j
dec rsi ; fix 512
and si , 0xFE00
add rsi, 0x0200
loop for_i


        xor rsi,rsi
        mov rcx,qword[m]
for_i2:
        mov rdx,qword[m]
for_j2:
push rsi
push rcx
push rdx
push rdx
call read_float
pop rdx
pop rdx
pop rcx
pop rsi
movss [mat2+rsi*4], xmm0
inc rsi
dec rdx
jnz for_j2
dec rsi ; fix 512
and si , 0xFE00
add rsi, 0x0200
loop for_i2

        mov rdx,qword[n]
        sub rdx,qword[m]
inc rdx
        xor rcx , rcx
convolution1:

        xor r10,r10
convolution2:

        xor r11,r11
convolution3:

        xor r12,r12
convolution4:
        ; i=rcx / j=r10 / k=r11 /

        mov r13 , r11 ; r13 = k
        add r13 , rcx ; r13 = i + k
shl r13 , 9
        mov r14 , r10 ; r14 = j
        add r14 , r12 ; r14 = j + l
        add r13 , r14 ;
movss xmm0 , [mat1 + r13*4]   ; xmm0 = mat1[i+k][j+l]
        mov r13, r11 ; r13 = k
shl r13 , 9 ; shift left r13
        add r13 , r12
movss xmm1 , [mat2 + r13*4] ; xmm1 = mat2[k][l]
        mulss xmm0,xmm1 ; xmm0 = mat1[i+k][j+l] * mat2[k][l]
        mov r13 , rcx ; r13 = i
shl r13 , 9 ;
        add r13 , r10
movss xmm1 , [mat3 + r13*4]
        addss xmm1 , xmm0
movss [mat3 + r13*4], xmm1
BREAK1:
inc r12
        cmp r12,qword[m]
jl  convolution4

inc r11
        cmp r11,qword[m]
jl convolution3

inc r10
        cmp r10,rdx
jl convolution2



inc rcx
        cmp rcx, rdx
jl convolution1


        xor rsi, rsi
        mov r15 ,rdx
        mov rcx, r15
for_iii:
        mov rdx,r15
for_jjj:
push rsi
push rcx
push rdx
push rdx
movss xmm0, [mat3+rsi*4] ; rsi multiplies by 4 because size of every element in mat3 is 4 bytes(dd or double word)
call print_float
mov rdi, ' '
call putchar
pop rdx
pop rdx
pop rcx
pop rsi
inc rsi
dec rdx
jnz for_jjj ; if rdx != 0 jump to for_jjj
push rsi
push rcx
push rdx
push rdx
mov rdi, 10
call putchar
pop rdx
pop rdx
pop rcx
pop rsi
dec rsi
and si , 0xFE00
add rsi, 0x0200
loop for_iii
add     rsp, 8
ret

; section that our datas place in it
; thiese datas are located in memory
; if we don't use aligh=64 and use movups
; the program will result in segmentation fault
segment .data align=64
read_float_format:  db   "%lf", 0
print_float_format: db  "%.2lf ", 0
print_label_A:  db  "matrix A: ", 0
print_label_B:  db  "matrix B: ", 0
normal_multiply_lable:  db   "normal multiplication elapsed time: ", 0
single_scalar_multiply_lable:   db    "vector instructinos multiplication elapsed time: ", 0
multiply_result_lable:  db  "matrix A*B: ", 10, 0
normal_start_time: dq 0
normal_end_time: dq 0
vector_start_time: dq 0
vector_end_time: dq 0
temp: times 4 dq 0
size_A: dq 0
size_B: dq 0
eight: dq 8
two: dq 2
four: dq 4
result: dq 0
multiplication_result: times 0x40000 dq 0
fst_matrix: times 0x40000 dq 0
sec_matrix: times 0x40000 dq 0
auxiliary_matrix: times 0x40000 dq 0
matrix_convolve: times 100 dq 0
n:  dq 0
m:  dq 0
mat1:
dd 0x40000 DUP (0.0)    ;ox40000 is equal to 512 * 512. which is equal to maximum elements which can be place in an array in x86
                        ; this code duplicates ox40000 homes of memory for mat1
mat2:
dd 0x40000 DUP (0.0)
mat3:   ;mat3 is convolution matrix which has been made of mat1 and mat2(kernel matrix)
dd 0x40000 DUP (0.0)
