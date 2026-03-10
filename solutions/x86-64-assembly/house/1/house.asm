default rel

section .data
    verse_subject db "house that Jack builtmaltratcatdogcow with the crumpled hornmaiden all forlornman all tattered and tornpriest all shaven and shornrooster that crowed in the mornfarmer sowing his cornhorse and the hound and the horn", 0x00
    verse_verb db "lay inatekilledworriedtossedmilkedkissedmarriedwokekeptbelonged to", 0x00
    subject_lengths db 0, 21, 25, 28, 31, 34, 60, 78, 103, 130, 161, 183, 215
    verb_lengths db 0, 0, 6, 9, 15, 22, 28, 34, 40, 47, 51, 55, 66

section .text
global recite
recite:
    ; rdi: (char*) output
    ; rsi: (int) start_verse
    ; rdx: (int) end_verse

    mov r8, rsi
    mov r9, rdx
    mov r10, r8 ; save starting point

.verse_loop:
    mov rax, "This is "
    stosq
    mov rax, "the "
    stosd

.line_loop:
    ; get subject
    lea rsi, [verse_subject]
    lea rdx, [subject_lengths]
    movzx rcx, byte [rdx + r8]
    sub cl, byte [rdx + r8 - 1]
    add sil, byte [rdx + r8 - 1]
    rep movsb

    cmp r8, 1
    je .finish_line
    
    mov rax, " t"
    stosw
    mov rax, "hat "
    stosd
    
    ; get verb
    lea rsi, [verse_verb]
    lea rdx, [verb_lengths]
    movzx rcx, byte [rdx + r8]
    sub cl, byte [rdx + r8 - 1]
    add sil, byte [rdx + r8 - 1]
    rep movsb

    mov rax, " "
    stosb

    mov rax, "the "
    stosd

    dec r8
    jmp .line_loop

.finish_line:
    ; add dot, newline and null
    mov rax, 0x0A2E
    stosw

    inc r10
    mov r8, r10
    
    cmp r8, r9
    jle .verse_loop

    mov byte [rdi], 0x00
    ret

%ifidn __OUTPUT_FORMAT__,elf64
section .note.GNU-stack noalloc noexec nowrite progbits
%endif
