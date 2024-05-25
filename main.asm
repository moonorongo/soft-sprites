// BUILD AND RUN = F6
#import "inc/pointers.asm"
#import "inc/constants.asm" 

BasicUpstart2(main)

main:
  sei
  set_hires() 

  disable_basic()
  disable_interrupts()  
  enable_vic_irq()

  select_bank_for_vic()

  // clear MSB raster
  lda $d011
  and #%01111000
  ora #%00000101 // fix vertical position
  sta $d011

  // Set interrupt line
  lda #SCREEN_INTERRUPT_LINE
  sta $d012 

  lda #<intcode
  sta 788      
  lda #>intcode
  sta 789
  cli

  // Background colors
  lda #BLACK
  sta BASE_VIC + $20
  lda #BLACK
  sta BASE_VIC + $21

  // clear screen
  jsr clear_screen

/*
  // TEST CALC BYTES
  ldx #200
  stx sprite_x  // posicion X del sprite

  ldx #150
  stx sprite_y  // posicion Y del sprite

  // puntero del sprite que quiero copiar
  ldx #<crazy_face
  stx SPR_PUT_SPRITE_POINTER
  ldx #>crazy_face
  stx SPR_PUT_SPRITE_POINTER + 1

  jsr calc_bytes  // calcula posicion memoria para pintar sprite
  jsr put_sprite  // pinta el sprite
*/

/*
  ldx #10
  stx sprite_x  // posicion X del sprite

  ldx #15
  stx sprite_y  // posicion Y del sprite

  // puntero del sprite que quiero copiar
  ldx #<crazy_face
  stx SPR_PUT_SPRITE_POINTER
  ldx #>crazy_face
  stx SPR_PUT_SPRITE_POINTER + 1

  jsr calc_bytes  // calcula posicion memoria para pintar sprite
  jsr put_sprite  // pinta el sprite
*/


main_loop:
  // check SYNC screen
  lda loop_flag
  beq loop_flag_false
  jmp synced_code // loop_flag true 

loop_flag_false:
  jmp exit

// todo este codigo se ejecuta SYNC con el refresco de pantalla
// se rompe todo, por que??? 
// deberia imprimir solamente una carita...
synced_code:
  lda #WHITE
  sta BASE_VIC + $20


  ldx #10
  stx sprite_x  // posicion X del sprite

  ldx #15
  stx sprite_y  // posicion Y del sprite

  // puntero del sprite que quiero copiar
  ldx #<crazy_face
  stx SPR_PUT_SPRITE_POINTER
  ldx #>crazy_face
  stx SPR_PUT_SPRITE_POINTER + 1

  jsr calc_bytes  // calcula posicion memoria para pintar sprite
  jsr put_sprite  // pinta el sprite


  lda #BLACK
  sta BASE_VIC + $20


  // set flag as false
  lda #0 
  sta loop_flag

exit:
  jmp main_loop



// Interrupt code for SCREEN_INTERRUPT_LINE
intcode:
  lda #1 
  sta loop_flag

  // SALIDA DEL GAME LOOP
  inc $d019           // acusamos recibo

  pla             
  tay             
  pla             
  tax             
  pla             
  rti


loop_flag:
.byte $ff

#import "inc/subroutines/put_sprite.asm"
#import "inc/subroutines/calc_byte.asm"
#import "inc/subroutines/clear_screen.asm"

#import "inc/macros/config.asm"

#import "inc/tables.asm"

* = $c000 "Crazy Face"
#import "inc/sprites/crazy_face.asm"
