[bits 16] ; use 16 bits
[org 0x7c00] ; sets the start address

;;; Four NOPs just so I can locate my code in RAM. Not needed to work.
    nop
    nop
    nop
    nop

    ;; initialize stack
    mov bp, 0x8000
    mov sp, bp

    ;; set bx to the number to print
    mov ax, 0xffff

    ;; call the print_number function
    call print_number

    ;; done, so infinite loop
    jmp $                       ; end prog

;;; the number to print is stored in ax
print_number:

    xor cx, cx                  ; set up counter for number of digits
    mov bx, 0x0a                ; prepare divisor

cvt_number_loop:
    xor dx, dx                  ; clear dx to hopefully prep for dx:ax / bx
    div bx                      ; divide ax by 10; q = al, r = ah
    ;; ax = quotient ; dx = remainder
    ;; why no workie for 0x8000-0xffff? why is it determined to be SIGNED?!?

    push dx                     ; push the remainder onto the stack
    inc cx                      ; increment the digit counter
    test ax, ax                 ; see if quotient is zero
    jz cvt_number_done          ; if so, exit number conversion loop
    jmp cvt_number_loop         ; next loop iteration

cvt_number_done:
    xor ax, ax                  ; clear out ax

print_digits:
    pop bx                      ; pop the high-order digit off the stack
    dec cx                      ; decrement the digit counter
    mov al, bl                  ; put it into al to print
    add al, '0'                 ; renormalize to '0' to print ASCII digit
    push cx                     ; save counter from being clobbered
    call __print
    pop cx                      ; restore saved counter
    test cx, cx                 ; see if counter is zero
    jz done_printing            ; if so, exit print loop
    jmp print_digits            ; if not, print next digit

done_printing:
    call __print_crlf           ; print CRLF after last digit
    ;; done printing the number so return
    ret

__print_crlf:
    pusha
    mov al, 0x0a
    call __print
    mov al, 0x0d
    call __print
    popa
    ret

;;; al needs to have the character in it to print
__print:
    pusha
    mov ah, 0x0e
    int 0x10
    popa
    ret

;;; quick and dirty debug print function; prints one character
;;; that is stored in dl
__debug_print:
    pusha
    mov al, dl
    call __print
    call __print_crlf
    popa
    ret

    times 510-($-$$) db 0
    db 0x55, 0xaa