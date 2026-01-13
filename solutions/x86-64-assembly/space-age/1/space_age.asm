default rel

section .rodata
    planet_years dd 0.2408467, 0.61519726, 1.0, 1.8808158, 11.862615, 29.447498, 84.016846, 164.79132
    earth_year_secs dd 31557600

section .text
global age
age:
    ; Provide your implementation here
    ; The function has type signature float age(enum planet planet, int seconds)
    ; The return value is of type float, which is a 32-bit floating-point number
    ; The first argument is of type enum planet, which is a 32-bit signed integer that represents a planet:
    ; 0 -> Mercury
    ; 1 -> Venus
    ; 2 -> Earth
    ; 3 -> Mars
    ; 4 -> Jupiter
    ; 5 -> Saturn
    ; 6 -> Uranus
    ; 7 -> Neptune
    ; The second argument is of type int, which is a 32-bit signed integer
    
    lea rax, [planet_years]
    movss xmm0, [rax + (rdi*4)] ; xmm0 is earth years of planet
    
    cvtsi2ss xmm1, rsi ; xmm1 now contains seconds
    cvtsi2ss xmm2, [earth_year_secs] ; xmm2 is secs in earth year

    divss xmm1, xmm2

    divss xmm1, xmm0

    movss xmm0, xmm1
    
    ret

%ifidn __OUTPUT_FORMAT__,elf64
section .note.GNU-stack noalloc noexec nowrite progbits
%endif
