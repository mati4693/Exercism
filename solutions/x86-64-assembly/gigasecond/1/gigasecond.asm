; start with 8 leap days
; if starting year is century but not divisible by 400: dec leap_days
; if ending year is leap year and end date is before 29/02: dec leap_days
; if one of years added is century but not leap year: dec leap_days

default rel
; 31 år, 259 dage, 1 time, 46 minutter og 40 sekunder
section .data
    secs db 0
    mins db 0
    hours db 0
    day dw 0
    month db 0
    year dw 0

    days_converted dw 0
    
    leap_days db 8

    months_to_days dw 0, 0, 31, 59, 90, 120, 151, 181, 212, 243, 273, 304, 334  ; 0 at first index to offset entire array
    days_in_months db 0, 31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31         ; 0 at first index to offset entire array

section .text
global add_seconds

add_seconds:
    ; Provide your implementation here
    ; rdi: (char) ptr to output buffer
    ; rsi: (char) ptr to input date
    ; ret: (void)

    ; ensure values are zero
    mov byte [secs], 0
    mov byte [mins], 0
    mov byte [hours], 0
    
    push rdi ; save output ptr for later
    
    ; parse year
    lea rdi, [year]
    mov rdx, 1
    call stoi

    inc rsi ; skip hyphen
    
    ; parse month
    lea rdi, [month]
    mov rdx, 0
    call stoi

    inc rsi ; skip hyphen
    
    ; parse day
    lea rdi, [day]
    mov rdx, 0
    call stoi

    ; check for T
    cmp byte [rsi], 0x00
    je .parsing_done ; parsing is done since we have reached null terminator
    
    inc rsi ; skip T
    
    ; parse hours
    lea rdi, [hours]
    mov rdx, 0
    call stoi

    inc rsi ; skip colon
    
    ; parse minutes
    lea rdi, [mins]
    mov rdx, 0
    call stoi

    inc rsi ; skip colon

    ; parse seconds
    lea rdi, [secs]
    mov rdx, 0
    call stoi
    
.parsing_done:

    ;---------------------------------------

    ; convert months and days into total days

    lea rcx, [months_to_days]
    
    mov al, [month]
    movzx rax, word [rcx + rax * 2]

    add al, [day]
    
    mov [days_converted], ax
    
    ;---------------------------------------

    ; check if start year is century but not leap year
    mov r8, 100
    xor rdx, rdx
    movzx rax, word [year]
    div r8

    test rdx, rdx
    jnz .skip_start_year_check

    call is_leap
    test rax, rax
    jnz .skip_start_year_check

    call inc_day

.skip_start_year_check:
    
    ;---------------------------------------

    ; add gigasecond

    mov rcx, 40
.add_secs_to_date:
    call inc_sec
    loop .add_secs_to_date

    mov rcx, 46
.add_mins_to_date:
    call inc_min
    loop .add_mins_to_date

    mov rcx, 1
.add_hours_to_date:
    call inc_hour
    loop .add_hours_to_date

    mov rcx, 259
    sub cx, [leap_days]
.add_days_to_date:
    call inc_day
    loop .add_days_to_date 

    mov rcx, 31
.add_years_to_date:
    call inc_year
    loop .add_years_to_date

    ;---------------------------------------

    ; check if end year is leap and end date is before 29/02

    call is_leap
    test rax, rax
    jz .skip_end_year_check

    cmp word [days_converted], 60
    jge .skip_end_year_check

    call inc_day

.skip_end_year_check:

    ;---------------------------------------

    ; convert total days into months and days

    mov rcx, 1 ; start at january
    movzx rax, word [days_converted]
    lea rdx, [months_to_days]
    
.total_days_to_months_and_days:
    movzx r8, word [rdx + rcx * 2]
    cmp ax, r8w
    jge .repeat_month

    dec rcx ; go back one month
    
    mov [month], cl ; write month

    sub ax, [rdx + rcx * 2] ; get days
    mov [day], al ; write day
    
    jmp .total_days_converted
    
.repeat_month:
    inc rcx
    jmp .total_days_to_months_and_days

.total_days_converted:
    
    ;---------------------------------------
    
    ; convert int to str

    pop rdi
    
    lea rsi, [year]
    mov rdx, 1
    call itos

    add rdi, 5
    mov rax, "-"
    stosb
    
    lea rsi, [month]
    mov rdx, 0
    call itos

    add rdi, 3
    mov rax, "-"
    stosb

    lea rsi, [day]
    mov rdx, 0
    call itos

    add rdi, 3
    mov rax, "T"
    stosb

    lea rsi, [hours]
    mov rdx, 0
    call itos

    add rdi, 3
    mov rax, ":"
    stosb

    lea rsi, [mins]
    mov rdx, 0
    call itos

    add rdi, 3
    mov rax, ":"
    stosb

    lea rsi, [secs]
    mov rdx, 0
    call itos

    ; null terminate
    add rdi, 3
    mov rax, 0x00
    stosb
    
    ret

inc_sec:
    inc byte [secs]
    cmp byte [secs], 60
    jne .skip
    mov byte [secs], 0
    call inc_min
.skip:
    ret

inc_min:
    inc byte [mins]
    cmp byte [mins], 60
    jne .skip
    mov byte [mins], 0
    call inc_hour
.skip:
    ret

inc_hour:
    inc byte [hours]
    cmp byte [hours], 24
    jne .skip
    mov byte [hours], 0
    call inc_day
.skip:
    ret

inc_day:
    inc word [days_converted]
    cmp word [days_converted], 366 ; 365 + 1
    jne .skip
    mov word [days_converted], 1
    call inc_year
.skip:
    ret

inc_year:
    inc word [year]

    ; check if year added is century but not leap year
    mov r8, 100
    xor rdx, rdx
    movzx rax, word [year]
    div r8

    test rdx, rdx
    jnz .not_century_or_leap_year

    call is_leap
    test rax, rax
    jnz .not_century_or_leap_year

    call inc_day
    
.not_century_or_leap_year:
    ret

is_leap:
    ; ret: bool
    movzx rdi, word [year]

    mov r8, 100
    xor rdx, rdx
    mov rax, rdi
    div r8 ; check if year is century
    
    test rdx, rdx ; check if remainder is 0
    jz .is_century

    mov r8, 4
    xor rdx, rdx
    mov rax, rdi
    div r8
    jmp .check_remainder

.is_century:
    mov r8, 400
    xor rdx, rdx
    mov rax, rdi
    div r8

.check_remainder:
    test rdx, rdx
    jz .true
    
    mov rax, 0
    ret

.true:
    mov rax, 1
    ret

stoi:
    ; convert year to int
    ; rdi: ptr to output
    ; rsi: input register
    ; rdx: bool for size of input (0: byte; 1: word)

    mov r9, rdx
    
    test r9, r9
    jnz .word_input
    mov rcx, 2

    jmp .stoi_init

.word_input:
    mov rcx, 4
    
.stoi_init:
    xor rax, rax
    xor rdx, rdx
    
.stoi_loop:
    ; multiply year by 10
    imul ax, 10

    ; fetch char
    movzx rdx, byte [rsi]
    sub dx, '0' ; convert to int

    add ax, dx
    
    test r9, r9
    jnz .write_word
    mov [rdi], al

    jmp .end_loop

.write_word:
    mov [rdi], ax

.end_loop:
    inc rsi
    loop .stoi_loop
    ret

itos:
    ; convert int to str
    ; rdi: ptr to output
    ; rsi: ptr to input
    ; rdx: bool for size of input (0: byte; 1: word)

    test rdx, rdx
    jnz .word_input
    movzx rax, byte [rsi]
    mov rcx, 2

    jmp .itos_init
    
.word_input:
    movzx rax, word [rsi]
    mov rcx, 4

.itos_init:
    mov r9, 10d

    ; start at end of output string
    add rdi, rcx
    dec rdi

.itos_loop:
    xor rdx, rdx
    div r9 ; div year with r9

    ; add char
    mov [rdi], dl
    add byte [rdi], 0x30 ; convert int to str
    
    dec rdi
    loop .itos_loop
    ret

%ifidn __OUTPUT_FORMAT__,elf64
section .note.GNU-stack noalloc noexec nowrite progbits
%endif