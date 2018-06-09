;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;										;
;	IMPRIMIR_TURNO.asm							;
;										;
;	Este modulo contiene el codigo para indicar de que jugador es el turno	;
;										;
;	Entrada: A(turno)							;
;	Salida:  A(turno)							;
;	Registros afectados: A,CC						;
;	Registros afectados por subrutinas: A,X,CC				;
;										;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	
	.module imprimir_turno
	.globl imprime_turno

	;;Añadimos los .globl para acceder a las subrutinas necesarias
	.globl imprime_cadena
	
	;;Variables
	turno:.byte 0	

	;;Texto a imprimir:
	turno_J1:
		.asciz"\n\33[35mJUGADOR1 (\33[31mX\33[35m):\33[37m "
	turno_J2:
		.asciz"\n\33[35mJUGADOR2 (\33[32mO\33[35m):\33[37m "

	;;Programa:
	imprime_turno:
		sta turno
		;;comparamos A: (porque ahi esta almacenado turno)
		cmpa #1
		bne turno_jugador_2
			;;.asciz"\n\33[35mJUGADOR1 (\33[31mX\33[35m):\33[37m "
			ldx #turno_J1
			jsr imprime_cadena
			;;incrementamos a para que turno=2
			inc turno		
			lda turno
			;;salimos
			bra seguir_imprimir_turno
		turno_jugador_2:
			;;.asciz"\n\33[35mJUGADOR2 (\33[32mO\33[35m):\33[37m "
			ldx #turno_J2
			jsr imprime_cadena
			;;decrementamos a para que turno=1
			dec turno		
			lda turno
		seguir_imprimir_turno:
			;;finalizamos
			rts	

