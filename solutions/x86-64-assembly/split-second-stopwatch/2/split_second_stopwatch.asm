default rel

%include "debug.mac"

%macro TIME_IN_SECS 1 ; 1% time_str
    ; get seconds from time
    ; rax: return
    ; rcx: counter
    ; rdx: tmp register
    ; r8: total secs
    ; r9: factor for multiplication/division
    xor rax, rax
    mov r8, 0
    mov r9, 36000

    mov rcx, 8
%%time_parse_loop:
    movzx rax, byte [%1]
    cmp al, 0x3A
    je %%colon_divide_by_6
    sub rax, 0x30 ; convert from str to int
    xor rdx, rdx ; ensure rdx is clear after division
    
    mul r9
    
    add r8, rax ; add to total

%%divide_by_ten:
    mov rax, r9
    mov r9, 10
    jmp %%divide
%%colon_divide_by_6:
    mov rax, r9
    mov r9, 10
    xor rdx, rdx
    mul r9
    mov r9, 6
%%divide:
    ;debugu64 r8
    ;debugu64 rax
    cqo ; clear rdx to create octoword rdx:rax
    div r9
    mov r9, rax ; store new factor
%%done:
    inc qword %1

    dec rcx
    jnz %%time_parse_loop

    sub qword %1, 8 ; restore pointer
    mov rax, r8 ; return time in secs
    
    ;debugu64 rax
%endmacro

%macro SECS_INTO_TIME 2 ; 1%: output_ptr; 2%: secs
    ; get time from seconds
    ; rax: total_secs
    ; rcx: counter
    ; rdx: tmp register
    ; r8: register for saving seconds
    ; r9: factor for multiplication/division
    mov r8, %2
    mov r9, 36000

    mov rcx, 8
%%time_parse_loop:
    cmp rcx, 3
    je %%colon_divide_by_6
    cmp rcx, 6
    je %%colon_divide_by_6

    ; not colon
    mov byte [%1], 0x30 ; "0"
    
    cqo ; clear rdx to create octoword rdx:rax
    mov rax, r8
    div r9 ; rax is quotient and rdx is rest
    
    add byte [%1], al ; add to char
    mov r8, rdx
    
%%divide_by_ten:
    mov rax, r9
    mov r9, 10
    jmp %%divide
%%colon_divide_by_6:
    mov byte [%1], 0x3A ; ":"
    mov rax, r9
    mov r9, 10
    xor rdx, rdx
    mul r9
    mov r9, 6
%%divide:
    cqo ; clear rdx to create octoword rdx:rax
    div r9
    mov r9, rax ; store new factor
%%done:
    ;debugu8 byte [%1]
    inc qword %1
    
    dec rcx
    jnz %%time_parse_loop
    
    sub qword %1, 8 ; restore pointer
%endmacro

section .data
    watch_state db 0 ; 0: ready; 1: running; 2: stopped
    current_lap_time db 9 dup (0) ; 8 bytes for string and 1 byte for null
    total_lap_time db 9 dup (0) ; 8 bytes for string and 1 byte for null
    laps_run db 0
    lap_times db 90 dup (0) ; define ten lap times (one lap is 8+1 bytes)

    initial_time dq "00:00:00"
    

section .text

global new
global start
global stop
global reset
global state
global lap
global current_lap
global previous_laps
global advance_time
global total

new:
    ; clear values
    mov byte [watch_state], 0
    mov byte [laps_run], 0
    
    mov rax, [initial_time]
    mov [current_lap_time], rax
    mov [total_lap_time], rax
    
    mov rcx, 10
    mov rax, 0
    lea rdi, [lap_times]
    rep stosq ; clear 80 bytes of 90 bytes
    rep stosb ; clear last 10 bytes of the 90 bytes
    ret

start:
    ; ret: error_type
    cmp byte [watch_state], 0
    jne .check_if_running
    mov byte [watch_state], 1
    mov rax, 0 ; 0 = success
    jmp .done
.check_if_running:
    cmp byte [watch_state], 1
    jne .check_if_stopped
    mov rax, 1 ; 1 = already_running
    jmp .done
.check_if_stopped:
    cmp byte [watch_state], 2
    jne .done
    mov byte [watch_state], 1
    mov rax, 0 ; 0 = success
.done:
    ret

stop:
    ; ret: error_type
    cmp byte [watch_state], 1
    jne .check_if_ready
    mov byte [watch_state], 2
    mov rax, 0 ; 0 = success
    jmp .done
.check_if_ready:
    cmp byte [watch_state], 0
    mov rax, 2 ; 2 = not_running
    jmp .done
.done:
    ret

reset:
    cmp byte [watch_state], 2
    jne .not_stopped_error

    mov byte [watch_state], 0 ; set watch_state to ready

    mov rax, [initial_time]
    mov [current_lap_time], rax

    mov byte [laps_run], 0
    
    mov rcx, 10
    mov rax, 0
    lea rdi, [lap_times]
    rep stosq ; clear 80 bytes of 90 bytes
    rep stosb ; clear last 10 bytes of the 90 bytes
    
    mov rax, 0
    jmp .done
.not_stopped_error:
    mov rax, 3 ; 3 is not_stopped
.done:
    ret

state:
    movzx rax, byte [watch_state]
    ret

lap:
    cmp byte [watch_state], 1
    jne .not_running_error
    
    lea rdi, [lap_times]
    
    mov rax, 9
    xor rdx, rdx
    mul byte [laps_run]
    add rdi, rax
    
    mov rax, qword [current_lap_time]
    stosq ; store rax in rdi
    mov rax, 0x00
    stosb ; store null terminator
    
    ; reset current_lap_time
    mov rax, [initial_time]
    mov [current_lap_time], rax

    inc byte [laps_run]
    
    mov rax, 0 ; 0 is successful
    jmp .done
.not_running_error:
    mov rax, 2 ; 2 is not_running
.done:
    ret

current_lap:
    lea rax, [current_lap_time]
    ret

previous_laps:
    ; rdi: (const char*) buffer
    ; ret: amount of laps
    
    movzx rax, byte [laps_run]

    ; check if none laps written
    test rax, rax
    jz .done 
    
    mov rcx, rax
    lea rsi, [lap_times]
    
.previous_laps_loop:

    mov [rdi], rsi
    add rsi, 9
    add rdi, 8
    loop .previous_laps_loop
    
.done:
    ret

advance_time:
    ; rdi: (const char*) str
    cmp byte [watch_state], 1
    jne .not_running

    TIME_IN_SECS rdi ; rax now has secs
    push rax
    
    ; add time to current_lap_time
    lea rdi, [current_lap_time]
    TIME_IN_SECS rdi

    pop r8
    push r8 ; save advance_time for later
    add rax, r8 ; rax now holds the sum of advance_time and current_lap_time

    lea rdi, [current_lap_time]
    SECS_INTO_TIME rdi, rax

    ; add time to total_lap_time
    lea rdi, [total_lap_time]
    TIME_IN_SECS rdi
    
    pop r8
    add rax, r8 ; rax now holds the sum of advance_time and total_lap_time

    lea rdi, [total_lap_time]
    SECS_INTO_TIME rdi, rax
    
.not_running:
    ret

total:
    lea rax, [total_lap_time]
    ret

%ifidn __OUTPUT_FORMAT__,elf64
section .note.GNU-stack noalloc noexec nowrite progbits
%endif
