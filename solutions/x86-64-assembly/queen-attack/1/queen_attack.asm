section .text
global can_create
can_create:
    ; Provide your implementation here
    ; The function has type signature int can_create(int row, int column)
    ; Both arguments and the return value are of int type, which is a 32-bit signed integer
    ; The return value should be set to zero if false and non-zero if true

    mov rdx, rdi
    add rdx, rdx
    jc .invalid

    mov rdx, rsi
    add rdx, rdx
    jc .invalid
    
    cmp rdi, 0
    jl .invalid
    cmp rdi, 7
    jg .invalid

    cmp rsi, 0
    jl .invalid
    cmp rsi, 7
    jg .invalid

    mov rax, 1
    ret

.invalid:
    mov rax, 0
    ret

global can_attack
can_attack:
    ; Provide your implementation here
    ; The function has type signature int can_attack(int white_row, int white_column, int black_row, int black_column)
    ; All arguments and the return value are of int type, which is a 32-bit signed integer
    ; The return value should be set to zero if false and non-zero if true

    ; check row
    cmp rdi, rdx
    je .attack

    ; check column
    cmp rsi, rcx
    je .attack

    ; check diag first and second
    mov r8, rdi
    add r8, rsi
    
    mov r9, rdx
    add r9, rcx

    cmp r8, r9
    je .attack
    
    ; check diag third and fourth
    mov r8, rdi
    sub r8, rsi
    
    mov r9, rdx
    sub r9, rcx

    cmp r8, r9
    ja .reverse_second
    jb .reverse_first

    cmp r8, r9
    je .attack

    xor r8, r8
    xor r9, r9

    ; failsafe false return
    jmp .cant_attack

.attack:
    mov rax, 1
    ret

.cant_attack:
    mov rax, 0
    ret

.reverse_first:
    neg r8

.reverse_second:
    neg r9

%ifidn __OUTPUT_FORMAT__,elf64
section .note.GNU-stack noalloc noexec nowrite progbits
%endif
