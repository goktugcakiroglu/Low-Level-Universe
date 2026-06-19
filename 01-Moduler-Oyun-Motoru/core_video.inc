; --- core_video.inc ---

temizle_ve_mod_ayarla proc near
    mov ax, 0003h       ; 80*25 test mode
    int 10h             ; reset screen
    ret
temizle_ve_mod_ayarla endp
 
imlec_konumlandir proc near
    ; dh=satir(y), dl=sutun(x)
    mov ah,02h
    mov bh,00h          ; 0.sayfa
    int 10h
    ret       
imlec_konumlandir endp