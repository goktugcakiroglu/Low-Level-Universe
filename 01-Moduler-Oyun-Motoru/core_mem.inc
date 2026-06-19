; MODULE:core_mem.inc

;FUNCTION: MEM_COPY
;INPUT: DS:SI(Source Address), ES:DI(Destination Address), CX(Copied Byte Numbers)

mem_copy proc near
    push ax
    cld      ;df=0 yon bayragi ileri
    rep movsb;cx 0 olana kadar ds:si yi es:di ya 
    pop ax
    ret
mem_copy endp

;FUNCTION: MEM_FIND_CHAR
;INPUT: ES:DI (Searched Memory Area), AL(Searched ASCII Character), CX(Border)
;OUTPUT: ZF=1 ise bulundu, DI pointeri bulunan karakterin bir sonraki adresinde

mem_find_char proc near
    cld ;ileri dogru tara
    repne scasb ;karakteri bulamiyorsan di yi artir ve tara
    ret
mem_find_char endp 




