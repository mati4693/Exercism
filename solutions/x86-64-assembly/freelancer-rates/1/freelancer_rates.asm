; Everything that comes after a semicolon (;) is a comment.

section .text

; You should implement functions in the .text section.
; A skeleton is provided for the first function.

; The global directive makes a function visible to the test files.
global daily_rate
daily_rate:
    ; This function takes an hourly_rate, as a 64-bit floating-point number.
    ; It returns the daily rate, also as a 64-bit floating-point number.
    ; A day has 8 billable hours.

    mov rax, 8
    cvtsi2sd xmm1, rax
    
    mulsd xmm0, xmm1
    ret

global apply_discount
apply_discount:
    ; TODO: define the 'apply_discount' function.
    ; It takes as parameters a price and a discount in percent, both as 64-bit floating-point number.
    ; It returns the price with discount applied, as a 64-bit floating-point number.

    movsd xmm3, xmm0 ; xmm3 is orig price
    
    mov rax, 100
    cvtsi2sd xmm2, rax ; xmm2 is used for dividing

    ; getting amount to substract
    mulsd xmm3, xmm1
    divsd xmm3, xmm2

    subsd xmm0, xmm3
    ret

global monthly_rate
monthly_rate:
    ; TODO: define the 'monthly_rate' function.
    ; It takes as parameters an hourly_rate and a discount in percent, both as a 64-bit floating-point number.
    ; It returns the discounted monthly rate, as a 64-bit integer, rounded up.
    ; A month has 22 billable days.
    
    mov r8, 22
    imul r8, 8
    cvtsi2sd xmm5, r8 ; get multiplier for total hours
    
    mulsd xmm0, xmm5
    
    call apply_discount

    roundsd xmm0, xmm0, 2
    cvtsd2si rax, xmm0
    ret

global days_in_budget
days_in_budget:
    ; TODO: define the 'days_in_budget' function.
    ; It takes as parameters:
    ; 1. A budget as a 64-bit unsigned integer.
    ; 2. An hourly_rate, as a 64-bit floating-point number.
    ; 3. A discount in percent, as a 64-bit floating-point number.
    ; It returns the number of complete days of work the budget covers, as a 32-bit unsigned integer, rounded down.

    cvtsi2sd xmm4, rdi ; convert budget to 64-bit float

    movsd xmm5, xmm1 ; save discount for later
    call daily_rate

    movsd xmm1, xmm5 ; move discount into xmm1
    call apply_discount

    divsd xmm4, xmm0
    roundsd xmm4, xmm4, 1

    cvtsd2si rax, xmm4
    ret

%ifidn __OUTPUT_FORMAT__,elf64
section .note.GNU-stack noalloc noexec nowrite progbits
%endif
