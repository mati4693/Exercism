section .text
global square_root
square_root:
    ; Provide your implementation here
    ; The function has type signature int square_root(int radicand)
    ; The return value and the argument are of type int, which is a 32-bit signed integer

    xor rax, rax
    
    mov r8, 0 ; L
    mov r9, 1 ; a
    mov r10, 3 ; d

.sqrt_loop:
    cmp r9, rdi
    ja .exit

    add r9, r10
    add r10, 2
    add r8, 1
    jmp .sqrt_loop
    
.exit:
    mov eax, r8d
    ret

%ifidn __OUTPUT_FORMAT__,elf64
section .note.GNU-stack noalloc noexec nowrite progbits
%endif
