data segment
    len equ 400 
    msg db " sot. tys. jitelei$"
    msg21 db "Strana: $"
    msg22 db "Naselenie: $"
    new_line db 0dh,0ah,'$'
    text1 db "Vvedite 1, chtoby vvesti dannye vruchnuiu$"
    text2 db "Vvedite 2, chtoby vvesti predopredelennye dannye$"
    text3 db "Vvedite 3, chtoby otobraziti ishodnye dannye$"
    text4 db "Vvedite 4, chtoby otobraziti dannye soglasno variantu$"
    strany db len dup(?)
    nasel dw 40 dup(?)
    s1 db "Moldova"
    s2 db "Ucraine"
    s3 db "Russia"
    s4 db "Belarus"
    s5 db "USA"
    s6 db "Finland"
    s7 db "Mexico"
    s8 db "France"
    s9 db "Germany"
    s10 db "Switzerland"
    nas1 dw 23,' ', 377,' ',1438,' ',91,' ',3401,' ',55,' ',1297,' ',682,' ',832,' ',88,' '
ends
stack segment
    dw   128  dup(0)
ends
code segment
    print_ax proc
    cmp ax, 0
    jne print_ax_r
        push ax
        mov al, '0'
        mov ah, 0eh
        int 10h
        pop ax
        ret 
    print_ax_r:
        pusha
        mov dx, 0
        cmp ax, 0
        je pn_done
        mov bx, 10
        div bx    
        call print_ax_r
        mov ax, dx
        add al, 30h
        mov ah, 0eh
        int 10h    
        jmp pn_done
    pn_done:
        popa  
        ret  
    endp           

    menu1 proc
        mov cx, 10
        repeating:
            
        loop repeating
    cicl1:   
        lea dx, msg21
        mov ah, 9
        int 21h
    c1:
        mov ah, 01h
        int 21h
        cmp ax, 21h
        je end
        mov strany[si], ax
        inc si
        jmp c1
        
        lea dx,new_line
        mov ah, 9
        int 21h   
        lea dx,msg22
        mov ah, 9
        int 21h
    c2:
        lea dx,msg22
        mov ah, 9
        int 21h
        
    end:            
        ret                 
    endp

    menu2 proc
        lea si, s1
        lea di, strany
        mov cx, 20
        rep movsb
        
        lea si, s2
        lea di, strany
        mov cx, 20
        rep movsb
        
        lea si, s3
        lea di, strany
        mov cx, 20
        rep movsb
        
        lea si, s4
        lea di, strany
        mov cx, 20
        rep movsb
        
        lea si, s5
        lea di, strany
        mov cx, 20
        rep movsb
        
        lea si, s6
        lea di, strany
        mov cx, 20
        rep movsb
        
        lea si, s7
        lea di, strany
        mov cx, 20
        rep movsb
        
        lea si, s8
        lea di, strany
        mov cx, 20
        rep movsb
        
        lea si, s9
        lea di, strany
        mov cx, 20
        rep movsb
        
        lea si, s10
        lea di, strany
        mov cx, 20
        rep movsb
        
        lea si, nas1
        lea di, nasel
        mov cx, 20
        rep movsw
        
        ret
    endp

start:
    mov ax, data
    mov ds, ax
    mov es, ax
    
    xor ax,ax
    
    call menu2
        
    lea dx, text1
    mov ah, 9
    int 21h
    lea dx, new_line
    mov ah, 9
    int 21h
    lea dx, text2
    mov ah, 9
    int 21h
    lea dx, new_line
    mov ah, 9
    int 21h
    lea dx, text3
    mov ah, 9
    int 21h
    lea dx, new_line
    mov ah, 9
    int 21h
    lea dx, text4
    mov ah, 9
    int 21h
    lea dx, new_line
    mov ah, 9
    int 21h 
    
    ;mov ah, 1
    ;int 21h
    
    xor ax,ax
    
    call menu2
    xor ax,ax
    lea dx, strany
    mov ah,9
    int 21h
    
    mov ax, 4c00h
    int 21h    
ends

end start 