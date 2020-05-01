File: .asciz "binario.txt"
.align
Handle:.word 0
arreglo: .skip 100*4

MAIN:						;para abrir archivos, donde recibe nombre y el handle del archivo y luego crear el arreglo
	ldr r0, =File
	mov r1, #0
	swi 0x66
	ldr r1, =Handle
	str r0, [r1]
	ldr r0, =Handle
	ldr r0, [r0]
	swi 0x6c

	mov r3, r0				;asigna largo del arreglo en r3
	mov r2, #0				;i=0
	ldr r5, =arreglo		;arreglo donde se guardan los numeros


ELEMENTS:
	cmp r3, r2
	ldr r0, =Handle
	ldr r0, [r0]
	swi 0x6c

	mov r4, r0  			;asigna el siguiente valor a r4, al terminar el loop, r4 es el valor a buscar
	beq POSICIONES

	mov r6, r2, lsl#2
	add r7, r5, r6			;r7 sera el temp
	str r4, [r7]			;almacena los valores en las distintas posiciones de memoria del arreglo. (sumando 4 con el logical shift left)
	add r2, r2, #1
	b ELEMENTS

POSICIONES:
	mov r2, #0				;posicion minima del arreglo
	sub r6, r3, #1			;posicion maxima del arreglo
	add r7, r6, r2
	mov r8, r7, asr#1		;posicion actual del arreglo
	b ULTIMAPOS

PRIMERAPOS:					;verifica si el numero esta en la primera posicion
	mov r7, r2, lsl#2
	add r7, r5, r7
	ldr r9, [r7]
	cmp r4, r9
	beq FINAL
	b BUSQUEDA


ULTIMAPOS:					;verifica si el numero esta en la ultima posicion
	mov r7, r6, lsl#2
	add r7, r5, r7
	ldr r9, [r7]
	cmp r4, r9
	beq FINAL
	b BUSQUEDA

BUSQUEDA:					;realiza la busqueda binaria
	mov r7, r8, lsl#2
	add r7, r5, r7
	ldr r9, [r7]			;r9 es el valor de la pos actual
	cmp r4, r9
	beq RESULTADO
	bgt MAYOR
	blt MENOR

MAYOR:						;si el numero buscado es mayor al de la pos actual
	mov r2, r8
	add r7, r2, r6
	mov r8, r7, asr#1
	b RESTA
	b BUSQUEDA

MENOR:						;si el numero buscado es menor al de la pos actual
	mov r6, r8
	add r7, r2, r6
	mov r8, r7, asr#1
	b RESTA
	b BUSQUEDA

RESTA:						;branch para no entrar en un loop si el numero buscado no esta en el arreglo
	cmp r10, #2
	beq NOESTA
	sub r11, r6, r2
	cmp r11, #1
	beq CONTADOR
	cmp r11, #0
	beq CONTADOR
	b BUSQUEDA

CONTADOR:					;contador utilizado para evitar el loop
	add r10, r10, #1
	b BUSQUEDA


FINAL:						;mensaje que indica que el numero esta en la ultima pos del arreglo
	mov r0, #1
	ldr r1, =final
	swi 0x69
	ldr r0, =Handle
	ldr r0, [r0]
	swi 0x68
	swi 0x11

RESULTADO:					;mensaje que indica en que pos se encuentra el numero buscado
	mov r0, #1

	mov r1, r8
	swi 0x6b
	ldr r1, =resultado
	swi 0x69
	ldr r0, =Handle
	ldr r0, [r0]
	swi 0x68
	swi 0x11

NOESTA:						;mensaje que indica que el numero buscado no esta en el arreglo
	mov r0, #1
	ldr r1, =noesta
	swi 0x69
	ldr r0, =Handle
	ldr r0, [r0]
	swi 0x68
	swi 0x11

resultado: .asciz " es la posision donde esta el numero buscado."
final: .asciz "El numero esta en la ultima posicion del arreglo"
noesta: .asciz "El numero buscado no esta en el arreglo"