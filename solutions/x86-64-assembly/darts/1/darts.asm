default rel

section .data
    ten dq 1.0
    five dq 5.0
    one dq 10.0

section .text

global score
score:
    ; Provide your implementation here
    ; The function has type signature uint8_t score(double x, double y)
    ; The return value is of type uint8_t, which is a 8-bit unsigned integer
    ; Both arguments are of type double, which is a 64-bit floating-point

    call get_diag

    mov al, 10
    comisd xmm0, [ten]
    jbe .ret_point

    mov al, 5
    comisd xmm0, [five]
    jbe .ret_point

    mov al, 1
    comisd xmm0, [one]
    jbe .ret_point

    mov al, 0
    ret

.ret_point:
    ret

global get_diag
get_diag:
    mulsd xmm0, xmm0
    mulsd xmm1, xmm1

    addsd xmm0, xmm1
    
    sqrtsd xmm0, xmm0
    ret
    

%ifidn __OUTPUT_FORMAT__,elf64
section .note.GNU-stack noalloc noexec nowrite progbits
%endif
