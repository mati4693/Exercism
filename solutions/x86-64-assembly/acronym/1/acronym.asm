section .text
global abbreviate
abbreviate:
    ; Provide your implementation here
    ; rdi - char * in - read
    ; rsi - char * out - write result, assume length 0x100

    mov r8, rdi ; save rdi for later
    xor rdi, rdi

    xor rcx, rcx ; rcx is input iter
    xor rdx, rdx ; rdx is output iter

    ; take first char
    mov dil, [r8]
    call upper

    ; save first char
    mov byte [rsi], dil
    
    inc rcx
    inc rdx

.abbreviate_loop:

    mov dil, [r8+rcx]

    call is_char
    
    cmp rax, 1 ; check if is_char result is true
    jne .abbreviate_skip_char

    mov rax, 0
    
    cmp byte [r8+rcx-1], 0x20 ; check for space in char before
    cmove rax, rdi

    cmp byte [r8+rcx-1], 0x2D ; check for hyphen in char before
    cmove rax, rdi

    cmp byte [r8+rcx-1], 0x5F ; check for underscore in char before
    cmove rax, rdi

    cmp rax, rdi ; check if dil has been moved to rax
    jne .abbreviate_skip_char

    call upper
    
    mov [rsi+rdx], dil
    inc rdx
    
.abbreviate_skip_char:
    test dil, dil
    jz .abbreviate_loop_done
    
    inc rcx
    jmp .abbreviate_loop
    
.abbreviate_loop_done:
    mov byte [rsi+rdx], 0x00 ; add null char
    ret

is_char:
    mov rax, 0

    cmp dil, 0x41 ; 0x41 is A
    jl .not_char

    cmp dil, 0x5F ; 0x5F is _
    je .not_char

    mov rax, 1

.not_char:
    ret

upper:
    cmp dil, 0x5A ; 0x5A is Z
    jle .skip_upper

    cmp dil, 0x5F ; 0x5F is _
    je .skip_upper

    sub dil, 32
    
.skip_upper:
    ret

%ifidn __OUTPUT_FORMAT__,elf64
section .note.GNU-stack noalloc noexec nowrite progbits
%endif
