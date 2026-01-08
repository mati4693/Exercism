section .text
global square_of_sum
square_of_sum:
    ; Provide your implementation here
    ; The function has signature int square_of_sum(int number)
    ; The return value and the argument are of type int, which is a 32-bit signed integer
    xor rax, rax
    mov rcx, rdi

.sq_sum_loop:
    add rax, rcx

    loop .sq_sum_loop

.exit:
    imul rax, rax
    ret

global sum_of_squares
sum_of_squares:
    ; Provide your implementation here
    ; The function has signature int sum_of_squares(int number)
    ; The return value and the argument are of type int, which is a 32-bit signed integer
    xor rax, rax
    mov rcx, rdi

.sum_sq_loop:
    mov r8, rcx
    imul r8, r8
    add rax, r8

    loop .sum_sq_loop

.exit:
    ret

global difference_of_squares
difference_of_squares:
    ; Provide your implementation here
    ; The function has signature int difference_of_squares(int number)
    ; The return value and the argument are of type int, which is a 32-bit signed integer
    call square_of_sum
    mov r10, rax

    call sum_of_squares
    sub r10, rax

    mov rax, r10
    ret

%ifidn __OUTPUT_FORMAT__,elf64
section .note.GNU-stack noalloc noexec nowrite progbits
%endif
