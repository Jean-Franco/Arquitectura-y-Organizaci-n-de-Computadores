File: .asciz "factorial.txt"
.align
Handle:.word 0

    ldr r0,=File
    mov r1,#0
    swi 0x66						;Abre el File
    ldr r1,=Handle
    str r0,[r1]

    ldr r0,=Handle
    ldr r0,[r0]
    swi 0x6c						;Lee el numero del File

   									;Se veran los casos en que pueda calzar el numero con un factorial

	cmp r0, #1
	mov r1, #1
	beq RETURN

	cmp r0, #2
	mov r1, #2
	beq RETURN

	cmp r0, #6
	mov r1, #3
	beq RETURN

	cmp r0, #24
	mov r1, #4
	beq RETURN

	cmp r0, #120
	mov r1, #5
	beq RETURN
	bne ELSE

RETURN:
    mov r0,#1
    swi 0x6b						;Imprime el factorial adecuado para el numero del File
    ldr r0, =Handle
    ldr r0, [r0]
    swi 0x13
    swi 0x68						;Cierra el File
    swi 0x11						;Termina el programa

ELSE:
	ldr r0, =fail 
	swi 0x02						;Imprime el string fail

	swi 0x68						;Cierra el File
    swi 0x11						;Termina el programa

fail: .asciz "El numero no es factorial."