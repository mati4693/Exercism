; Everything that comes after a semicolon (;) is a comment

default rel

section .data
    time dd 1, 3, 3, 4, 5, 4, 7, 10

section .text

; You should implement functions in the .text section
; A skeleton is provided for the first function

; the global directive makes a function visible to the test files
global time_to_make_juice
time_to_make_juice:
    ; This function has one argument, the ID for a juice as a 32-bit number
    ; It returns the time to prepare this juice, as a 32-bit number
    lea rcx, [time]
    mov eax, dword [rcx + (rdi-1)*4]
    ret

global time_to_prepare
time_to_prepare:
    ; TODO: define the 'time_to_prepare' function
    ; This function has two arguments:
    ; - An array with the IDs for ordered juices, each ID a 32-bit number
    ; - The number of ordered juices, also a 32-bit number.
    ; It returns the total time to prepare all ordered juices, as a 32-bit number
    xor rax, rax
    xor edx, edx
    
    mov rcx, rsi
    lea r8, [time]

    .iter:
        mov edx, dword [rdi + (rcx-1)*4]
        add eax, dword [r8 + (rdx-1)*4]
        loop .iter
    
    ret

global limes_to_cut
limes_to_cut:
    ; TODO: define the 'limes_to_cut' function
    ; This function takes three arguments:
    ; - The number of wedges needed, as a 32-bit number.
    ; - An array with the current supply of limes, each represented by a 8-bit number.
    ; - The number of limes in the supply, as a 32-bit number.
    ; It returns the number of limes that need to be cut, as a 32-bit number

    xor eax, eax
    xor ecx, ecx

    test edi, edi
    jz .done

    test edx, edx
    jz .done
    
.lime_iter:
    cmp ecx, edi
    jge .done

    cmp eax, edx
    jge .done

    mov bl, byte [rsi + rax]
    
    cmp bl, 'S'
    je .s

    cmp bl, 'M'
    je .m

    cmp bl, 'L'
    je .l

    jmp .lime_iter

.s:
    add ecx, 6
    jmp .count

.m:
    add ecx, 8
    jmp .count

.l:
    add ecx, 10

.count:
    inc eax

.next:
    jmp .lime_iter
    
.done:
    ret

global remaining_orders
remaining_orders:
    ; TODO: define the 'remaining_orders' function
    ; This function takes two arguments:
    ; - The time left in the shift, as a 32-bit number.
    ; - An array  with the IDs for ordered juices still not prepared, each ID a 32-bit number.
    ; It returns the number of juices made before the shift ends, as a 32-bit number.
    ; You may consider that:
    ; - The array is never empty.
    ; - The time left in the shift at the beginning is always greater than 0.
    ; - There are more orders in the array than that which can be prepared before the shift ends.

    xor r8, r8 ; order_iter & juices_made
    xor ebx, ebx ; juices_minutes

    mov r9d, edi ; minutes_left

.order_iter:
    cmp ebx, r9d
    jae .done

    mov edi, dword [rsi + r8*4]
    call time_to_make_juice
    add ebx, eax
    
    inc r8
    jmp .order_iter
    
.done:
    mov rax, r8
    ret

%ifidn __OUTPUT_FORMAT__,elf64
section .note.GNU-stack noalloc noexec nowrite progbits
%endif
