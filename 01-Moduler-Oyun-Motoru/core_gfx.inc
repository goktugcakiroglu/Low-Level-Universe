;core_gfx.inc

;FUNCTION: gfx_print_color_str
;INPUT: DS:DX(String Address), BL(color)
;4fh-> 4 (red background),f(white background)

gfx_print_color_str proc near
    push ax
    push cx
    
    ;once mevcut islemi oku (dh,dl almak icin)
    mov ah,03h
    mov bh,00h
    int 10h ;dx imleci tutuyor
    
    ;renkli dizeyi ekrana basmak
    mov ah,13h ;write string with attribute
    mov al,01h ;imleci yazdiktan sonra tasi
    mov bh,00h ;0.sayfa
    mov cx,25  ;sabit metin uzunlugu 
    int 10h
    
    pop cx
    pop ax
    ret
gfx_print_color_str endp

;FUNCTION: GFX_HIDE_CURSOR
;Ekrandaki yanip sonen cizgiyi tamamen gizler
gfx_hide_cursor proc near
    mov ah,01h
    mov ch,20h ;cursor start/end satirlarini kapatarak gizleme bitti
    mov cl,00h
    int 10h
    ret
gfx_hide_cursor endp


    

