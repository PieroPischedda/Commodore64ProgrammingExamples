;*********************************************************************
;* Hello World with auto start. Works with CBM prg Studio and VICE   *
;* The first lines beginning with BYTE contains the BASIC code       *
;* 10 SYS 4096 that is necessary to start the program automatically. *
;* Type LIST to show the BASIC source.                               *
;* Type RUN or SYS 4096 to start the program.                        *
;* Author Piero Pischedda 26/10/2018                                 *
;*********************************************************************


*=$0801                 ;basic start address

        BYTE $0c, $08, $0a, $00, $9e, $20
        BYTE $34, $30, $39, $36, $00, $00
        BYTE $00


*=$1000                 ;start address 4096
        
        JSR $E544       ;clear the screen
        LDX #$0         ;load 0 in the X register
loop    LDA MESSAGE,X   ;load message one character at a time with a loop
        AND #$3F        ;logic AND to change to uppercase character
        STA $0400,X     ;write character in the screen memory
        INX             ;increment X register value
        CPX #$0C        ;compare X register value with 12 (string length)
        BNE loop        ;continue loop if X<12
        RTS             ;otherwise exit

MESSAGE TEXT "HELLO WORLD!"

