; ------------------------------------------------------------------------------
; mover_serpiente
; Entrada: serpiente_x/serpiente_y, longitud, dir_actual (scan code)
; Salida : cola_x_ant/cola_y_ant = cola antes de mover
;          serpiente[i+1] = serpiente[i] para i = longitud-1 .. 0
;          serpiente[0] = nueva cabeza segun dir_actual
; Preserva: AX, CX, SI
; ------------------------------------------------------------------------------
mover_serpiente PROC
    push ax
    push cx
    push si

    mov cx, longitud             ; CX = iteraciones del desplazamiento
    mov si, cx
    dec si                       ; SI = indice de la cola

    mov al, serpiente_x[si]      ; guardar cola para borrarla
    mov cola_x_ant, al
    mov al, serpiente_y[si]
    mov cola_y_ant, al

ms_desplazar:                    ; de la cola hacia la cabeza
    mov al, serpiente_x[si]
    mov serpiente_x[si+1], al    ; x[i+1] = x[i]
    mov al, serpiente_y[si]
    mov serpiente_y[si+1], al    ; y[i+1] = y[i]
    dec si
    loop ms_desplazar

    mov al, dir_actual           ; calcular nueva cabeza
    cmp al, KEY_UP
    je ms_arriba
    cmp al, KEY_DOWN
    je ms_abajo
    cmp al, KEY_LEFT
    je ms_izquierda
    cmp al, KEY_RIGHT
    je ms_derecha
    jmp ms_fin                   ; direccion invalida: no avanza

ms_arriba:
    dec serpiente_y              ; fila - 1
    jmp ms_fin
ms_abajo:
    inc serpiente_y              ; fila + 1
    jmp ms_fin
ms_izquierda:
    dec serpiente_x              ; columna - 1
    jmp ms_fin
ms_derecha:
    inc serpiente_x              ; columna + 1

ms_fin:
    pop si
    pop cx
    pop ax
    ret
mover_serpiente ENDP


; ------------------------------------------------------------------------------
; verificar_colision
; Entrada: serpiente_x/serpiente_y (cabeza en indice 0), longitud
; Salida : CF = 1 y game_over = 1 si la cabeza toca un borde o el cuerpo
;          CF = 0 (game_over sin cambios) si no hay choque
; Preserva: AX, CX, SI
; ------------------------------------------------------------------------------
verificar_colision PROC
    push ax
    push cx
    push si

    mov al, serpiente_x          ; AL = columna de la cabeza
    mov ah, serpiente_y          ; AH = fila de la cabeza

    cmp al, 1                    ; borde izquierdo (col 0)
    jb vc_choque
    cmp al, ANCHO                ; borde derecho (col ANCHO+1)
    ja vc_choque
    cmp ah, 1                    ; borde superior (fila 0)
    jb vc_choque
    cmp ah, ALTO                 ; borde inferior (fila ALTO+1)
    ja vc_choque

    mov cx, longitud
    dec cx                       ; segmentos del cuerpo (sin cabeza)
    jz vc_sin_choque
    mov si, 1                    ; empezar en el indice 1

vc_cuerpo:
    cmp al, serpiente_x[si]
    jne vc_siguiente
    cmp ah, serpiente_y[si]
    je vc_choque                 ; misma columna y fila
vc_siguiente:
    inc si
    loop vc_cuerpo

vc_sin_choque:
    clc                          ; CF = 0: sin colision
    jmp vc_fin

vc_choque:
    mov game_over, 1
    stc                          ; CF = 1: colision

vc_fin:
    pop si                       ; POP no altera CF
    pop cx
    pop ax
    ret
verificar_colision ENDP


; ------------------------------------------------------------------------------
; verificar_comida
; Entrada: cabeza (serpiente_x/serpiente_y[0]), comida_x, comida_y
; Salida : si la cabeza esta sobre la comida:
;          longitud + 1 (tope MAX_LONGITUD-1), puntaje + 1, nueva comida
; Preserva: AX
; ------------------------------------------------------------------------------
verificar_comida PROC
    push ax

    mov al, serpiente_x
    cmp al, comida_x
    jne vco_fin                  ; columna distinta
    mov al, serpiente_y
    cmp al, comida_y
    jne vco_fin                  ; fila distinta

    cmp longitud, MAX_LONGITUD-1
    jae vco_puntaje              ; ya en el tope: no crece
    inc longitud                 ; segmento nuevo = cola anterior

vco_puntaje:
    inc puntaje
    call generar_comida          ; Integrante 4

vco_fin:
    pop ax
    ret
verificar_comida ENDP
