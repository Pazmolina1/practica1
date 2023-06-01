; PIC16F887 Configuration Bit Settings


; PIC16F887 Configuration Bit Settings

; Assembly source line config statements

; CONFIG1
  CONFIG  FOSC = INTRC_CLKOUT   ; Oscillator Selection bits (RC oscillator: CLKOUT function on RA6/OSC2/CLKOUT pin, RC on RA7/OSC1/CLKIN)
  CONFIG  WDTE = ON             ; Watchdog Timer Enable bit (WDT enabled)
  CONFIG  PWRTE = ON           ; Power-up Timer Enable bit (PWRT disabled)
  CONFIG  MCLRE = ON          ; RE3/MCLR pin function select bit (RE3/MCLR pin function is digital input, MCLR internally tied to VDD)
  CONFIG  CP = OFF              ; Code Protection bit (Program memory code protection is disabled)
  CONFIG  CPD = OFF             ; Data Code Protection bit (Data memory code protection is disabled)
  CONFIG  BOREN = OFF           ; Brown Out Reset Selection bits (BOR disabled)
  CONFIG  IESO = OFF            ; Internal External Switchover bit (Internal/External Switchover mode is disabled)
  CONFIG  FCMEN = OFF           ; Fail-Safe Clock Monitor Enabled bit (Fail-Safe Clock Monitor is disabled)
  CONFIG  LVP = OFF             ; Low Voltage Programming Enable bit (RB3 pin has digital I/O, HV on MCLR must be used for programming)

; CONFIG2
  CONFIG  WRT = OFF             ; Flash Program Memory Self Write Enable bits (Write protection off)

// config statements should precede project file includes.
#include <xc.inc>

; When assembly code is placed in a psect, it can be manipulated as a
; whole by the linker and placed in memory.  
;
; In this example, barfunc is the program section (psect) name, 'local' means
; that the section will not be combined with other sections even if they have
; the same name.  class=CODE means the barfunc must go in the CODE container.
; PIC18 should have a delta (addressible unit size) of 1 (default) since they
; are byte addressible.  PIC10/12/16 have a delta of 2 since they are word
; addressible.  PIC18 should have a reloc (alignment) flag of 2 for any
; psect which contains executable code.  PIC10/12/16 can use the default
; reloc value of 1.  Use one of the psects below for the device you use:
       
psect   MainCode,global,class=CODE,delta=2 ; PIC10/12/16
; psect   barfunc,local,class=CODE,reloc=2 ; PIC18
; Configuración del microcontrolador
  
; Inicialización de variables
    contador        equ     0x20
    estadoBoton1    equ     0x21
    estadoBoton2    equ     0x22

; Configuración de puertos
    banksel TRISB
    ;movlw   b'00001000'
    movwf   TRISB       ; RB3 como salida (LED parpadeante)
    
    banksel TRISD
    ;movlw   b'11111110'
    movwf   TRISD       ; RD0 como entrada (LED condicional)

; Programa principal
inicio:
    banksel PORTB
    bsf     PORTB, 3    ; Encender LED parpadeante
    
    banksel PORTD
    btfss   PORTD, 0    ; Si el botón 2 está presionado...
        goto        apagaLedCondicional
    
    btfss   PORTC, 0    ; Si el botón 1 está presionado...
        goto        enciendeLedCondicional
    
apagaLedCondicional:
    banksel PORTD
    bcf     PORTD, 0    ; Apagar LED condicional
    
sigueParpadeando:
    banksel PORTB
    bcf     PORTB, 3    ; Apagar LED parpadeante
    
espera:
    ;movlw   .d100       ; Esperar un tiempo antes de volver a encender el LED parpadeante
esperaLoop:
    decfsz  contador, f ; Decrementar contador y saltar si es cero
        goto        esperaLoop
    
reiniciaContador:
   ; movlw   .d100       ; Reiniciar contador a 100 (decimal)
    movwf   contador
    
vuelveAInicio:
    goto inicio

enciendeLedCondicional:
    banksel PORTD
    bsf     PORTD, 0    ; Encender LED condicional
    
sigueParpadeando2:
    banksel PORTB
    bcf     PORTB, 3
    
espera2:
    ;movlw   .d100       ; Esperar un tiempo antes de volver a encender el LED parpadeante
esperaLoop2:
    decfsz  contador, f ; Decrementar contador y saltar si es cero
        goto        esperaLoop2
    
reiniciaContador2:
    ;c       ; Reiniciar contador a 100 (decimal)
    movwf   contador
    
vuelveAInicio2:
goto inicio

end