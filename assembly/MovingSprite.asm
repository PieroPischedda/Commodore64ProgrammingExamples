;********************************************************
;* Create and move a smiley sprite                      *
;* Use W, A, S, D key to move the sprite in the screen  *
;* Start with SYS 49152                                 *
;* Author Piero Pischedda 18/10/2018                    *
;********************************************************


*=$c000                 ;start address


;KERNAL functions
CLEAR   = $E544         ;clear the screen
GETIN   = $FFE4         ;read byte from default input
SCNKEY  = $FF9F         ;put current matrix code into memory address


;sprite labels
SPRITE0 = $7F8          ;sprite 0 address
COLOR0  = $D027         ;sprite 0 color address
SP0X    = $D000         ;sprite 0 X coordinate
SP0Y    = $D001         ;sprite 0 Y coordinate
MSBX    = $D010         ;most significant bit for X coordinates
SP0VAL  = $0340         ;sprite 0 start data address (stored in datassette I/O buffer)

ENABLE  = $D015         ;address for enabling sprites
XEXPAND = $D01D         ;address for horizontal sprite expanding
YEXPAND = $D017         ;address for vertical sprite expanding


        JSR CLEAR      ; execute clear screen routine
            
        LDA #$0D        ;using block 13 for sprite0
        STA SPRITE0
            
        LDA #01         ;enable sprite 0
        STA ENABLE
            
        LDA #07         ;use yellow for sprite0
        STA COLOR0

        ;LDA #01         ;0 normal, 1 expand      
        ;STA YEXPAND     ;enable vertical sprite 0 expanding
        ;STA XEXPAND     ;enable horizontal sprite 0 expanding
            
        LDX #0
        LDA #0
            

        ;reset the spriteval data
CLEANUP STA SP0VAL,X
        INX
        CPX #63
        BNE CLEANUP
        
        
        ;read the data to build sprite
        LDX #0

BUILD   LDA DATA,X
        STA SP0VAL,X
        INX
        CPX #63
        BNE BUILD


        ;position
        ;LDA #0          ;stick with x0-255
        ;STA MSBX
            

        ;starting sprite location
        LDX #172        ;x coordinate to center it on the screen
        LDY #128        ;y coordinate to center it on the screen
        STX SP0X
        STY SP0Y


        ;scan keyboard waiting for user to press a key
SCAN    JSR SCNKEY      ;get key
        JSR GETIN       ;put key in A

START   CMP #87         ;W - up
        BEQ UP

        CMP #83         ;S - down
        BEQ DOWN
            
        CMP #65         ;A - left
        BEQ LEFT
            
        CMP #68         ;D - right
        BEQ RIGHT
            
        CMP #13         ;end if enter pressed
        BEQ END
            
        JMP SCAN


        ;move sprite up
UP      LDY SP0Y
        DEY             ;decrement Y coordinate
        STY SP0Y
        JMP SCAN


        ;move sprite down
DOWN    LDY SP0Y
        INY             ;increment Y coordinate
        STY SP0Y
        JMP SCAN

        
        ;move sprite left
LEFT    LDX SP0X
        DEX             ;decrement X coordinate
        STX SP0X
        CPX #255
        BNE SCAN
        LDA #0
        STA MSBX        ;set the most significant bit for X coordinates to 0
        JMP SCAN


        ;move sprite right
RIGHT   LDX SP0X
        INX             ;increment X coordinate
        STX SP0X
        CPX #255
        BNE SCAN
        LDA #1
        STA MSBX        ;set the most significant bit for X coordinates to 1
        JMP SCAN


        ;clean up at the end
END     JSR CLEAR
        LDA #0          ;disable sprite
        STA ENABLE
        RTS             ;return and exit from program


        ;define the sprite
DATA    BYTE 0,126,0
        BYTE 3,255,192
        BYTE 7,255,224
        BYTE 31,255,248
        BYTE 31,255,248
        BYTE 63,255,252
        BYTE 127,255,254
        BYTE 126,126,126
        BYTE 254,126,127
        BYTE 255,255,255
        BYTE 255,255,255
        BYTE 255,255,255
        BYTE 255,255,255
        BYTE 126,255,127
        BYTE 127,126,254
        BYTE 63,129,252
        BYTE 31,255,248
        BYTE 31,255,248
        BYTE 7,255,224
        BYTE 3,255,192
        BYTE 0,255,0
        BYTE 0,126,0
        
