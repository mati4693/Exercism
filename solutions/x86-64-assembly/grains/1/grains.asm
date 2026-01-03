section .text
global square
square:
    ; Provide your implementation here
    ; The function has type signature uint64_t square(int64_t number)
    ; The return value is of type uint64_t, which is an unsigned 64-bit integer
    ; The argument is of type int64_t, which is a signed 64-bit integer

    mov rsi, rdi
    add rsi, rsi
    jc .negative_number
    
    mov rax, 1

    cmp rdi, 2
    jl .square_under_two
    
    dec rdi
    jmp .exponent

.exponent:
    dec rdi
    imul rax, 2
    
    cmp rdi, 0
    jg .exponent
    jle .end

.end:
    ret

.square_under_two:
    mov rax, rdi
    ret

.negative_number:
    mov rax, 0
    ret
    

global total
total:
    ; Provide your implementation here
    ; The function has type signature uint64_t total(void)
    ; The return value is of type uint64_t, which is an unsigned 64-bit integer
    ; It has no argument

    mov r8, 0 ; temp sum counter
    mov r9, 64 ; squares left
    
    jmp .sum

.sum:
    mov rdi, r9
    call square
    add r8, rax

    dec r9
    cmp r9, 0
    je .end

    jmp .sum

.end:
    mov rax, r8
    ret

%ifidn __OUTPUT_FORMAT__,elf64
section .note.GNU-stack noalloc noexec nowrite progbits
%endif
