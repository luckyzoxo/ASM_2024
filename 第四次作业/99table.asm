.MODEL SMALL
.STACK 100h

.DATA
    OUTPUT_TEMPLATE DB 00H, '*', 00H, '=', 2 DUP(2), '  ', '$' ; 用于输出格式
    NEWLINE DB 0DH, 0AH, '$'     ; 换行符号
    TEMP_REG DW 0000H            ; 用于保存IP寄存器中的数据

.CODE
START:
    MOV AX, @DATA
    MOV DS, AX
    MOV CX, 9                    ; 设置CX寄存器为9（外循环次数）

; 外循环（遍历乘数从9到1）
LOOP1:
    MOV DH, 0AH                   ; DH = 10 (用于将乘数从9倒数到1)
    SUB DH, CL                    ; 将CL寄存器的值从DH中减去，得到乘数（从9开始）
    MOV DL, 01H                   ; 设置DL为1（被乘数起始值）
    MOV AL, DH                    ; 将当前乘数放入AL寄存器
    AND AX, 00FFH                 ; 保留AX的低8位

; 内循环（遍历被乘数从1到乘数）
LOOP2:
    CMP DL, DH                    ; 比较被乘数（DL）和乘数（DH），如果DL > DH，跳转到NEXT
    JA NEXT
    PUSH DX                       ; 保存被乘数和乘数寄存器
    PUSH CX                       ; 保存外层循环计数器
    PUSH AX                       ; 保存乘数
    PUSH DX                       ; 再次保存被乘数和乘数
    MOV AL, DH                    ; 将乘数存入AL
    MUL DL                        ; 执行 AL = 乘数 * 被乘数
    PUSH AX                       ; 保存乘积结果
    CALL PRINT_LINE               ; 调用打印函数，输出乘法结果
    POP CX                        ; 恢复外层循环计数器
    POP DX                        ; 恢复被乘数和乘数寄存器
    INC DL                        ; 被乘数加1
    JMP LOOP2                     ; 返回内循环继续

; 外层循环，输出换行符号
NEXT:
    MOV DX, OFFSET NEWLINE        ; 输出换行
    MOV AH, 09H
    INT 21H
    LOOP LOOP1                    ; 循环，直到CX=0
    MOV AH, 4CH                   ; 正常退出程序
    INT 21H

; 输出乘法结果的子程序
PRINT_LINE PROC
    POP TEMP_REG                  ; 从堆栈中恢复保存的IP寄存器
    POP DX                        ; 恢复被乘数和乘数
    MOV AX, DX                    ; AX = DX (AX现在保存的是乘数和被乘数)
    MOV BL, 0AH                   ; 设置BL为10，用于除法操作
    DIV BL                        ; 除以10，得到十位数和个位数

    CMP AL, 0                     ; 检查商是否为0（即是否有十位数）
    JZ SKIP_TENS                  ; 如果没有十位数，跳过存储

    ADD AL, 30H                   ; 转换十位数为ASCII码
    MOV OUTPUT_TEMPLATE+4, AL      ; 存储到OUTPUT_TEMPLATE的相应位置
    JMP STORE_ONES                ; 跳到存储个位数

SKIP_TENS:
    MOV OUTPUT_TEMPLATE+4, ' '    ; 没有十位数，填充空格

STORE_ONES:
    ADD AH, 30H                   ; 转换个位数为ASCII码
    MOV OUTPUT_TEMPLATE+5, AH     ; 存储个位数

    POP AX                        ; 恢复之前保存的乘积
    AND AL, 0FH                   ; 获取乘积的个位数
    ADD AL, 30H                   ; 转换为ASCII码
    MOV OUTPUT_TEMPLATE+2, AL     ; 存储到OUTPUT_TEMPLATE的相应位置

    POP AX                        ; 恢复被乘数
    AND AL, 0FH                   ; 获取被乘数的个位数
    ADD AL, 30H                   ; 转换为ASCII码
    MOV OUTPUT_TEMPLATE, AL       ; 存储被乘数到OUTPUT_TEMPLATE

    MOV DX, OFFSET OUTPUT_TEMPLATE ; 设置DX指向输出模板
    MOV AH, 09H
    INT 21H                       ; 执行字符串输出

    PUSH TEMP_REG                 ; 恢复IP寄存器的值
    RET                           ; 返回

PRINT_LINE ENDP

END START
