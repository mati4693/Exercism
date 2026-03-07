default rel

section .data
    row_count dq 0
    column_count dq 0
    
section .text
global tick
tick:
    ; Provide your implementation here
    ; rdi: (uint64_t*) output
    ; rsi: (uint64_t*) input
    ; rdx: (size_t) row_count
    ; rcx: (size_t) column_count
    
    mov r8, rcx ; x
    mov r9, rdx ; y
    mov [row_count], rdx
    mov [column_count], rcx

    dec r9
    
.row_loop:
    mov r8, [column_count] ; restore x
    dec r8
    
    xor rdx, rdx ; rdx is temp row

.column_loop:
    call neighbors_alive

    cmp rax, 3
    jg .next_cell ; avoid over crowding
    cmp rax, 2
    jl .next_cell ; under two so already dead

    mov rcx, 0x8000000000000000 ; bitmask for setting msb
    
    jne .set_alive ; rax is definitely 3

    mov r13, [column_count]
    dec r13
    sub r13, r8
    
    ; rax is 2
    bt qword [rsi + r9*8], r13 ; check msb for carry flag
    jnc .next_cell
    
.set_alive:
    or rdx, rcx
    
.next_cell:
    shr rdx, 1
    
    dec r8
    test r8, r8
    jns .column_loop

    shl rdx, 1

    ; do some magic which makes it work
    mov rcx, [column_count]
    rol rdx, cl
    
    mov qword [rdi + r9*8], rdx
    
    ; new row
    dec r9
    test r9, r9
    jns .row_loop

    ret

neighbors_alive: 
    ; regs altered: rax, rcx, r10, r11, r12
    ; r8: x 
    ; r9: y 
    ; ret: number of neighbors alive 
    
    xor rax, rax 

    ; start in top left corner
    dec r8
    dec r9
    
    mov r12, r8 ; save orig x
    
    mov r10, 3 ; row counter 
    
.check_row_cells: 
    mov r11, 3 ; column counter 
    
.check_column_cells:
    cmp r11, 2
    jne .not_center_cell
    cmp r10, 2
    je .next_column

.not_center_cell:
    ; check if x is negative 
    test r8, r8 
    js .next_column ; skip empty space 
    
    ; check if x is over 
    cmp r8, qword [column_count] 
    jge .next_column ; skip 

    ; check for negative y 
    test r9, r9 
    js .next_column ; skip empty space 

    ; check if over y 
    cmp r9, qword [row_count] 
    jge .next_column ; skip

    ; invert x so we get from msb
    mov rcx, [column_count]
    dec rcx
    sub rcx, r8
    
    bt qword [rsi + r9*8], rcx ; bit test into carry flag 
    jnc .next_column ; dead cell in carry bit (msb)
    
    inc rax 
.next_column: 
    inc r8 
    dec r11 
    jnz .check_column_cells 
    
.next_row: 
    inc r9 ; next line 
    mov r8, r12 ; reset x 
    dec r10 
    jnz .check_row_cells 
    
.done:
    ; restore coords
    inc r8 ; restore x
    sub r9, 2 ; restore y

    ret ; return count

%ifidn __OUTPUT_FORMAT__,elf64
section .note.GNU-stack noalloc noexec nowrite progbits
%endif
