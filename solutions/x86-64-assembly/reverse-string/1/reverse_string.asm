section .text
global reverse
reverse:
    ; Provide your implementation here
    ; The function has type signature void reverse(char *str)
    ; It has no return value
    ; The argument is of type char*, which is the address of a writable NUL-terminated sequence of bytes stored in memory

    xor rcx, rcx ; null iter

.null_index:
    cmp byte [rdi + rcx], 0x00
    je .null_found

    inc rcx
    jmp .null_index

.null_found:
    ;dec rcx ; account for last char being \0

    mov rax, rcx
    sar rax, 1
    dec rax

.reverse_loop:
    cmp rax, -1
    je .exit

    mov rdx, rcx
    sub rdx, rax
    dec rdx

    cmp rax, rdx
    je .skip_iter
    
    mov r8b, byte [rdi + rax]
    mov r9b, byte [rdi + rdx]

    mov byte [rdi + rax], r9b
    mov byte [rdi + rdx], r8b

.skip_iter:
    dec rax
    jmp .reverse_loop

.exit:  
    ret

%ifidn __OUTPUT_FORMAT__,elf64
section .note.GNU-stack noalloc noexec nowrite progbits
%endif
