default rel

section .rodata
    one_point db "AEIOULNRST"
    one_len dq $-one_point
    
    two_points db "DG"
    two_len dq $-two_points
    
    three_points db "BCMP"
    three_len dq $-three_points
    
    four_points db "FHVWY"
    four_len dq $-four_points
    
    five_points db "K"
    five_len dq $-five_points
    
    eight_points db "JX"
    eight_len dq $-eight_points
    
    ten_points db "QZ"
    ten_len dq $-ten_points

section .text
global score
score:
    ; Provide your implementation here
    ; The function has type signature int score(const char *score)
    ; The return value is of type int, which is a 32-bit signed integer
    ; The argument is of type const char*, which is the address of a read-only NUL-terminated sequence of bytes stored in memory

    mov r9, rdi ; save rdi for later
    mov r10, 0 ; score
    mov r11, 0 ; word_iter

.score_loop:
    movzx rax, byte [r9 + r11]
    
    cmp al, 0x00
    jz .done
    
    movzx rdi, al
    call upper_string

    lea rdi, [one_point]
    mov rcx, [one_len]
    mov r12, 1
    repne scasb ; if rax matches letter in one_point then ZF=1
    cmove rdx, r12
    je .add_point

    lea rdi, [two_points]
    mov rcx, [two_len]
    mov r12, 2
    repne scasb ; if rax matches letter in two_points then ZF=1
    cmove rdx, r12
    je .add_point

    lea rdi, [three_points]
    mov rcx, [three_len]
    mov r12, 3
    repne scasb ; if rax matches letter in three_points then ZF=1
    cmove rdx, r12
    je .add_point

    lea rdi, [four_points]
    mov rcx, [four_len]
    mov r12, 4
    repne scasb ; if rax matches letter in four_points then ZF=1
    cmove rdx, r12
    je .add_point

    lea rdi, [five_points]
    mov rcx, [five_len]
    mov r12, 5
    repne scasb ; if rax matches letter in five_points then ZF=1
    cmove rdx, r12
    je .add_point

    lea rdi, [eight_points]
    mov rcx, [eight_len]
    mov r12, 8
    repne scasb ; if rax matches letter in eight_points then ZF=1
    cmove rdx, r12
    je .add_point

    lea rdi, [ten_points]
    mov rcx, [ten_len]
    mov r12, 10
    repne scasb ; if rax matches letter in ten_points then ZF=1
    cmove rdx, r12

.add_point:
    add r10, rdx
    inc r11
    jmp .score_loop

.done:
    mov rax, r10
    ret
    

global upper_string
upper_string:  
    cmp dil, 0x61 ; 0x61 is a which is the fist lower letter
    jl .upper_skip
    
    sub dil, 32 ; 32 is offset between capital to lower letters
.upper_skip:
    mov al, dil
    ret

%ifidn __OUTPUT_FORMAT__,elf64
section .note.GNU-stack noalloc noexec nowrite progbits
%endif
