; Everything that comes after a semicolon (;) is a comment

C2 equ 2
C3 equ 3
C4 equ 4
C5 equ 5
C6 equ 6
C7 equ 7
C8 equ 8
C9 equ 9
C10 equ 10
CJ equ 11
CQ equ 12
CK equ 13
CA equ 14

TRUE equ 1
FALSE equ 0

section .text

; You should implement functions in the .text section

; the global directive makes a function visible to the test files
global value_of_card
value_of_card:
    ; This function takes as parameter a number representing a card
    ; The function should return the numerical value of the passed-in card

    cmp rdi, 14
    je .ace_card
    
    cmp rdi, 10
    ja .image_card
    
    mov rax, rdi ; if this is reached, then it's just a number card
    ret

.ace_card:
    mov rax, 1
    ret

.image_card:
    mov rax, 10
    ret

global higher_card
higher_card:
    ; This function takes as parameters two numbers each representing a card
    ; The function should return which card has the higher value
    ; If both have the same value, both should be returned
    ; If one is higher, the second one should be 0

    mov r8, rdi
    mov r9, rsi
    
    mov rdi, rsi
    call value_of_card 
    mov rsi, rax ; rsi is now the calculated value of card 2

    mov rdi, r8
    call value_of_card 
    mov rdi, rax ; rdi is now the calculated value of card 1
    
    cmp rdi, rsi

    je .return_both
    ja .first_larger
    jb .second_larger

.return_both:
    mov rax, r8
    mov rdx, r9
    ret

.first_larger:
    mov rax, r8
    mov rdx, 0
    ret

.second_larger:
    mov rax, r9
    mov rdx, 0
    ret

global value_of_ace
value_of_ace:
    ; This function takes as parameters two numbers each representing a card
    ; The function should return the value of an upcoming ace

    mov rdx, 0

    cmp rdi, 14
    je .return_one

    cmp rsi, 14
    je .return_one

    mov r8, rdi
    mov r9, rsi
    
    mov rdi, rsi
    call value_of_card 
    mov rsi, rax ; rsi is now the calculated value of card 2

    mov rdi, r8
    call value_of_card 
    mov rdi, rax ; rdi is now the calculated value of card 1

    add rdx, rdi
    add rdx, rsi
    ; rdx is now the sum of the calculated cards

    cmp rdx, 10

    ja .return_one
    jbe .return_eleven

.return_one:
    mov rax, 1
    ret

.return_eleven:
    mov rax, 11
    ret

global is_blackjack
is_blackjack:
    ; This function takes as parameters two numbers each representing a card
    ; The function should return TRUE if the two cards form a blackjack, and FALSE otherwise
    cmp rdi, 14
    je .check_second_card

    cmp rsi, 14
    je .check_first_card

    mov rax, FALSE
    ret

.check_first_card:
    call value_of_card ; rax is equal to value of first card
    cmp rax, 10

    je .forms_blackjack

    mov rax, FALSE
    ret
    

.check_second_card:
    mov rdi, rsi
    call value_of_card ; rax is equal to value of first card
    cmp rax, 10

    je .forms_blackjack

    mov rax, FALSE
    ret

.forms_blackjack:
    mov rax, TRUE
    ret

global can_split_pairs
can_split_pairs:
    ; This function takes as parameters two numbers each representing a card
    ; The function should return TRUE if the two cards can be split into two pairs, and FALSE otherwise

    mov r8, rdi
    mov r9, rsi
    
    mov rdi, rsi
    call value_of_card 
    mov rsi, rax ; rsi is now the calculated value of card 2

    mov rdi, r8
    call value_of_card 
    mov rdi, rax ; rdi is now the calculated value of card 1

    cmp rdi, rsi
    je .can_split

    mov rax, FALSE
    ret

.can_split:
    mov rax, TRUE
    ret

global can_double_down
can_double_down:
    ; This function takes as parameters two numbers each representing a card
    ; The function should return TRUE if the two cards form a hand that can be doubled down, and FALSE otherwise
    
    mov r8, rdi
    mov r9, rsi
    
    mov rdi, rsi
    call value_of_card 
    mov rsi, rax ; rsi is now the calculated value of card 2

    mov rdi, r8
    call value_of_card 
    mov rdi, rax ; rdi is now the calculated value of card 1

    mov rax, 0
    add rax, rdi
    add rax, rsi
    
    cmp rax, 9
    jb .not_double_down

    cmp rax, 11
    ja .not_double_down

    mov rax, TRUE
    ret

.not_double_down:
    mov rax, FALSE
    ret

%ifidn __OUTPUT_FORMAT__,elf64
section .note.GNU-stack noalloc noexec nowrite progbits
%endif
