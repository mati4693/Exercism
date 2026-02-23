default rel

section .data    
    next_id dd 0
    max_names dd 676000

section .text

global create_name
global reset_name
global release_names

create_name:
    ; rdi: (char*) output

    mov eax, [next_id]
    inc dword [next_id]

    ; scramble id
    mov ecx, 65537
    mul ecx                
    xor edx, edx
    div dword [max_names]  ; eax = quotient, edx = remainder

    mov eax, edx ; eax is now scrambled id

    ; extract last 3 digits
    mov ecx, 1000
    xor edx, edx
    div ecx ; eax = letters, edx = numbers

    mov r8d, eax
    mov r9d, edx

    ; write letters
    mov eax, r8d
    mov ecx, 26
    xor edx, edx
    div ecx ; eax = first letter, edx = second letter
    add al, 'A'
    stosb

    mov al, dl
    add al, 'A'
    stosb

    ; write numbers
    mov eax, r9d
    
    mov ecx, 100 ; get amount of hundreds
    xor edx, edx
    div ecx ; eax = hundreds, edx = rest
    add al, '0'
    stosb

    mov eax, edx
    mov ecx, 10 ; get amount of tens
    xor edx, edx
    div ecx ; eax = tens, edx = ones
    add al, '0'
    stosb

    add dl, '0'
    mov al, dl
    stosb

    ; null terminate
    xor eax, eax
    stosb

    ret

reset_name:
    jmp create_name

release_names:
    mov dword [next_id], 0
    ret

%ifidn __OUTPUT_FORMAT__,elf64
section .note.GNU-stack noalloc noexec nowrite progbits
%endif