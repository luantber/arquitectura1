name "keybrd"

org     100h

;Imprimir Mensaje
mov dx, offset msg
mov ah, 9
int 21h

    ;Bucle
    espera_tecla:
            mov     ah, 1
            int     16h
            jz      espera_tecla
        
    mov     ah, 0
    int     16h
    
;Abrir Ctrl + o 
    cmp     al, 0fh
    jz      open 
    
    
;Impresion
    mov     ah, 0eh
    int     10h    
           
     
;Backspace <-
    cmp     al, 08h
    jz      back
    
;Guardar Ctrl + G   ( 07h)
    cmp     al, 07h
    jz      guardar

;Memoria
    mov     offset reserva+bx,al
    inc     bx

;"Esc"
    cmp     al, 1bh
    jz      exit

;Regresa al bucle
    jmp     espera_tecla
 
 

;============================

;FUNCIONES

;abrir
    open:
        mov si,bx ; Para no perder el contador
        
    	mov al, 2   ;Lectura y Escritura
    	mov dx, offset file1
    	mov ah, 3dh
    	int 21h
    	mov handle, ax
    	
    	; Read file:
        mov ah, 3fh
        mov bx, handle
        mov dx, offset reserva
        mov cx, 100
        int 21h
        
        ; Imprimimos
        mov dx, offset reserva
        mov ah, 9
        int 21h
        
        mov bx,si ;Recuperamos el contador  
    	
        

;retroceso<-
    back:
        ;borrar <- de memoria
        dec bx
        mov offset reserva+bx,' '
          
          
        ;Borramos de la pantalla
        mov al, ' '
        mov     ah, 0eh
        int     10h
        
        ;print <-
        mov al, 08h
        mov     ah, 0eh
        int     10h      
         
        ;vuelve al bucle
        jmp espera_tecla


;Guardar
    guardar:
        mov si,bx ; Para no perder el contador
        
        mov al, 2   ;Lectura y Escritura
    	mov dx, offset file1
    	mov ah, 3dh
    	int 21h
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
        
        mov bx,si ;Recuperamos el contador
	 


;Salir
    exit:
        ret 


;0Dh Retorno de Carro
;0Ah Nueva linea
 
file1 db "c:\test1\file1.txt", 0  

handle dw ?

msg  db "Escribe un texto (Max 100):", 0Dh,0Ah
     db "[Enter] - Retorna al inicio.", 0Dh,0Ah
     db "[Ctrl]+[Enter] - Salto de Linea", 0Dh,0Ah
     db "[Ctrl]+[O] - Abrir Archivo", 0Dh,0Ah
     db "[Ctrl]+[G] - Guardar Archivo", 0Dh,0Ah
     db "[Esc] - Salir.", 0Dh,0Ah, "$"
  
reserva db "                                                  "
        db "                                                 $"
end
