_start:
    mov ah, 0x0e ; tty mode
    mov al, 'H'
    int 0x10
    mov al, 'e'
    int 0x10
    mov al, 'l'
    int 0x10
    int 0x10 ; 'l' is still on al, remember?
    mov al, 'o'
    int 0x10

loop_forever:
    jmp loop_forever

times 510-($-$$) db 0

dw 0xaa55