.MODEL SMALL
.STACK 100H
.DATA
    msg DB 'a'
    newline DB 0DH, 0AH, '$'   ; 换行符
.CODE
MAIN PROC
    MOV AX, @DATA      
    MOV DS, AX

    MOV CX, 26         
    MOV AL, 'a'        
    MOV BX, 0          ; 计数器，用于每行输出13个字母

output_loop:
    MOV DL, AL         
    MOV AH, 2          
    INT 21H

    INC AL             
    INC BX             

    CMP BX, 13         ; 判断是否已经输出13个字母
    JNE continue_output

    ; 输出换行符
    MOV AH, 9          
    LEA DX, newline    ; 指向换行符
    INT 21H

    MOV BX, 0          ; 重置计数器

continue_output:
    LOOP output_loop   ; 循环，直到CX为0

    ; 退出程序
    MOV AH, 4CH        
    INT 21H
MAIN ENDP
END MAIN
