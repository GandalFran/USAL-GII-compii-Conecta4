;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;										;
;	COMPROBAR_GANADORES.asm							;
;										;
;	Este modulo contiente el codigo para saber quien ha gando e		;
;	indicarlo por pantalla							;
;										;
;	Entrada: A(ganador)							;
;	Salida:  No								;
;	Registros afectados: A,CC						;
;	Registros afectados por subrutinas: X,A,CC				;
;										;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	
	.module comprobar_ganadores
	.globl comprobar_ganadores

	;;Texto a imprimir
	ganadores_empate:
		.asciz "\33[35m \n¡Empate!, tablero lleno\n\33[37m"
	ganadores_J1:
		.asciz "\33[35m \n Felicidades ¡J1(\33[31mX\33[35m) ha ganado!\n\33[37m"
	ganadores_J2:
		.asciz "\33[35m \n Felicidades ¡J2(\33[32mO\33[35m) ha ganado!\n\33[37m"
	
	;;programa
	comprobar_ganadores:
		;;Añadimos los .globl para acceder a las subrutinas necesarias
		.globl imprime_cadena
		;;comparamos A (ganadores), y si A=0 empate, si A=1 gana J1 y si A=2 gana J2
			cmpa #0
			bne ganadores_case_J1
			;;.asciz "\33[35m\n¡Empate!, tablero lleno\n\33[37m"
			ldx #ganadores_empate
			jsr imprime_cadena
			lbra ganadores_seguir
		ganadores_case_J1:
			cmpa #1
			bne ganadores_case_J2
			;;.asciz "\33[35m\n Felicidades ¡J1(\33[31mX\33[37m) ha ganado!\n\33[37m"
			ldx #ganadores_J1
			jsr imprime_cadena
			bra ganadores_seguir
		ganadores_case_J2:
			cmpa #2		;;comparamos por si no es 0,1 o 2
			bne ganadores_seguir
			;;.asciz "\33[35m\n Felicidades ¡J2(\33[32mO\33[37m) ha ganado!\n\33[37m"
			ldx #ganadores_J2
			jsr imprime_cadena
		ganadores_seguir:
		
		;;se retorna 
		rts
