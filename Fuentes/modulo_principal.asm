;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;										;
;				MODULO_PRINCIPAL.asm				;
;										;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
		

	.module modulo_principal
        ;Constantes
	fin      .equ 0xFF01
	pantalla .equ 0xFF00
	teclado  .equ 0xFF02
	pilaU	 .equ 0xF000
	pilaS	 .equ 0xE000
	.globl programa
	
	;;Añadimos los .globl para acceder a las subrutinas necesarias
	.globl imprime_cadena
	.globl instrucciones
	.globl imprime_turno
	.globl lee_coloca_matriz
	.globl buscar_4_fichas_seguidas
	.globl comprobar_ganadores
	.globl limpiar_tablero
	.globl imprime_turno
	.globl imprime_tablero

	;;Texto a imprimir:
		limpiar_pantalla:
			.asciz "\33[2J"
		titulo:	
			.ascii "\33[36m\n"
			.ascii "   ___                 _          _ _  \n"
			.ascii "  / __|___ _ _  ___ __| |_ __ _  | | | \n"
			.ascii " | (__/ _ \ ' \/ -_) _|  _/ _` | |_  _|\n"
			.asciz "  \___\___/_||_\___\__|\__\__,_|   |_| \n\n\33[37m"

		menu_imprimir:
			.ascii"\n\t1)Instrucciones"
			.ascii"\n\t2)Jugar"
			.ascii"\n\t3)Salir"
			.asciz"\n\nSeleccione: "
	
		menu_seleccion_imprimir:
			.asciz"\nSeleccione opcion:  "

		error_menu_seleccion_imprimir:
			.asciz"\33[33m\nError:Valor no permitido\33[37m"

		instrucciones_imprimir:
			.ascii "\n\n\nINSTRUCCIONES:\n"
			.ascii "\t Es un juego de 2 jugadores por turnos en el cual 	\n"
			.ascii "\t se introduce una ficha por jugador y turno en una	\n"
			.ascii "\t de las 7 posiciones que tiene el tablero.    	\n"
			.ascii "\t El objetivo es conseguir 4 fichas juntas (en fila	\n"
			.ascii "\t columna o diagonal), a la vez que impides a tu   	\n"
			.asciz "\t oponente conseguir el mismo objetivo.            	\n"

		pausa:
			.asciz "\nPulse culquier tecla para continuar..."

	;;Variables
		turno:.byte 0  	 	;;variable con la que definiremos el turno
		ganador:.byte 3 	;;variable en la que almacenaremos quien ha ganado (0=empate | 1=J1 | 2=J2)
		cont:.byte 0		;;contador para saber en que turno estamos
		mat:			;;matriz			
		.ascii"\n\t*       *"
		.ascii"\n\t*       *"
		.ascii"\n\t*       *"
		.ascii"\n\t*       *"
		.ascii"\n\t*       *"	
		.ascii"\n\t*       *"
		.ascii"\n\t*********"
		.asciz"\n\t*1234567*\n"


	programa:	;;comienzo del programa
		;;cargamos la pila con una direccion segura
		ldu #pilaU
		lds #pilaS
		;;Se imprime el menu, se controla que sea un valor correcto y se actua en consecuencia
		
	menu_seleccion:
		ldx #limpiar_pantalla
		jsr imprime_cadena
		ldx #titulo
		jsr imprime_cadena
		ldx #mat
		jsr imprime_tablero
		;;.asciz"\nSeleccione opcion:  "
		ldx #menu_imprimir
		jsr imprime_cadena
		
		lda teclado		;;cargamos el valor de teclado
		suba #'0

		cmpa #1			;;si el valor es 1, mostramos las instrucciones
		beq instrucciones
		cmpa #2			;;si el valor es 2, se comienza una partida
		beq iniciar_partida		
		cmpa #3			;;si el valor es 3, se sale	
		lbeq acabar


		error_menu_selection:
		;;.asciz"\nError:Valor no permitido\n"
		ldx #error_menu_seleccion_imprimir
		jsr imprime_cadena
		ldx #pausa
		jsr imprime_cadena
		lda teclado

		bra menu_seleccion		;;si no es ninguno de los anteriores se repite la introduccion


;;;;;;;;;;;;;;;;;;;;;;;;;;;
;	INSTRUCCIONES
;;;;;;;;;;;;;;;;;;;;;;;;;;;
	instrucciones:
		ldx #limpiar_pantalla
		jsr imprime_cadena
		ldx #titulo
		jsr imprime_cadena
		ldx #instrucciones_imprimir
		jsr imprime_cadena
		ldx #pausa
		jsr imprime_cadena
		lda teclado   ;;lo uso como system pause
		bra menu_seleccion

;;;;;;;;;;;;;;;;;;;;;;;;;;;
;	NUEVA PARTIDA
;;;;;;;;;;;;;;;;;;;;;;;;;;;
	;;inicia las variables y el tablero para comenzar una partida
	iniciar_partida:
		ldd #mat
		jsr limpiar_tablero 
		clra 
		sta cont
		lda #1
		sta turno
		lda #3
		sta ganador
	;;comenzamos una nueva partida
	nueva_partida:
		;;cadena para limpiar pantalla y titulo
			ldx #limpiar_pantalla
			jsr imprime_cadena
			ldx #titulo
			jsr imprime_cadena
		;;Imprimimos el tablero
			ldx #mat
			jsr imprime_tablero
		;;Indicamos el turno
			;;cargamos A con la variable turno y llamamos a la subrutina
			lda turno
			jsr imprime_turno
			;;volvemos a cargar la variable turno con el retorno (almacenado en A)
			sta turno
		;;Leemos de teclado, vemos si es correcto y colocarlo en la matriz
			;;pasamos en el registro A turno, y la matriz por X
			lda turno
			ldx #mat
			jsr lee_coloca_matriz
		;;Comprobamos si hay ganadores			
			;;buscamos 4 fichas seguidasm y si las hay devolvemos quien ha ganado por el registro A
			ldd #mat
			jsr buscar_4_fichas_seguidas
			sta ganador
			;;si hay un ganador lo indicamos por pantalla
			jsr comprobar_ganadores
			;;en el caso de que haya ganador se sale
			lda ganador
			cmpa #3	;;valor inicial que se le asigna
			bne terminar_partida	
		;;Incrementos el contador de ciclos
		inc cont
		lda cont
		;;Si hemos llegado a el ciclo 43 ponemos el flag de ganador a empate(0), y seguimos
		;;  ya que en la siguiente iteracion indicara que es empate y saldrá del bucle
		cmpa #41
		bhi nueva_partida_empate
		bls nueva_partida
	
	;;en el caso de que sea empate porque se acaban las posiciones del tablero
	nueva_partida_empate:
		;;ponemos ganador a 0 (empate)
		clra
		sta ganador
		jsr comprobar_ganadores
		bra terminar_partida

	terminar_partida:
		;;antes de terminar imprimimos el tablero y el ganador para que
		;; el jugador pueda apreciar el tablero con la ultima ficha
		;; colocada; ya que si no, este no la veria porque el tablero
		;; se muestra al principio de cada turno
		ldx #limpiar_pantalla
		jsr imprime_cadena
		ldx #titulo
		jsr imprime_cadena
		ldx #mat
		jsr imprime_tablero
		lda ganador
		jsr comprobar_ganadores	
		ldx #pausa
		jsr imprime_cadena
		lda teclado
		lbra menu_seleccion


;;;;;;;;;;;;;;;;;;;;;;;;;;;
;	SALIR DEL JUEGO
;;;;;;;;;;;;;;;;;;;;;;;;;;;

	acabar:		;;acabamos el programa
		clra
		sta fin
		.area FIJA(ABS)
		.org 0xFFFE	; vector de RESET
		.word programa

