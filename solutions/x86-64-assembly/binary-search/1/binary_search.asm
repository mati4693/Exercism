section .text
global find
find:
    ; Provide your implementation here
    ; This function has type signature int find(int *array, int size, int value)
    ; The first argument is the address to a memory location where an array of 32-bit signed integers is stored
    ; The second and third arguments are of type int, which is a signed 32-bit integer
    ; The function should return the index of the element in the array as a signed 32-bit integer, or -1 if the element is not in the array
    test rsi, rsi
    jz .error
    
    cmp rsi, 2
    jl .skip_sort 
    call bubble_sort ; bubble_sort if array length is 2 or longer
    
.skip_sort:
    mov r8, 0 ; lower_index
    
    mov r9, rsi ; upper_index
    dec r9

.check_bounds:
    cmp edx, dword [rdi]
    jl .error

    cmp edx, dword [rdi + (rsi-1) * 4]
    jg .error

.split_arr:
    mov r10, 0 ; init middle_index var
    add r10, r9 ; add upper_index
    sub r10, r8 ; sub lower_index to get diff between upper and lower index
    sar r10, 1 ; divide by two

    mov r11, r10 ; r11 is middle_index
    add r11, r8

    cmp r8, r9
    je .check_for_val

    cmp edx, dword [rdi + (r11)*4]
    jl .lower_half
    jg .upper_half

    ; if equal
    mov rax, r11
    ret

.lower_half:
    dec r11
    mov r9, r11 ; reassign upper_index

    jmp .split_arr

.upper_half:
    inc r11
    mov r8, r11 ; reassign lower_index

    jmp .split_arr

.check_for_val:
    cmp edx, dword [rdi + (r11)*4]
    jne .error

    mov rax, r11
    ret

.error:
    mov rax, -1
    ret

global bubble_sort
bubble_sort:
    xor rax, rax
    xor rcx, rcx

    xor r8, r8 ; iter
    
    mov r9, rsi ; comparisons left
    dec r9

.outer_loop:
    mov r8, 0
    mov r10, r9 ; r10 is upper iter

.inner_loop:
    mov eax, [rdi + r8 * 4]
    mov ecx, [rdi + r8 * 4 + 4]
    cmp eax, ecx
    jle .no_swap ; if eax is less than ebx then dont swap

    mov dword [rdi + r8 * 4 + 4], eax
    mov dword [rdi + r8 * 4], ecx

.no_swap:
    inc r8

    dec r10
    jnz .inner_loop ; if r10 (upper iter) isn't zero, then continue inner_loop

    dec r9
    jnz .outer_loop ; if r10 (comparisons left) isn't zero, then continue jmp inner_loop

    ; if execution reaches here, then the list is fully sorted
    ret

%ifidn __OUTPUT_FORMAT__,elf64
section .note.GNU-stack noalloc noexec nowrite progbits
%endif
