#make_boot#

org 7c00h      ; set location counter.

start_os:
   ;1-Ekran kaydi kaydedicilerini temizle ve ayarla
   XOR AX,AX ;AX=0
   MOV DS,AX ;Data segment reset
   MOV ES,AX ;Extra segment reset
   
   ;2-Ekran video modu (BIOS kesmesi ile)
   MOV AX,0003h ;80x25 Metin modu
   INT 10h      ;BIOS Ekran Kesmesi
   
   ;3-Ekrana OS a hos geldiniz mesaji basmak
   LEA SI,os_mesaji  ;mesajin baslangic adresini SI'ye yukle
   CALL PRINT_STRING ;BIOS tabanli string yazdirma fonksiyonumuz
  
SISTEMI_DONDUR:
   JMP SISTEMI_DONDUR ;OS yuklendi,sonsuz dongude islemciyi bekle
   
;PROCEDURES (Saf BIOS Tabanli Karakter Basma Sinifi)
PRINT_STRING PROC NEAR
    MOV AH,0Eh ;BIOS Teletype
    MOV BH,00h ;0.sayfa
    MOV BL,07h ;Standart Beyaz Renk Ozniteligi
    
YAZDIRMA_DONGUSU:
    LODSB ;DS:SI adresindekini AL e yukle ve SI yi 1 artir
    CMP AL,0 ;Karakter dizisinin sonuna (Null) geldik mi 
    JE YAZDIRMA_BITTI ;0 ise bitti,cik
    INT 10h
    JMP YAZDIRMA_DONGUSU
    
YAZDIRMA_BITTI:
    RET
PRINT_STRING ENDP 

;---DATA SECTION---
os_mesaji DB "---GOKTUG OS v1.0 UNIVERSE---",0Dh,0Ah
          DB "Loading Kernel...",0Dh,0Ah
          DB "Hardware Interfacing: OK",0Dh,0Ah
          DB "System Boot Success. Welcome Commander!",0
          
;BOOT SIGNATURE
;7C00h a 510 eklendiginde 7dfe olur
;Padding
ORG 7DFEh    
DW 0AA55h ;Bellekte 55h ve AAh olarak depolanir. 