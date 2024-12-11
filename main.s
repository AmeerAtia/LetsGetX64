; sock_fd = socket(family, type, protocol)
%macro socket 4
    mov RAX, 41
    mov RDI, %1
    mov RSI, %2
    mov RDX, %3
    syscall
    mov %4, RAX
    ; handle error 
    cmp RAX, 0
    jl .end
%endmacro

; bind(sock_fd, sock_address_in, sock_len)
%macro bind 3
    mov RAX, 49
    mov RDI, %1
    mov RSI, %2
    mov RDX, %3
    syscall
    ; handle error
    cmp RAX, 0
    jne .end
%endmacro

; listen(sock_fd, backlog)
%macro listen 2
    mov rax, 50
    mov RDI, %1
    mov RSI, %2
    syscall
    ; handle error
    cmp RAX, 0
    jne .end
%endmacro

; client_fd = accept(sock_fd, sock_address_in, sock_len)
%macro accept 4
    mov RAX, 43
    mov RDI, %1
    mov RSI, %2
    mov RDX, %3
    syscall
    mov %4, RAX
    ; handle error
    cmp RAX, 0
    jl .end
%endmacro

; connect(sock_fd, sock_address_in, sock_len)
%macro connect 3
    mov rax, 42
    mov RDI, %1
    mov RSI, %2
    mov RDX, %3
    syscall
    ; handle error
    cmp RAX, 0
    jne .end
%endmacro

; fork(point)
%macro fork 1
    mov rax, 57
    syscall
    test rax, rax
    jz %1
%endmacro

; send(sock_fd, buf, len)
%macro send 3
    mov RAX, 44
    mov RDI, %1 ; sock_fd
    mov RSI, %2 ; [text]
    mov RDX, %3 ; len
    xor R10, R10
    syscall
    cmp RAX, -1
    je .end
%endmacro

; recv(sock_fd, buf, len)
%macro recv 3
    mov RAX, 45
    mov RDI, %1
    mov RSI, %2
    mov RDX, %3
    syscall
    mov byte [%2 + RAX], 0 
%endmacro

%macro close 1
    mov RAX, 3
    mov RDI, %1
    syscall
    ; handle error
    cmp RAX, 0
    jl .end
%endmacro

; print(message, len)
%macro print 2
    mov RAX, 1
    mov RDI, 1
    mov RSI, %1
    mov RDX, %2
    syscall
%endmacro

; input(message, len)
%macro input 2
    mov RAX, 0
    mov RDI, 0
    mov RSI, %1
    mov RDX, %2
    syscall
    mov byte [%1 + RAX], 0
    ; handle error
    cmp RAX, -1
    je .end
%endmacro

; exit(status)
%macro exit 1
    mov RAX, 60
    mov RDI, %1
    syscall
%endmacro





section .data
    prompt db "Be host or client(h/c)?: ", 0
    prompt_len equ $-prompt

    host_ask db "Hosting on port?: ", 0
    host_ask_len equ $-host_ask

    client_ask db "Connecting to?: ", 0
    client_ask_len equ $-client_ask

    invalid db "invalid input", 10, 0
    invalid_len equ $-invalid

    msg_ask db "Enter message: ", 0
    msg_ask_len equ $-msg_ask
    
    recv_msg db "Got: ", 0
    recv_len equ $-recv_msg

    ; sock_address_in dw 0x0200, 0x0BD0, 0x00000000

    sock_address_in:
        dw 2
        dw 3090
        dd 0x00000000
        db 0, 0, 0, 0, 0, 0, 0, 0


section .bss
    mode resb 1
    app_mode resb 1
    send_message resb 100
    recv_message resb 100
    sock_fd resq 1
    client_fd resq 1

section .text
global _start

_start:

.ask_mode:
    ; print prompt
    print  prompt, prompt_len
    ; ask for mode
    input  mode, 1
    mov    AL, byte [mode]
    ; if mode = host, enter host_mode
    cmp    AL, 'h'
    je     .host_mode
    ; if mode = client, enter client_mode
    cmp    AL, 'c'
    je     .client_mode
    ; else, ask again
    print  invalid, invalid_len
    jmp    .ask_mode

.host_mode:
    ; create socket: socket(AF_INET, SOCK_STREAM, 0)
    socket 2, 1, 0, [sock_fd]
    ; bind(sockfd, sockaddr_in , size of sockaddr_in)
    bind [sock_fd], sock_address_in, 16 ; err here
    listen [sock_fd], 5

    ; Accept connection
    ; Client sockaddr (can be NULL)
    ; Length (not used here)
    accept [sock_fd],0 , 0, [client_fd]
    ; Enter chat loop
    jmp .fork_chat

.client_mode:
    ; Create socket: socket(AF_INET, SOCK_STREAM, 0)
    socket 2, 1, 0, [sock_fd]

    ; Connect to server
    connect [sock_fd], sock_address_in, 16
    ; Enter chat loop
    jmp .fork_chat

; 2 processes 1 for send_loop and another for receive_loop
.fork_chat:
    fork .receive_loop

.send_loop:
    ; print "Enter message: "
    print msg_ask, msg_ask_len
    ; read input
    input send_message, 100
    mov AL, byte [send_message]
    mov byte [app_mode],  AL
    call .is_ended
    ; send message
    send [sock_fd], send_message, 100
    ; loop
    jmp .send_loop

.receive_loop:
    call .is_ended
    ; wait for a message
    recv [sock_fd], recv_message, 100

    ; handle error
    cmp RAX, -1
    je .end

    cmp RAX, 0
    je .receive_loop
    jl .end
    ; print "Got: "
    print recv_msg, recv_len
    ; print the received message
    print recv_message, 100
    ; loop
    jmp .receive_loop

.is_ended:
    mov RAX, 0
    cmp byte [app_mode], ';'
    je .end
    ret

.end:
    ; save err
    mov RSI, RAX
    close [sock_fd]
    exit RSI
