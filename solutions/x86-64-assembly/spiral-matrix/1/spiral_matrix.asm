%include "debug.mac"

section .text
global spiral_matrix

spiral_matrix:
    ; rdi: (uint32_t*) dest; rsi: (size_t) sidelength
    ; r8: x
    ; r9: y
    ; r10: direction (0:right; 1:down; 2:left; 3:up)
    ; r11: amount to move
    ; rax: current_num
    ; ret: total_size

    xor r8, r8
    xor r9, r9
    
    mov r10, 0
    mov r11, rsi

    mov rax, 1

    cmp rsi, 2
    jge .valid_length
    ; check for zero
    test rsi, rsi
    jz .done
    ; write first value
    mov dword [rdi], eax
    inc rax
    jmp .done
    
.valid_length:
    ; prepare rcx
    mov rcx, rsi
    sal rcx, 1
    dec rcx
    
.outer_loop:
    cmp r10, 0
    je .dont_dec_distance
    cmp r10, 2
    je .dont_dec_distance
    
    ; decrease distance
    dec r11
    
.dont_dec_distance:
    mov rdx, r11 ; make rdx ready

.direction_loop:
    cmp r10, 0
    jne .not_right
    ; right
    inc r8
    jmp .direction_repeat
.not_right:
    cmp r10, 1
    jne .not_down
    ; down
    inc r9
    jmp .direction_repeat
.not_down:
    cmp r10, 2
    jne .not_left
    ; left
    dec r8
    jmp .direction_repeat
.not_left:
    ; then it's up
    dec r9
.direction_repeat:
    push rcx
    push rdx ; rdx is jumbled by mul
    mov rcx, rax ; save rax
    
    ; calculate index
    mov rax, r9
    mul rsi
    add rax, r8
    mov dword [rdi+(rax-1)*4], ecx

    mov rax, rcx
    pop rdx
    pop rcx

    inc rax
    
    dec rdx
    jnz .direction_loop
;-------------------------
    ; repeat outer_loop
    inc r10
    cmp r10, 4
    jne .outer_loop_repeat
    xor r10, r10
.outer_loop_repeat:
    dec rcx
    jnz .outer_loop
    
.done:
    dec rax
    ret

%ifidn __OUTPUT_FORMAT__,elf64
section .note.GNU-stack noalloc noexec nowrite progbits
%endif
