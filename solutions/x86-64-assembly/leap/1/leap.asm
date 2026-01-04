section .text
global leap_year
leap_year:
    ; Provide your implementation here
    ; The function has type signature int leap_year(int year)
    ; The return value and the argument are of type int, which is a 32-bit signed integer
    mov r10, 1
    
    mov rax, rdi
    mov rcx, 4
    cqo
    idiv rcx
    
    cmp rdx, 0
    cmove r8, r10
    jne .not_leap

    mov rax, rdi
    mov rcx, 100
    cqo
    idiv rcx

    mov r9, 0
    cmp rdx, 0
    cmovne r9, r10
    add r8, r9

    mov rax, rdi
    mov rcx, 400
    cqo
    idiv rcx
    
    mov r9, 0
    cmp rdx, 0
    cmove r9, r10
    add r8, r9

    mov rax, 0
    cmp r8, 2
    cmovae rax, r10

    ret

.not_leap:
    mov ax, 0
    ret

%ifidn __OUTPUT_FORMAT__,elf64
section .note.GNU-stack noalloc noexec nowrite progbits
%endif
