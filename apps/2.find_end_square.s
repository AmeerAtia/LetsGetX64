global _start

section .data
    ; prompt
    prompt_msg db "your puzzle?: ", 0
    prompt_len equ $-prompt_msg

    ; Letters
    ocb db '{'
    ccb db '}'
    osb db '['
    csb db ']'

section .bss
    puzzle       resb 50      ; Buffer for input
    puzzle_len   resd 1       ; Length of input

section .text
_start:
    ; Print the prompt
    mov   rax, 1              ; sys_write
    mov   rdi, 1              ; stdout
    mov   rsi, prompt_msg     ; Prompt message
    mov   rdx, prompt_len     ; Prompt Length
    syscall

    ; Read input
    mov   rax, 0              ; sys_read
    mov   rdi, 0              ; stdin
    mov   rsi, puzzle         ; Input pointer
    mov   rdx, 50             ; Max length
    syscall
    mov   [puzzle_len], eax   ; Save the Length of the text that read

    ; Null-terminate the input
    mov   rsi, puzzle         ; Set pointer to puzzle
    add   rsi, [puzzle_len]   ; Set pointer after last puzzle character
    mov   byte [rsi], 0       ; Add null terminator

    ; Initialize stack for validation
    lea   rsi, [puzzle]       ; Set pointer to input
    mov   ecx, 10             ; Stack counter (10 make it not finishing)

.loop:
    mov   al, byte [rsi]      ; Load the current character
    test  al, al              ; Check for null terminator
    je    .output             ; Exit loop if null-terminated
    cmp   al, byte [osb]      ; Check for '['
    je    .open_square
    cmp   al, byte [ocb]      ; Check for '{'
    je    .open_curly
    cmp   al, byte [ccb]      ; Check for '}'
    je    .close_curly
    jmp   .next_char          ; Skip current character

.open_square:
    mov   ecx, 1              ; Set stack counter
    jmp   .next_char

.open_curly:
    add   ecx, 1              ; Increment stack counter
    jmp   .next_char          ; Continue loop

.close_curly:
    sub   ecx, 1              ; Decrement stack counter
    cmp   ecx, 0              ; If stack counter = 0 (balanced)
    je    .output             ; Print output
    jmp   .next_char          ; Else, continue loop

.next_char:
    add   rsi, 1              ; Move pointer to next character
    jmp   .loop               ; Back to loop

.output:
    mov byte [rsi], ']'       ; Edit puzzle to be solved

    ; Print solved puzzle
    mov   RAX, 1              ; sys_write
    mov   RDI, 1              ; stdout
    mov   RSI, puzzle         ; Print message
    mov   RDX, [puzzle_len]   ; Length of message
    syscall

.exit:
    mov   RAX, 60             ; sys_exit
    mov   RDI, 0              ; Exit status 0
    syscall



