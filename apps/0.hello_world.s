global _start

section .data
    msg db "Hello, World!", 0xA ; message with new line
    len equ $-msg               ; get length of message

section .text
_start:
	mov rax, 1     ; system write number
	mov rdi, 1     ; file descriptor -> stdout
	mov rsi, msg   ; the message
	mov rdx, len   ; length of message
	syscall        ; call system
	; exit syscall
	mov rax, 60    ; system exit number
	xor rdi, rdi   ; 0 close status
	syscall        ; call system

