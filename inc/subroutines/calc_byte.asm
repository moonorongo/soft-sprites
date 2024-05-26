calc_bytes:
{
  // reset values
  lda #0
  sta tmp_address
  sta tmp_address + 1
  sta CALC_BYTE_OUTPUT
  sta CALC_BYTE_OUTPUT + 1

  // y / 8 (integer division)
  lda sprite_y
  clc
  ror
  ror
  ror
  and #%00011111
  sta ro

  // esto quita los ultimos 3 bits
  // (esos 3 bits en realidad me siven para definir el shifting)
  lda sprite_x
  and #%11111000
  sta co

  // li es el nro de linea del caracter
  lda sprite_y
  and #%00000111
  sta li

  // ro * 320
  // 1) ro * 256
  lda ro
  sta CALC_BYTE_OUTPUT + 1 // msb output_address 
  
  // 2) ro * 64
  lda ro
  sta tmp_address // lsb tmp_address
  clc
  rol tmp_address
  rol tmp_address + 1
  rol tmp_address
  rol tmp_address + 1
  rol tmp_address
  rol tmp_address + 1
  rol tmp_address
  rol tmp_address + 1
  rol tmp_address
  rol tmp_address + 1
  rol tmp_address
  rol tmp_address + 1
  
  lda tmp_address
  and #%11000000
  sta tmp_address



  // 3) sumo tmp_address + output_address
  jsr sum_tmp_plus_output
  

  // 4) sumo co
  clc
  lda CALC_BYTE_OUTPUT
  adc co
  sta CALC_BYTE_OUTPUT
  bcs add_one_msb_2 
  jmp sum_li

add_one_msb_2:
  inc CALC_BYTE_OUTPUT + 1

  // 5) suma li
sum_li:
  clc
  lda CALC_BYTE_OUTPUT
  adc li
  sta CALC_BYTE_OUTPUT
  bcs add_one_msb_3 
  jmp sum_memory

add_one_msb_3:
  inc CALC_BYTE_OUTPUT + 1

sum_memory: // BASE_VIC_HIRES_MEMORY
  // copio BASE_VIC_HIRES_MEMORY en tmp_address
  lda #>BASE_VIC_HIRES_MEMORY
  sta tmp_address+1
  lda #<BASE_VIC_HIRES_MEMORY
  sta tmp_address

  jsr sum_tmp_plus_output 

output:
  rts

sum_tmp_plus_output:
  clc
  lda CALC_BYTE_OUTPUT
  adc tmp_address
  sta CALC_BYTE_OUTPUT  
  bcs add_one_msb 
  jmp sum_msb

// esta mierda no creo q sea necesaria
add_one_msb:
  inc CALC_BYTE_OUTPUT + 1

sum_msb:
  clc
  lda CALC_BYTE_OUTPUT + 1
  adc tmp_address + 1
  sta CALC_BYTE_OUTPUT + 1  
  
  rts
// END sum_tmp_plus_output:

// temp vars
// ---------
ro:
  .byte $ff
co:
  .byte $ff
li:
  .byte $ff
}
tmp_address:
  .byte $00,$00

// resultado de la fn
CALC_BYTE_OUTPUT: 
  .byte $00,$00
