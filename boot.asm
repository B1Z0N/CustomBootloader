Use16
org     0x7C00
start:
        cli
        mov     ax, cs
        mov     ds, ax
        mov     es, ax
        mov     ss, ax
        mov     sp, 0x7C00   
       
        mov     ax, 0xB800
        mov     gs, ax      
       
        mov     si, msg
        call    k_puts
       
        hlt                    
       
        jmp     $          
       
k_puts:
        lodsb
        test    al, al
        jz      .end_str
        mov     ah, 0x0E
        mov     bl, 0x07
        int     0x10
       
        jmp     k_puts

.end_str:

ret
 
msg     db 'Hello world', 0x0d, 0x0a, 0
 
times 510-($-$$) db 0
        db 0x55, 0xaa
