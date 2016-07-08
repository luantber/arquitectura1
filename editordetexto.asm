name "keybrd"

org     100h

;Este Int 21h ... podria servir para sacar imprimir todo el texto del archivo ...
; si te fijas mas abajo declara msg ... con offset sacas la direccion

;INT 21h / AH=9 - output of a string at DS:DX. String must be terminated by '$'. 

mov dx, offset msg
mov ah, 9
int 21h


espera_tecla:
;nam nam .. por que no hay eñe ... la en*e pz .. 
;esto es un bucle que espera que se presione una tecla .. en ese caso .. se activa el flag z
; y sale del bucle
; check for keystroke in
; keyboard buffer:

;INT 16h / AH = 01h - check for keystroke in the keyboard buffer.
        mov     ah, 1
        int     16h
        jz      espera_tecla

; get keystroke from keyboard:
; (remove from the buffer)
;aqui solo borramos el buffer del bucle .. creo . no se .. avr miras que hace ese int
mov     ah, 0
int     16h

;nam.. imprmes 'al'
; print the key:
mov     ah, 0eh
int     10h    
           
;ah .. aqui revisa si la tecla presionada es el backspace <-
; pero no borra la pantalla solo en memoria           
; Backspace
cmp     al, 08h
jz      back
    

    
;cmp al, 0fh


;Revisa si la telca pressed is Ctrl + G   ( 07h)
cmp     al, 07h
jz      guardar

;Guarda en la memoria el texto para escribirlo posteriormente
;estoy guardondo en memoria .. que declare mas abajo .. porque no se como rayos se declara aqui
; y no quiero violar memoria del sistema .. .. pff .. si es un emulador

mov     offset reserva+bx,al
;y incremento un contador bx ... ntncs .. si .. reserva = 100
; despues escribes en 101 .. 102 .por el contador bx
inc bx


; comparas si es "Esc"
cmp     al, 1bh
jz      exit

; En caso que no paso nada .. sigues en el bucle esperando
jmp     espera_tecla

;============================

;Aqui estan las funciones ... 
back:
     ;Esto borra un caracter de 'reserva' .. decrementas .. y escribo un ' ' :3
    dec bx
    mov offset reserva+bx,' '
      
      
     ;Borramos de la pantalla
     mov al, ' '
    mov     ah, 0eh
    int     10h
    
    mov al, 08h
    mov     ah, 0eh
    int     10h      
    
    jmp espera_tecla

;esto guarda el archivo mm .. mira el ejemplo .. ahi lo explican creo .. pero no esta dificl
guardar:
    mov al, 2
	mov dx, offset file1
	mov ah, 3dh
	int 21h
	;jc .. cuidado
	mov handle, ax
	
    	
    ; write to file:
    mov ah, 40h
    mov bx, handle
    mov dx, offset reserva
    mov cx, 100
    int 21h
    ; close c:\emu8086\vdrive\C\test1\file1.txt
    mov ah, 3eh
    mov bx, handle
    int 21h
    jmp espera_tecla
	 



exit:
ret 


; todo aqui .. estoy separando memoria 
;0Dh Retorno de Carro
;0Ah Nueva linea
 
file1 db "c:\test1\file1.txt", 0
handle dw ?

;Escribo en memoria .. :3
msg  db "Escribe un texto (Max 100):", 0Dh,0Ah
     db "[Enter] - Retorna al inicio.", 0Dh,0Ah
     db "[Ctrl]+[Enter] - Salto de Linea", 0Dh,0Ah
     db "[Ctrl]+[G] - Guardar Archivo", 0Dh,0Ah
     db "[Esc] - Salir.", 0Dh,0Ah, "$"

;reservo 100bytes en blanco jajaj    
reserva db "                                                  "
        db "                                                  "
end
