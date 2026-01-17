section .text
global two_fer
two_fer:
    ; Provide your implementation here
    ; The function has type signature void two_fer(const char *name, char *buffer)
    ; It has no return value
    ; The first argument is of type const char*, which is the address of a read-only NUL-terminated sequence of bytes stored in memory that represents the name of a person
    ; If no name is passed, this address has a value of 0
    ; The second argument is of type char*, which is the address of a writable sequence of bytes stored in memory
    ; The resulting string should be NUL-terminated and stored at the location pointed to by the address provided in the second argument.

    ; switch addresses so dest becomes rdi and src becomes rsi
    mov rax, rdi
    mov rdi, rsi
    mov rsi, rax

    mov r8, rdi ; r8 is address for output
    mov r9, rsi ; r9 is adress for name

    ; append prefix
    mov rax, "One for "
    mov rcx, 8 ; len of rax
    stosq

    test r9, r9
    jz .no_name

    xor rcx, rcx ; iter
    jmp .append_name

.no_name:
    mov rax, "you"
    stosd

    dec rdi ; remove null terminator

    jmp .append_suffix

.append_name:
    mov r8, rdi ; save output for later
    mov r9, rsi ; save name for later

    ; find index of 0x00
    mov rax, 0x00
    mov rcx, -1
    mov rdi, r9
    repnz scasb

    ; rcx is length of name
    mov rcx, rdi
    sub rcx, r9
    dec rcx ; remove null terminator

    ; restore rdi and rsi
    mov rdi, r8
    mov rsi, r9
    rep movsb

    jmp .append_suffix

.append_suffix:
    mov rax, ", one "
    stosq

    sub rdi, 2 ; remove null terminator

    mov rax, "for me."
    stosq

%ifidn __OUTPUT_FORMAT__,elf64
section .note.GNU-stack noalloc noexec nowrite progbits
%endif
