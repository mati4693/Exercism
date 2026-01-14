BAD_BASE equ -1
BAD_DIGIT equ -2

section .text
global rebase

rebase:
    ; Provide your implementation here
    ; rdi: ptr to in_digits
    ; rsi: size of in_digits
    ; rdx: base of in_digits
    ; rcx: ptr to out_digits
    ; r8: base of out_digits

    ; ret is size of out_digits in int32_t
    
    ; test if base over 1
    cmp rdx, 2
    jl .err_base

    cmp r8, 2
    jl .err_base

    ; test for empty in_digits list
    cmp rdi, 0
    je .empty_list

    ; test negativity
    test edx, 0x80000000 ; test if sign is set
    jnz .err_base

    test r8d, 0x80000000 ; test if sign is set
    jnz .err_base

    ; values are valid

    cmp rdi, 10
    cmove rax, rdi
    je .skip_to_base10
    
    call to_base10

.skip_to_base10:
    cmp rax, BAD_DIGIT ; check if err_digit was called from subroutine
    je .err_digit
    
    mov rdi, rax ; set rdi to base10 number
    mov rsi, rcx ; set rsi to ptr for out_digits
    mov rdx, r8
    call base10_to

    mov rdi, rcx ; rdi is ptr for out_digits
    mov rsi, rax ; rsi is size of out_digits
    call reverse
    ret

.err_base:
    mov rax, BAD_BASE
    ret

.err_digit:
    mov rax, BAD_DIGIT
    ret

.empty_list:
    mov rax, 1
    mov dword [rcx], 0 ; set first elem to 0
    ret

to_base10:
    xor r9, r9 ; r9 is current number in base [rdx]
    xor rax, rax ; rax is current number in base 10

    mov r9d, dword [rdi + (rsi-1)*4] ; r9 now contains int32_t

    mov r10, rdx ; r10 is conversion number

    mov rax, r9 ; first multiplication is always 1, so no need to imul
    dec rsi

.to_base10_loop:
    test rsi, rsi
    jz .to_base10_done

    xor r9, r9
    mov r9d, dword [rdi + (rsi-1)*4]

    cmp r9, rdx ; if digit == base then number is invalid
    je rebase.err_digit

    test r9d, 0x80000000 ; check if digit is negative
    jnz rebase.err_digit
    
    imul r9, r10

    add rax, r9
    
    imul r10, rdx
    dec rsi
    jmp .to_base10_loop
    
.to_base10_done:
    ret
    
base10_to:
    mov r9, 1 ; r9 is size of out_digits
    mov r10, rdx ; r10 is base of out_digits

    mov rax, rdi
    
.base10_to_loop:
    cqo
    idiv r10

    mov dword [rsi + (r9-1)*4], edx

    test rax, rax ; check if division resulted in 0
    jz .base10_to_done

    inc r9
    
    jmp .base10_to_loop
    
.base10_to_done:
    mov rax, r9
    ret

reverse:
    ; rdi is ptr
    ; rsi is size

    mov r9, rsi ; r9 is size
    sar r9, 1 ; divide r9 by 2

.reverse_iter:
    test r9, r9
    jz .done

    mov rdx, rsi
    sub rdx, r9
    
    mov dword r10d, [rdi + (r9 - 1)*4]
    mov dword r11d, [rdi + rdx*4]

    mov dword [rdi + (r9 - 1)*4], r11d
    mov dword [rdi + rdx*4], r10d

    dec r9
    
    jmp .reverse_iter

.done:
    ret
    
%ifidn __OUTPUT_FORMAT__,elf64
section .note.GNU-stack noalloc noexec nowrite progbits
%endif
