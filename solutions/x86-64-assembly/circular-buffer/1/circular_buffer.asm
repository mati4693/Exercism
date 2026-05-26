%include "debug.mac"

%macro INC_OLDEST_INDEX 0
    push rax
    movzx rax, byte [buffer_len]
    inc byte [oldest_index]
    cmp byte [oldest_index], al
    jl .oldest_not_above
    mov byte [oldest_index], 0
.oldest_not_above:
    pop rax
%endmacro

%macro GET_NEXT_INDEX 0 ; returns rax
    movzx rax, byte [oldest_index]
    add al, byte [items]
    cmp al, byte [buffer_len]
    jl .next_not_above
    sub al, byte [buffer_len]
.next_not_above:
    ; pass
%endmacro

%macro WRITE_BUFFER 1 ; %1 is int32_t
    GET_NEXT_INDEX ; rax is output
    
    lea rdx, [buffer]
    mov [rdx+(rax*4)], %1

    inc byte [items]
    mov rax, 1
%endmacro

default rel
section .data
    oldest_index db 0 
    items db 0
    buffer_len db 0
    
section .bss
    buffer resd 100 ; buffer contains dwords

section .text

global create_buffer
global read_buffer
global write_buffer
global clear_buffer
global overwrite_buffer
global delete_buffer

create_buffer:
    ; rdi: buffer_len
    mov byte [oldest_index], 0
    mov byte [items], 0
    mov byte [buffer_len], dil
    ret

read_buffer:
    ; rdi: (int32_t*) output pointer
    ; ret: (bool) success
    
    ; check if empty
    cmp byte [items], 0
    jne .not_empty
    
    mov rax, 0
    jmp .done
    
.not_empty:
    lea rdx, [buffer]
    movzx rax, byte [oldest_index]

    mov ecx, dword [rdx+(rax*4)]
    
    mov [rdi], ecx
    
    INC_OLDEST_INDEX ; act if read has deleted latest value
    dec byte [items]
    
    mov rax, 1
.done:
    ret

write_buffer:
    ; rdi: (int32_t) input
    ; ret: (bool) success
    
    movzx rax, byte [items]
    cmp al, byte [buffer_len]
    jl .not_full
    
    mov rax, 0
    jmp .done
    
.not_full:
    WRITE_BUFFER edi
.done:
    ret

clear_buffer:
    mov byte [oldest_index], 0
    mov byte [items], 0
    ret

overwrite_buffer:
    ; rdi: (int32_t) input

    movzx rax, byte [items]
    
    cmp al, byte [buffer_len]
    jl .non_full_buffer
    dec byte [items]
    INC_OLDEST_INDEX
.non_full_buffer:
    WRITE_BUFFER edi
    ret

delete_buffer:
    ; reset buffer
    mov byte [oldest_index], 0
    mov byte [items], 0
    mov byte [buffer_len], dil
    ret

%ifidn __OUTPUT_FORMAT__,elf64
section .note.GNU-stack noalloc noexec nowrite progbits
%endif
