data segment
    temp dw 0
    tmp10 db 10
    len equ 400
    n dw 0
    ncx dw ?
    cons dw 0
    conn dw 0
    space db " $"
    msg db " sot. tys. jitelei$"
    msg21 db "Strana: $"
    msg22 db "Naselenie: $"
    new_line db 0dh, 0ah, '$'
    err db "Nedopustimoe znacenie$"
    text db "Vvedite colicestvo stran: $"
    text1 db "Vvedite 1, chtoby vvesti dannye vruchnuiu$"
    text2 db "Vvedite 2, chtoby vvesti predopredelennye dannye$"
    text3 db "Vvedite 3, chtoby otobraziti ishodnye dannye$"
    text4 db "Vvedite 4, chtoby otobraziti dannye soglasno variantu$"
    strany db len dup(?)
    naselenie dw 40 dup(?)
    s1 db "Moldova            $"
    s2 db "Ucraine            $"
    s3 db "Russia             $"
    s4 db "Belarus            $"
    s5 db "USA                $"
    s6 db "Finland            $"
    s7 db "Mexico             $"
    s8 db "France             $"
    s9 db "Germany            $"
    s10 db "Switzerland        $"
    nas1 dw 23, 377, 1438, 91, 3401, 55,1297,682,832,88
ends
stack segment
    dw 128 dup(0)
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
    lea dx, new_line
    mov ah, 9h
    int 21h
    lea dx, text
    mov ah, 9h
    int 21h
;vvod colicestva stran    
    mov ah, 01h
    int 21h
    cmp al, '1'
    je m
    sub al, 48
    xor ah,ah  
    mov cx, ax
    add n, ax
    jmp cicl1
m:  
    mov ah, 01h
    int 21h
    cmp al, 13
    je c0  
    mov cx, 10
    add n, 10
    jmp cicl1
c0:
    mov cx, 1
    add n, 1
;vvod strany
cicl1:
    mov ncx, cx
    xor ax,ax
    lea dx, new_line
    mov ah, 9
    int 21h   
    lea dx, msg21
    mov ah, 9
    int 21h
    mov di, cons
c1:
    mov ah, 01h
    int 21h
    cmp al,13
    je c2
    
    mov strany[di], al
    inc di
    jmp c1

;vvod naselenia    
c2:
    lea si, space
    lea di, strany[di]
    mov cx,  2
    rep movsb
    inc di
    mov cx, ncx
    lea dx,new_line
    mov ah, 9
    int 21h
    lea dx,msg22
    mov ah, 9
    int 21h
zanovo:
    mov ah, 01h
    int 21h
    cmp al,13
    je end1
    sub al, 48
    xor ah, ah
    xor bx, bx
    mov bx, ax
    mov ax, temp
    mul tmp10
    add ax, bx
    mov temp, ax
    jmp zanovo
end1:
    mov ax, temp
    mov si, conn
    mov naselenie [si], ax
    add si, 2
    loop cicl1

    lea dx, new_line
    mov ah, 9h
    int 21h          
    ret                 
endp

menu2 proc
    mov si, cons
    lea si, s1
    mov di, offset strany
    mov cx,  20
    rep movsb

    lea si, s2
    add di, 20
    mov cx,  20
    rep movsb

    lea si, s3
    add di, 20
    mov cx,  20
    rep movsb

    lea si, s4
    add di, 20
    mov cx,  20
    rep movsb

    lea si, s5
    add di, 20
    mov cx,  20
    rep movsb

    lea si, s6
    add di, 20
    mov cx,  20
    rep movsb

    lea si, s7
    add di, 20
    mov cx,  20
    rep movsb

    lea si, s8
    add di, 20
    mov cx,  20
    rep movsb

    lea si, s9
    add di, 20
    mov cx,  20
    rep movsb

    lea si, s10
    add di, 20
    mov cx,  20
    rep movsb
    
    mov cons, di
    
    xor si, si
    lea si, nas1
    lea di, naselenie
    mov cx, 10
    rep movsw
    mov conn, si
    
    lea dx, new_line
    mov ah, 9h
    int 21h
    ret
endp

menu3 proc
    lea dx, new_line
    mov ah, 9h
    int 21h

    xor si, si
    xor di, di
    mov cx, 10
cicl3:
    lea dx, strany[di]
    mov ah, 9
    int 21h
    mov ax, naselenie[si]
    call print_ax
    lea dx, msg
    mov ah,9
    int 21h
    lea dx, new_line
    mov ah, 9h
    int 21h
    
    add si, 2
    add di, 40
    loop cicl3

    lea dx, new_line
    mov ah, 9h
    int 21h
    ret
endp

menu4 proc
    xor si,si
    xor di,di
    lea dx, new_line
    mov ah, 9h
    int 21h

    mov cx, n
cicl4:
    cmp naselenie [si], 100
    jb show
    jnbe ccc
show:
    lea dx, strany[di]
    mov ah, 9
    int 21h
    mov ax, naselenie[si]
    call print_ax
    lea dx, msg
    mov ah,9
    int 21h
    lea dx, new_line
    mov ah, 9h
    int 21h
    add si, 2
    add di, 40
    jmp end4
    
ccc:
    add si, 2
    add di, 40
end4:
    loop cicl4
    lea dx, new_line
    mov ah, 9h
    int 21h
    ret
endp

start:
    mov ax, data
    mov ds, ax
    mov es, ax
    
    xor ax,ax
        
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
    mov ah, 1
    int 21h
    cmp al, '1'
    je m1
    cmp al, '2'
    je m2
    cmp al, '3'
    je m3
    cmp al, '4'
    je m4
    jmp error
m1:
    call menu1
    jmp start
m2:
    call menu2
    jmp start
m3:
    call menu3
    jmp start
m4:
    call menu4
    jmp start
error:
    lea dx, new_line
    mov ah, 9h
    int 21h
    lea dx, err
    mov ah, 9
    int 21h
    lea dx, new_line
    mov ah, 9h
    int 21h
ends
end start 