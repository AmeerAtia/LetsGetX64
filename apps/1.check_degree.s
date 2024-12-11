global _start

section .data

    ; prompt
    prompt_msg db "your degree?: ", 0
    prompt_len equ $-prompt_msg

    ; success
    success_msg db "u succeeded", 10, 0
    success_len equ $-success_msg

    ; fail
    fail_msg db "u failed", 0xA, 0
    fail_len equ $-fail_msg


section .bss
    ; 4b input
    degree resb 4


section .text
_start:
    ; Print the prompt
    mov rax, 1              ; sys_write
    mov rdi, 1              ; stdout
    mov rsi, prompt_msg     ; Prompt message
    mov rdx, prompt_len     ; Prompt Length
    syscall

    ; Read input
    mov rax, 0              ; sys_read
    mov rdi, 0              ; stdin
    mov rsi, degree         ; Input pointer
    mov rdx, 4              ; Max length (4 bytes)
    syscall

    ; Convert input from ASCII to integer
    movzx eax, byte [degree]     ; Load the first degree
    sub eax, '0'                 ; Convert ASCII to integer
    movzx ebx, byte [degree + 1] ; Load the second degree
    sub ebx, '0'                 ; Convert ASCII to integer
    imul eax, eax, 10            ; eax *= 10
    add eax, ebx                 ; eax += ebx

    ; Check if degree >= 5
    cmp eax, 50       ; Compare degree with 50
    jge .succeeded    ; If >= 5, jump to success
    jl .failed        ; If < 5, jump to failed


.succeeded:
    ; Print "u succeeded"
    mov rax, 1              ; sys_write
    mov rdi, 1              ; stdout
    mov rsi, success_msg    ; Pointer to success message
    mov rdx, success_len    ; Length of success message
    syscall
    jmp .exit

.failed:
    ; Print "u failed"
    mov rax, 1              ; sys_write
    mov rdi, 1              ; stdout
    mov rsi, fail_msg       ; Pointer to fail message
    mov rdx, fail_len       ; Length of fail message
    syscall
    jmp .exit



.exit:
    mov rax, 60 ; sys_exit
    mov rdi, 0  ; close status
    syscall



