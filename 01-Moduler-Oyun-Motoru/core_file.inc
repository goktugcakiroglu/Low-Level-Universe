;core_file.inc
;FUNCTION: FILE_APPEND_DATA
;INPUT: DS:DX (File Name), DS:SI(Writing String), CX(Writing Byte Number)
;OUTPUT: AX=Error Code (If CF=1)

file_append_data proc near
    ;1-mevcudu oku/yaz modu
    mov ah, 3dh
    mov al, 02h ;read/write erisim
    int 21h
    jc file_error ;kesme sonrasi cf=1 ise failed
    mov bx,ax ;file handle i bx e sakla
    
    ;2-pointeri en sona tasi (lseek-append)
    mov ah,42h
    mov al,02h ;dosyanin sonundan beri oteleme
    mov cx,00h
    mov dx,00h ;0 byte otele (sonda dur)
    int 21h
    
    ;3-veriyi yaz
    mov ah,40h
    lea dx,[si] ;yazilacak verinin adresi
    int 21h
    
    ;4-dosyayi kapat(memory leak onle)
    mov ah,3eh
    int 21h
    clc ;hata yoksa cf=0 yap
    ret 
    
file_error:
 stc
 ret
file_append_data endp

