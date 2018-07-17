;must be compiled as:           "nasm -f bin boot.asm"
;and written to flash disc as:  "dd if=boot of=/dev/sd??

;only proto, this code may be found elsewhere on the internet

;some useful links for beginners(such as i am):
;https://bit.ly/2uGIy97
;https://bit.ly/2mqFY3y(BIOS interrupt table)
;https://bit.ly/2uxJLQM(osdev main page, look bootloaders)
;some Russian tutorials https://habr.com/post/107030/ https://habr.com/post/173705/
;the last one in English https://bit.ly/2LjBBoE
;;
        ;;
                ;;
                        ;;
Use16                           ;real mode(the only available in boot)
org     0x7C00                  ;address of our program in RAM
start:                          ;
        cli                     ;disable interruptions
        mov     ax, cs          ;init segment registers
        mov     ds, ax          ;
        mov     es, ax          ;
        mov     ss, ax          ;
        mov     sp, 0x7C00      ;stack is going up, so it won`t interact with other segments
                                ;
        mov     ax, 0xB800      ;https://bit.ly/2zMBE85
        mov     gs, ax          ;
                                ;
        mov     si, msg         ;our message to print
        call    k_puts          ;call our printfunc
                                ;
        hlt                     ;halt
                                ;
        jmp     $               ;endless loop($ - this point of the programm)
                                ;
k_puts:                         ;
        lodsb                   ;load si->al and inc si
        test    al, al          ;if end of string
        jz      .end_str        ;jump to .end_str
        mov     ah, 0x0E        ;gray font
        mov     bl, 0x07        ;dark background
        int     0x10            ;call BIOS interrupt to do job for us(see https://bit.ly/2NjiVmk)
                                ;
        jmp     k_puts          ;
                                ;
.end_str:                       ;
                                ;
ret                             ;       
                                ;
                                ;
msg     db 'Hello world',       ;
                0x0d, 0x0a, 0   ;
                                ;
times 510-($-$$) db 0           ;fulfill rest of the file with 0($$-start of the program in memory)
        db 0x55, 0xaa           ;the last two bits must be exactly this, to enable BIOS reading this to RAM
        
