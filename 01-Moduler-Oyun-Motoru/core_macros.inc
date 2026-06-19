;core_macros.inc

show_char macro karakter
    push ax
    push dx
    mov ah,02h
    mov dl,karakter
    int 21h
    pop dx
    pop ax
endm

;guvenli sekilde sistemi kapatma
terminate_os macro
    mov ax,4c00h
    int 21h
endm



