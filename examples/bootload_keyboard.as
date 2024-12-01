[org 0x7c00]

keyboard_input:
    mov ah, 0
    int 0x16
    mov ah, 0x0e
    int 0x10
    jmp keyboard_input

times 510-($-$$) db 0
dw 0xaa55