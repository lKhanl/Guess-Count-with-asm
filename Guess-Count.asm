#start=Emulation_Kit.exe#
org 100h

main:
    call print
    call getRandomNumber
    mov ah, 1  
	int 21h
	
	cmp al, 40h   
	jnb call reset
	cmp al, 30h     
	jb call reset   
	
	
	cmp al,dl 
	je equal
	
	continue:
	inc bh 
	call ledProcesses
	call screenProcesses
	call newline
	jmp main
	ret
	
equal:
    call incBL
    jmp continue
	
getRandomNumber proc
    mov ah, 00h      
    int 1ah            
    mov  ax, dx                
    xor  dx, dx
    mov  cx, 10    
    div  cx  
    add dl, 30h   
    ret
endp

print proc
      lea si, message 
      mov ah, 0eh 
      mov cx, 28
    printmessage:
    
    lodsb
    int 10h
    loop printmessage
    ret     
endp

reset proc
    call newline
    jmp main
endp

newline proc
    mov ah, 0eh
    lea si, linefeed    
    mov cx,2
    printLinefeed:
    lodsb
    int 10h
    loop printLinefeed
    ret
endp

incBL proc
    inc bl 
    ret 
endp

screenProcesses proc 
    mov dx, 2040h 
    mov cx, 9h   
    lea si, winMessage 
    win:
    lodsb 
    
    out dx, al 
    inc dx  
    loop win
    mov al, bl 
    add al, 30h
    out dx, al 
    
    mov dx, 2050h 
    mov cx, 0dh  
    lea si, totalGuessMessage
    total:
    lodsb  
    out dx, al     
    inc dx
    loop total
    mov al, bh 
    add al, 30h   
    out dx, al   
    ret 
endp

ledProcesses proc
    push ax  
    sub al, 30h 
    lea si, ledSetter 
    push dx        
    mov dx, 2030h  
    mov cx, 8h     
    a: 
        lodsb   
        out dx, al    
        inc dx 
    loop a
    pop dx 
    pop ax  ;
    lea si, numbers 
    mov ah, 0
    sub al, 30h 
    cmp al,0   
    je goon0 
    mov cx, ax 
        findn:
            inc si 
            loop findn
 
    goon0:
    lodsb  
    push dx
    mov dx, 2032h
    out dx, al   
    
    pop dx  
   
    mov dh, 0 
    lea si, numbers 
    sub dl, 30h       
    
    cmp dl, 0 
    je goon1  
    mov cx, dx
        findnn:
            inc si  
            loop findnn
      add dl,30h   
      push dx   
    goon1:
    lodsb 
    mov dx, 2037h 
    out dx, al    
    pop dx   
    ret
     
endp

message db "Enter a number between 0-9: "  ;28
totalGuessMessage db "Total guess: "
winMessage db "You win: " ;9
linefeed db 13, 10
ledSetter db 00111110b,01000000b,00000000b,00000000b,00000000b,00111001b,01000000b,00000000b 
numbers db 3fh, 6h, 5bh, 4fh, 66h, 6dh, 7dh, 07h, 7fh, 6fh  