;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;										;
;	BUSCAR_4_FICHAS_SEGUIDAS.asm						;
;										;
;	Este modulo contiene las llamadas a buscr fichas por diagonales,	;
;	filas, y columnas.							;
;										;
;	Entrada: D(mat)								;
;	Salida:  A(ganadores)							;
;	Registros afectados: A,CC						;
;	Registros afectados por subrutinas: A,B,D,X,Y,CC			;	
;										;
;										;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

	.module buscar_fichas_seg
	.globl buscar_4_fichas_seguidas

	;;Añadimos los .globl para acceder a las subrutinas necesarias
	.globl recorrer_filas
	.globl recorrer_columnas
	.globl recorrer_diagonales


	;;Variables
	mat:.word 0  ;;variable para guardar la direccion de la matriz


	buscar_4_fichas_seguidas:
		;;guardamos mat
		std mat
		;;buscamos por filas (Todas estas subrutinas devuelven si hay gandor 1 o 2 en A, si no devuelven 3)
	;;filas
		;;ldd mat (no es necesario porque mat ya esta en d)
		jsr recorrer_filas
		cmpa #3
		bne salir_buscar_4_fichas_seguidas
		
	;;columnas
		ldd mat
		jsr recorrer_columnas
		cmpa #3
		bne salir_buscar_4_fichas_seguidas
	;;diagonales
		ldd mat
		jsr recorrer_diagonales

	salir_buscar_4_fichas_seguidas:
		rts	;;se retorna desde donde se hizo la llamada

