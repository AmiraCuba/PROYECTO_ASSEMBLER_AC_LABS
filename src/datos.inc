; Dimensiones del area de juego (80x25)
ANCHO           EQU 78       ; Columnas utiles (1 a 78)
ALTO            EQU 23       ; Filas utiles (1 a 23)
MAX_LONGITUD    EQU 100      ; Capacidad maxima de la serpiente

; Scan codes del teclado (INT 16h)
KEY_UP          EQU 48h
KEY_DOWN        EQU 50h
KEY_LEFT        EQU 4Bh
KEY_RIGHT       EQU 4Dh
KEY_ESC         EQU 01h

; Caracteres y atributos de color
CHAR_CABEZA     EQU 02h      ; Cara sonriente
CHAR_CUERPO     EQU 'o'
CHAR_COMIDA     EQU '*'
CHAR_BORDE      EQU '#'
CHAR_VACIO      EQU ' '      ; Para borrar la cola

COLOR_CABEZA    EQU 0Eh      ; Amarillo
COLOR_CUERPO    EQU 0Ah      ; Verde claro
COLOR_COMIDA    EQU 0Ch      ; Rojo claro
COLOR_BORDE     EQU 07h      ; Gris/blanco
COLOR_TEXTO     EQU 0Fh      ; Blanco brillante

; Coordenadas de la serpiente (indice 0 = cabeza)
serpiente_x     db MAX_LONGITUD dup(0)
serpiente_y     db MAX_LONGITUD dup(0)
cola_x_ant      db 0         ; Ultima posicion borrada
cola_y_ant      db 0

; Estado del juego
longitud        dw 3         ; Tamano inicial
dir_actual      db KEY_RIGHT ; Direccion de avance
game_over       db 0         ; 0 = activo, 1 = terminado

; Comida y aleatoriedad
comida_x        db 0
comida_y        db 0
semilla         dw 0

; Puntuacion y temporizacion
puntaje         dw 0
velocidad       dw 2         ; Ticks de espera (~110 ms)

; Cadenas de texto para DOS (INT 21h, AH=09h)
msg_score       db 'Puntaje: $'
msg_game_over   db '*** GAME OVER ***$'
msg_press_key   db 'Presione cualquier tecla para salir...$'
