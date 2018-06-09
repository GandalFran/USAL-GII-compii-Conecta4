;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;										;
;	CALCULA_POSICION.asm							;
;										;
;	Este modulo contiene el codigo para calcula una posicion de la matriz	;
;	Se hizo como subrutina porque era una operacion muy recurrente		;
;										;
;	Entrada: X,Y(mat[X][Y]),D(mat)						;
;	Salida:  D(posicion de mat[X][Y])					;
;	Registros afectados: D							;
;	Registros afectados por subrutinas: No					;
;										;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	
	.module calcula_posicion
	.globl calcula_posicion

	mat:.word 0 ;;variable para almacenar la posicon de la matriz 
	temp:.byte 0

	calcula_posicion:	
	;;mat[X][Y]-->mat[X*ncol + Y]--> [mat + Y + X*ncol] 
	;;(tener en cuenta que una fila es 7(X o O o espacio)+2(*)+1(\n)+1(\t) --> \n\t*       *)
		std mat
		tfr x,d
		lda #11
		mul
		stb temp	;;esto es para poder pasar el registro y al x
		tfr y,d
		addb temp
		addd mat
	;;retornamos	
	rts
