;Muhammad Raees Shujaan Azhar (21I-0406)
;Muneel Haider (21I-0640)
;Section-G
;COAL LAB PROJECT
;----------------------------------BRICK BREAKER GAME-------------------------------------
;The player has to bounce the ball using the slider in such a way that it breaks all the bricks
;The game difficulty increases as the level increases so are you a ProGrammer to win this game?
;We completely own the rights of the game and anyone who wants to play can buy from us in just
;69000$. If anyone found pirating our game will be sued on Qiyamat ke din


theball STRUCT

    x1 dw 0
    y1 dw 0
    x2 dw 0
    y2 dw 0
    speed dw 1
    color db 0110b

theball ENDS

padder STRUCT

    x1 dw 0
    y1 dw 0
    x2 dw 0
    y2 dw 0
    color db 0111b

padder ENDS

thehitboxes STRUCT

    x1 dw 0
    y1 dw 0
    x2 dw 0
    y2 dw 0
    color dw 0
    collided dw 0
    
thehitboxes ENDS

player STRUCT

    nameInp db 10 dup('$')
    score dw 0
    level dw 0

player ENDS

.model small
.stack 100h
.data

    ;For Baap Intro Page
    intro1 db "Brick Breaker Game $"
    intro2 db "Please Enter Your Name: $"
    intro3 db "Navigate using $"
    intro4 db "-> arrows keys to move the slider$"
    intro5 db "-> and BackSpace for Exit.$"

    
    testingdead db '$'
    lives db 3
    endername db '$'
    scoreStr db 5 dup('$')
    fileHandler dw ?

    msg db "              INSTRUCTIONS$"
    msg0 db "1. This is a single player game.$"
    msg1 db "2. The game's objective is to destroy$"
    msg2 db "   all of the bricks.$"
    msg3 db "3. In this the player will have control$"
    msg4 db "   over a paddle which reflects the ball$"

    hmsg0 db "                HIGHSCORES$"
    hmsg1 db "   Name:     Scores:  Level:$"
    hmsg2 db "   Muneel    170       2$"
    hmsg3 db "   Shujaan   110       1$"
    hmsg4 db "   Haider    35        1$"
    hmsg5 db "   Azhar     5         1$"

   
    looper dw 20
    x db 0
    gamebreaker db 0
    direction dw 5
    freq dw 1000
    boxesdestroyed db 0
    level db 1
    temp dw 0
    divide dw 10
    
    fName db "scores.txt"

    ball theball <150, 140, 156, 146>

    pad padder <150, 183, 201, 184>

    ;Players
    p1 player <>
    p2 player <>
    p3 player <>
    p4 player <>
    
    buffer db 10 dup('$')
    rScore dw 0

    box1 thehitboxes <40,39,63,48, 12>
    box2 thehitboxes <64,39,87,48, 12>
    box3 thehitboxes <88,39,111,48, 12>
    box4 thehitboxes <112,39,135,48, 12>
    box5 thehitboxes <136,39,159,48, 12>
    box6 thehitboxes <160,39,183,48, 12>
    box7 thehitboxes <184,39,207,48, 12>
    box8 thehitboxes <208,39,231,48, 12>
    box9 thehitboxes <232,39,255,48, 12>
    box10 thehitboxes <256,39,279,48, 12>
    box11 thehitboxes <280,39,303,48, 12>
    box12 thehitboxes <24,55,47,64, 12>
    box13 thehitboxes <48,55,71,64, 12>
    box14 thehitboxes <72,55,95,64, 12>
    box15 thehitboxes <96,55,119,64, 12>
    box16 thehitboxes <120,55,143,64, 12>
    box17 thehitboxes <144,55,167,64, 12>
    box18 thehitboxes <168,55,191,64, 12>
    box19 thehitboxes <192,55,215,64, 12>
    box20 thehitboxes <216,55,239,64, 12>
    box21 thehitboxes <240,55,263,64, 12>
    box22 thehitboxes <264,55,287,64, 12>
    box23 thehitboxes <40,71,63,80, 12>
    box24 thehitboxes <64,71,87,80, 12>
    box25 thehitboxes <88,71,111,80, 12>
    box26 thehitboxes <112,71,135,80, 12>
    box27 thehitboxes <136,71,159,80, 12>
    box28 thehitboxes <160,71,183,80, 12>
    box29 thehitboxes <184,71,207,80, 12>
    box30 thehitboxes <208,71,231,80, 12>
    box31 thehitboxes <232,71,255,80, 12>
    box32 thehitboxes <256,71,279,80, 12>
    box33 thehitboxes <280,71,303,80, 12>

.code

    mov ax, @data
    mov ds, ax
    mov ax, 0

    ;video mode (graphic)
    mov ah, 0
    mov al, 13h    ;320x200
    int 10h

    ;Draws a border
    borderDraw macro c1, r1, c2, r2, color
        mov cx, c1
        mov dx, r1
        
        ;_____
        .while cx != c2
            mov al, color
            mov ah, 0Ch
            int 10h
            inc cx
            .endw

        ;|
        .while dx != r2
            mov al, color
            mov ah, 0Ch
            int 10h
            inc dx 
            
            .endw


        ;_____
        .while cx != c1
            mov al, color
            mov ah, 0Ch
            int 10h
            dec cx

            .endw
        
        ;|
        .while dx != r1
            mov al, color
            mov ah, 0Ch
            int 10h
            dec dx 
            .endw

    endm

    ;Print a pixel
    lineprint macro c1, c2, color
        mov cx, c1
        .while cx <= c2
            mov al, color
            mov ah, 0Ch
            int 10h
            inc cx
        .endw

    endm

    ; Check collisions with wall
    collisionwalls macro c2, r2, r1, c1

        ;Game Breaker
        mov ah, 1
        int 16h
        .if al == 08d
            mov gamebreaker, 1
            jmp ender
        .endif

        .if(r2 == 198)

            sub lives, 1

            ;Removes the old ball
            mov ball.color, 205
            mov direction, 5
            call ballDrawer

            ;Resets the ball
            mov ball.x1, 150
            mov ball.y1, 140
            mov ball.x2, 156
            mov ball.y2, 146
            mov ball.color, 0110b
            call ballDrawer


        .elseif(c2 == 318)

            .if(direction == 2)
                mov direction, 3
            .elseif(direction == 0)
                mov direction, 1
            .endif


        .elseif(r1 == 40)
            
            .if(direction == 3)
                jmp g1
            .elseif(direction == 2)
                jmp g0
            .elseif(direction == 4)
                jmp g5
            .endif

        .elseif(c1 == 11)
        
            .if(direction == 3)
                jmp g2
            .elseif(direction == 1)
                jmp g0
            .endif

        .endif

    endm

    collisionslider macro sx1, sy1, sx2

        ;17 x 3 => 3 regions of 17 px of slider
            
        mov ax, sx1
        mov bx, sy1
        mov cx, sx2

        ;helping defining regions of slider
        mov dx, ax
        add dx, 17
        
        .if (ball.y2 == bx)
            ;Region 1
            .if (ball.x1 >= ax && ball.x2 <= dx)
                jmp g3

            .endif

            ;Region 2
            inc dx
            mov ax, dx
            add dx, 17

            .if (ball.x2 >= ax && ball.x1 <= dx)
                jmp g4

            .endif

            ;Region 3
            inc dx
            .if (ball.x2 >= dx && ball.x1 <= cx)
                jmp g2

            .endif

        .endif

    endm

    filledBox macro r1, c1, r2, c2, color
        mov ah, 6
        mov al, 0
        mov bh, color     ;color
        mov ch, r1     ;top row of window
        mov cl, c1     ;left most column of window
        mov dh, r2     ;Bottom row of window
        mov dl, c2     ;Right most column of window

        int 10h
        
    endm

    printChars macro c, r, color, char
        mov ax, 0
        mov bx, 0

        mov ah, 2
        mov dh, r     ;row
        mov dl, c     ;column
        int 10h

        mov ah, 0eh
        mov al, char
        mov bx, 0
        mov bl, color   ;Color
        mov cx, 1       ;repetition count
        mov ah,09h
        int 10h

    endm

    ;Game ka daddy proc
    main proc

        ;Baap Menu

        call FirstPage
        mov lives, 3
        starter:

            mov ah, 0
            mov al, 13h    ;320x200
            int 10h

            mov direction, 0

            call backgroundPage
            
            ;BRICK BREAKER GAME
            mov x, 11
            printChars x, 4, 11, 'B'
            inc x
            printChars x, 4, 11, 'R'
            inc x
            printChars x, 4, 11, 'I'
            inc x
            printChars x, 4, 11, 'C'
            inc x
            printChars x, 4, 11, 'K'
            inc x
            printChars x, 4, 0, ' '
            inc x
            printChars x, 4, 11, 'B'
            inc x
            printChars x, 4, 11, 'R'
            inc x
            printChars x, 4, 11, 'E'
            inc x
            printChars x, 4, 11, 'A'
            inc x
            printChars x, 4, 11, 'K'
            inc x
            printChars x, 4, 11, 'E'
            inc x
            printChars x, 4, 11, 'R'
            inc x
            printChars x, 4, 11, ' '
            inc x
            printChars x, 4, 11, 'G'
            inc x
            printChars x, 4, 11, 'A'
            inc x
            printChars x, 4, 11, 'M'
            inc x
            printChars x, 4, 11, 'E'
            inc x

            ;Printing boxes

            filledBox 6, 12, 8, 27, 4h
            filledBox 10, 12, 12, 27, 4h
            filledBox 14, 12, 16, 27, 4h
            filledBox 18, 12, 20, 27, 4h

            ;Print NEW GAME
            
            mov x, 16

            printChars x, 7, 10, 'N'
            inc x
            printChars x, 7, 10, 'E'
            inc x
            printChars x, 7, 10, 'W'
            inc x
            printChars x, 7, 4, ' '
            inc x
            printChars x, 7, 10, 'G'
            inc x
            printChars x, 7, 10, 'A'
            inc x
            printChars x, 7, 10, 'M'
            inc x
            printChars x, 7, 10, 'E'

            mov x, 15

            printChars x, 11, 10, 'I'
            inc x
            printChars x, 11, 10, 'N'
            inc x
            printChars x, 11, 10, 'S'
            inc x
            printChars x, 11, 10, 'T'
            inc x
            printChars x, 11, 10, 'R'
            inc x
            printChars x, 11, 10, 'U'
            inc x
            printChars x, 11, 10, 'C'
            inc x
            printChars x, 11, 10, 'T'
            inc x
            printChars x, 11, 10, 'I'
            inc x
            printChars x, 11, 10, 'O'
            inc x
            printChars x, 11, 10, 'N'

            ;Print INSTRUCTIoN

            mov x, 15

            printChars x, 15, 10, 'H'
            inc x
            printChars x, 15, 10, 'I'
            inc x
            printChars x, 15, 10, 'G'
            inc x
            printChars x, 15, 10, 'H'
            inc x
            printChars x, 15, 10, ' '
            inc x
            printChars x, 15, 10, 'S'
            inc x
            printChars x, 15, 10, 'C'
            inc x
            printChars x, 15, 10, 'O'
            inc x
            printChars x, 15, 10, 'R'
            inc x
            printChars x, 15, 10, 'E'

            ;Print EXIT

            mov x, 18

            printChars x, 19, 10, 'E'
            inc x
            printChars x, 19, 10, 'X'
            inc x
            printChars x, 19, 10, 'I'
            inc x
            printChars x, 19, 10, 'T'

            call borderprinter

            ifPressed:
                mov ah, 0
                int 16h
                cmp al, 08d  ;Backspace
                je ender
                cmp al, 13   ;Enter
                je game
                cmp al, 32
                je instruct
                cmp al, 'h'
                je hishcores
                mov dl, al
                mov ah, 2
                int 21h
                jmp ifPressed

            hishcores:

                mov ah, 0
                mov al, 13h
                int 10h

                call printHighscores

                jmp starter

            instruct:

                mov ah, 0
                mov al, 13h
                int 10h

                call printinstruction

                jmp starter

        game:

                mov ah, 0
                mov al, 13h    ;320x200
                int 10h

                call beep

                ;Game bg
                filledBox 0, 0, 100, 200, 205

                ;header
                filledBox 0, 0, 3, 200, 183

                call namePrinter

                .while gamebreaker != 1

                    call boxmovement

                    mov ah, 1
                    int 16h

                    .if(al == 8)
                        
                        jmp ender
                
                    .endif

                .endw

    main endp

    ;Game ke sub Daddy procs below

    updateScores proc

        pop si

        mov al, '$'
        mov di, offset scoreStr
        
        ;clearing the str
        mov [di], al
        inc di
        mov [di], al
        inc di
        mov [di], al
        inc di
        mov [di], al
        inc di
        mov [di], al
        inc di

        mov di, offset scoreStr
        mov bx, 0

        .IF p1.score == bx

            mov cx, '0'
            mov [di], cx
            inc di

            mov cx, '$'
            mov [di], cx

        .ENDIF

        mov bx, 0

        .if p1.score != bx

            mov cx, p1.score
            mov temp, cx
            mov cx, 0
            mov ax, temp

            splitter:
                mov dx, 0
                div divide
                add dx, 48
                inc  cx
                push dx
                TEST ax, ax

                jnz splitter

            mov di, offset scoreStr

            mov ah, 1
            int 16h

            fillingStr:
                pop ax
                mov [di], ax
                inc di

            loop fillingStr

            mov ax, '$'
            mov [si], ax

        .endif
        push si

        ret

    updateScores endp
    
    checkcollide proc 

        .if(boxesdestroyed == 33 && level == 1)

            add level, 1
            mov boxesdestroyed, 0

            for i, <box1, box2, box3, box4, box5, box6, box7, box8, box9, box10, box11, box12, box13, box14, box15, box16, box17, box18, box19, box20, box21, box22, box23, box24, box25, box26, box27, box28, box29, box30, box31, box32, box33>
                mov i.collided, 0
            endm

        .elseif(boxesdestroyed == 66 && level == 2)
            
            add level, 1
            mov boxesdestroyed, 0

            for i, <box1, box2, box3, box4, box5, box6, box7, box8, box9, box10, box11, box12, box13, box14, box15, box16, box17, box18, box19, box20, box21, box22, box23, box24, box25, box26, box27, box28, box29, box30, box31, box32, box33>
                mov i.collided, 0
            endm

        .endif

        .if(level == 3)

            call printWinGame

        .endif

        

        .if(level == 1)

            ;row 1
            .if(box1.collided == 0)
                filledBox 5,5,5,7, 1
                borderDraw 40,39,63,48, 12
            
            .elseif(box1.collided == 1)
            
                filledBox 5,5,5,7, 205
                borderDraw 40,39,63,48, 205
                
            .endif
            
            .if(box2.collided == 0)
                filledBox 5,8,5,10, 2
                borderDraw 64,39,87,48, 12
            
            .elseif(box2.collided == 1)
            
                filledBox 5,8,5,10, 205
                borderDraw 64,39,87,48, 205
            
            .endif

            .if(box3.collided == 0)
                filledBox 5,11,5,13, 3
                borderDraw 88,39,111,48, 12
            
            .elseif(box3.collided == 1)
                filledBox 5,11,5,13, 205
                borderDraw 88,39,111,48, 205

            .endif
            
            .if(box4.collided == 0)
                filledBox 5,14,5,16, 4
                borderDraw 112,39,135,48, 12
            
            .elseif(box4.collided == 1)
                filledBox 5,14,5,16, 205
                borderDraw 112,39,135,48, 205

            .endif
            
            .if(box5.collided == 0)
                filledBox 5,17,5,19, 5
                borderDraw 136,39,159,48, 12
            
            .elseif(box5.collided == 1)
                filledBox 5,17,5,19, 205
                borderDraw 136,39,159,48, 205
            
            .endif
            
            .if(box6.collided == 0)
                filledBox 5,20,5,22, 6
                borderDraw 160,39,183,48, 12

            .elseif(box6.collided == 1)
                filledBox 5,20,5,22, 205
                borderDraw 160,39,183,48, 205

            .endif
            
            .if(box7.collided == 0)
                filledBox 5,23,5,25, 7
                borderDraw 184,39,207,48, 12

            .elseif(box7.collided == 1)
                filledBox 5,23,5,25, 205
                borderDraw 184,39,207,48, 205
            .endif
            
            .if(box8.collided == 0)
                filledBox 5,26,5,28, 8
                borderDraw 208,39,231,48, 12
            
            .elseif(box8.collided == 1)
                filledBox 5,26,5,28, 205
                borderDraw 208,39,231,48, 205

            .endif
            
            .if(box9.collided == 0)
                filledBox 5,29,5,31, 9
                borderDraw 232,39,255,48, 12

            .elseif(box9.collided == 1)
                filledBox 5,29,5,31, 205
                borderDraw 232,39,255,48, 205

            .endif
            
            .if(box10.collided == 0)
                filledBox 5,32,5,34, 10
                borderDraw 256,39,279,48, 12

            .elseif(box10.collided == 1)
                filledBox 5,32,5,34, 205
                borderDraw 256,39,279,48, 205

            .endif

            .if(box11.collided == 0)
                filledBox 5,35,5,37, 11
                borderDraw 280,39,303,48, 12

            .elseif(box11.collided == 1)
                filledBox 5,35,5,37, 205
                borderDraw 280,39,303,48, 205

            .endif

            ;row 2
            .if(box12.collided == 0)
                filledBox 7,3,7,5, 13
                borderDraw 24,55,47,64, 12
            
            .elseif(box12.collided == 1)
                filledBox 7,3,7,5, 205
                borderDraw 24,55,47,64, 205

            .endif
            
            .if(box13.collided == 0)
                filledBox 7,6,7,8, 14
                borderDraw 48,55,71,64, 12
            
            .elseif(box13.collided == 1)
                filledBox 7,6,7,8, 205
                borderDraw 48,55,71,64, 205

            .endif

            .if(box14.collided == 0)
                filledBox 7,9,7,11, 1
                borderDraw 72,55,95,64, 12
            
            .elseif(box14.collided == 1)
                filledBox 7,9,7,11, 205
                borderDraw 72,55,95,64, 205

            .endif

            .if(box15.collided == 0)
                filledBox 7,12,7,14, 5
                borderDraw 96,55,119,64, 12
            
            .elseif(box15.collided == 1)
                filledBox 7,11,7,14, 205
                borderDraw 96,55,119,64, 205

            .endif

            .if(box16.collided == 0)
                filledBox 7,15,7,17, 7
                borderDraw 120,55,143,64, 12
            
            .elseif(box16.collided == 1)
                filledBox 7,15,7,17, 205
                borderDraw 120,55,143,64, 205

            .endif
            .if(box17.collided == 0)
                filledBox 7,18,7,20, 8
                borderDraw 144,55,167,64, 12
            
            .elseif(box17.collided == 1)
                filledBox 7,18,7,20, 205
                borderDraw 144,55,167,64, 205

            .endif
            .if(box18.collided == 0)
                filledBox 7,21,7,23, 2
                borderDraw 168,55,191,64, 12
            
            .elseif(box18.collided == 1)
                filledBox 7,21,7,23, 205
                borderDraw 168,55,191,64, 205

            .endif
            
            .if(box19.collided == 0)
                filledBox 7,24,7,26, 4
                borderDraw 192,55,215,64, 12
                    
            .elseif(box19.collided == 1)
                filledBox 7,24,7,26, 205
                borderDraw 192,55,215,64, 205

            .endif
            .if(box20.collided == 0)
                filledBox 7,27,7,29, 11
                borderDraw 216,55,239,64, 12
                    
            .elseif(box20.collided == 1)
                filledBox 7,27,7,29, 205
                borderDraw 216,55,239,64, 205

            .endif
            
            .if(box21.collided == 0)
                filledBox 7,30,7,32, 45
                borderDraw 240,55,263,64, 12
                    
            .elseif(box21.collided == 1)
                filledBox 7,30,10,32, 205
                borderDraw 240,55,263,64, 205

            .endif
            
            .if(box22.collided == 0)
                filledBox 7,33,7,35, 23
                borderDraw 264,55,287,64, 12
                    
            .elseif(box22.collided == 1)
                filledBox 7,33,10,35, 205
                borderDraw 264,55,287,64, 205

            .endif
            
            ;row 3
            .if(box23.collided == 0)
                filledBox 9,5,9,7, 60
                borderDraw 40,71,63,80, 12
            
            .elseif(box23.collided == 1)
                filledBox 9,5,9,7, 205
                borderDraw 40,71,63,80, 205

            .endif
            
            .if(box24.collided == 0)
                filledBox 9,8,9,10, 88
                borderDraw 64,71,87,80, 12
            
            .elseif(box24.collided == 1)
                filledBox 9,8,9,10, 205
                borderDraw 64,71,87,80, 205

            .endif
            
            .if(box25.collided == 0)
                filledBox 9,11,9,13, 2
                borderDraw 88,71,111,80, 12
            
            .elseif(box25.collided == 1)
                filledBox 9,11,9,13, 205
                borderDraw 88,71,111,80, 205

            .endif
            
            .if(box26.collided == 0)
                filledBox 9,14,9,16, 14
                borderDraw 112,71,135,80, 12
            
            .elseif(box26.collided == 1)
                filledBox 9,14,9,16, 205
                borderDraw 112,71,135,80, 205

            .endif
            
            .if(box27.collided == 0)
                filledBox 9,17,9,19, 1
                borderDraw 136,71,159,80, 12
            
            .elseif(box27.collided == 1)
                filledBox 9,17,9,19, 205
                borderDraw 136,71,159,80, 205

            .endif

            .if(box28.collided == 0)
                filledBox 9,20,9,22, 99
                borderDraw 160,71,183,80, 12
            
            .elseif(box28.collided == 1)
                filledBox 9,20,9,22, 205
                borderDraw 160,71,183,80, 205

            .endif

            .if(box29.collided == 0)
                filledBox 9,23,9,25, 4
                borderDraw 184,71,207,80, 12
            
            .elseif(box29.collided == 1)
                filledBox 9,23,9,25, 205
                borderDraw 184,71,207,80, 205

            .endif

            .if(box30.collided == 0)
                filledBox 9,26,9,28, 5
                borderDraw 208,71,231,80, 12
            
            .elseif(box30.collided == 1)
                filledBox 9,26,9,28, 205
                borderDraw 208,71,231,80, 205

            .endif

            .if(box31.collided == 0)
                filledBox 9,29,9,31, 11
                borderDraw 232,71,255,80, 12
            
            .elseif(box31.collided == 1)
                filledBox 9,29,9,31, 205
                borderDraw 232,71,255,80, 205

            .endif

            .if(box32.collided == 0)
                filledBox 9,32,9,34, 10
                borderDraw 256,71,279,80, 12
            
            .elseif(box32.collided == 1)
                filledBox 9,32,9,34, 205
                borderDraw 256,71,279,80, 205

            .endif

            .if(box33.collided == 0)
                filledBox 9,35,9,37, 6
                borderDraw 280,71,303,80, 12
            
            .elseif(box33.collided == 1)
                filledBox 9,35,9,37, 205
                borderDraw 280,71,303,80, 205

            .endif

        .endif

        .if(level == 2)

            ;row 1
            .if(box1.collided == 0)
                filledBox 5,5,5,7, 1
                borderDraw 40,39,63,48, 12
            
            .elseif(box1.collided == 1)
            
                filledBox 5,5,5,7, 2
                borderDraw 40,39,63,48, 12
                
            .elseif(box1.collided == 2)

                filledBox 5,5,5,7, 205
                borderDraw 40,39,63,48, 205

            .endif
            
            .if(box2.collided == 0)
                filledBox 5,8,5,10, 2
                borderDraw 64,39,87,48, 12
            
            .elseif(box2.collided == 1)
            
                filledBox 5,8,5,10, 3
                borderDraw 64,39,87,48, 12
            
            .elseif(box2.collided == 2)

                filledBox 5,8,5,10, 205
                borderDraw 64,39,87,48, 205

            .endif

            .if(box3.collided == 0)
                filledBox 5,11,5,13, 3
                borderDraw 88,39,111,48, 12
            
            .elseif(box3.collided == 1)
                filledBox 5,11,5,13, 4
                borderDraw 88,39,111,48, 12

            .elseif(box3.collided == 2)

                filledBox 5,11,5,13, 205
                borderDraw 88,39,111,48, 205

            .endif
            
            .if(box4.collided == 0)
                filledBox 5,14,5,16, 4
                borderDraw 112,39,135,48, 12
            
            .elseif(box4.collided == 1)
                filledBox 5,14,5,16, 5
                borderDraw 112,39,135,48, 12

            .elseif(box4.collided == 2)

                filledBox 5,14,5,16, 205
                borderDraw 112,39,135,48, 205

            .endif
            
            .if(box5.collided == 0)
                filledBox 5,17,5,19, 5
                borderDraw 136,39,159,48, 12
            
            .elseif(box5.collided == 1)
                filledBox 5,17,5,19, 6
                borderDraw 136,39,159,48, 12
            
            .elseif(box5.collided == 2)

                filledBox 5,17,5,19, 205
                borderDraw 136,39,159,48, 205

            .endif
            
            .if(box6.collided == 0)
                filledBox 5,20,5,22, 6
                borderDraw 160,39,183,48, 12

            .elseif(box6.collided == 1)
                filledBox 5,20,5,22, 7
                borderDraw 160,39,183,48, 12

            .elseif(box6.collided == 2)

                filledBox 5,20,5,22, 205
                borderDraw 160,39,183,48, 205

            .endif
            
            .if(box7.collided == 0)
                filledBox 5,23,5,25, 7
                borderDraw 184,39,207,48, 12

            .elseif(box7.collided == 1)
                filledBox 5,23,5,25, 8
                borderDraw 184,39,207,48, 12

            .elseif(box7.collided == 2)

                filledBox 5,23,5,25, 205
                borderDraw 184,39,207,48, 205

            .endif
            
            .if(box8.collided == 0)
                filledBox 5,26,5,28, 8
                borderDraw 208,39,231,48, 12
            
            .elseif(box8.collided == 1)
                filledBox 5,26,5,28, 9
                borderDraw 208,39,231,48, 12

            .elseif(box8.collided == 2)

                filledBox 5,26,5,28, 205
                borderDraw 208,39,231,48, 205

            .endif
            
            .if(box9.collided == 0)
                filledBox 5,29,5,31, 9
                borderDraw 232,39,255,48, 12

            .elseif(box9.collided == 1)
                filledBox 5,29,5,31, 10
                borderDraw 232,39,255,48, 12

            .elseif(box9.collided == 2)

                filledBox 5,29,5,31, 205
                borderDraw 232,39,255,48, 205

            .endif
            
            .if(box10.collided == 0)
                filledBox 5,32,5,34, 10
                borderDraw 256,39,279,48, 12

            .elseif(box10.collided == 1)
                filledBox 5,32,5,34, 11
                borderDraw 256,39,279,48, 12

            .elseif(box10.collided == 2)

                filledBox 5,32,5,34, 205
                borderDraw 256,39,279,48, 205

            .endif

            .if(box11.collided == 0)
                filledBox 5,35,5,37, 11
                borderDraw 280,39,303,48, 12

            .elseif(box11.collided == 1)
                filledBox 5,35,5,37, 12
                borderDraw 280,39,303,48, 12

            .elseif(box11.collided == 2)

                filledBox 5,35,5,37, 205
                borderDraw 280,39,303,48, 205

            .endif

            ;row 2
            .if(box12.collided == 0)
                filledBox 7,3,7,5, 13
                borderDraw 24,55,47,64, 12
            
            .elseif(box12.collided == 1)
                filledBox 7,3,7,5, 11
                borderDraw 24,55,47,64, 12

            .elseif(box12.collided == 2)

                filledBox 7,3,7,5, 205
                borderDraw 24,55,47,64, 205
            .endif
            
            .if(box13.collided == 0)
                filledBox 7,6,7,8, 14
                borderDraw 48,55,71,64, 12
            
            .elseif(box13.collided == 1)
                filledBox 7,6,7,8, 13
                borderDraw 48,55,71,64, 12

            .elseif(box13.collided == 2)

                filledBox 7,6,7,8, 205
                borderDraw 48,55,71,64, 205

            .endif

            .if(box14.collided == 0)
                filledBox 7,9,7,11, 1
                borderDraw 72,55,95,64, 12
            
            .elseif(box14.collided == 1)
                filledBox 7,9,7,11, 2
                borderDraw 72,55,95,64, 12
            
            .elseif(box14.collided == 2)

                filledBox 7,9,7,11, 205
                borderDraw 72,55,95,64, 205

            .endif

            .if(box15.collided == 0)
                filledBox 7,12,7,14, 5
                borderDraw 96,55,119,64, 12
            
            .elseif(box15.collided == 1)
                filledBox 7,12,7,14, 3
                borderDraw 96,55,119,64, 12

            .elseif(box14.collided == 2)

                filledBox 7,12,7,14, 205
                borderDraw 96,55,119,64, 205

            .endif

            .if(box16.collided == 0)
                filledBox 7,15,7,17, 7
                borderDraw 120,55,143,64, 12
            
            .elseif(box16.collided == 1)
                filledBox 7,15,7,17, 5
                borderDraw 120,55,143,64, 12

            .elseif(box16.collided == 2)
                filledBox 7,15,7,17, 205
                borderDraw 120,55,143,64, 205

            .endif
            .if(box17.collided == 0)
                filledBox 7,18,7,20, 8
                borderDraw 144,55,167,64, 12
            
            .elseif(box17.collided == 1)
                filledBox 7,18,7,20, 15
                borderDraw 144,55,167,64, 12

            .elseif(box17.collided == 2)
                filledBox 7,18,7,20, 205
                borderDraw 144,55,167,64, 205

            .endif

            .if(box18.collided == 0)
                filledBox 7,21,7,23, 2
                borderDraw 168,55,191,64, 12
            
            .elseif(box18.collided == 1)
                filledBox 7,21,7,23, 9
                borderDraw 168,55,191,64, 12

            .elseif(box18.collided == 2)
                filledBox 7,21,7,23, 205
                borderDraw 168,55,191,64, 205

            .endif
            
            .if(box19.collided == 0)
                filledBox 7,24,7,26, 4
                borderDraw 192,55,215,64, 12
                    
            .elseif(box19.collided == 1)
                filledBox 7,24,7,26, 13
                borderDraw 192,55,215,64, 12

            .elseif(box19.collided == 2)
                filledBox 7,24,7,26, 205
                borderDraw 192,55,215,64, 205

            .endif

            .if(box20.collided == 0)
                filledBox 7,27,7,29, 11
                borderDraw 216,55,239,64, 12
                    
            .elseif(box20.collided == 1)
                filledBox 7,27,7,29, 16
                borderDraw 216,55,239,64, 12

            .elseif(box20.collided == 2)
                filledBox 7,27,7,29, 205
                borderDraw 216,55,239,64, 205

            .endif
            
            .if(box21.collided == 0)
                filledBox 7,30,7,32, 45
                borderDraw 240,55,263,64, 12
                    
            .elseif(box21.collided == 1)
                filledBox 7,30,10,32, 50
                borderDraw 240,55,263,64, 12
            
            .elseif(box21.collided == 2)
                filledBox 7,30,7,32, 205
                borderDraw 240,55,263,64, 205
                
            .endif
            
            .if(box22.collided == 0)
                filledBox 7,33,7,35, 23
                borderDraw 264,55,287,64, 12
                    
            .elseif(box22.collided == 1)
                filledBox 7,33,7,35, 25
                borderDraw 264,55,287,64, 12

            .elseif(box22.collided == 2)
                filledBox 7,33,7,35, 205
                borderDraw 264,55,287,64, 205
                    
            .endif
            
            ;row 3
            .if(box23.collided == 0)
                filledBox 9,5,9,7, 60
                borderDraw 40,71,63,80, 12
            
            .elseif(box23.collided == 1)
                filledBox 9,5,9,7, 20
                borderDraw 40,71,63,80, 12

            .elseif(box23.collided == 2)
                filledBox 9,5,9,7, 205
                borderDraw 40,71,63,80, 205

            .endif
            
            .if(box24.collided == 0)
                filledBox 9,8,9,10, 88
                borderDraw 64,71,87,80, 12
            
            .elseif(box24.collided == 1)
                filledBox 9,8,9,10, 45
                borderDraw 64,71,87,80, 12

            .elseif(box24.collided == 2)
                filledBox 9,8,9,10, 205
                borderDraw 64,71,87,80, 205
            
            .endif
            
            .if(box25.collided == 0)
                filledBox 9,11,9,13, 2
                borderDraw 88,71,111,80, 12
            
            .elseif(box25.collided == 1)
                filledBox 9,11,9,13, 65
                borderDraw 88,71,111,80, 12

            .elseif(box25.collided == 2)
                filledBox 9,11,9,13, 205
                borderDraw 88,71,111,80, 205
            
            .endif
            
            .if(box26.collided == 0)
                filledBox 9,14,9,16, 14
                borderDraw 112,71,135,80, 12
            
            .elseif(box26.collided == 1)
                filledBox 9,14,9,16, 75
                borderDraw 112,71,135,80, 12

            .elseif(box26.collided == 2)
                filledBox 9,14,9,16, 205
                borderDraw 112,71,135,80, 205
            
            .endif
            
            .if(box27.collided == 0)
                filledBox 9,17,9,19, 1
                borderDraw 136,71,159,80, 12
            
            .elseif(box27.collided == 1)
                filledBox 9,17,9,19, 35
                borderDraw 136,71,159,80, 12

            .elseif(box27.collided == 2)
                filledBox 9,17,9,19, 205
                borderDraw 136,71,159,80, 205
            
            .endif

            .if(box28.collided == 0)
                filledBox 9,20,9,22, 99
                borderDraw 160,71,183,80, 12
            
            .elseif(box28.collided == 1)
                filledBox 9,20,9,22, 95
                borderDraw 160,71,183,80, 12

            .elseif(box28.collided == 2)
                filledBox 9,20,9,22, 205
                borderDraw 160,71,183,80, 205
            
            .endif

            .if(box29.collided == 0)
                filledBox 9,23,9,25, 4
                borderDraw 184,71,207,80, 12
            
            .elseif(box29.collided == 1)
                filledBox 9,23,9,25, 30
                borderDraw 184,71,207,80, 12

            .elseif(box29.collided == 2)
                filledBox 9,23,9,25, 205
                borderDraw 184,71,207,80, 205
            
            .endif

            .if(box30.collided == 0)
                filledBox 9,26,9,28, 5
                borderDraw 208,71,231,80, 12
            
            .elseif(box30.collided == 1)
                filledBox 9,26,9,28, 25
                borderDraw 208,71,231,80, 12

            .elseif(box30.collided == 2)
                filledBox 9,26,9,28, 205
                borderDraw 208,71,231,80, 205
            
            .endif

            .if(box31.collided == 0)
                filledBox 9,29,9,31, 11
                borderDraw 232,71,255,80, 12
            
            .elseif(box31.collided == 1)
                filledBox 9,29,9,31, 105
                borderDraw 232,71,255,80, 12

            .elseif(box31.collided == 2)
                filledBox 9,29,9,31, 205
                borderDraw 232,71,255,80, 205
            
            .endif

            .if(box32.collided == 0)
                filledBox 9,32,9,34, 10
                borderDraw 256,71,279,80, 12
            
            .elseif(box32.collided == 1)
                filledBox 9,32,9,34, 200
                borderDraw 256,71,279,80, 12

            .elseif(box32.collided == 2)
                filledBox 9,32,9,34, 205
                borderDraw 256,71,279,80, 205
            
            .endif

            .if(box33.collided == 0)
                filledBox 9,35,9,37, 6
                borderDraw 280,71,303,80, 12
            
            .elseif(box33.collided == 1)
                filledBox 9,35,9,37, 69
                borderDraw 280,71,303,80, 12

            .elseif(box33.collided == 2)

                filledBox 9,35,9,37, 205
                borderDraw 280,71,303,80, 205

            .endif

        .endif

        ret
        
    checkcollide endp

    boxmovement proc

            ;Game Breaker
            ;mov ax, 0
            mov ah, 1
            int 16h
            .if al == 08d
                mov gamebreaker, 1
            .endif

        call livesprinter
        call playPause
        mov ball.speed, 1

        ;Quad 4
        .if direction == 0

            jmp h0
            g0:
            mov direction, 0

            h0:
            
            mov ball.color, 0110b
            call ballDrawer

            mov pad.color, 0111b
            call padDrawer

            .if(level == 1)
                mov looper, 1000000
            .elseif(level == 2)
                mov looper, 10000
            .elseif(level == 3)
                mov looper, 1000
            .endif

            .while looper > 0

                dec looper

            .endw
            
            ;padDrawer ball.x1, ball.y1, ball.x2, ball.y2, 0000b
            mov ball.color, 205
            call ballDrawer

            mov pad.color, 205
            call padDrawer


            call padmovement

            mov ax, ball.speed
            add ball.x1, ax
            add ball.x2, ax
            add ball.y1, ax
            add ball.y2, ax
            
            
            mov ball.color, 0110b
            call ballDrawer
            
            mov pad.color, 0111b
            call padDrawer
            collisionslider pad.x1, pad.y1, pad.x2
            collisionwalls ball.x2, ball.y2, ball.y1, ball.x1
            call collisionboxes
            call checkcollide

        .endif
        
        ;Quad 3
        .if direction == 1

            jmp h1
            g1:
            mov direction, 1

            h1:
            
            mov ball.color, 0110b
            call ballDrawer
            
            mov pad.color, 0111b
            call padDrawer

            .if(level == 1)
                mov looper, 1000000
            .elseif(level == 2)
                mov looper, 10000
            .elseif(level == 3)
                mov looper, 1000
            .endif

            .while looper > 0

                dec looper

            .endw
            
            ;padDrawer ball.x1, ball.y1, ball.x2, ball.y2, 0000b
            mov ball.color, 205
            call ballDrawer

            mov pad.color, 205
            call padDrawer


            call padmovement

            mov ax, ball.speed
            sub ball.x1, ax
            sub ball.x2, ax
            add ball.y1, ax
            add ball.y2, ax
            
            
            mov ball.color, 0110b
            call ballDrawer
            
            mov pad.color, 0111b
            call padDrawer
            collisionslider pad.x1, pad.y1, pad.x2
            collisionwalls ball.x2, ball.y2, ball.y1, ball.x1
            call collisionboxes
            call checkcollide

        .endif

        ;Quad 1
        .if direction == 2

            jmp h2
            g2:
            mov direction, 2

            h2:
            
            mov ball.color, 0110b
            call ballDrawer
            
            mov pad.color, 0111b
            call padDrawer

            .if(level == 1)
                mov looper, 1000000
            .elseif(level == 2)
                mov looper, 10000
            .elseif(level == 3)
                mov looper, 1000
            .endif

            .while looper > 0

                dec looper

            .endw
            
            ;padDrawer ball.x1, ball.y1, ball.x2, ball.y2, 0000b
            mov ball.color, 205
            call ballDrawer
            
            mov pad.color, 205
            call padDrawer

            call padmovement

            mov ax, ball.speed
            add ball.x1, ax
            add ball.x2, ax
            sub ball.y1, ax
            sub ball.y2, ax
            
            
            mov ball.color, 0110b
            call ballDrawer

            mov pad.color, 0111b
            call padDrawer

            collisionslider pad.x1, pad.y1, pad.x2
            collisionwalls ball.x2, ball.y2, ball.y1, ball.x1
           call collisionboxes
            call checkcollide

        .endif

        ;Quad 2
        .if direction == 3

            jmp h3
            g3:
            mov direction, 3

            h3:
            
            mov ball.color, 0110b
            call ballDrawer

            mov pad.color, 0111b
            call padDrawer

            .if(level == 1)
                mov looper, 1000000
            .elseif(level == 2)
                mov looper, 10000
            .elseif(level == 3)
                mov looper, 1000
            .endif

            .while looper > 0

                dec looper

            .endw
            
            ;padDrawer ball.x1, ball.y1, ball.x2, ball.y2, 0000b
            mov ball.color, 205
            call ballDrawer

            mov pad.color, 205
            call padDrawer

            call padmovement

            mov ax, ball.speed
            sub ball.x1, ax
            sub ball.x2, ax
            sub ball.y1, ax
            sub ball.y2, ax
            
            
            mov ball.color, 0110b
            call ballDrawer

            mov pad.color, 205
            call padDrawer

            collisionslider pad.x1, pad.y1, pad.x2
            collisionwalls ball.x2, ball.y2, ball.y1, ball.x1
           call collisionboxes
           call  checkcollide

        .endif

        ;Upward Straight Movement
        .if(direction == 4)
            jmp h4
            g4:
            mov direction, 4

            h4:
            
            mov ball.color, 0110b
            call ballDrawer

            mov pad.color, 0111b
            call padDrawer

            .if(level == 1)
                mov looper, 1000000
            .elseif(level == 2)
                mov looper, 10000
            .elseif(level == 3)
                mov looper, 1000
            .endif
            
            .while looper > 0

                dec looper

            .endw
            
            ;padDrawer ball.x1, ball.y1, ball.x2, ball.y2, 0000b
            mov ball.color, 205
            call ballDrawer

            mov pad.color, 205
            call padDrawer

            call padmovement

            mov ax, ball.speed
            
            sub ball.y1, ax
            sub ball.y2, ax
            
            
            mov ball.color, 0110b
            call ballDrawer

            mov pad.color, 0111b
            call padDrawer

            collisionslider pad.x1, pad.y1, pad.x2
            collisionwalls ball.x2, ball.y2, ball.y1, ball.x1
            call collisionboxes
            call checkcollide
        .endif

        ;Downward Straight Movement
        .if(direction == 5)
            jmp h5
            g5:
            mov direction, 5

            h5:
            
            mov ball.color, 0110b
            call ballDrawer
            
            mov pad.color, 0111b
            call padDrawer

            .if(level == 1)
                mov looper, 1000000
            .elseif(level == 2)
                mov looper, 10000
            .elseif(level == 3)
                mov looper, 1000
            .endif
           
            .while looper > 0

                dec looper

            .endw
            
            ;padDrawer ball.x1, ball.y1, ball.x2, ball.y2, 0000b
            mov ball.color, 205
            call ballDrawer
            
            mov pad.color, 205
            call padDrawer

            call padmovement

            mov ax, ball.speed
            
            add ball.y1, ax
            add ball.y2, ax
            
            
            mov ball.color, 205
            call ballDrawer

            mov pad.color, 0111b
            call padDrawer

            collisionslider pad.x1, pad.y1, pad.x2
            collisionwalls ball.x2, ball.y2, ball.y1, ball.x1
            call collisionboxes
            call checkcollide
        .endif

        ret
    boxmovement endp

    padmovement proc

        mov ah, 1
        int 16h

        .if(ah == 4Dh)
            add pad.x1, 4
            add pad.x2, 4
            .if (pad.x1 >= 270)
                sub pad.x1, 8
                sub pad.x2, 8
            
            .endif

            mov ah, 0
            int 16h

        ;.endif

        .elseif(ah == 4Bh)
            sub pad.x1, 4
            sub pad.x2, 4
            .if(pad.x1 <= 11)
                add pad.x1, 8
                add pad.x2, 8

            .endif

            mov ah, 0
            int 16h

        .endif

        ret

    padmovement endp

    ballDrawer proc

        ;Line 1

        mov cx, ball.x1    
        inc cx
        inc cx
        inc cx
        mov dx, ball.y1    
        mov bh, 0
        mov al, ball.color  
        mov ah, 0ch 
        int 10h

        mov cx, ball.x1    
        inc cx
        inc cx
        inc cx
        inc cx
        mov dx, ball.y1    
        mov bh, 0
        mov al, ball.color  
        mov ah, 0ch 
        int 10h

        ;Line 2

        mov cx, ball.x1    
        inc cx
        inc cx
        mov dx, ball.y1    
        inc dx
        mov bh, 0
        mov al, ball.color  
        mov ah, 0ch 
        int 10h

        mov cx, ball.x1    
        inc cx
        inc cx
        inc cx
        mov dx, ball.y1    
        inc dx
        mov bh, 0
        mov al, ball.color  
        mov ah, 0ch 
        int 10h

        mov cx, ball.x1    
        inc cx
        inc cx
        inc cx
        inc cx
        mov dx, ball.y1    
        inc dx
        mov bh, 0
        mov al, ball.color  
        mov ah, 0ch 
        int 10h

        mov cx, ball.x1    
        inc cx
        inc cx
        inc cx
        inc cx
        inc cx
        mov dx, ball.y1    
        inc dx
        mov bh, 0
        mov al, ball.color  
        mov ah, 0ch 
        int 10h

        ;Line 3

        mov cx, ball.x1    
        inc cx
        mov dx, ball.y1    
        inc dx
        inc dx
        mov bh, 0
        mov al, ball.color  
        mov ah, 0ch 
        int 10h

        mov cx, ball.x1    
        inc cx
        inc cx
        mov dx, ball.y1    
        inc dx
        inc dx
        mov bh, 0
        mov al, ball.color  
        mov ah, 0ch 
        int 10h

        mov cx, ball.x1    
        inc cx
        inc cx
        inc cx
        mov dx, ball.y1    
        inc dx
        inc dx
        mov bh, 0
        mov al, ball.color  
        mov ah, 0ch 
        int 10h

        mov cx, ball.x1    
        inc cx
        inc cx
        inc cx
        inc cx
        mov dx, ball.y1    
        inc dx
        inc dx
        mov bh, 0
        mov al, ball.color  
        mov ah, 0ch 
        int 10h

        mov cx, ball.x1    
        inc cx
        inc cx
        inc cx
        inc cx
        inc cx
        mov dx, ball.y1    
        inc dx
        inc dx
        mov bh, 0
        mov al, ball.color  
        mov ah, 0ch 
        int 10h

        mov cx, ball.x1    
        inc cx
        inc cx
        inc cx
        inc cx
        inc cx
        inc cx
        mov dx, ball.y1    
        inc dx
        inc dx
        mov bh, 0
        mov al, ball.color 
        mov ah, 0ch 
        int 10h

        ;Line 4

        mov cx, ball.x1    
        inc cx
        mov dx, ball.y1    
        inc dx
        inc dx
        inc dx
        mov bh, 0
        mov al, ball.color 
        mov ah, 0ch 
        int 10h

        mov cx, ball.x1    
        inc cx
        inc cx
        mov dx, ball.y1    
        inc dx
        inc dx
        inc dx
        mov bh, 0
        mov al, ball.color
        mov ah, 0ch 
        int 10h

        mov cx, ball.x1   
        inc cx
        inc cx
        inc cx
        mov dx, ball.y1   
        inc dx
        inc dx
        inc dx
        mov bh, 0
        mov al, ball.color
        mov ah, 0ch 
        int 10h

        mov cx, ball.x1
        inc cx
        inc cx
        inc cx
        inc cx
        mov dx, ball.y1   
        inc dx
        inc dx
        inc dx
        mov bh, 0
        mov al, ball.color 
        mov ah, 0ch 
        int 10h

        mov cx, ball.x1  
        inc cx
        inc cx
        inc cx
        inc cx
        inc cx
        mov dx, ball.y1  
        inc dx
        inc dx
        inc dx
        mov bh, 0
        mov al, ball.color 
        mov ah, 0ch 
        int 10h

        mov cx, ball.x1  
        inc cx
        inc cx
        inc cx
        inc cx
        inc cx
        inc cx
        mov dx, ball.y1  
        inc dx
        inc dx
        inc dx
        mov bh, 0
        mov al, ball.color 
        mov ah, 0ch 
        int 10h

        ;Line 2

        mov cx, ball.x1  
        inc cx
        inc cx
        mov dx, ball.y1   
        inc dx
        inc dx
        inc dx
        inc dx
        mov bh, 0
        mov al, ball.color 
        mov ah, 0ch 
        int 10h

        mov cx, ball.x1 
        inc cx
        inc cx
        inc cx
        mov dx, ball.y1  
        inc dx
        inc dx
        inc dx
        inc dx
        mov bh, 0
        mov al, ball.color 
        mov ah, 0ch 
        int 10h

        mov cx, ball.x1   
        inc cx
        inc cx
        inc cx
        inc cx
        mov dx, ball.y1  
        inc dx
        inc dx
        inc dx
        inc dx
        mov bh, 0
        mov al, ball.color 
        mov ah, 0ch 
        int 10h

        mov cx, ball.x1  
        inc cx
        inc cx
        inc cx
        inc cx
        inc cx
        mov dx, ball.y1  
        inc dx
        inc dx
        inc dx
        inc dx
        mov bh, 0
        mov al, ball.color  
        mov ah, 0ch 
        int 10h

        ;Line 1

        mov cx, ball.x1    
        inc cx
        inc cx
        inc cx
        mov dx, ball.y1    
        inc dx
        inc dx
        inc dx
        inc dx
        inc dx
        mov bh, 0
        mov al, ball.color  
        mov ah, 0ch 
        int 10h

        mov cx, ball.x1    
        inc cx
        inc cx
        inc cx
        inc cx
        mov dx, ball.y1    
        inc dx
        inc dx
        inc dx
        inc dx
        inc dx
        mov bh, 0
        mov al, ball.color 
        mov ah, 0ch 
        int 10h

        ret

    ballDrawer endp

    beep PROC

        mov     al, 182
        out     43h, al

        mov     ax, freq       
        out     42h, al
        mov     al, ah
        out     42h, al               

        in      al, 61h         
        or      al, 00000011b  
        out     61h, al      
        mov bx, 2

        delay1:
            mov cx, 65535
        delay2:
            dec cx
            jne delay2
            dec bx
            jne delay1
            in al, 61h
            and al, 11111100b
            out 61h, al

            ret

    beep ENDP

    collisionboxes proc

        ;Game Breaker
        mov ah, 1
        int 16h
        .if al == 08d
            mov gamebreaker, 1
            jmp ender
        .endif

        mov ax, ball.x1
        mov bx, ball.y1
        mov cx, ball.x2
        mov dx, ball.y2
        for i, <box1, box2, box3, box4, box5, box6, box7, box8, box9, box10, box11, box12, box13, box14, box15, box16, box17, box18, box19, box20, box21, box22, box23, box24, box25, box26, box27, box28, box29, box30, box31, box32, box33>
            
            .if(level == 1)

                .if (i.y2 == bx && ax >= i.x1 && cx <= i.x2 && i.collided < 1)
                    add i.collided, 1
                    add p1.score, 5
                    add boxesdestroyed, 1
                    
                    ;down collision
                    .if(direction == 3)
                        mov direction, 1

                    .elseif(direction == 2)
                        mov direction, 0

                    .elseif(direction == 4)
                        mov direction, 5

                    .endif
                
                .endif
                
                ;left side of ball collision
                .if(i.x2 == ax && dx >= i.y1 && bx <= i.y2 && i.collided < 1)
                    add i.collided, 1
                    add p1.score, 5
                    add boxesdestroyed, 1

                    .if(direction == 3)
                        mov direction, 2
                    
                    .elseif(direction == 1)
                        mov direction, 0
                    
                    .endif

                .endif
                
                ;right side of ball collision
                .if(i.x1 == cx && dx >= i.y1 && bx <= i.y2 && i.collided < 1)
                    add i.collided, 1
                    add p1.score, 5
                    add boxesdestroyed, 1
                    
                    .if(direction == 2)
                        mov direction, 1
                    
                    .elseif(direction == 0)
                        mov direction, 1
                
                    .endif
                
                .endif

                ;upside collision
                .if(i.y1 == dx  && ax >= i.x1 && cx <= i.x2 && i.collided < 1)
                    add i.collided, 1
                    add p1.score, 5
                    add boxesdestroyed, 1

                    .if(direction == 1)
                        mov direction, 3
                    
                    .elseif(direction == 0)
                        mov direction, 2

                    .elseif(direction == 4)
                        mov direction, 5

                    .endif

                .endif

            .elseif(level == 2)

                .if (i.y2 == bx && ax >= i.x1 && cx <= i.x2 && i.collided < 2)
                    add i.collided, 1
                    add p1.score, 5
                    add boxesdestroyed, 1
                    
                    ;down collision
                    .if(direction == 3)
                        mov direction, 1

                    .elseif(direction == 2)
                        mov direction, 0

                    .elseif(direction == 4)
                        mov direction, 5

                    .endif
                
                .endif
                
                ;left side of ball collision
                .if(i.x2 == ax && dx >= i.y1 && bx <= i.y2 && i.collided < 2)
                    add i.collided, 1
                    add p1.score, 5
                    add boxesdestroyed, 1

                    .if(direction == 3)
                        mov direction, 2
                    
                    .elseif(direction == 1)
                        mov direction, 0
                    
                    .endif

                .endif
                
                ;right side of ball collision
                .if(i.x1 == cx && dx >= i.y1 && bx <= i.y2 && i.collided < 2)
                    add i.collided, 1
                    add p1.score, 5
                    add boxesdestroyed, 1
                    
                    .if(direction == 2)
                        mov direction, 1
                    
                    .elseif(direction == 0)
                        mov direction, 1
                
                    .endif
                
                .endif

                ;upside collision
                .if(i.y1 == dx  && ax >= i.x1 && cx <= i.x2 && i.collided < 2)
                    add i.collided, 1
                    add p1.score, 5
                    add boxesdestroyed, 1

                    .if(direction == 1)
                        mov direction, 3
                    
                    .elseif(direction == 0)
                        mov direction, 2

                    .elseif(direction == 4)
                        mov direction, 5

                    .endif

                .endif

            .endif

        endm
        ret
    collisionboxes endp

    ;HIGHSCORES Page
    printHighscores proc

        mov dx, 10
        mov ah, 2
        int 21h
        int 21h
        int 21h
        int 21h
        
        mov dx, offset hmsg0
        mov ah, 9
        int 21h

        mov dx, 10
        mov bh, 0
        mov ah, 2
        int 21h
        int 21h
        int 21h

        mov dx, offset hmsg1
        mov ah, 9
        int 21h

        mov dx, 10
        mov bh, 0
        mov ah, 2
        int 21h
        int 21h

        mov dx, offset hmsg2
        mov ah, 9
        int 21h

        mov dx, 10
        mov bh, 0
        mov ah, 2
        int 21h
        int 21h

        mov dx, offset hmsg3
        mov ah, 9
        int 21h

        mov dx, 10
        mov bh, 0
        mov ah, 2
        int 21h
        int 21h

        mov dx, offset hmsg4
        mov ah, 9
        int 21h

        mov dx, 10
        mov bh, 0
        mov ah, 2
        int 21h
        int 21h

        mov dx, offset hmsg5
        mov ah, 9
        int 21h

        ; mov dx, offset buffer
        ; mov ah, 9
        ; int 21h
        
        ;call fileReader

        
        ; mov ah, 9
        ; lea dx, buffer
        ; int 21h
        


        call borderprinter

        .while(al != 8)

        mov ah, 0
        int 16h

        .endw

        ret 
        
    printHighscores endp

    printWinGame proc

        mov ah, 0
        mov al, 13h    ;320x200
        int 10h

        call backgroundPage
        call borderprinter

        mov x, 12
        printChars x, 6, 11, 'C'
        inc x
        printChars x, 6, 11, 'O'
        inc x
        printChars x, 6, 11, 'N'
        inc x
        printChars x, 6, 11, 'G'
        inc x
        printChars x, 6, 11, 'A'
        inc x
        printChars x, 6, 11, 'T'
        inc x
        printChars x, 6, 11, 'U'
        inc x
        printChars x, 6, 11, 'L'
        inc x
        printChars x, 6, 11, 'A'
        inc x
        printChars x, 6, 11, 'T'
        inc x
        printChars x, 6, 11, 'I'
        inc x
        printChars x, 6, 11, 'O'
        inc x
        printChars x, 6, 11, 'N'
        inc x
        printChars x, 6, 11, 'S'
        inc x
        printChars x, 6, 11, ' '
        inc x
        printChars x, 6, 11, '!'
        inc x
        printChars x, 6, 11, ' '
        inc x

        MOV X, 12
        printChars x, 10, 11, 'Y'
        inc x
        printChars x, 10, 11, 'O'
        inc x
        printChars x, 10, 11, 'U'
        inc x
        printChars x, 10, 11, ' '
        inc x
        printChars x, 10, 11, 'C'
        inc x
        printChars x, 10, 11, 'O'
        inc x
        printChars x, 10, 11, 'M'
        inc x
        printChars x, 10, 11, 'P'
        inc x
        printChars x, 10, 11, 'L'
        inc x
        printChars x, 10, 11, 'E'
        inc x
        printChars x, 10, 11, 'T'
        inc x
        printChars x, 10, 11, 'E'
        inc x
        printChars x, 10, 11, 'D'
        inc x
        printChars x, 10, 11, ' '
        inc x
        printChars x, 10, 11, 'G'
        inc x
        printChars x, 10, 11, 'A'
        inc x
        printChars x, 10, 11, 'M'
        inc x
        printChars x, 10, 11, 'E'
        inc x
    
        mov x, 14
        printChars x, 14, 11, 'N'
        inc x
        printChars x, 14, 11, 'A'
        inc x
        printChars x, 14, 11, 'M'
        inc x
        printChars x, 14, 11, 'E'
        inc x
        printChars x, 14, 11, ':'
        inc x
        printChars x, 14, 11, ' '
        inc x
        printChars x, 14, 11, ' '
        inc x

        mov dx, offset p1.nameInp
        mov ah, 9
        int 21h

        mov x, 15
        printChars x, 17, 11, 'S'
        inc x
        printChars x, 17, 11, 'C'
        inc x
        printChars x, 17, 11, 'O'
        inc x
        printChars x, 17, 11, 'R'
        inc x
        printChars x, 17, 11, 'E'
        inc x
        printChars x, 17, 11, ':'
        inc x
        printChars x, 17, 11, ' '

        call updateScores
        mov dx, offset scoreStr
        mov ah, 9
        int 21h

        jmp ender

        ret

    printWinGame endp

    ;Instruction Page
    printinstruction proc

        mov dx, 10
        mov ah, 2
        int 21h
        int 21h

        mov dx, offset msg
        mov ah, 9
        int 21h

        mov dx, 10
        mov ah, 2
        int 21h
        int 21h

        mov dx, offset intro1
        mov ah, 9
        int 21h

        mov dx, 10
        mov ah, 2
        int 21h
        int 21h

        mov dx, offset msg0
        mov ah, 9
        int 21h

        mov dx, 10
        mov ah, 2
        int 21h
        int 21h

        mov dx, offset msg1
        mov ah, 9
        int 21h

        mov dx, 10
        mov ah, 2
        int 21h

        mov dx, offset msg2
        mov ah, 9
        int 21h

        mov dx, 10
        mov ah, 2
        int 21h
        int 21h
    
        mov dx, offset msg3
        mov ah, 9
        int 21h

        mov dx, 10
        mov ah, 2
        int 21h

        mov dx, offset msg4
        mov ah, 9
        int 21h

        mov dx, 10
        mov ah, 2
        int 21h
        int 21h

        mov dx, offset intro3
        mov ah, 9
        int 21h

        mov dx, 10
        mov ah, 2
        int 21h
        int 21h

        mov dx, offset intro4
        mov ah, 9
        int 21h

        mov dx, 10
        mov ah, 2
        int 21h
        int 21h

        mov dx, offset intro5
        mov ah, 9
        int 21h

        mov dx, 10
        mov ah, 2
        int 21h
        int 21h

        .while(al != 8)

        mov ah, 0
        int 16h

        .endw

        ;call fileReader

        ret

    printinstruction endp

    livesprinter proc

        .if(lives == 3)

        printChars 2, 2, 3, 'L'
        printChars 3, 2, 3, 'I'
        printChars 4, 2, 3, 'V'
        printChars 5, 2, 3, 'E'
        printChars 6, 2, 3, 'S'
        printChars 7, 2, 3, ':'
        printChars 8, 2, 3, ' '

        ;Hearts
        printChars 9, 2, 4, 3
        printChars 10, 2, 4, 3
        printChars 11, 2, 4, 3
        
        .elseif(lives == 2)

        printChars 2, 2, 3, 'L'
        printChars 3, 2, 3, 'I'
        printChars 4, 2, 3, 'V'
        printChars 5, 2, 3, 'E'
        printChars 6, 2, 3, 'S'
        printChars 7, 2, 3, ':'
        printChars 8, 2, 3, ' '
        
        ;Hearts
        printChars 9, 2, 4, 3
        printChars 10, 2, 4, 3
        printChars 11, 2, 7, 3

        .elseif(lives == 1)

        printChars 2, 2, 3, 'L'
        printChars 3, 2, 3, 'I'
        printChars 4, 2, 3, 'V'
        printChars 5, 2, 3, 'E'
        printChars 6, 2, 3, 'S'
        printChars 7, 2, 3, ':'
        printChars 8, 2, 3, ' '
        
        ;Hearts
        printChars 9, 2, 4, 3
        printChars 10, 2, 7, 3
        printChars 11, 2, 7, 3
        
        .elseif(lives == 0)

            call gameover

        .endif

        printChars 30, 2, 3, 'S'
        printChars 31, 2, 3, 'C'
        printChars 32, 2, 3, 'O'
        printChars 33, 2, 3, 'R'
        printChars 34, 2, 3, 'E'
        printChars 35, 2, 3, ':'
        printChars 36, 2, 3, ' '
        
        call updateScores
        mov dx, offset scoreStr
        mov ah, 9
        int 21h
        
        ret

    livesprinter endp

    namePrinter proc

        printChars 14, 2, 10, 'N'
        printChars 15, 2, 10, 'A'
        printChars 16, 2, 10, 'M'
        printChars 17, 2, 10, 'E'
        printChars 18, 2, 10, ':'
        printChars 19, 2, 10, ' '

        mov dx, offset p1.nameInp
        mov ah, 9
        int 21h
        
        ret

    namePrinter endp
    
    nameInput proc

        push ax
        mov si, offset p1.nameInp

        .while(al != 13)

            mov ah, 1h
            int 21h

            .if(al == 8)
                jmp ender

            .endif

            mov [si], al
            inc si

        .endw

        mov al, '$'
        mov [si], al

        pop ax

        ret
        
    nameInput endp

    backgroundPage proc

        mov ah, 6
        mov al, 0
        mov bh, 12     ;color
        mov ch, 0     ;top row of window
        mov cl, 0     ;left most column of window
        mov dh, 110     ;Bottom row of window
        mov dl, 110     ;Right most column of window

        int 10h

        ret 

    backgroundPage endp

    borderprinter proc

        mov ah, 6
        mov al, 0
        mov bh, 4     ;color
        mov ch, 0     ;top row of window
        mov cl, 0     ;left most column of window
        mov dh, 24     ;Bottom row of window
        mov dl, 1     ;Right most column of window
        int 10h

        mov ah, 6
        mov al, 0
        mov bh, 4     ;color
        mov ch, 0     ;top row of window
        mov cl, 0     ;left most column of window
        mov dh, 1     ;Bottom row of window
        mov dl, 40    ;Right most column of window
        int 10h

        mov ah, 6
        mov al, 0
        mov bh, 4     ;color
        mov ch, 0     ;top row of window
        mov cl, 38     ;left most column of window
        mov dh, 36     ;Bottom row of window
        mov dl, 39    ;Right most column of window
        int 10h

        mov ah, 6
        mov al, 0
        mov bh, 4     ;color
        mov ch, 28    ;top row of window
        mov cl, 0     ;left most column of window
        mov dh, 29     ;Bottom row of window
        mov dl, 39    ;Right most column of window
        int 10h

        ret

    borderprinter endp
    
    FirstPage proc

        mov ah, 0
        mov al, 13h
        int 10h

        mov ax, 0

        call backgroundPage
        call borderprinter

        mov x, 11
        printChars x, 4, 11, 'B'
        inc x
        printChars x, 4, 11, 'R'
        inc x
        printChars x, 4, 11, 'I'
        inc x
        printChars x, 4, 11, 'C'
        inc x
        printChars x, 4, 11, 'K'
        inc x
        printChars x, 4, 0, ' '
        inc x
        printChars x, 4, 11, 'B'
        inc x
        printChars x, 4, 11, 'R'
        inc x
        printChars x, 4, 11, 'E'
        inc x
        printChars x, 4, 11, 'A'
        inc x
        printChars x, 4, 11, 'K'
        inc x
        printChars x, 4, 11, 'E'
        inc x
        printChars x, 4, 11, 'R'
        inc x
        printChars x, 4, 11, ' '
        inc x
        printChars x, 4, 11, 'G'
        inc x
        printChars x, 4, 11, 'A'
        inc x
        printChars x, 4, 11, 'M'
        inc x
        printChars x, 4, 11, 'E'
        inc x
        
        mov x, 8
        printChars x, 18, 11, 'P'
        inc x
        printChars x, 18, 11, 'R'
        inc x
        printChars x, 18, 11, 'E'
        inc x
        printChars x, 18, 11, 'S'
        inc x
        printChars x, 18, 11, 'S'
        inc x
        printChars x, 18, 11, ' '
        inc x
        printChars x, 18, 11, 'E'
        inc x
        printChars x, 18, 11, 'N'
        inc x
        printChars x, 18, 11, 'T'
        inc x
        printChars x, 18, 11, 'E'
        inc x
        printChars x, 18, 11, 'R'
        inc x
        printChars x, 18, 11, ' '
        inc x
        printChars x, 18, 11, 'T'
        inc x
        printChars x, 18, 11, 'O'
        inc x
        printChars x, 18, 11, ' '
        inc x
        printChars x, 18, 11, 'S'
        inc x
        printChars x, 18, 11, 'A'
        inc x
        printChars x, 18, 11, 'V'
        inc x
        printChars x, 18, 11, 'E'
        inc x
        printChars x, 18, 11, ' '
        inc x
        printChars x, 18, 11, 'N'
        inc x
        printChars x, 18, 11, 'A'
        inc x
        printChars x, 18, 11, 'M'
        inc x
        printChars x, 18, 11, 'E'
        inc x
        printChars x, 18, 11, ' '
        inc x

        mov x, 8
        printChars x, 8, 11, 'E'
        inc x
        printChars x, 8, 11, 'N'
        inc x
        printChars x, 8, 11, 'T'
        inc x
        printChars x, 8, 11, 'E'
        inc x
        printChars x, 8, 11, 'R'
        inc x
        printChars x, 8, 0, ' '
        inc x
        printChars x, 8, 11, 'Y'
        inc x
        printChars x, 8, 11, 'O'
        inc x
        printChars x, 8, 11, 'U'
        inc x
        printChars x, 8, 11, 'R'
        inc x
        printChars x, 8, 11, ' '
        inc x
        printChars x, 8, 11, 'N'
        inc x
        printChars x, 8, 11, 'A'
        inc x
        printChars x, 8, 11, 'M'
        inc x
        printChars x, 8, 11, 'E'
        inc x
        printChars x, 8, 11, ' '
        inc x
        printChars x, 8, 11, ':'
        inc x
        printChars x, 8, 11, ' '
        inc x
        printChars x, 8, 11, ' '
        inc x

        call nameInput

        mov ah, 0
        int 16h

        .if(al == 8)

            jmp ender
        .endif
        
        ret

    FirstPage endp

    gameover proc
    
        mov ah, 0
        mov al, 13h    ;320x200
        int 10h

        call backgroundPage
        call borderprinter

        mov x, 14
        printChars x, 6, 11, 'G'
        inc x
        printChars x, 6, 11, 'A'
        inc x
        printChars x, 6, 11, 'M'
        inc x
        printChars x, 6, 11, 'E'
        inc x
        printChars x, 6, 11, ' '
        inc x
        printChars x, 6, 11, 'O'
        inc x
        printChars x, 6, 11, 'V'
        inc x
        printChars x, 6, 11, 'E'
        inc x
        printChars x, 6, 11, 'R'
        inc x
        printChars x, 6, 11, ' '
        inc x
        printChars x, 6, 11, '!'
        inc x

        mov x, 14
        printChars x, 10, 11, 'N'
        inc x
        printChars x, 10, 11, 'A'
        inc x
        printChars x, 10, 11, 'M'
        inc x
        printChars x, 10, 11, 'E'
        inc x
        printChars x, 10, 11, ':'
        inc x
        printChars x, 10, 11, ' '
        inc x
        printChars x, 10, 11, ' '
        inc x

        mov dx, offset p1.nameInp
        mov ah, 9
        int 21h

        mov x, 14
        printChars x, 13, 11, 'S'
        inc x
        printChars x, 13, 11, 'C'
        inc x
        printChars x, 13, 11, 'O'
        inc x
        printChars x, 13, 11, 'R'
        inc x
        printChars x, 13, 11, 'E'
        inc x
        printChars x, 13, 11, ':'
        inc x
        printChars x, 13, 11, ' '
        inc x
        printChars x, 13, 11, ' '
        inc x

        call updateScores
        mov dx, offset scoreStr
        mov ah, 9
        int 21h

        jmp ender

        ret

    gameover endp

    ;pauses and resumes the game
    playPause proc

        mov ah, 1
        int 16h

        .if(al == 'p')

            .while(al != 'r')

                mov ah, 0
                int 16h

            .endw

        .endif

        ret
        
    playPause endp
    
    padDrawer proc
        
        mov ah, 1
        int 16h
        .if al == 08d
            mov gamebreaker, 1
        .endif

        mov dx, pad.y1

        .while dx <=  pad.y2
            lineprint pad.x1, pad.x2, pad.color
            inc dx
        .endw

        ret

    padDrawer endp

    fileReader PROC
        
        ; ;creates a file
        ; mov ah, 3ch
        ; lea dx, fName
        ; mov cl, 0
        ; int 21h
        ; mov fileHandler, ax

        ; ;opens a file
        ; mov ah, 3DH
        ; mov al, 2 ; 0 for reading, 1 for writing. 2 for both
        ; lea dx, fName
        ; int 21h
        ; mov fileHandler, ax

        ; ;write
        ; mov ah, 40H
        ; mov bx, fileHandler
        ; mov cx, 4
        ; mov dx, offset buffer
        ; int 21h

        ; ;reads a file
        ; mov ah, 3FH
        ; mov cx, 4
        ; lea dx, buffer
        ; mov bx, fileHandler
        ; int 21h

        ; mov ah, 3Eh
        ; mov bx, fileHandler
        ; int 21h

        ; mov dx, offset buffer
        ; mov ah, 9
        ; int 21h

        ; mov dx, offset buffer
        ; mov ah, 9
        ; int 21h

        ; mov ah, 3FH
        ; mov cx, 5
        ; mov dx, offset p1.score
        ; mov bx, fileHandler
        ; int 21h

        mov si, offset buffer

        printChars 50,10, 2, [si]
        inc si
        printChars 51,10, 2, [si]
        inc si
        printChars 52,10, 2, [si]
        inc si
        printChars 53,10, 2, [si]
        
        ret

    fileReader ENDP

    writeFile proc

        ret

    writeFile endp


    ender:
        mov ah, 4ch
        int 21h
        end