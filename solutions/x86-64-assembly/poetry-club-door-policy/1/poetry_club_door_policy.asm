; Everything that comes after a semicolon (;) is a comment.

section .text

; You should implement functions in the .text section.
; A skeleton is provided for the first function.

; the global directive makes a function visible to the test files.
global front_door_response
front_door_response:
    ; This function takes the address in memory for a line of the poem as an argument.
    ; It returns the first letter of that line, as a ASCII-encoded character.
    mov rsi, rdi
    lodsb ; lodsb takes the first byte from addr rsi and loads it in rax
    ret

global front_door_password
front_door_password:
    ; TODO: define the 'front_door_password' function.
    ; This function takes as argument the address in memory for a string containing the combined letters you found in task 1.
    ; It must modify this string in-place, making it correctly capitalized.
    ; The function has no return value
    mov rcx, 0 ; iter

.password_iter:
    mov al, byte [rdi + rcx]

    cmp al, 0x00
    je .null

    cmp al, 0x5A ; 0x5A is Z which is the last capital letter
    jg .skip

    add al, 32 ; 32 is offset between capital to lower letters
    
.skip:
    mov byte [rdi + rcx], al

    inc rcx
    jmp .password_iter

.null:
    sub byte [rdi], 32
    ret
    
global back_door_response
back_door_response:
    ; TODO: define the 'back_door_response' function.
    ; This function takes as argument the address in memory for a line of the poem.
    ; It returns the last letter of that line that is not a whitespace character, as a ASCII-encoded character.

    mov rcx, 0 ; iter
    mov rdx, 0 ; last char which isnt whitespace

.back_door_loop:
    cmp byte [rdi + rcx], 0x00
    je .back_door_null

    cmp byte [rdi + rcx], 0x41 ; 0x41 is A which is past all spaces and punctuation
    cmovae rdx, rcx

    inc rcx
    jmp .back_door_loop

.back_door_null:
    mov al, byte [rdi + rdx]
    ret

global back_door_password
back_door_password:
    ; TODO: define the 'back_door_password' function
    ; This function takes as arguments, in this order:
    ; 1. The address in memory for a buffer where the resulting string will be stored.
    ; 2. The address in memory for a string containing the combined letters you found in task 3.
    ; It should store the polite version of the capitalized password in the buffer.
    ; A polite version is correctly capitalized and has ", please." added at the end.
    ; The function has no return value.

    mov r8, rdi ; save rdi to r8
    mov rdi, rsi ; move rsi to rdi for coroutine
    
    call front_door_password
    
    mov rdi, r8 ; restore rdi from r8

    mov rcx, 0 ; iter
    
.b_door_password:
    mov al, byte [rsi + rcx]
    cmp al, 0x00
    je .b_door_null
    
    mov byte [rdi + rcx], al
    inc rcx
    jmp .b_door_password

.b_door_null:
    mov rax, ", please" ; max 8 bytes in immediate
    add rdi, rcx ; offset rdi to end of prefix
    stosq ; store rax in rdi

    ; no need to increment rdi, since stosq already did it
    mov rax, "." ; add last char
    stosb

    mov rax, 0x00 ; append null terminator
    stosb

    ret

%ifidn __OUTPUT_FORMAT__,elf64
section .note.GNU-stack noalloc noexec nowrite progbits
%endif
