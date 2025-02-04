section .data
    prompt          db  'Choose host (h) or client (c): '
    host_msg        db  'Running as host...'
    client_msg      db  'Running as client...'
    port            equ 12345
    sockaddr_host   dw  2                   ; AF_INET
                    dw  0x3930              ; Port 12345 (network byte order)
                    dd  0                   ; INADDR_ANY
                    dq  0
    sockaddr_cli    dw  2                   ; AF_INET
                    dw  0x3930              ; Port 12345
                    dd  0x0100007f          ; 127.0.0.1
                    dq  0
    reuseaddr_val   dd  1                   ; For setsockopt

section .bss
    input       resb 1
    sockfd      resd 1
    commfd      resd 1
    buffer      resb 256

section .text
    global _start

_start:
    ; Display prompt
    mov rax, 1
    mov rdi, 1
    mov rsi, prompt
    mov rdx, 31
    syscall

    ; Get user choice
    xor rax, rax
    xor rdi, rdi
    mov rsi, input
    mov rdx, 1
    syscall

    cmp byte [input], 'h'
    je host
    cmp byte [input], 'c'
    je client
    jmp exit

host:
    ; Display host message
    mov rax, 1
    mov rdi, 1
    mov rsi, host_msg
    mov rdx, 18
    syscall

    ; Create socket
    mov rax, 41
    mov rdi, 2
    mov rsi, 1
    xor rdx, rdx
    syscall
    mov [sockfd], eax

    ; Set socket options
    mov rax, 54
    mov rdi, [sockfd]
    mov rsi, 1
    mov rdx, 2
    mov r10, reuseaddr_val
    mov r8, 4
    syscall

    ; Bind socket
    mov rax, 49
    mov rdi, [sockfd]
    mov rsi, sockaddr_host
    mov rdx, 16
    syscall

    ; Listen
    mov rax, 50
    mov rdi, [sockfd]
    mov rsi, 5
    syscall

    ; Accept connection
    mov rax, 43
    mov rdi, [sockfd]
    xor rsi, rsi
    xor rdx, rdx
    syscall
    mov [commfd], eax

    jmp chat

client:
    ; Display client message
    mov rax, 1
    mov rdi, 1
    mov rsi, client_msg
    mov rdx, 20
    syscall

    ; Create socket
    mov rax, 41
    mov rdi, 2
    mov rsi, 1
    xor rdx, rdx
    syscall
    mov [sockfd], eax

    ; Connect to host
    mov rax, 42
    mov rdi, [sockfd]
    mov rsi, sockaddr_cli
    mov rdx, 16
    syscall

    mov eax, [sockfd]
    mov [commfd], eax

chat:
    ; Fork process
    mov rax, 57
    syscall
    cmp rax, 0
    je receiver

sender:
    ; Send loop
    xor rax, rax
    xor rdi, rdi
    mov rsi, buffer
    mov rdx, 256
    syscall

    cmp rax, 0
    jle exit

    mov r8, rax
    mov rax, 1
    mov rdi, [commfd]
    mov rsi, buffer
    mov rdx, r8
    syscall

    jmp sender

receiver:
    ; Receive loop
    xor rax, rax
    mov rdi, [commfd]
    mov rsi, buffer
    mov rdx, 256
    syscall

    cmp rax, 0
    jle exit

    mov r8, rax
    mov rax, 1
    mov rdi, 1
    mov rsi, buffer
    mov rdx, r8
    syscall

    jmp receiver

exit:
    ; Close sockets and exit
    mov rax, 3
    mov rdi, [sockfd]
    syscall

    mov rax, 3
    mov rdi, [commfd]
    syscall

    mov rax, 60
    xor rdi, rdi
    syscall
