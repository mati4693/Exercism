section .text
global factors
factors:
    ; Provide your implementation here

    ; rdi: (uint64_t) ptr for output array
    ; rsi: (uint64_t) value
    ; ret: (size_t) len of output_array

    mov rax, rsi ; rax is dividend
    mov rcx, 2 ; rcx is divisor (2 is the minimum prime factor)
    
    xor r8, r8 ; r8 is len of output_array

    test rdi, rdi
    jz .no_factors

.factor_loop:
    cmp rax, 1
    je .factor_loop_done

    ; if divisor is larger than dividend
    cmp rcx, rax
    jg .no_factors

    mov r9, rax ; save orig dividend
    
    xor rdx, rdx
    div rcx
    
    test rdx, rdx
    jnz .factor_loop_inc_divisor

    mov qword [rdi+(r8*8)], rcx
    inc r8 ; inc output array length
    jmp .factor_loop

.factor_loop_inc_divisor:
    mov rax, r9 ; restore rax
    inc rcx
    jmp .factor_loop

.factor_loop_done:
    mov rax, r8
    ret

.no_factors:
    mov rax, 0
    ret

%ifidn __OUTPUT_FORMAT__,elf64
section .note.GNU-stack noalloc noexec nowrite progbits
%endif
