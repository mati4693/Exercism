section .text

global latest
latest:
    ; Provide your implementation here
    ; The function has type signature int32_t latest(size_t scores_count, const int32_t *scores)
    ; The return value is of type int32_t, which is a 32-bit signed integer
    ; scores_count is a 64-bit integer, passed in rdi
    ; scores is the address to a read-only sequence of 32-bit signed integers, passed in rsi
    ;
    ; The function should return the last element in the input array
    ; 32-bit integer values are returned in eax

    mov eax, dword [rsi + (rdi-1)*4] ; times 4 because every score is 32-bit
    ret

global personal_best
personal_best:
    ; Provide your implementation here
    ; The function has type signature int32_t personal_best(size_t scores_count, const int32_t *scores)
    ; The return value is of type int32_t, which is a 32-bit signed integer
    ; scores_count is a 64-bit integer, passed in rdi
    ; scores is the address to a read-only sequence of 32-bit signed integers, passed in rsi
    ;
    ; The function should return the greatest element in the input array
    ; 32-bit integer values are returned in eax

    mov r8, 0
    mov r8d, dword [rsi + (rdi-1)*4] ; r8 is highest score
    jmp .score_iter

.score_iter:
    dec rdi

    cmp rdi, 0
    je .end
    
    cmp r8d, dword [rsi + (rdi-1)*4]
    cmovb r8d, dword [rsi + (rdi-1)*4]

    jmp .score_iter

.end:
    mov eax, r8d
    ret

global personal_top_three
personal_top_three:
    ; Provide your implementation here
    ; The function has type signature size_t personal_top_three(int32_t *buffer, const int32_t *scores, size_t scores_count)
    ; The return value is of type size_t, which is a 64-bit unsigned integer
    ; buffer is the address to a writable sequence of 32-bit signed integers, passed in rdi
    ; scores is the address to a read-only sequence of 32-bit signed integers, passed in rsi
    ; scores_count is a 64-bit integer, passed in rdx
    ;
    ; The function should write in the output buffer up to the three greatest elements in the input array
    ; And return the size of this buffer.
    ; 64-bit integer values are returned in rax
    
    test rdx, rdx
    jz .ret_z

    mov r8, rdi ; output_ptr
    mov r9, rsi ; scores_ptr
    mov r10, rdx ; scores_count

    mov r11, 0x80000000 ; curr_first_place
    mov r12, 0x80000000 ; curr_second_place
    mov r13, 0x80000000 ; curr_third_place

.iterate:
    test r10, r10 ; check if r10 is zero
    jz .write_out

    cmp dword [r9 + (r10*4) - 4], r11d
    jle .check_second

    mov r13d, r12d
    mov r12d, r11d
    mov r11d, dword [r9 + (r10*4) - 4]
    jmp .next
    ret

.check_second:
    cmp dword [r9 + (r10*4) - 4], r12d
    jle .check_third

    mov r13d, r12d
    mov r12d, dword [r9 + (r10*4) - 4]
    jmp .next

.check_third:
    cmp dword [r9 + (r10*4) - 4], r13d
    jle .next
    
    mov r13d, dword [r9 + (r10*4) - 4]

.next:
    dec r10
    jmp .iterate

.done:
    ret

.ret_z:
    xor rax, rax
    ret

.write_out:
    xor rax, rax
    
    mov dword [r8], r11d
    inc rax
    
    cmp rdx, 1
    je .done
    
    mov dword [r8+4], r12d
    inc rax

    cmp rdx, 2
    je .done
    
    mov dword [r8+8], r13d
    inc rax
    ret

%ifidn __OUTPUT_FORMAT__,elf64
section .note.GNU-stack noalloc noexec nowrite progbits
%endif
