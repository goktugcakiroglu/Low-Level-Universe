;TEMPLATE: Professional Multi-Segment x86 EXE Architecture

STACK_SEG SEGMENT STACK
    DW 256 DUP(0) 
STACK_SEG ENDS

DATA_SEG SEGMENT 'DATA'
    ;buyuk veri,metin,matris,log degisken buraya gelecek
    sistem_mesaji DB "--- SECURE SYSTEM CORE OPERATIONAL ---", 0Dh, 0Ah, "$"
    sifre_istek DB "Sistem sifresini giriniz: $"
    hata_mesaji DB 0Dh, 0Ah, "ERISIM REDDEDILDI! SYSTEM LOCKED.$", 0Dh, 0Ah
    onay_mesaji DB 0Dh, 0Ah, "ERISIM ONAYLANDI! KASA ACILDI.$", 0Dh, 0Ah
    
    ;veritabani ve tampon alanlar
    gercek_sifre DB "goktug123"
    girilen_sifre DB 15 DUP(0)
    
    ;disk gunlugu ayarlari
    log_dosyasi DB "vault.log",0
    log_handle DW ?
    log_text DB "Success: Vault accessed by user." 
DATA_SEG ENDS

CODE_SEG SEGMENT 'CODE'
    ASSUME CS:CODE_SEG,DS:DATA_SEG,SS:STACK_SEG

START_ENGINE PROC FAR
    ;1-Segment eslesmelerini donanima bildir
    MOV AX, DATA_SEG
    MOV DS,AX
    MOV ES,AX
    
    ;2-Ekrana giris mesajini bas
    MOV AH,09h
    LEA DX,sistem_mesaji
    INT 21h
    
    MOV AH,09h
    LEA DX,sifre_istek
    INT 21h
    
    ;3-Klavyeden sifreyi karakter karakter oku (Buffer doldurma)
    LEA DI, girilen_sifre
    MOV CX,9
    
SIFRE_OKU_DONGU:
    MOV AH,00h ;Tus bekle
    INT 16h
    MOV [DI],AL;Basilan tusu RAM e data segmentine kaydet
    
    ;Girilen karakteri yildiz olarak maskele
    MOV AH,02h
    MOV DL,'*'
    INT 21h
    
    INC DI
    LOOP SIFRE_OKU_DONGU
    
    ;4-String komutu ile RAM deki iki blogu karsilastir
    LEA SI, gercek_sifre
    LEA DI, girilen_sifre
    MOV CX,9
    CLD
    REPE CMPSB
    JNE ERISIM_REDI
    
    ;---DURUM 1:ERISIM ONAYI---
    MOV AH,09h
    LEA DX,onay_mesaji
    INT 21h
    
    ;Kripto Loglama: Logu diske yazmadan XOR ile maskeleme
    LEA SI,log_text
    MOV CX,32
KRIPTO_LOOP:
    XOR BYTE PTR [SI], 55h
    INC SI
    LOOP KRIPTO_LOOP
    
    ;Dosya sistemini tetikle (Kriptolu veriyi gunluge kazi)
    MOV AH,3Ch  ;Dosya olustur
    MOV CX,00h
    LEA DX,log_dosyasi
    INT 21h
    MOV log_handle, AX
    
    MOV AH,40h
    MOV BX,log_handle
    MOV CX,32
    LEA DX,log_text
    INT 21h
    
    MOV AH,3Eh
    MOV BX,log_handle
    INT 21h
    JMP SISTEMI_KAPAT
    
ERISIM_REDI:
    ;---DURUM 2:ERISIM REDDI---
    MOV AH,09h
    LEA DX,hata_mesaji
    INT 21h
    
SISTEMI_KAPAT:
    MOV AX,4C00h
    INT 21h
START_ENGINE ENDP
CODE_SEG ENDS
    
END START_ENGINE