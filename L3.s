		;		Programa L3.as
		
		;		ZONA I: Definicao de variáveis
varX		DCD		3
varY		DCD		9
res		FILL		4
		
		;		ZONA II: Código
		
		;		Programa Principal: programa que recebe dois números inteiros positivos, x e y, em varX e varY,
		;		respetivamente. Retorna o valor de x^y.
		ADR		R1, varX
		LDR		R1, [R1]
		ADR		R2, varY
		LDR		R2, [R2]
		
		SUB		SP, SP, #8         ;;mete x y na pilha
		STR		R1, [SP, #4]
		STR		R2, [SP, #0]
		
		BL		Pow
		
		LDR		R0, [SP, #0]
		ADR		R3 ,res
		STR		R0,[R3]
		END
		
		;		Pow: Rotina que efectua o calculo de x^y, sendo x e y dois numeros inteiros positivos.
		;		Entradas: R1, R2 - x e y, respetivamente
		;		Saidas: R1 - resultado
		;		Efeitos: ---
		
		
		
		
Pow		SUB		SP, SP, #16    			;;contexto
		STR		LR, [SP, #12]
		STR		R3, [SP, #8]
		STR		R2, [SP, #4]
		STR		R1, [SP, #0]
		
		LDR		R1, [SP, #20]            ;; r1=x r2=y
		LDR		R2, [SP, #16]
		
		
		MOV		R3,#1
		CMP		R2,#0
		BEQ		fimpow			;;y=1, pow x,y = x
		
		
		LSR		R3,R2,#1 		;; r3 = h
		SUB		SP, SP, #8         ;;mete x e h na pilha
		STR		R1, [SP, #4]
		STR		R3, [SP, #0]
		BL		Pow
		LDR		R3,[SP,#0]      ;;pop resultado
		ADD		SP,SP,#4
		
		
		
		SUB		SP,SP,#8
		STR		R3,[SP,#4]				;;pow^2
		STR		R3,[SP,#0]
		BL		Mult
		
		LDR		R3,[SP,#0]				 ;;pop resultado  r3 = pow^2
		ADD		SP,SP,#4
		
		AND		R0, R2, #1     ;; se y par r0 = 0, senao y impar
		CMP		R0,#0
		BEQ		fimpow
		
		SUB		SP,SP,#8
		STR		R1,[SP,#4]
		STR		R3,[SP,#0]
		BL		Mult
		
		LDR		R3,[SP,#0]				 ;;pop resultado  r3 = x * pow^2
		ADD		SP,SP,#4
		
		
fimpow	MOV		R1,R3
		STR		R1, [SP, #20]      ;;resultado na pilha
		LDR		R1, [SP, #0]
		LDR		R2, [SP, #4]         ;; pops
		LDR		R3, [SP, #8]
		LDR		LR, [SP, #12]
		ADD		SP, SP, #20
		
		MOV		PC, LR
		
		
		;		Mult: Rotina que efectua o cálculo de a*B, sendo a e b números inteiro positivos, dados como parâmetros de entrada
		;		Entradas: [SP], [SP, #4] - numeros a processar
		;		Saidas: [SP] - resultado
		;		Efeitos: ---
		
		
		
		
		
Mult		SUB		SP, SP, #12
		STR		R0, [SP, #8]
		STR		R1, [SP, #4]
		STR		R2, [SP, #0]
		
		LDR		R2, [SP, #16]
		LDR		R1, [SP, #12]
		MOV		R0, #0
		
		CMP		R1, R0
		BEQ		OutMul
		CMP		R2, R0
		BEQ		OutMul
MulLoop	ADD		R0, R0, R1
		SUBS		R2, R2, #1
		BNE		MulLoop
OutMul	STR		R0, [SP, #16]
		LDR		R2, [SP, #0]
		LDR		R1, [SP, #4]
		LDR		R0, [SP, #8]
		ADD		SP, SP, #16
		MOV		PC, LR
