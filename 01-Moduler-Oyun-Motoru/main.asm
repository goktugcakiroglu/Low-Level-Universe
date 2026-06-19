; ====================================================================
; PROJECT: Ultimate 8086 Master Engine Architecture (Modular COM)
; FILE: main.asm
; ====================================================================
ORG 100h

JMP RUN_ENGINE

; --- RAM / GLOBAL DATA SEGMENT ---
char_x DB 40
char_y DB 12
food_x DB 25
food_y DB 08
skor DB 0
dosya_adi DB "syslog.txt", 0
dosya_handle DW ?
skor_str DB "Oyun Bitti! Toplam Skorunuz: "
skor_rakam DB "0", 0Dh, 0Ah, "$"

; KUTUPHANE ENJEKSIYONLARI
INCLUDE "core_macros.inc"
INCLUDE "core_mem.inc"
INCLUDE "core_gfx.inc"
INCLUDE "core_file.inc"
INCLUDE "core_video.inc"
INCLUDE "core_logger.inc"

RUN_ENGINE:
    CALL TEMIZLE_VE_MOD_AYARLA 
    CALL GFX_HIDE_CURSOR

OYUN_AKIS_DONGUSU:
    MOV AX, 0003h
    INT 10h

    ; 1. Yemi Ciz
    MOV DH, food_y
    MOV DL, food_x
    CALL IMLEC_KONUMLANDIR
    SHOW_CHAR '*'                  

    ; 2. Oyuncuyu Ciz
    MOV DH, char_y
    MOV DL, char_x
    CALL IMLEC_KONUMLANDIR
    SHOW_CHAR 'O'                  

    ; 3. Carpisma Testi
    MOV AL, char_x
    CMP AL, food_x
    JNE KLAVYE_POLLING
    
    MOV AL, char_y
    CMP AL, food_y
    JNE KLAVYE_POLLING

    ; Yem Yendi!
    INC skor        
    ADD food_x, 12
    CMP food_x, 70
    JB Y_GUNCELLE
    MOV food_x, 10  
Y_GUNCELLE:
    ADD food_y, 4
    CMP food_y, 20
    JB KLAVYE_POLLING
    MOV food_y, 5

KLAVYE_POLLING:
    MOV AH, 01h
    INT 16h
    JZ OYUN_AKIS_DONGUSU          

    MOV AH, 00h
    INT 16h                        

    CMP AL, 'w'
    JE YUKARI
    CMP AL, 's'
    JE ASAGI
    CMP AL, 'a'
    JE SOL
    CMP AL, 'd'
    JE SAG
    CMP AL, 'q'
    JE SISTEMI_LOGLA_REBOOT
    JMP OYUN_AKIS_DONGUSU

YUKARI:
    DEC char_y
    JMP OYUN_AKIS_DONGUSU
ASAGI:
    INC char_y
    JMP OYUN_AKIS_DONGUSU
SOL:
    DEC char_x
    JMP OYUN_AKIS_DONGUSU
SAG:
    INC char_x
    JMP OYUN_AKIS_DONGUSU

SISTEMI_LOGLA_REBOOT:
    MOV AL, skor
    CALL SKORU_DISKE_YAZ           
    TERMINATE_OS                   
RET