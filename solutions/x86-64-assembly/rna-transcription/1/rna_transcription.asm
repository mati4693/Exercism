section .text
global to_rna
to_rna:
    ; Provide your implementation here
    ; The function has type signature void to_rna(const char *strand, char *buffer)
    ; It has no return value
    ; The first argument is of type const char*, which is the address of a read-only NUL-terminated sequence of bytes stored in memory
    ; The second argument is of type char*, which is the address of a writable sequence of bytes stored in memory

    xor rcx, rcx; iter

.to_rna_loop:
    cmp byte [rdi + rcx], 0x00
    je .done

    mov rdx, 'C' ; rna equivalent
    cmp byte [rdi + rcx], 'G'
    cmove rax, rdx

    mov rdx, 'G' ; rna equivalent
    cmp byte [rdi + rcx], 'C'
    cmove rax, rdx

    mov rdx, 'A' ; rna equivalent
    cmp byte [rdi + rcx], 'T'
    cmove rax, rdx

    mov rdx, 'U' ; rna equivalent
    cmp byte [rdi + rcx], 'A'
    cmove rax, rdx

    mov byte [rsi + rcx], al

    inc rcx
    jmp .to_rna_loop

.done:
    mov byte [rsi + rcx], 0x00 ; add null terminator
    ret

%ifidn __OUTPUT_FORMAT__,elf64
section .note.GNU-stack noalloc noexec nowrite progbits
%endif
