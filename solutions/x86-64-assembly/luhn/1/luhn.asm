section .text
global valid
valid:
    ; rdi: (char*) input str
    ; ret: (int) validity

    xor rax, rax
    xor rcx, rcx
    xor r8, r8 ; r8 is amount of space
    
.get_len:
    movzx rax, byte [rdi + rcx]
    
    cmp rax, 0x00
    je .len_found

    cmp rax, "0"
    jl .not_number
    cmp rax, "9"
    jg .not_number

    jmp .next_len_char
.not_number:
    cmp rax, 0x20 ; check for space
    jne .invalid
    inc r8
.next_len_char:
    inc rcx
    jmp .get_len

.len_found:
    ; get amount of nums
    mov rax, rcx
    sub rax, r8
    
    cmp rax, 1
    jle .invalid
    
    xor rdx, rdx ; rdx is sum
    xor r8, r8 ; r8 is number counter
    
.char_loop:
    ; check if number
    movzx rax, byte [rdi + rcx - 1]

    cmp rax, 0x20 ; check for space
    je .next_char
    
    ; char is number
    sub rax, 0x30 ; convert str to int
    
    cmp r8, 1
    jne .dont_multiply

    shl rax, 1
    cmp rax, 9
    jle .dont_multiply ; skip subtraction
    sub rax, 9
    
.dont_multiply:
    add rdx, rax
    xor r8b,  0x01 ; flip lsb bit
    jmp .next_char

.next_char:
    loop .char_loop

    ; check if divisible by ten
    mov rax, rdx
    xor rdx, rdx
    mov r9, 10
    div r9

    cmp rdx, 0
    jne .invalid

    mov rax, 1
    jmp .return

.invalid:
    mov rax, 0
.return:
    ret

%ifidn __OUTPUT_FORMAT__,elf64
section .note.GNU-stack noalloc noexec nowrite progbits
%endif
