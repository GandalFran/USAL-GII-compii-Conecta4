;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;										;
;	LEE_COLOCA_MATRIZ.asm							;
;										;
;	Este modulo contiene el codigo para leer un valor (1-7) de teclado	;
;	comprobar si esta ocupada o llena la coluna y volver apreguntar		;
;	si es necesario.							;
;										;
;	Entrada: A(turno), X(matriz)						;
;	Salida:  No								;
;	Registros afectados: A,B,X,Y,CC						;
;	Registros afectados por subrutinas: A,X,CC				;
;										;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	
	.module lee_coloca_matriz
	teclado		.equ 0xFF02
	pantalla	.equ 0xFF00
	.globl lee_coloca_matriz

	;;Añadimos los .globl para acceder a las subrutinas necesarias
	.globl imprime_cadena
	.globl calcula_posicion

	
	;;texto a imprimir
	error_valor_incorrecto:
		.asciz"\33[33m\nError: Valor no permitido, vuelva a introducir: \33[37m"
	error_columna_llena:
		.asciz"\33[33m\nError: Columna llena, por favor, introduzca otra columna: \33[37m"
	depuracion:
		.asciz"\nFICHA COLOCADA\n"
	;;Variables
		turno:.byte 0   ;;variable con la que definiremos el turno
		pos:.word 0	;;variable para guardar la posicion
		mat:.word 0	;;direccion del primer elemento de la matriz	
		col:.byte 0	;;columna escogida por el usuario
	
	lee_coloca_matriz:
		;;primero sacamos las vairalbes de pila y las asignamos
		sta turno
		stx mat
		;;ahora haremos un bucle que compruebe que la lectura de teclado este entre 1 y 7.
		;;Lo hacemos entre 1 y 7 porque nuestra matriz en la columna 0 tiene asteriscos
		lectura_teclado:
			;;leemos de teclado 
			lda teclado
			;;restamos el caracter 0 ya que del teclado recibimos en ascii
			suba #'0 
			;;guardamos A en col
			sta col
			;;comprobamos que este en el margen
			cmpa #1
			blo error_lectura_teclado
			cmpa #7
			bhi error_lectura_teclado
			;;si lo esta nos vamos a 
			;;primero le sumamos 1 ya, que se introduce un numero del 1 al 7 
			;;y nosotros queremos desplazar el rango del 3 al 9
			;;porque una fila es "\n\t*1234567*"
			adda #2
			sta col
			;; si se cumplen las condiciones nos vamos a colocar la ficha			
			jmp colocar_ficha
			;;si ha habido error se indica y se repite la introduccion
			error_lectura_teclado:
				;;.asciz"\nError: Valor no permitido, vuelva a introducir: "
				ldx #error_valor_incorrecto
				jsr imprime_cadena
				lbra lectura_teclado

		;;ahora que hemos asegurado que el valor esta dentro del margen
		;;y comprobamos que la columna no esta llena, en cuyo caso metemos la ficha
		colocar_ficha:
			;;inicializamos x a 0 y a Y con col
			ldx #5
			pshu x
			ldb col
			clra
			tfr d,y
			
		;;Ahora vamos recorriendo la columna de abajo a arriba buscando una posicion vacia
		for_colocar_ficha:	
				;;calculamos la posicion		
				ldd mat
				jsr calcula_posicion
				std pos
				lda [pos]
				;;comparamos lo que hemos obtenido y si es espacio colocamos la ficha, si no realizamos incrementos
				cmpa #32
				beq colocarla_ya
				lbra posicion_ocupada
				jmp for_colocar_ficha
				
        		posicion_ocupada:
				;;aqui sacamos la x de la pila, la incrementamos y la volvemos a guardar en la pila
           			pulu x
            			exg d,x
            			subd #1
            			exg x,d
            			pshu x
            
				;;cargamos y con col, porque en calcula_posicion usamos este registro
            			ldb col
       	    			clra
	    			tfr d,y
				;;comparamos si x es menor que 0, en cuyo caso indicamos que la columa esta llena
	    			tfr x,d
				addd #1	;;esta comparacion la hacemos asi porque si no, no fuciona
            			cmpd #0
            			bls columna_llena
				;;en el caso de no ser la posicion de arriba nos vamos a seguir recorriendo
            			jmp for_colocar_ficha
            
            
            colocarla_ya:
		;;si llegamos aqui es porque la columna no esta llena y tenemos que meter la ficha en pos
		;;como hemos tratado el turno antes de entrar aqui, ahora es al reves, 1=J2 y 2=J1
		;;si es el turno de J1 introducimos X y si es el de J2 introducimos O
		lda turno
		cmpa #1
		beq poner_O
		lda #'X
		jmp fin_poner
		poner_O:                
			lda #'O
		fin_poner:
			sta [pos]
			jmp salir_for_colocar_ficha
                	
	salir_for_colocar_ficha:
		;;retronamos y sacamos x para vaciar la pila del todo
		pulu x
		rts
			

	;;aqui se viene solo si la columna esta llena
	columna_llena:
		;;.asciz"\nError: Columna llena, por favor, introduzca otra columna: "
		ldx #error_columna_llena
		jsr imprime_cadena
		lbra lectura_teclado

