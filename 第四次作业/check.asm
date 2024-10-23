.MODEL SMALL
.STACK 100h

.DATA
    ; 定义9x9乘法表，table存储每个乘法的结果
    table db 7,2,3,4,5,6,7,8,9
          db 2,4,7,8,10,12,14,16,18
          db 3,6,9,12,15,18,21,24,27
          db 4,8,12,16,7,24,28,32,36
          db 5,10,15,20,25,30,35,40,45
          db 6,12,18,24,30,7,42,48,54
          db 7,14,21,28,35,42,49,56,63
          db 8,16,24,32,40,48,56,7,72
          db 9,18,27,36,45,54,63,72,81

    info  db "x  y", 0DH, 0AH, '$'    ; 信息提示输出
    space db "  ", '$'                ; 空格用于格式化
    err   db "  error", 0DH, 0AH, '$' ; 错误提示
    endl  db 0DH, 0AH, '$'            ; 换行符

.CODE
START:
    MOV    AX, @DATA
    MOV    DS, AX

    ; 输出表头信息 "x  y"
    LEA    DX, info
    MOV    AH, 09H
    INT    21H

    MOV    CX, 9            ; 外循环，控制乘数 (x)
    MOV    AX, 1            ; 初始乘数为1
    MOV    SI, 0            ; SI为索引，遍历table数组

A_LOOP:
    PUSH   CX               ; 保存外循环计数器
    PUSH   AX               ; 保存当前乘数

    MOV    BX, 1            ; 被乘数从1开始 (y)
    MOV    CX, 9            ; 内循环，控制被乘数 (y)

B_LOOP:
    XOR    DX, DX           ; 清空DX，用于存储结果
    MOV    DL, table[SI]    ; 从table中读取当前乘法表中的结果
    MUL    BL               ; AX = 乘数 * 被乘数
    CMP    AX, DX           ; 比较计算结果与预存的乘法表结果
    JNE    OUTPUT_ERR       ; 如果不相等，跳转到错误输出

    ; 如果结果正确，继续执行
    JMP    CONTINUE

OUTPUT_ERR:
    ; 输出错误信息
    POP    DX               ; 恢复被乘数 (y)
    PUSH   DX               ; 再次保存被乘数
    MOV    AL, DL           ; 将错误结果存入AL
    ADD    AL, 30H          ; 转换为ASCII码
    MOV    AH, 02H
    MOV    DL, AL           ; DL = 错误的乘积
    INT    21H

    ; 输出空格
    LEA    DX, space
    MOV    AH, 09H
    INT    21H

    ; 输出被乘数
    MOV    AL, BL
    ADD    AL, 30H          ; 转换为ASCII码
    MOV    DL, AL
    MOV    AH, 02H
    INT    21H

    ; 输出 "error" 提示
    LEA    DX, err
    MOV    AH, 09H
    INT    21H

CONTINUE:
    POP    AX               ; 恢复乘数 (x)
    PUSH   AX               ; 再次保存乘数
    INC    BX               ; 被乘数加1
    INC    SI               ; 移动到table中的下一个位置
    LOOP   B_LOOP           ; 内循环继续

    POP    AX               ; 恢复外循环中的乘数
    INC    AX               ; 乘数加1
    POP    CX               ; 恢复外循环计数器
    LOOP   A_LOOP           ; 外循环继续

    MOV    AH, 4CH          ; 正常退出程序
    INT    21H

END START
