default rel

section .data
    curr_string dq 0, 0 ; 16 bytes long
    pling db "Pling"
    plang db "Plang"
    plong db "Plong"

section .text
global convert

convert:
    ; Provide your implementation here
    ; rdi: (int) number
    ; rsi: (char*) buffer

    mov r9, 0 ; bool if num is divisible
    mov r8, 0 ; store number
    
    ; switch params for easier writing
    mov r8, rdi
    mov rdi, rsi

    mov rax, r8
    
    mov rcx, 3
    xor rdx, rdx
    div rcx

    test rdx, rdx
    jnz .not_div_3

    mov r9, 1
    
    mov rcx, 5
    lea rsi, [pling]
    rep movsb

.not_div_3:

    mov rax, r8
    
    mov rcx, 5
    xor rdx, rdx
    div rcx

    test rdx, rdx
    jnz .not_div_5

    mov r9, 1
    
    mov rcx, 5
    lea rsi, [plang]
    rep movsb

.not_div_5:

    mov rax, r8
    
    mov rcx, 7
    xor rdx, rdx
    div rcx

    test rdx, rdx
    jnz .not_div_7

    mov r9, 1
    
    mov rcx, 5
    lea rsi, [plong]
    rep movsb

.not_div_7:

    test r9, r9 ; if zero, means not divisible
    jnz .end

    mov rax, r8
    
    mov rcx, 10
    xor rdx, rdx
    div rcx ; rax = tens, rdx = ones

    test rax, rax
    jz .no_tens

    add al, '0'
    stosb
    
.no_tens:
    mov al, dl
    add al, '0'
    stosb
    
.end:
    mov rax, 0x00
    stosb
    ret

%ifidn __OUTPUT_FORMAT__,elf64
section .note.GNU-stack noalloc noexec nowrite progbits
%endif
