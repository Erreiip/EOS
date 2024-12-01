[org 0X7c00]

mov bp, 0x8000 ; stack
mov sp, bp     ; stack pointer to start of stack

mov ax, 0x0f0a   ; value to print
xor cx, cx       ; reset the counter
call func_divide 

func_divide:
    xor dx, dx
    mov bx, 0x0a
    div bx
    push dx
    add cx, 1
    cmp ax, 0
    jne func_divide

print:
    cmp cx, 0
    je end
    pop bx
    mov ah, 0x0e
    mov al, bl
    add al, '0'
    int 0x10
    sub cx, 1
    jmp print 

end:
    jmp $

times 510-($-$$) db 0
dw 0xaa55