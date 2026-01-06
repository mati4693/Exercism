; Everything that comes after a semicolon (;) is a comment

section .data
    last_week_arr db 0, 2, 5, 3, 7, 8, 4, 0 ; first number is oldest (lsb) and second last is newest
    
    curr_days_counted db 0, 0, 0, 0, 0, 0, 0, 0 ; first number is oldest (lsb) and second last is newest
    curr_week_count db 0, 0, 0, 0, 0, 0, 0, 0
    
    curr_day_num db 0 ; 0=monday and 6=sunday

    empty_template db 0, 0, 0, 0, 0, 0, 0, 0

;section .bss
;    curr_week_count resb 8

section .text

; You should implement functions in the .text section
; A skeleton is provided for the first function

; the global directive makes a function visible to the test files

global last_week_counts
last_week_counts:
    ; This function takes no parameter
    ; It returns a copy of last week's counts as a 8-byte number
    ; At the start of the program, last week's counts are 0, 2, 5, 3, 7, 8 and 4
    ; The last byte of the return value is always zero

    mov rax, [rel last_week_arr]
    ret

global current_week_counts
current_week_counts:
    ; TODO: define the 'current_week_counts' function
    ; This function takes no parameter
    ; It returns two values:
    ; - A copy of current week's counts as a 8-byte number.
    ; - The number of days already filled in the current week, as a 8-byte number.
    ; All days after the most recent one should have its corresponding byte zeroed-out in the output
    ; At the start of the program, there is no count for the current week

    mov rax, [rel curr_week_count]
    mov rdx, [rel curr_days_counted]
    ret

global save_count
save_count:
    ; TODO: define the 'save_count' function
    ; This function takes as parameter the most recent count, as a 1-byte number
    ; It must save this value in a new entry for the current week
    ; If there is already 7 entries in the current week before the function is called, then:
    ; - The current week becomes the last week.
    ; - A new entry is added with the passed value in a new current week.
    ; The function has no return value
    
    mov r8, [rel curr_week_count]
    mov r9, [rel curr_days_counted]
    mov r10b, [rel curr_day_num]

    mov r11, [rel last_week_arr]

    mov r12b, 0 ; conv immediate to register for cmove
    
    cmp r10w, 7
    cmove r11, r8
    cmove r8, [rel empty_template]
    cmove r9, [rel empty_template]
    cmove r10w, r12w

    mov [rel curr_week_count], r8
    mov [rel curr_days_counted], r9
    mov [rel last_week_arr], r11

    
    lea r8, [rel curr_week_count]
    mov byte [r8 + r10], dil

    lea r9, [rel curr_days_counted]
    mov byte [r9 + r10], 1

    inc r10b
    mov [rel curr_day_num], r10b
    ret

global today_count
today_count:
    ; TODO: define the 'today_count' function
    ; This function has no parameter
    ; It returns the most recent entry for the current week, as a 1-byte number

    lea r8, [rel curr_week_count]
    mov r9, [rel curr_day_num]
    
    mov al, byte [r8 + r9]
    ret

global update_today_count
update_today_count:
    ; TODO: define the 'update_today_count' function
    ; This function takes as parameter a 1-byte number
    ; It adds this number to the most recent entry for the current week
    ; This function has no return value

    lea r8, [rel curr_week_count]
    mov r9, [rel curr_day_num]
    
    add byte [r8 + r9], dil

    ret

global update_week_counts
update_week_counts:
    ; TODO: define the 'update_week_counts' function
    ; This function takes as parameter a 8-byte number
    ; Each byte in the input parameter, but the last, represents a day's count in the current week
    ; The last byte in the input parameter has no meaning and must be zeroed-out
    ; This function makes the following changes:
    ; - The current week becomes the last week.
    ; - The counts in the input parameter are fully inserted in the current week.

    ret

%ifidn __OUTPUT_FORMAT__,elf64
section .note.GNU-stack noalloc noexec nowrite progbits
%endif