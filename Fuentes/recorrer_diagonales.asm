;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;										;
;	RECORRER_DIAGONALES.asm							;
;										;
;	Este modulo contiene el codgio para recorrer el tablero por diagonales	;
;	e indicar si hay 4 fichas iguales seguidas.				;
;										;
;	Entrada: D(mat)								;
;	Salida:  A(Ganador--> 1=J1, 2=J2, 3=Nadie)				;
;	Registros afectados: A,D,X,Y,CC						;
;	Registros afectados por subrutinas: D,X,Y				;
;										;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


	.module recorrer_diagonales
	.globl recorrer_diagonales

	;;Añadimos los .globl para acceder a las subrutinas necesarias
	.globl calcula_posicion
	
	;;Variables
	mat:.word 0	;;direccion del primer elemento de la matriz
	pos:.word 0	;;variable temporal para almacenar la direccion de un elemento de mat

	kX:.byte 0	;;contadores de las fichas que van seguidas
	kO:.byte 0

	M:.byte 0	;;variables para controlar el recorrido de las diagonales
	N:.byte 0
	cont:.byte 0
	

	;;primero recorremos las diagonales (rojas) 
	;;   *
	;;    *
	;;     *
	recorrer_diagonales:
		;;almacenamos la matriz en mat		
		std mat
		;;ahora comenzamos el bucle para recorrer las diagonales de 00 a nn (las rojas de nuestro esquema)
		;;inicializamos algunas variables que necesitamos
		clr cont
		lda #2
		sta M
		lda #0
		sta N
		;;ahora comenzamos el bucle		
		while_1_diagonales:
			;;evaluamos la condicion--> cont<6 porque es el numero de diagonales
			lda cont
			cmpa #6
			lbhi seguir_while_1_diagonales
				;;ahora recorremos la diagonal con un  for y buscamos si hay 4 fichas seguidas
				;;inicializamos los indices
				ldx M
				ldy N
				;;sumamos 2 a y para saltarnos \n y *
				exg y,d
				addd #3
				exg y,d
				;;comenzamos el bucle
				for_diagonales_1:
					;;primero ponemos a 0 los contadores de X y O
					clr kX
					clr kO
					;;comparamos con 6 porque hay 6 filas
					cmpx #6
					bhs fin_for_diagonales_1
					;;ponemos los registros para llamar a calcular posicion
					ldd mat
					pshu x,y
					jsr calcula_posicion
					pulu x,y
					;;ahora la posicion esta en D, pero nosotros cargaremos lo que hay en esa posicion
					std pos
					ldd [pos]
					;;ahora segun lo que haya actuamos
						cmpd #32 ;;espacio en ASCII
						bne x_diag_1
							;;si hay espacio ponemos a 0 los dos contadores
							clr kX
							clr kO
						lbra seguir_comparar_diag_1
					x_diag_1:
						cmpd #'X
						bne o_diag_1
							;;si hay X incrementamos el contador de X y ponemos a 0 el de O
							inc kX
							clr kO
						lbra seguir_comparar_diag_1
					o_diag_1:
							;;si hay O incrementamos el contador de O y ponemos a 0 el de X
							inc kO
							clr kX
					seguir_comparar_diag_1:
					;;ahora comprobamos si hay algun contador a 4 para decir que hay ganador
					lda kX
					cmpa #4
					lbhs diagonales_ganado_J1
					clra
					lda kO
					cmpa #4
					lbhs diagonales_ganado_J2
					;;incrementamos los dos indices y volvemos al principio del bucle for (bucle interno)
					exg x,d
					addd #1 
					exg x,d
					exg y,d
					addd #1
					exg y,d
					lbra for_diagonales_1
				fin_for_diagonales_1:
			;;incrementamos las varibles (los incrementos estan sujetos a condiciones) y volvemos al principio del bucle while
			;;cont
			inc cont
			;;M
			lda M
			cmpa #0
			bls seguir_decrementoM_1
				dec M
			seguir_decrementoM_1:			
			;;N
			lda cont
			cmpa #3
			blo seguir_incremento_N_1
				inc N
			seguir_incremento_N_1:
			lbra while_1_diagonales
		seguir_while_1_diagonales:
			

		;;ahora recorremos las diagonales
		;;     *	
		;;    *	
		;;   *	

		;;ahora hacemos el MISMO PROCESO pero con las diagonales en sentido opuesto (coloreadas de AZUL en nuestro esquema)
		;;inicializamos algunas variables que necesitamos
		clra
		sta cont
		lda #3
		sta M
		lda #0
		sta N
		;;ahora comenzamos el bucle		
		while_2_diagonales:
			;;evaluamos la condicion--> cont<6 porque es el numero de diagonales
			lda cont
			cmpa #6
			lbhi seguir_while_2_diagonales
				;;ahora recorremos la diagonal con un  for y buscamos si hay 4 fichas seguidas
				;;inicializamos los indices
				ldx M
				ldy N
				;;incrementamos y en dos porque se va desde 2 hasta 9
				exg y,d
				addd #3
				exg y,d
				;;comenzamos el bucle
				for_diagonales_2:
					;;primero ponemos a 0 los contadores de X y O
					clr kX
					clr kO
					;;comparamos con 6 porque hay 6 filas
					cmpx #6
					lbhs fin_for_diagonales_2
					;;ponemos los registros para llamar a calcular posicion
					ldd mat
					pshu x,y
					jsr calcula_posicion
					pulu x,y
					;;ahora la posicion esta en D, pero nosotros cargaremos lo que hay en esa posicion
					std pos
					ldd [pos]
					;;ahora segun lo que haya actuamos
						cmpd #32 ;;espacio en ASCII
						bne x_diag_2
							;;si hay espacio ponemos a 0 los dos contadores
							clr kX
							clr kO
						lbra seguir_comparar_diag_2
					x_diag_2:
						cmpd #'X
						bne O_diag_2
							;;si hay X incrementamos el contador de X y ponemos a 0 el de O
							inc kX
							clr kO		
						lbra seguir_comparar_diag_2
					O_diag_2:
							;;si hay O incrementamos el contador de O y ponemos a 0 el de X
							inc kO
							clr kX
					seguir_comparar_diag_2:
					;;ahora comprobamos si hay algun contador a 4 para decir que hay ganador
					lda kX
					cmpa #4
					bhs diagonales_ganado_J1
					lda kO
					cmpa #4
					bhs diagonales_ganado_J2
					;;incrementamos los dos indices y volvemos al principio del bucle for (bucle interno)
					exg x,d
					subd #1
					exg x,d
					exg y,d
					addd #1
					exg y,d
					lbra for_diagonales_2
				fin_for_diagonales_2:
			;;incrementamos las varibles (los incrementos estan sujetos a condiciones) y volvemos al principio del bucle while
			;;cont
			inc cont
			;;M
			lda M
			cmpa #5
			bhs seguir_incrementoM_2
				inc M
			seguir_incrementoM_2:			
			;;N
			lda cont
			cmpa #3
			blo seguir_incremento_N_2
				inc N
			seguir_incremento_N_2:
			lbra while_2_diagonales
		seguir_while_2_diagonales:


	
		;;por ultimo si no ha ganado nadie, indicamos que no hay ganadores en este recorrido
		lbra diagonales_ganado_nadie


	;;asignamos quien ha ganado
	diagonales_ganado_J1:
		lda #1
		bra diagonales_salir
	diagonales_ganado_J2:
		lda #2
		bra diagonales_salir
	diagonales_ganado_nadie:
		lda #3
	diagonales_salir:	
		;;se retorna 
		rts
