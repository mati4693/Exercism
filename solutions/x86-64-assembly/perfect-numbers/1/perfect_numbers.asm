DEFICIENT equ 1
PERFECT equ 2
ABUNDANT equ 3
INVALID equ -1

section .text
global classify
classify:
    ; Provide your implementation here
    ; rdi: (int64_t) number to classify

    xor rax, rax ; rax is the dividend and finally the return value

    ; check for zero and negative
    cmp rdi, 0
    jle .inva

    mov rcx, rdi ; rcx is divisor
    dec rcx ; remove possibility of counting rdi as a factor

    xor r8, r8 ; r8 is sum of factors

.factor_loop:
    test rcx, rcx
    jz .factor_loop_done

    mov rax, rdi ; prepare dividend
    
    cqo
    idiv rcx

    test rdx, rdx ; check for remainder
    jnz .factor_loop_repeat

    add r8, rcx

.factor_loop_repeat:
    dec rcx
    jmp .factor_loop

.factor_loop_done:
    
    cmp r8, rdi
    jl .defi
    je .perf
    jg .abun

.defi:
    mov rax, DEFICIENT
    jmp .done

.perf:
    mov rax, PERFECT
    jmp .done

.abun:
    mov rax, ABUNDANT
    jmp .done

.inva:
    mov rax, INVALID
.done:
    ret

%ifidn __OUTPUT_FORMAT__,elf64
section .note.GNU-stack noalloc noexec nowrite progbits
%endif
