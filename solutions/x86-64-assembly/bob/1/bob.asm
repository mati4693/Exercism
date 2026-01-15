default rel

section .data
    question db "Sure.", 0x00
    all_caps db "Whoa, chill out!", 0x00
    all_caps_question db "Calm down, I know what I'm doing!", 0x00
    silence db "Fine. Be that way!", 0x00
    else db "Whatever.", 0x00

section .text
global response
response:
    ; Provide your implementation here

    xor rcx, rcx ; string iter
    mov rdx, 1 ; current character

    mov r8, 2 ; all caps state 0: lowercase found; 1: only uppercase; 2: no letters found
    mov r9, 0 ; question state
    mov r10, 1 ; silence state
    mov r11, 0 ; last char

.response_iter:
    test dl, dl
    jz .response_iter_done

    movzx rdx, byte [rdi+rcx]

    mov rax, r11
    inc rax
    cmp rdx, 0x40 ; is last char before letters

    ; silence state
    mov rax, 0
    cmp dl, 0x29 ; 0x29 is last char before letters and numbers
    cmovg r10, rax

    ; caps state
    cmp dl, 0x41 ; 0x41 is first char of capital letters
    jl .skip_caps_check
    
    mov rax, 0
    cmp dl, 0x60 ; 0x60 is begining of lowercase letters
    cmovg r8, rax
    jg .skip_caps_check

    ; only uppercase letters reaches this
    mov rax, 1
    cmp r8, 2
    cmove r8, rax

.skip_caps_check:
    ; get last char
    cmp dl, 0x20 ; 0x20 is space
    cmovg r11w, dx

    inc rcx
    jmp .response_iter
    
.response_iter_done:
    ; check for question mark in last char
    cmp r11b, "?"
    je .question_response

    cmp r10, 2
    je .else_response

    cmp r8, 1
    je .all_caps_response

    cmp r10, 1
    je .silence_response

.else_response:
    lea rax, [else]
    ret

.question_response:
    cmp r8, 1
    je .all_caps_question_response
    lea rax, [question]
    jmp .done

.all_caps_question_response:
    lea rax, [all_caps_question]
    jmp .done

.all_caps_response:
    lea rax, [all_caps]
    jmp .done

.silence_response:
    lea rax, [silence]
    jmp .done

.done:
    ret

%ifidn __OUTPUT_FORMAT__,elf64
section .note.GNU-stack noalloc noexec nowrite progbits
%endif
