; Everything that comes after a semicolon (;) is a comment

section .text

; You should implement functions in the .text section
; A skeleton is provided for the first function

; the global directive makes a function visible to the test files
global create_item_entry
create_item_entry:
    ; TODO: implement the 'create_item_entry' function.
    ; This function may take any number of parameters, of which the first 6 are:
    ;
    ; 1. The address for a location in memory where the item should be stored.
    ; 2. The ID for the item, as a 64-bit unsigned integer.
    ; 3. The address for a string with the item's description.
    ; 4. The day it was found, as a 64-bit unsigned integer.
    ; 5. The month it was found, as a 64-bit unsigned integer.
    ; 6. The number of categories for the item, as a 64-bit unsigned integer.
    ; Each subsequent parameter is the address for a string with one of the categories.
    ;
    ; Values should be stored in the provided memory location in the same order of the arguments:
    ; ID, description, day, month, number of categories, and each category in order.
    ;
    ; This function has no return value.

    ; add id
    mov rax, rsi
    stosq

    ; add description  
    mov rax, rdx
    stosq

    ; add date
    mov rax, rcx
    stosq

    ; add month
    mov rax, r8
    stosq

    ; add category count
    mov rax, r9
    stosq

    ; add category pointers
    mov rcx, rax ; set rcx to amount of categories
    mov rsi, rsp ; move stack pointer to rsi
    add rsi, 8 ; move 8 bytes down the stack to access first argument

    rep movsq
    ret

global create_monthly_list
create_monthly_list:
    ; TODO: implement the 'create_monthly_list' function.
    ; This function takes as parameters:
    ;
    ; 1. The capacity of the array in bytes, as a 64-bit unsigned integer.
    ; 2. An allocator function.
    ;
    ; The allocator function should be called with the capacity as argument.
    ; It returns the address of the allocated space.
    ; This space has undefined value and should be cleared.
    ;
    ; The 'create_month_list' function should return the address for the space allocated with the allocator function.

    ; Preserve registers we will reuse
    push rdi
    call rsi ; call alloc function at rsi with rdi
    mov rdx, rax ; save alloc output

    pop rcx ; set counter to size of array
    xor rax, rax ; clear rax
    mov rdi, rdx
    rep stosb

    mov rax, rdx
    
    ret

global insert_found_item
insert_found_item:
    ; TODO: implement the 'insert_found_item' function.
    ; This function takes as parameters:
    ;
    ; 1. The address for a space in memory where the monthly list is located.
    ; 2. The current number of entries already stored in the list, as a 64-bit unsigned integer.
    ; 3. A new entry to be added to the list.
    ;
    ; You may consider that the new entry always fits into the list.
    ; All entries in the list take up 120 bytes in space.
    ; This function has no return value.

    imul rsi, 120
    add rdi, rsi
    
    mov rcx, 15 ; 120/8 equals 15
    mov rsi, rdx
    rep movsq
    
    ret

global print_item
print_item:
    ; TODO: implement the 'print_item' function.
    ; This function takes as parameters:
    ; 1. The address for a buffer where an introductory ASCII NUL-terminated string may be stored.
    ; 2. The address for a space in memory where the monthly list is located.
    ; 3. The index of the entry in the array for the item that should be printed, as a 64-bit unsigned integer.
    ; 4. A printing function.
    ;
    ; This function must call the printing function with the following arguments:
    ;
    ; 1. The address to a memory location where the introductory string is stored; or `0` (as a 64-bit integer) if no string is passed.
    ; 2. The index of the entry in the array for the item that should be printed, as a 64-bit unsigned integer.
    ; 3. The ID for the item, as a 64-bit unsigned integer.
    ; 4. The address for a string with the item's description.
    ; 5. The day the item was found, as a 64-bit unsigned integer.
    ; 6. The month the item was found, as a 64-bit unsigned integer.
    ; 7. The number of categories for the item, as a 64-bit unsigned integer.
    ; 8. The address of the first category string.
    ;
    ; The introductory string is optional.
    ; If it is used in the printing function, this string must be NUL-terminated (ending in `0`) and have at most 50 characters, already considering the NUL terminator.
    ; Otherwise, the value `0` should be passed to the printing function instead.
    ;
    ; This function has no return value.

    ; The two items sill be pushed to the stack before calling the
    ; print function. In order for rsp to be 16-byte aligned when
    ; calling the print function, we adjust rsp here.
    lea rsp, [rsp - 8]
    
    ; We store the printer function pointer to rax.
    mov rax, rcx
    ; Calculate the address of the item to print and store it to r10.
    imul r10, rdx, 120 ; Offset from the array address.
    lea r10, [rsi + r10]              ; The address of the item.
    ; Prepare the arguments to the print function.
    
    ; Before preparing the register arugments , we work on the
    ; variables to pass through the stack by using r8 in addition to
    ; the address of the item in r9.
    ; Eighth argument: the address of the first category string, which
    ; is the ADDRESS of the sixth member of the item struct.
    lea r11, [r10 + 40]
    push r11
    ; Seventh argument: the number of categories to which the item
    ; belongs, which is the fifth member of the item struct.
    mov r11, [r10 + 32]
    push r11
    ; We now prepare the register arguments to the print function.
    ; First argument: rdi, the address of introduction string.
    mov rdi, 0
    ; Second argument: rsi, the index of the item in the array.
    mov rsi, rdx
    ; Third argument: rdx, the id of the item, which is the first
    ; member of the item struct.
    mov rdx, [r10]
    ; Fourth argument: rcx, a pointer to the item description string,
    ; which is the second member of the item struct.
    mov rcx, [r10 + 8]
    
    ; Fifth argument: r8, the day of the month in which the item was
    ; found, which is the third member of the item struct.
    mov r8, [r10 + 16]
    ; Sixth argument: r9, the member in the item was found, which is
    ; the fourth member of the item struct.
    mov r9, [r10 + 24]
    
    ; Now call the print function. The function pointer is in rax.
    call rax
    
    ; Restore rsp and rbp to the original value.
    add rsp, 24
    ret

%ifidn __OUTPUT_FORMAT__,elf64
section .note.GNU-stack noalloc noexec nowrite progbits
%endif
