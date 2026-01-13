default rel

section .rodata
    INVALID_NUMBER equ -1

section .text
global prime

prime:
    ; Provide your implementation here

    test rdi, rdi ; test if rdi is 0
    jz .error
    
    ;mov r10, 20000
    ;cmp rdi, 65536
    ;cmovg rdi, r10

    mov r8, rdi ; r8 is nth prime
    mov rcx, 0 ; rcx is total of primes found
    mov rdi, 2 ; rdi is current prime

.outer_loop:
    cmp rcx, r8 ; check if primes found equals rdi 
    je .done

    call isprime
    test rax, rax
    jz .not_prime

    inc rcx
    
.not_prime:
    inc rdi

    jmp .outer_loop
    
.done:
    mov rax, rdi
    dec rax
    ret

.error:
    mov rax, INVALID_NUMBER
    ret

isprime:
    ; check if divisible by 2
    mov rax, rdi
    mov r9, 2

    cqo
    idiv r9

    test rdx, rdx
    jz .check_if_equal

    ; check if divisible by 3
    mov rax, rdi
    mov r9, 3

    cqo
    idiv r9

    test rdx, rdx
    jz .check_if_equal

    cvtsi2sd xmm0, rdi
    sqrtsd xmm0, xmm0
    cvtsd2si rax, xmm0

    mov r10, 4 ; r10 is step
    mov r11, rax; r11 is m
    inc r11

    mov r9, 5 ; rsi is i

.isprime_loop:
    cmp r9, r11
    jge .prime

    mov rax, rdi

    cqo
    idiv r9

    test rdx, rdx
    jz .not_prime

    mov rax, 6
    sub rax, r10
    mov r10, rax ; step = 6-step

    add r9, r10 ; i += step

    jmp .isprime_loop

.not_prime:
    mov rax, 0
    ret

.prime:
    mov rax, 1
    ret

.check_if_equal:
    cmp rdi, r9
    je .prime

    mov rax, 0
    ret

%ifidn __OUTPUT_FORMAT__,elf64
section .note.GNU-stack noalloc noexec nowrite progbits
%endif
