ERROR_VALUE equ -1

section .text
global steps
steps:
    ; Provide your implementation here
    ; The function has type signature int steps(int number)
    ; The return value and the argument are of type int, which is a 32-bit signed integer type
    xor rax, rax
    mov r8, 0

.collatz_loop:
    cmp edi, 1
    je .done
    jl .error

    mov r9d, edi
    and r9d, 1
    jz .even

    inc r8
    imul edi, 3
    inc edi
    jmp .collatz_loop

.even:
    inc r8
    sar edi, 1
    jmp .collatz_loop

.done:
    mov eax, r8d
    ret

.error:
    mov eax, -1
    ret

%ifidn __OUTPUT_FORMAT__,elf64
section .note.GNU-stack noalloc noexec nowrite progbits
%endif
