[org 0x7c00]
mov ah, 0x0e
mov bx, hello_string

print_string:
    mov al, [bx]    
    cmp al, 0
    je end
    int 0x10
    add bx, 1
    jmp print_string
end:

jmp $

hello_string:
    db "Hello world", 0

times 510-($-$$) db 0
dw 0xaa55