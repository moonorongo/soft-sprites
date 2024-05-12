sprite_x:
    .byte $ff

sprite_y:
    .byte $ff

put_sprite:
{
// BLOQUE SETEO PUNTERO DE ORIGEN DATOS
// obtengo desplazamiento de x
// para obtener que frame quiero imprimir
    lda sprite_x
    and #%00000111
    
    tax
    beq skip_multiply // si x = 0 no necesito adicionar nada
    
    cpx #6 
    bmi multiply
    // si no adiciono 1 al MSB de SPR_PUT_SPRITE_POINTER
    inc SPR_PUT_SPRITE_POINTER + 1

multiply:
    clc
    lda mul_by_48_lo, x
    adc SPR_PUT_SPRITE_POINTER
    sta SPR_PUT_SPRITE_POINTER
    bcs inc_one_spr_pointer_msb
    jmp skip_multiply

inc_one_spr_pointer_msb:
    inc SPR_PUT_SPRITE_POINTER + 1
// FIN BLOQUE SETEO PUNTERO ORIGEN DATOS

// comienzo bloque copia spr data a screen
skip_multiply:
// set sprite value index 
    ldy #0

// set column counter
    ldx #2   

// copio salida de calc_byte a SCREEN_MEMORY_POINTER  
    jsr copy_calc_byte_to_scr_mem_ptr

loop1:
    // leo origen y escribo destino
    lda (SPR_PUT_SPRITE_POINTER),y
    sta SCREEN_MEMORY_POINTER:$ffff // dummy values

    // determino si estoy en el ultimo byte del caracter
    lda SCREEN_MEMORY_POINTER // cargo el lsb de la posicion de pantalla a escribir
    and #7
    cmp #7
    beq ultimo_byte_del_caracter

    // si no lo estoy simplemente incremento LSB
    inc SCREEN_MEMORY_POINTER

    jmp out_loop

ultimo_byte_del_caracter:
    //sumo 320 a SCREEN_MEMORY_POINTER (con acarreo)
    // add 256 (inc MSB)
    inc SCREEN_MEMORY_POINTER + 1
    
    // add 57 (porque quiero que vaya al 1er byte del siguiente char debajo)
    clc
    lda SCREEN_MEMORY_POINTER
    adc #57
    sta SCREEN_MEMORY_POINTER
    bcs !inc_msb_smp+
    jmp out_loop

!inc_msb_smp:
    // como hay acarreo incremento el MSB
    inc SCREEN_MEMORY_POINTER + 1

out_loop:
    iny
    cpy out_loop_compare_value:#16
    beq end_copy_column_routine

    jmp loop1

end_copy_column_routine:
// vuelvo a copiar calcbytes a screen mem ptr
    jsr copy_calc_byte_to_scr_mem_ptr

// le adiciono 8 (para que vaya al proximo char a la derecha)
    clc
    lda SCREEN_MEMORY_POINTER
    adc #8
    sta SCREEN_MEMORY_POINTER
    bcs !inc_msb_smp+ 

    jmp set_column_comparator

!inc_msb_smp:
    inc SCREEN_MEMORY_POINTER + 1

set_column_comparator:
// modifico el comparador out_loop_compare_value a 32 o 48 segun valor de X
    cpx #2  
    bne set_48
    
    // si X == 2 => seteo punto comparacion 32
    lda #32
    sta out_loop_compare_value
    jmp end_column_comparator 

set_48:
    // si X == 1 => seteo punto comparacion 48
    lda #48
    sta out_loop_compare_value

end_column_comparator:
    dex
    beq end_put_sprite

// inicia copia siguiente columna
    jmp loop1

// fin de subrutina put_sprite
end_put_sprite:
    rts

// subs ---------------------------
copy_calc_byte_to_scr_mem_ptr:
    lda CALC_BYTE_OUTPUT + 1
    sta SCREEN_MEMORY_POINTER + 1
    lda CALC_BYTE_OUTPUT
    sta SCREEN_MEMORY_POINTER
    rts
}
