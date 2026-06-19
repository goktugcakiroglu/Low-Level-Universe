; --- core_logger.inc ---

skoru_diske_yaz proc near
    add al,30h
    mov skor_rakam,al
    
    ; dosya olustur
    mov ah,3ch
    mov cx,00h
    lea dx,dosya_adi
    int 21h
    mov dosya_handle,ax
    
    ; dosyaya yaz
    mov ah,40h
    mov bx,dosya_handle
    mov cx,30
    lea dx,skor_str
    int 21h
    
    ; dosyayı kapat
    mov ah,3eh
    mov bx,dosya_handle
    int 21h
    ret
skoru_diske_yaz endp