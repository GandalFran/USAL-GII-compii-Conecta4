;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;										;
;	IMPRIME_COLOR.asm							;
;										;
;	Este modulo contiene el codigo para imprimir en color las fichas y	;
;	los asteriscos.								;
;										;
;	Entrada: X (matriz)							;
;	Salida:  No								;
;	Registros afectados: A,D,X,Y,CC						;
;	Registros afectados por subrutinas: X,Y,D				;
;										;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	
	.module imprime_tablero
	pantalla	.equ 0xFF00
	.globl imprime_tablero

	;;Añadimos los .globl para acceder a las subrutinas necesarias
	.globl imprime_cadena
	
	;;texto a imprimir
		X_imprimir:
			.asciz"\33[31mX\33[37m"
		O_imprimir:
			.asciz"\33[32mO\33[37m"
		asterisco_imprimir:
			.asciz"\33[36m*\33[37m"
			
	;;variables
	cont:.word 0

	;;recorremos el tablero y segun el caracter usamos un color u otro
	imprime_tablero:
		;;inicializamos a 0 cont, b y guardamos x en la pila porque luego
		;; solo sacamos x para incrementar y cargar el valor de [x] en a
		clrb
		clr cont
		pshu x
	bucle:	
		;;comparamos con 89 porque hay 89 elementos
		cmpb #89
		bhi salir
		
		;;cargamos en a el contenido de x (la matriz recorrida secuencialemente)
		;; y lo guardamos en la pila porque imprimir los caracteres 
		;; del teclado nos pisa el valor de este
		pulu x
		lda ,x+
		pshu x
		;;imprimirmos el caracter que esta en a en color
		bra color_selection
		seguir_seleccion_color:
		
		;;incrementamos el contador y lo colocamos en b para que se realize la 	
		;; comparacion en la siguiente iteracion
		inc cont
		ldb cont
	
		bra bucle	

	salir:
		pulu x
		;;tras imprimir el tablero volvemos al modulo principal
		rts


		color_selection:
		case_X_it:
			;;comparamos y si es X lo imprimimos en rojo
			cmpa #'X
			bne case_O_it
			;;.asciz"\33[31mX\33[37m"
			ldx #X_imprimir
			jsr imprime_cadena
			bra seguir_seleccion_color
		case_O_it:
			;;comparamos si es O y lo imprimimos en verde
			cmpa #'O
			bne case_asterisco_it
			;;.asciz"\33[32mO\33[37m"
			ldx #O_imprimir
			jsr imprime_cadena
			bra seguir_seleccion_color
		case_asterisco_it:
			;;comparamos si es * y lo imprimimos en cyan
			cmpa #'*
			bne case_default_it
			;;.asciz"\33[36m*\33[37m"
			ldx #asterisco_imprimir
			jsr imprime_cadena
			bra seguir_seleccion_color
		case_default_it:
			;;en caso de que no sea ninguno, simplemente lo imprimimos
			
			sta pantalla
			bra seguir_seleccion_color

