; Everything that comes after a semicolon (;) is a comment.

default rel

section .data
    currencies dd "GBP", "EUR", "JPY", "AUD", "BRL", "CNY", "CAD", "INR"

; Some of the functions below make use of an enum currency_t defined as:
; enum currency_t {
;    GBP,
;    EUR,
;    JPY,
;    AUD,
;    BRL,
;    CNY,
;    CAD,
;    INR
; };

section .text

; You should implement functions in the .text section.
; A skeleton is provided for the first function.

; The global directive makes a function visible to the test files.
global stringify_currency
stringify_currency:
    ; This function has signature: void stringify_currency(char *buffer, enum currency_t currency);
    ; It stores the string representation for the value of a enum currency_t in the passed buffer
    lea rax, [currencies]
    
    mov eax, [rax + rsi*4]
    mov [rdi], eax
    
    ret

global exchange_rate
exchange_rate:
    ; TODO: define the 'exchange_rate' function.
    ; This function has signature: double exchange_rate(enum currency_t domestic_currency, enum currency_t foreign_currency, const double *value_in_US_dollars);
    ; It returns the value of one unit of foreign currency in the domestic currency.
    ; `value_in_US_dollars` is a pointer to the beginning of an array of `double` with the value of 1 unit of each enum currency_t, in dollars.

    shl rdi, 3 ; multiply by 8
    shl rsi, 3 ; multiply by 8
    
    movsd xmm0, [rdx + rsi] ; load foreign value
    movsd xmm1, [rdx + rdi]   ; load domestic value

    divsd xmm0, xmm1
    ret

global get_value_of_bills
get_value_of_bills:
    ; TODO: define the 'get_value_of_bills' function.
    ; This function has signature: uint64_t get_value_of_bills(unsigned long long denomination, unsigned short number_of_bills);
    ; It returns the total value of the bills.
    imul rdi, rsi
    mov rax, rdi
    
    ret

global get_number_of_bills
get_number_of_bills:
    ; TODO: define the 'get_number_of_bills' function.
    ; This function has signature: unsigned int get_number_of_bills(float amount, unsigned long long denomination);
    ; It returns the nuumber of whole bills that can be received within the given amount.
    roundss xmm0, xmm0, 1 ; round xmm0 down
    cvtss2si rax, xmm0

    cqo
    div rdi ; divide rax by rdi
    ret

global exchangeable_value
exchangeable_value:
    ; TODO: define the 'exchangeable_value' function.
    ; This function has signature: uint32_t exchangeable_value(float budget, double exchange_rate, uint8_t spread, unsigned long long denomination);
    ; It returns the maximum value of the new currency after calculating the exchange rate adjusted by the spread.

    ; xmm0 is budget 32-bit
    ; xmm1 is exchange_rate 64-bit
    ; rdi is spread 8-bit
    ; rsi is denomination  64-bit

    mov rdx, 100
    
    cvtsi2sd xmm2, rdi ; load spread to xmm2
    cvtsi2sd xmm3, rdx

    movsd xmm4, xmm1 ; save orig rate for later

    ; calculate rate with spread
    mulsd xmm1, xmm2
    divsd xmm1, xmm3
    addsd xmm1, xmm4
    
    cvtsd2ss xmm1, xmm1
    divss xmm0, xmm1 ; xmm0 is now new budget

    mov rdi, rsi
    call get_number_of_bills

    imul rax, rsi
    
    ret

%ifidn __OUTPUT_FORMAT__,elf64
section .note.GNU-stack noalloc noexec nowrite progbits
%endif
