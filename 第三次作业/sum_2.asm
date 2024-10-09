STKSEG SEGMENT STACK
DW 32 DUP(0)
STKSEG ENDS

DATASEG SEGMENT
    RESULT DW 0
DATASEG ENDS

CODESEG SEGMENT
    ASSUME DS:DATASEG, CS:CODESEG

MAIN PROC FAR
    MOV AX, DATASEG
    MOV DS, AX

    MOV CX, 100

L:
    ADD RESULT, CX
    LOOP L

    MOV AX, RESULT
    CALL PRINT_RESULT      ; 调用打印函数

    MOV AX, 4C00H
    INT 21H

MAIN ENDP

PRINT_RESULT PROC
    MOV BX, 10
    MOV SI, 0

CONVERT_LOOP:
    XOR DX, DX
    DIV BX
    ADD DL, '0'
    PUSH DX
    INC SI
    CMP AX, 0
    JNZ CONVERT_LOOP

PRINT_DIGITS:
    POP DX
    MOV AH, 02H
    INT 21H
    DEC SI
    JNZ PRINT_DIGITS
    RET
    
PRINT_RESUlT ENDP

CODESEG ENDS    

    END MAIN