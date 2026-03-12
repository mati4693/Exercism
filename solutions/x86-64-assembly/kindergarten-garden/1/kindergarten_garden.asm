default rel

section .text
global plants

plants:
    ; rdi: (char*) output
    ; rsi: (char*) plants
    ; rdx: (char*) student
    
    mov rcx, 2
    
    movzx rax, byte [rdx] ; get first letter of student
    sub rax, 0x41
    mul rcx ; rcx is already two
    mov r8, rax
    
    add rsi, r8
.first_row:
    lodsb
    call write
    loop .first_row
 
.find_newline:
    cmp byte [rsi], 0x0A ; check for newline
    je .newline_found
    inc rsi
    jmp .find_newline
    
.newline_found:
    mov rcx, 2

    inc rsi
    add rsi, r8

.second_row:
    lodsb
    call write
    loop .second_row

    ; done
    sub rdi, 2
    mov rax, 0x0000
    stosw
    
    ret

write:
    ; rdi: ptr output
    ; rax: plant
    ; ret: void

    cmp al, "G"
    jne .clover
    mov eax, "gras"
    stosd
    mov al, "s"
    stosb
    jmp .done
.clover:
    cmp al, "C"
    jne .radish
    mov eax, "clov"
    stosd
    mov ax, "er"
    stosw
    jmp .done
.radish:
    cmp al, "R"
    jne .violet
    mov rax, "radishes"
    stosq
    jmp .done
.violet:
    ; no need to check
    cmp al, "V"
    jne .done
    mov eax, "viol"
    stosd
    mov ax, "et"
    stosw
    mov al, "s"
    stosb
.done:
    mov rax, ", "
    stosw
    ret

%ifidn __OUTPUT_FORMAT__,elf64
section .note.GNU-stack noalloc noexec nowrite progbits
%endif
