default rel

section .data
    chars db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 
    ; 26 values for each letter found, if value is 1, then the letter has already been registered

;section .bss
;    chars resb 26 ; 26 values for each letter found, if value is 1, then the letter has already been registered

section .text
global is_isogram
is_isogram:
    ; Provide your implementation here
    ; The function has type signature int is_isogram(const char *str);
    ; The return value is of type int, which is a 32-bit signed integer
    ; The return value should be set to zero if false and non-zero if true
    ; The argument is of type const char*, which is the address of a read-only NUL-terminated sequence of bytes stored in memory

    mov r8, rdi
    lea r9, [chars]

    ; reset chars    
    mov rcx, 26 ; repeat 26 times
    lea rdi, [chars] ; addr for chars
    mov rax, 0 ; value to store
    rep stosb
    
    mov rax, 0 ; is isogram bool
    mov rcx, 0 ; iter

.isogram_loop:
    movzx rdx, byte [r8 + rcx]

    cmp dl, 0x00
    je .done

    cmp dl, 0x41 ; 0x41 is A
    jb .isogram_skip ; skip char if not letter

    mov dil, dl
    call lower_string
    mov dl, al
    
    cmp byte [r9 + rdx - 0x61], 1 ; remove offset so 0x61 (a) becomes 0x00
    je .already_registered

    mov byte [r9 + rdx - 0x61], 1  ; remove offset so 0x61 (a) becomes 0x00
    
    inc rcx
    jmp .isogram_loop

.isogram_skip:
    inc rcx
    jmp .isogram_loop

.already_registered:
    mov rax, 0
    ret
    
.done:
    ;movzx rax, byte [r9 + 'e' - 0x61]
    mov rax, 1
    ret

global lower_string
lower_string:  
    cmp dil, 0x5A ; 0x5A is Z which is the last capital letter
    jg .lower_skip
    
    add dil, 32 ; 32 is offset between capital to lower letters
.lower_skip:
    mov al, dil
    ret

%ifidn __OUTPUT_FORMAT__,elf64
section .note.GNU-stack noalloc noexec nowrite progbits
%endif
