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
    MOV BX, 0          

output_with_jump:
    MOV DL, AL         
    MOV AH, 2          
    INT 21H

    INC AL             ; 处理下一个字母
    INC BX             ; 计数加1

    CMP BX, 13         ; 判断是否到达13个字母
    JNE no_newline

    ; 输出换行符
    MOV AH, 9          
    LEA DX, newline    
    INT 21H
    MOV BX, 0          

no_newline:
    DEC CX             
    JNZ output_with_jump  ; 如果CX不为0，则继续循环

    ; 退出程序
    MOV AH, 4CH        
    INT 21H
MAIN ENDP
END MAIN
