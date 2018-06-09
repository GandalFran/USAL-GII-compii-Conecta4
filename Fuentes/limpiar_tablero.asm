;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;										;
;	LIMPIAR_TABLERO.asm							;
;										;
;	Este modulo contiene el codigo para limpiar el tablero para otra	;
;	partida.								;
;										;
;	Entrada: D (mat)							;
;	Salida:  No								;
;	Registros afectados: A,D,X,Y,CC						;
;	Registros afectados por subrutinas: X,Y,D				;
;										;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;	

	.module limpieza_tablero
	.globl limpiar_tablero

	;;Añadimos los .globl para acceder a las subrutinas necesarias
	.globl calcula_posicion

	;Variables
	mat:.word 0 ;direccion del primer elemento de la matriz
	pos:.word 0 ;variable a utilizar para alamcenar la direccion de un elemento mat


	limpiar_tablero:
	recorrer_filas:
		;;almacenamos la matriz en mat		
		std mat
		;;ahora hacemos dos bucles for para recorrer la matriz por filas
		;;inciamos las variables para el bucle externo
		ldx #0
		for_filas_lt:
			;;realizamos la comparacion
			cmpx #6
			bhs fin_for_filas_lt
				;;ahora iniciamos las variables para el bucle for interno
				ldy #3
			for_columnas_lt:
				;;realizamos la comparacion
				cmpy #10
				bhs fin_for_columnas_lt
				;;cargamos los registros con las entradas y calculamos la posicion
				ldd mat
				pshu x,y
				jsr calcula_posicion
				pulu x,y
				;;cargamos D con el retorno
				std pos
				;;cargamos el espacio y limpiamos
				lda #32
				sta [pos]
				;;por ultimo realizamos los incrementos del bucle interno
				exg y,d
				addd #1
				exg y,d
				lbra for_columnas_lt
			fin_for_columnas_lt:
			;;realizamos los incrementos del bucle externo
			exg x,d
			addd #1
			exg x,d
			lbra for_filas_lt
		fin_for_filas_lt:
		;;retornamos
		rts
			 

	
	
