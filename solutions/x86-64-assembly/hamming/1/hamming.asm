section .text
global distance
distance:
    ; Provide your implementation here
    ; The function has type signature int distance(const char *strand1, const char *strand2)
    ; The return value is of type int, which is a 32-bit signed integer
    ; Each argument is the address of a read-only NUL-terminated sequence of bytes stored in memory

    mov r10, rdi ; save rdi for later
    mov r11, rsi ; save rsi for later

    ; get length of rdi
    mov rax, 0
    mov rcx, -1
    repnz scasb
    mov r8, rdi
    sub r8, r10
    dec r8

    ; get length of rsi
    mov rdi, rsi
    repnz scasb
    mov r9, rdi
    sub r9, r11
    dec r9

    ; restore rdi and rsi
    mov rdi, r10
    mov rsi, r11

    mov rax, 0 ; hamming code distance
    mov rcx, 0 ; iter
    
    cmp r8, r9
    jne .error

.hamming_loop:
    cmp byte [rdi], 0x00
    je .done

    cmpsb
    jz .same

    inc rax
.same:
    jmp .hamming_loop

.done:
    ret

.error:
    mov rax, -1
    ret

%ifidn __OUTPUT_FORMAT__,elf64
section .note.GNU-stack noalloc noexec nowrite progbits
%endif
