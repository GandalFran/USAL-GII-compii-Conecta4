;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;										;
;	RECORRER_FILAS.asm							;
;										;
;	Este modulo contiene el codgio para recorrer el tablero por filas	;
;	e indicar si hay 4 fichas iguales seguidas.				;
;										;
;	Entrada: D(mat)								;
;	Salida:  A(Ganador--> 1=J1, 2=J2, 3=Nadie)				;
;	Registros afectados: A,D,X,Y,CC						;
;	Registros afectados por subrutinas: D,X,Y				;
;										;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


	.module recorrer_filas
	.globl recorrer_filas

	;;añadimos los .globl
	.globl calcula_posicion

	;Variables
	mat:.word 0 ;direccion del primer elemento de la matriz
	pos:.word 0 ;variable a utilizar para alamcenar la direccion de un elemento mat
	
	kX:.byte 0 ;contadores de las fichas que van seguidas
	kO:.byte 0
	
	
	recorrer_filas:
		;;almacenamos la matriz en mat		
		std mat
		;;ahora hacemos dos bucles for para recorrer la matriz por filas
		;;inciamos las variables para el bucle externo
		ldx #0
		for_filas_rec_fil:
			;;realizamos la comparacion
			cmpx #6
			bhs fin_for_filas_rec_fil
				;;ahora iniciamos las variables para el bucle for interno
				ldy #3
				clr kX
				clr kO
			for_columnas_rec_fil:
				;;realizamos la comparacion
				cmpy #10
				bhs fin_for_columnas_rec_fil
				;;cargamos los registros con las entradas y calculamos la posicion
				ldd mat
				pshu x,y
				jsr calcula_posicion
				pulu x,y
				;;cargamos D con el retorno
				std pos
				lda [pos]
				;;ahora segun lo que haya actuamos
					cmpa #32 ;;espacio en ASCII
					bne X_fil
						;;si hay espacio ponemos a 0 los dos contadores
						clr kX
						clr kO
					lbra seguir_comparar_fil
					X_fil:
						cmpa #'X
						bne O_fil
						;;si hay X incrementamos el contador de X y ponemos a 0 el de O
						inc kX
						clr kO
					lbra seguir_comparar_fil
					O_fil:
						;;si hay O incrementamos el contador de O y ponemos a 0 el de X
						inc kO
						clr kX
				seguir_comparar_fil:
				;;ahora comprobamos si hay algun contador a 4 para decir que hay ganador
				lda kX
				cmpa #4
				bhs filas_ganado_J1
				lda kO
				cmpa #4
				bhs filas_ganado_J2
				;;por ultimo realizamos los incrementos del bucle interno
				exg y,d
				addd #1
				exg y,d
				lbra for_columnas_rec_fil
			fin_for_columnas_rec_fil:
			;;realizamos los incrementos del bucle externo
			exg x,d
			addd #1
			exg x,d
			lbra for_filas_rec_fil
		fin_for_filas_rec_fil:
		;;si se llega aqui y no se ha saltado a algun ganador, se va a ganado_nadie
		lbra filas_ganado_nadie

	;;asignamos quien ha ganado
	filas_ganado_J1:
		lda #1
		bra filas_salir
	filas_ganado_J2:
		lda #2
		bra filas_salir
	filas_ganado_nadie:
		lda #3
	filas_salir:	
		;;se retorna 
		rts
