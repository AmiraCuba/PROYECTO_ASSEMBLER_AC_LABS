leer_tecla PROC
    push ax
    push bx

    mov ah, 01h                  
    int 16h
    jz lt_fin                    

    mov ah, 00h                  
    int 16h                     
    mov bl, ah                   

    cmp bl, KEY_ESC
    je lt_esc
    cmp bl, KEY_UP
    je lt_arriba
    cmp bl, KEY_DOWN
    je lt_abajo
    cmp bl, KEY_LEFT
    je lt_izquierda
    cmp bl, KEY_RIGHT
    je lt_derecha
    jmp lt_vaciar                

lt_arriba:
    cmp dir_actual, KEY_DOWN     
    je lt_vaciar
    jmp lt_aplicar
lt_abajo:
    cmp dir_actual, KEY_UP
    je lt_vaciar
    jmp lt_aplicar
lt_izquierda:
    cmp dir_actual, KEY_RIGHT
    je lt_vaciar
    jmp lt_aplicar
lt_derecha:
    cmp dir_actual, KEY_LEFT
    je lt_vaciar

lt_aplicar:
    mov dir_actual, bl           

lt_vaciar:                       
    mov ah, 01h
    int 16h
    jz lt_fin
    mov ah, 00h
    int 16h
    cmp ah, KEY_ESC              
    jne lt_vaciar

lt_esc:
    mov game_over, 1

lt_fin:
    pop bx
    pop ax
    ret
leer_tecla ENDP


dibujar_tablero PROC
    push ax
    push bx
    push dx

    ; Bordes superior e inferior
    mov dl, 0                    
dt_horizontal:
    mov al, CHAR_BORDE
    mov bl, COLOR_BORDE
    mov dh, 0                    
    call dibujar_celda
    mov al, CHAR_BORDE
    mov bl, COLOR_BORDE
    mov dh, ALTO+1               
    call dibujar_celda
    inc dl
    cmp dl, ANCHO+2              
    jb dt_horizontal

    ; Bordes izquierdo y derecho
    mov dh, 1                    
dt_vertical:
    mov al, CHAR_BORDE
    mov bl, COLOR_BORDE
    mov dl, 0                    
    call dibujar_celda
    mov al, CHAR_BORDE
    mov bl, COLOR_BORDE
    mov dl, ANCHO+1              
    call dibujar_celda
    inc dh
    cmp dh, ALTO+1               
    jb dt_vertical

    pop dx
    pop bx
    pop ax
    ret
dibujar_tablero ENDP


mostrar_puntaje PROC
     push ax
    push bx
    push cx
    push dx
    push si
    push di

    mov al, CHAR_VACIO
    mov bl, COLOR_TEXTO
    mov dx, 2                    
    call dibujar_celda

    mov di, 3                   
    lea si, msg_score
mp_texto:
    mov al, [si]
    cmp al, '$'
    je mp_numero
    mov bl, COLOR_TEXTO
    mov dx, di                   
    call dibujar_celda
    inc di
    inc si
    jmp mp_texto

mp_numero:
    mov ax, puntaje
    mov bx, 10
    xor si, si                   
mp_dividir:
    xor dx, dx                   
    div bx                       
    push dx
    inc si
    or ax, ax
    jnz mp_dividir              

mp_imprimir:
    pop ax                       
    add al, '0'                  
    mov bl, COLOR_TEXTO
    mov dx, di
    call dibujar_celda
    inc di
    dec si
    jnz mp_imprimir

    mov al, CHAR_VACIO
    mov bl, COLOR_TEXTO
    mov dx, di
    call dibujar_celda

    pop di
    pop si
    pop dx
    pop cx
    pop bx
    pop ax
    ret
mostrar_puntaje ENDP
