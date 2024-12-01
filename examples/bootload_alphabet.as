
mov ah, 0x0e
mov al, 65

print_char:
    int 0x10
    add al, 1
    cmp al, 'Z'
    jle print_char

boot_forever:
    jmp $

times 510-($-$$) db 0
db 0x55, 0xaa