%include "debug.mac"

default rel

section .data
    numbers_lower dq "no", "one", "two", "three", "four", "five", "six", "seven", "eight", "nine", "ten"
    numbers_upper dq "No", "One", "Two", "Three", "Four", "Five", "Six", "Seven", "Eight", "Nine", "Ten"
    numbers_len db 6, 5, 5, 3, 4, 4, 5, 3, 3, 4, 5
    alignment dq 8
    
section .text
global recite
recite:
    ; rdi: buffer ptr
    ; rsi: starting point
    ; rdx: loops

    mov rcx, rdx ; rcx is loops
    mov r8, rsi ; r8 is string index
    
.recite_loop:
    mov rax, r8
    mul qword [alignment]
    lea rsi, [numbers_upper]
    add rax, rsi
    mov rsi, rax
    movsq

    lea rax, [numbers_len]
    add rax, r8
    sub dil, byte [rax]
    
    mov rax, " green b"
    stosq

    ; check for singular
    cmp r8, 1
    jne .not_singular_pre_start
    mov rax, "ottle h"
    stosq
    dec rdi
    jmp .continue_recite_pre_start
.not_singular_pre_start:
    mov rax, "ottles h"
    stosq
.continue_recite_pre_start:
    
    mov rax, "anging o"
    stosq
    mov rax, "n the wa"
    stosq
    mov rax, 0x0A2C6C6C
    stosd

    mov rax, r8
    mul qword [alignment]
    lea rsi, [numbers_upper]
    add rax, rsi
    mov rsi, rax
    movsq
    
    lea rax, [numbers_len]
    add rax, r8
    sub dil, byte [rax]

    mov rax, " green b"
    stosq
    
    ; check for singular
    cmp r8, 1
    jne .not_singular_start
    mov rax, "ottle h"
    stosq
    dec rdi
    jmp .continue_recite_start
.not_singular_start:
    mov rax, "ottles h"
    stosq
.continue_recite_start:

    mov rax, "anging o"
    stosq
    mov rax, "n the wa"
    stosq
    mov rax, 0x0A2C6C6C
    stosd

    mov rax, "And if o"
    stosq
    mov rax, "ne green"
    stosq
    mov rax, 0x20
    stosb
    mov rax, "bottle s"
    stosq
    mov rax, "hould ac"
    stosq
    mov rax, "cidental"
    stosq
    mov rax, "ly fall,"
    stosq
    mov rax, 0x0A
    stosb
    mov rax, "There'll"
    stosq
    mov rax, " be "
    stosd

    dec r8; get one number lower
    mov rax, r8
    mul qword [alignment]
    lea rsi, [numbers_lower]
    add rax, rsi
    mov rsi, rax
    movsq
    inc r8

    dec r8; get one number lower
    lea rax, [numbers_len]
    add rax, r8
    sub dil, byte [rax]
    inc r8

    mov rax, 0x20
    stosb
    
    mov rax, "green bo"
    stosq

    ; check for singular
    cmp r8b, 2
    jne .not_singular
    mov rax, "ttle ha"
    stosq
    dec rdi
    jmp .continue_recite_ending
.not_singular:
    mov rax, "ttles ha"
    stosq
.continue_recite_ending:

    mov rax, "nging on"
    stosq
    mov rax, 0x20
    stosb
    mov rax, "the wall"
    stosq
    mov rax, 0x0A2E
    stosw
    mov rax, 0x0A
    stosb
    
    dec r8 ; dec string index
    
    dec rcx
    jnz .recite_loop

    dec rdi ; remove trailing newline
    mov rax, 0x00
    stosb
    
    ret

%ifidn __OUTPUT_FORMAT__,elf64
section .note.GNU-stack noalloc noexec nowrite progbits
%endif
