default rel

section .bss
    chars resb 26

section .text
global is_pangram
is_pangram:
    ; Provide your implementation here
    ; The function has type signature int is_pangram(const char *str)
    ; The return value is of type int, which is a 32-bit signed integer
    ; The return value should be set to zero if false and non-zero if true
    ; The argument is of type const char*, which is the address of a read-only NUL-terminated sequence of bytes stored in memory

    mov r8, rdi ;  save rdi in r8
    lea r9, [chars] ; save addr for chars in r9

    ; clear chars
    mov rax, 0
    mov rcx, 26
    mov rdi, r9
    rep stosb
    
    xor rcx, rcx ; iter
    xor rdx, rdx ; total chars counted 

.register_chars:
    movzx rax, byte [r8 + rcx]
    
    cmp al, 0x00
    je .check_if_all_chars_present

    cmp al, 0x41 ; 0x41 is A which is the first letter
    jl .skip_char

    movzx r10, al
    sub r10, 0x5B ; 0x5B is first char of chars between capital and lower letters
    cmp r10, 5
    jbe .skip_char ; needs to jbe because we need to check unsigned

    mov dil, al
    call lower_char
    
    cmp byte [r9 + rax - 0x61], 1
    je .skip_char

    mov byte [r9 + rax - 0x61], 1
    inc rdx

.skip_char:
    inc rcx
    jmp .register_chars
    
.check_if_all_chars_present:
    mov rax, 1
    
    cmp rdx, 26
    je .done

    mov rax, 0

.done:
    ret

global lower_char
lower_char:  
    cmp dil, 0x5A ; 0x5A is Z which is the last capital letter
    jg .lower_skip
    
    add dil, 32 ; 32 is offset between capital to lower letters
.lower_skip:
    mov al, dil
    ret

%ifidn __OUTPUT_FORMAT__,elf64
section .note.GNU-stack noalloc noexec nowrite progbits
%endif
