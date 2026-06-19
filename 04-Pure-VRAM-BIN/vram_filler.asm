;project: pure flat binary video ram filter
;template:bin no header no os

;1-ekran kartinin vram ini yakala
mov ax,0b800h ;80*25 burdan baslar
mov ds,ax     ;veri segment dogrudan vram e baglandi

;2-sayaclar ve pointer i ayarla
mov bx,0    ;vram ofset adresi(0.karakter,sol ust kose)
mov cx,2000 ;80*25 de toplam 2000

ekrani_boya_dongu:
    ;1-ascii byte
    ;2-metin rengi ve arka plan rengi byte
    
    MOV BYTE PTR [BX], 'G'    ; Ekranin o hucresine 'G' harfini kazi!
    INC BX                    ; Sonraki byte'a (Renk byte'ina) gecç
    
    MOV BYTE PTR [BX], 1Fh    ; 1 = Mavi Arka Plan, F = Parlak Beyaz Yazi Rengi
    INC BX                    ; Bir sonraki karakter hucresine gecç
    
    LOOP EKRANI_BOYA_DONGU     ; 2000 hucrenin tamami dolana kadar don!

; 3. Isletim sistemi (RET veya DOS cikisi) olmadigi icin islemciyi sonsuz dongude kilitle
SISTEMI_DONDUR:
    JMP SISTEMI_DONDUR



