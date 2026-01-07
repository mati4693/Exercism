; Everything that comes after a semicolon (;) is a comment

section .rodata
    PRIVATE_KEY equ 0b1011_0011_0011_1100

section .text

; You should implement functions in the .text section
; A skeleton is provided for the first function

; the global directive makes a function visible to the test files
global extract_higher_bits
extract_higher_bits:
    ; This function has a 16-bit integer as argument.
    ; it returns the higher 8-bit value of the argument.

    mov ax, di ; move di to ax 16-bit reg to access 8 highest bits with ah
    mov al, ah
    ret

global extract_lower_bits
extract_lower_bits:
    ; TODO: define the 'extract_lower_bits' function.
    ; This function takes one 16-bit integer as argument and must return the lower 8-bit value of it.

    mov ax, di ; automatically saves 8 lowest bits in al by moving di to ax
    ret
    
global extract_redundant_bits
extract_redundant_bits:
    ; TODO: define the 'extract_redundant_bits' function.
    ; This function takes one 16-bit integer as argument.
    ; It returns a 8-bit integer with all bits set in both the lower and the higher 8 bits of the argument.

    mov ax, di
    mov bh, ah ; extract 8 higher bits

    mov bl, al ; extract 8 lower bits

    and bl, bh ; perform bitmask
    
    mov al, bl
    ret

global set_message_bits
set_message_bits:
    ; TODO: define the 'set_message_bits' function.
    ; This function takes one 16-bit integer as argument.
    ; It returns a 8-bit integer with all bits set if they are set in the higher 8 bits of the argument, the others unchanged.

    mov ax, di
    mov cx, ax

    shr ax, 8 ; extract 8 higher bits
    and cx, 0xff ; extract 8 lower bits

    or cx, ax ; perform bitmask
    and cx, 0xff

    mov ax, cx
    ret

global rotate_private_key
rotate_private_key:
    ; TODO: define the 'rotate_private_key' function.
    ; This function takes one 16-bit integer as argument.
    ; It returns a 16-bit integer with bits of the private key rotated to the left a number of positions equal to the redundant bits.
    ; The private key is 0b1011_0011_0011_1100.
    ; A bit is redundant when it is set in both the lowest 8-bit portion of the argument and the highest 8-bit portion of the argument.

    call extract_redundant_bits
    movzx r8, al

    popcnt r8, r8
    mov cl, r8b

    mov r9, PRIVATE_KEY
    
    rol r9w, cl ; rotate 16 bits to the left cl times
    mov rax, r9
    ret

global format_private_key
format_private_key:
    ; TODO: define the 'format_private_key' function.
    ; This function takes one 16-bit integer as argument.
    ; It returns a 8-bit integer with the private key fully formatted.
    ; To format a private key, you must:
    ; - Rotate it.
    ; - Isolate the lowest 8-bit portion of the rotated private key, which is the base value.
    ; - Isolate the highest 8-bit portion of the rotated private key, which is a mask to be applied to the base value.
    ; - Flip set bits in the base value that are also set in the mask.
    ; - Flip all bits in the result.
    call rotate_private_key

    mov bh, ah ; extract 8 higher bits for mask

    mov bl, al ; extract 8 lower bits for base

    xor bl, bh

    not bl
    and bl, 0xFF

    mov al, bl
    ret

global decrypt_message
decrypt_message:
    ; TODO: define the 'decrypt_message' function
    ; This function takes one 16-bit integer as argument
    ; It returns a 16-bit integer, of which:
    ; - The higher 8 bits are the formatted private key, according to 'format_private_key'
    ; - The lower 8 bits are the message with all bits set, according to 'set_message_bits'
    
    push rdi
    call format_private_key
    mov ecx, eax
    pop rdi

    ; message with bits set -> EDX
    push rcx
    call set_message_bits
    mov edx, eax
    pop rcx

    ; assemble final 16-bit message
    shl ecx, 8
    or ecx, edx
    mov eax, ecx
    ret

%ifidn __OUTPUT_FORMAT__,elf64
section .note.GNU-stack noalloc noexec nowrite progbits
%endif
