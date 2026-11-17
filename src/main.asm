.model small
.stack 100h

.data
    include "datos.inc"

.code

; Modulos externos
include "input.asm"
include "logica.asm"
include "render.asm"

; ------------------------------------------------------------------------------
; Procedimiento principal
; ------------------------------------------------------------------------------
main PROC
    ; Inicializar segmento de datos
    mov ax, @data
    mov ds, ax

    ; Configurar modo de video texto 80x25 y limpiar pantalla
    mov ah, 00h
    mov al, 03h
    int 10h

    ; Ocultar cursor del sistema
    mov ah, 01h
    mov ch, 20h
    int 10h

    ; Inicializacion de la partida
    call inicializar_serpiente
    call dibujar_tablero
    call generar_comida
    call dibujar

; Ciclo principal del juego
bucle_principal:
    call leer_tecla

    ; Salir si se presiono ESC
    cmp game_over, 1
    je fin_del_juego

    call mover_serpiente

    ; Salir si hubo choque con pared o cuerpo
    call verificar_colision
    cmp game_over, 1
    je fin_del_juego

    call verificar_comida
    call dibujar
    call retardo

    jmp bucle_principal

; Rutina de finalizacion
fin_del_juego:
    call mostrar_game_over

    ; Esperar pulsacion de tecla antes de salir
    mov ah, 00h
    int 16h

    ; Restaurar cursor normal
    mov ah, 01h
    mov cx, 0607h
    int 10h

    ; Limpiar pantalla
    mov ah, 00h
    mov al, 03h
    int 10h

    ; Salir al sistema operativo
    mov ah, 4Ch
    mov al, 00h
    int 21h
main ENDP

; ------------------------------------------------------------------------------
; Inicializa la serpiente centrada con longitud 3 hacia la derecha
; ------------------------------------------------------------------------------
inicializar_serpiente PROC
    push ax

    mov longitud, 3
    mov dir_actual, KEY_RIGHT
    mov game_over, 0
    mov puntaje, 0

    ; Cabeza en centro (col 40, fila 12)
    mov serpiente_x[0], 40
    mov serpiente_y[0], 12

    ; Cuerpo
    mov serpiente_x[1], 39
    mov serpiente_y[1], 12

    mov serpiente_x[2], 38
    mov serpiente_y[2], 12

    ; Cola inicial
    mov cola_x_ant, 38
    mov cola_y_ant, 12

    pop ax
    ret
inicializar_serpiente ENDP

; ------------------------------------------------------------------------------
; Retardo temporal basado en los ticks de reloj de la BIOS (INT 1Ah)
; 1 tick ~= 55 ms. Espera 'velocidad' ticks (N = 2 ~= 110 ms)
; ------------------------------------------------------------------------------
retardo PROC
    push ax
    push bx
    push cx
    push dx

    ; Leer ticks iniciales (retorna en CX:DX)
    mov ah, 00h
    int 1Ah
    mov bx, dx

esperar_ticks:
    mov ah, 00h
    int 1Ah
    sub dx, bx                   ; Diferencia transcurrida
    cmp dx, velocidad
    jb esperar_ticks

    pop dx
    pop cx
    pop bx
    pop ax
    ret
retardo ENDP

; ------------------------------------------------------------------------------
; Muestra el mensaje centrado de Game Over en pantalla
; ------------------------------------------------------------------------------
mostrar_game_over PROC
    push ax
    push bx
    push dx

    ; Posicionar cursor en fila 11, columna 31
    mov ah, 02h
    mov bh, 0
    mov dh, 11
    mov dl, 31
    int 10h

    ; Imprimir texto de Game Over
    lea dx, msg_game_over
    mov ah, 09h
    int 21h

    ; Posicionar cursor en fila 13, columna 21
    mov ah, 02h
    mov bh, 0
    mov dh, 13
    mov dl, 21
    int 10h

    ; Imprimir indicacion para salir
    lea dx, msg_press_key
    mov ah, 09h
    int 21h

    pop dx
    pop bx
    pop ax
    ret
mostrar_game_over ENDP

END main
