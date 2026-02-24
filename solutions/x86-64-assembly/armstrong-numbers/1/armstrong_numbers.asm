section .text
global is_armstrong_number
is_armstrong_number:
    ; Provide your implementation here
    ; rdi: (int) number
    ; ret: (int) bool

    test rdi, rdi
    jz .true
    
    mov r8, 1 ; divisor
    mov r9, 10 ; step

    mov rax, rdi
    mov rcx, 0

.find_digits:
    cmp rax, 0
    je .digits_found

    mov rax, rdi
    xor rdx, rdx
    div r8

    xor rdx, rdx
    push rax
    mov rax, r8
    mul r9
    mov r8, rax
    pop rax

    inc rcx  
    jmp .find_digits

.digits_found:
    dec rcx
    
    ; decrement r8 by step
    mov rax, r8
    xor rdx, rdx
    div r9
    mov r8, rax

    mov rsi, rcx ; save num len in rsi

    push rdi ; save orig num for later
    
    mov rax, rdi
    xor rdi, rdi ; rdi is sum
    
.digit_exponent_sum:
    mov r8, 10
    xor rdx, rdx
    div r8
    
    push rax
    mov rax, rdx
    call exponent
    add rdi, rax
    pop rax
    
    loop .digit_exponent_sum

    pop rax ; rax is orig num

    cmp rax, rdi
    je .true
    
    mov rax, 0
    jmp .done
.true:
    mov rax, 1
.done:
    ret
    
exponent:
    ; rdx = base, rsi = exponent
    mov r10, rsi
    dec r10
    mov r11, rax
    cmp r10, 0
    je .done
.loop_exp:
    xor rdx, rdx
    mul r11
    dec r10
    jnz .loop_exp
.done:
    ret

%ifidn __OUTPUT_FORMAT__,elf64
section .note.GNU-stack noalloc noexec nowrite progbits
%endif
